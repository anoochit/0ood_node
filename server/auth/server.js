const express = require("express");
const jwt = require("jsonwebtoken");
const { request } = require("graphql-request");
const bcrypt = require("bcrypt");
const bodyParser = require("body-parser");

const app = express();
const secret = process.env.JWT_SECRET || "8d0a4102fa584bbe8308da94d3506bc8";
const hasuraUrl =
  process.env.HASURA_GRAPHQL || "http://localhost:8080/v1/graphql";
const adminSecret =
  process.env.HASURA_GRAPHQL_ADMIN_SECRET || "myadminsecretkey";
const saltRounds = 10;

app.use(bodyParser.json());

app.post("/auth/signup", async (req, res) => {
  const { username, password, role } = req.body;

  // Check if the username already exists in the database
  const checkUsernameQuery = `
    query checkUsername($username: String!) {
      users(where: {username: {_eq: $username}}) {
        id
      }
    }
  `;

  try {
    const headers = {
      "Content-Type": "application/json",
      "x-hasura-admin-secret": adminSecret,
    };
    const variables = { username };
    const data = await request(
      hasuraUrl,
      checkUsernameQuery,
      variables,
      headers
    );
    const users = data.users;

    if (users.length > 0) {
      res.status(409).json({ error: "Username already exists" });
    } else {
      // Hash the password
      const hashedPassword = await bcrypt.hash(password, saltRounds);

      // Add the new user to Hasura
      const addUserMutation = `
        mutation addUser($username: String!, $password: String!, $role: String!) {
          insert_users(objects: {username: $username, password: $password, role: $role}) {
            returning {
              id
            }
          }
        }
      `;

      const addUserVariables = {
        username,
        password: hashedPassword,
        role: role,
      };
      const addUserData = await request(
        hasuraUrl,
        addUserMutation,
        addUserVariables,
        headers
      );
      const { id } = addUserData.insert_users.returning[0];

      // Create a JWT token
      const payload = {
        "https://hasura.io/jwt/claims": {
          "x-hasura-allowed-roles": [role],
          "x-hasura-default-role": role,
          "X-Hasura-User-Id": id.toString(),
        },
      };

      const options = { expiresIn: "7d", algorithm: "HS256" };

      const token = jwt.sign(payload, secret, options);
      res.json({ token });
    }
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

app.post("/auth/signin", async (req, res) => {
  const { username, password } = req.body;

  // Check if the username and password match a user in the database
  const checkUserQuery = `
        query checkUser($username: String!) {
          users(where: {username: {_eq: $username}}) {
            id
            username
            password
            role
          }
        }
      `;

  try {
    const headers = {
      "Content-Type": "application/json",
      "x-hasura-admin-secret": adminSecret,
    };
    const variables = { username };
    const data = await request(hasuraUrl, checkUserQuery, variables, headers);
    const users = data.users;

    if (users.length === 0) {
      res.status(401).json({ error: "Invalid username or password" });
    } else {
      const user = users[0];

      // Compare the provided password with the hashed password
      const isMatch = await bcrypt.compare(password, user.password);

      if (isMatch) {
        // Create a JWT token
        const payload = {
          "https://hasura.io/jwt/claims": {
            "x-hasura-allowed-roles": [user.role],
            "x-hasura-default-role": user.role,
            "x-hasura-user-id": user.id.toString(),
          },
        };
        const options = {
          expiresIn: "7d",
          algorithm: "HS256",
        };

        const token = jwt.sign(payload, secret, options);
        res.json({ token });
      } else {
        res.status(401).json({ error: "Invalid username or password" });
      }
    }
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

app.listen(3000, () => {
  console.log("Server started on http://localhost:3000");
});
