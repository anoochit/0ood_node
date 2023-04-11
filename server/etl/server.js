const mqtt = require("mqtt");
const winston = require("winston");
const fetch = require("node-fetch");
const moment = require("moment");

// var mqtt_host
const mqtt_host = process.env.MQTT_BROKER_HOST;
const mqtt_port = process.env.MQTT_BROKER_PORT;

// var hasura
const hasuraServer = process.env.HASURA_HOST;
const hasuraSecret = process.env.HASURA_GRAPHQL_ADMIN_SECRET;
const hasuraUrl = "http://" + hasuraServer + ":8080/v1/graphql";

// hasura header
const hasuraHeaders = {
  "content-type": "application/json",
  "x-hasura-admin-secret": hasuraSecret,
};

const hasuraOperation = `mutation InsertLog($device_id: String! , $message: jsonb! , $timestamp: timestamptz! , $constraint: logs_constraint = logs_pkey) {
  insert_logs_one(object: {device_id: $device_id, message: $message, timestamp: $timestamp}, on_conflict: {constraint: $constraint, update_columns: device_id}) {
    timestamp
    device_id
    message
  }
}`;

const execute = async (variables, reqHeaders) => {
  const fetchResponse = await fetch(hasuraUrl, {
    method: "POST",
    headers: reqHeaders,
    body: JSON.stringify({
      query: hasuraOperation,
      variables,
    }),
  });
  return await fetchResponse.json();
};

const logger = winston.createLogger({
  level: "info",
  format: winston.format.simple(),
  defaultMeta: { service: "user-service" },
  transports: [
    new winston.transports.File({ filename: "log/error.log", level: "error" }),
    new winston.transports.File({ filename: "log/combined.log" }),
  ],
});

var client = mqtt.connect({ port: mqtt_port, host: mqtt_host });

client.subscribe("msg/#");
client.on("connect", () => {
  logger.info("MQTT Broker connected");
});

client.on("message", async function (topic, message) {
  const device_id_match = topic.match(/msg\/(.*)/);
  if (!device_id_match) {
    return logger.error(`Invalid topic format: ${topic}`);
  }
  const device_id = device_id_match[1];

  try {
    const message_parsed = JSON.parse(message.toString());
    const timestamp = moment.unix(message_parsed.timestamp).toISOString();
    const { data, errors } = await execute(
      { device_id, message: message_parsed, timestamp },
      hasuraHeaders
    );
    if (errors) {
      return logger.error(`Error inserting data: ${errors}`);
    }
    logger.info(`Data inserted for device: ${device_id}`);
  } catch (error) {
    return logger.error(`Error parsing message: ${error}`);
  }
});

client.on("error", (error) => {
  logger.error(error.toString());
});
