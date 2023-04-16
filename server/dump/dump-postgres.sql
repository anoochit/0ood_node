--
-- PostgreSQL database dump
--

-- Dumped from database version 14.7 (Debian 14.7-1.pgdg110+1)
-- Dumped by pg_dump version 14.2

-- Started on 2023-04-16 13:24:27

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 7 (class 2615 OID 16384)
-- Name: hdb_catalog; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA hdb_catalog;


ALTER SCHEMA hdb_catalog OWNER TO postgres;

--
-- TOC entry 4 (class 2615 OID 2200)
-- Name: public; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA public;


ALTER SCHEMA public OWNER TO postgres;

--
-- TOC entry 3461 (class 0 OID 0)
-- Dependencies: 4
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON SCHEMA public IS 'standard public schema';


--
-- TOC entry 259 (class 1255 OID 16422)
-- Name: gen_hasura_uuid(); Type: FUNCTION; Schema: hdb_catalog; Owner: postgres
--

CREATE FUNCTION hdb_catalog.gen_hasura_uuid() RETURNS uuid
    LANGUAGE sql
    AS $$select gen_random_uuid()$$;


ALTER FUNCTION hdb_catalog.gen_hasura_uuid() OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 213 (class 1259 OID 16444)
-- Name: hdb_action_log; Type: TABLE; Schema: hdb_catalog; Owner: postgres
--

CREATE TABLE hdb_catalog.hdb_action_log (
    id uuid DEFAULT hdb_catalog.gen_hasura_uuid() NOT NULL,
    action_name text,
    input_payload jsonb NOT NULL,
    request_headers jsonb NOT NULL,
    session_variables jsonb NOT NULL,
    response_payload jsonb,
    errors jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    response_received_at timestamp with time zone,
    status text NOT NULL,
    CONSTRAINT hdb_action_log_status_check CHECK ((status = ANY (ARRAY['created'::text, 'processing'::text, 'completed'::text, 'error'::text])))
);


ALTER TABLE hdb_catalog.hdb_action_log OWNER TO postgres;

--
-- TOC entry 215 (class 1259 OID 16468)
-- Name: hdb_cron_event_invocation_logs; Type: TABLE; Schema: hdb_catalog; Owner: postgres
--

CREATE TABLE hdb_catalog.hdb_cron_event_invocation_logs (
    id text DEFAULT hdb_catalog.gen_hasura_uuid() NOT NULL,
    event_id text,
    status integer,
    request json,
    response json,
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE hdb_catalog.hdb_cron_event_invocation_logs OWNER TO postgres;

--
-- TOC entry 214 (class 1259 OID 16454)
-- Name: hdb_cron_events; Type: TABLE; Schema: hdb_catalog; Owner: postgres
--

CREATE TABLE hdb_catalog.hdb_cron_events (
    id text DEFAULT hdb_catalog.gen_hasura_uuid() NOT NULL,
    trigger_name text NOT NULL,
    scheduled_time timestamp with time zone NOT NULL,
    status text DEFAULT 'scheduled'::text NOT NULL,
    tries integer DEFAULT 0 NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    next_retry_at timestamp with time zone,
    CONSTRAINT valid_status CHECK ((status = ANY (ARRAY['scheduled'::text, 'locked'::text, 'delivered'::text, 'error'::text, 'dead'::text])))
);


ALTER TABLE hdb_catalog.hdb_cron_events OWNER TO postgres;

--
-- TOC entry 212 (class 1259 OID 16434)
-- Name: hdb_metadata; Type: TABLE; Schema: hdb_catalog; Owner: postgres
--

CREATE TABLE hdb_catalog.hdb_metadata (
    id integer NOT NULL,
    metadata json NOT NULL,
    resource_version integer DEFAULT 1 NOT NULL
);


ALTER TABLE hdb_catalog.hdb_metadata OWNER TO postgres;

--
-- TOC entry 217 (class 1259 OID 16496)
-- Name: hdb_scheduled_event_invocation_logs; Type: TABLE; Schema: hdb_catalog; Owner: postgres
--

CREATE TABLE hdb_catalog.hdb_scheduled_event_invocation_logs (
    id text DEFAULT hdb_catalog.gen_hasura_uuid() NOT NULL,
    event_id text,
    status integer,
    request json,
    response json,
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE hdb_catalog.hdb_scheduled_event_invocation_logs OWNER TO postgres;

--
-- TOC entry 216 (class 1259 OID 16483)
-- Name: hdb_scheduled_events; Type: TABLE; Schema: hdb_catalog; Owner: postgres
--

CREATE TABLE hdb_catalog.hdb_scheduled_events (
    id text DEFAULT hdb_catalog.gen_hasura_uuid() NOT NULL,
    webhook_conf json NOT NULL,
    scheduled_time timestamp with time zone NOT NULL,
    retry_conf json,
    payload json,
    header_conf json,
    status text DEFAULT 'scheduled'::text NOT NULL,
    tries integer DEFAULT 0 NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    next_retry_at timestamp with time zone,
    comment text,
    CONSTRAINT valid_status CHECK ((status = ANY (ARRAY['scheduled'::text, 'locked'::text, 'delivered'::text, 'error'::text, 'dead'::text])))
);


ALTER TABLE hdb_catalog.hdb_scheduled_events OWNER TO postgres;

--
-- TOC entry 218 (class 1259 OID 16510)
-- Name: hdb_schema_notifications; Type: TABLE; Schema: hdb_catalog; Owner: postgres
--

CREATE TABLE hdb_catalog.hdb_schema_notifications (
    id integer NOT NULL,
    notification json NOT NULL,
    resource_version integer DEFAULT 1 NOT NULL,
    instance_id uuid NOT NULL,
    updated_at timestamp with time zone DEFAULT now(),
    CONSTRAINT hdb_schema_notifications_id_check CHECK ((id = 1))
);


ALTER TABLE hdb_catalog.hdb_schema_notifications OWNER TO postgres;

--
-- TOC entry 211 (class 1259 OID 16423)
-- Name: hdb_version; Type: TABLE; Schema: hdb_catalog; Owner: postgres
--

CREATE TABLE hdb_catalog.hdb_version (
    hasura_uuid uuid DEFAULT hdb_catalog.gen_hasura_uuid() NOT NULL,
    version text NOT NULL,
    upgraded_on timestamp with time zone NOT NULL,
    cli_state jsonb DEFAULT '{}'::jsonb NOT NULL,
    console_state jsonb DEFAULT '{}'::jsonb NOT NULL,
    ee_client_id text,
    ee_client_secret text
);


ALTER TABLE hdb_catalog.hdb_version OWNER TO postgres;

--
-- TOC entry 220 (class 1259 OID 24576)
-- Name: devices; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.devices (
    id text NOT NULL,
    name text NOT NULL,
    user_id integer
);


ALTER TABLE public.devices OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 16520)
-- Name: logs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.logs (
    device_id text NOT NULL,
    message jsonb NOT NULL,
    "timestamp" timestamp with time zone NOT NULL
);


ALTER TABLE public.logs OWNER TO postgres;

--
-- TOC entry 222 (class 1259 OID 24589)
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id integer NOT NULL,
    username text NOT NULL,
    password text NOT NULL,
    role text DEFAULT 'user'::text NOT NULL
);


ALTER TABLE public.users OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 24588)
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.users_id_seq OWNER TO postgres;

--
-- TOC entry 3462 (class 0 OID 0)
-- Dependencies: 221
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- TOC entry 3270 (class 2604 OID 24592)
-- Name: users id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- TOC entry 3446 (class 0 OID 16444)
-- Dependencies: 213
-- Data for Name: hdb_action_log; Type: TABLE DATA; Schema: hdb_catalog; Owner: postgres
--

COPY hdb_catalog.hdb_action_log (id, action_name, input_payload, request_headers, session_variables, response_payload, errors, created_at, response_received_at, status) FROM stdin;
\.


--
-- TOC entry 3448 (class 0 OID 16468)
-- Dependencies: 215
-- Data for Name: hdb_cron_event_invocation_logs; Type: TABLE DATA; Schema: hdb_catalog; Owner: postgres
--

COPY hdb_catalog.hdb_cron_event_invocation_logs (id, event_id, status, request, response, created_at) FROM stdin;
\.


--
-- TOC entry 3447 (class 0 OID 16454)
-- Dependencies: 214
-- Data for Name: hdb_cron_events; Type: TABLE DATA; Schema: hdb_catalog; Owner: postgres
--

COPY hdb_catalog.hdb_cron_events (id, trigger_name, scheduled_time, status, tries, created_at, next_retry_at) FROM stdin;
\.


--
-- TOC entry 3445 (class 0 OID 16434)
-- Dependencies: 212
-- Data for Name: hdb_metadata; Type: TABLE DATA; Schema: hdb_catalog; Owner: postgres
--

COPY hdb_catalog.hdb_metadata (id, metadata, resource_version) FROM stdin;
1	{"sources":[{"configuration":{"connection_info":{"database_url":{"from_env":"HASURA_GRAPHQL_METADATA_DATABASE_URL"},"isolation_level":"read-committed","use_prepared_statements":false}},"kind":"postgres","name":"public","tables":[{"array_relationships":[{"name":"logs","using":{"foreign_key_constraint_on":{"column":"device_id","table":{"name":"logs","schema":"public"}}}}],"object_relationships":[{"name":"user","using":{"foreign_key_constraint_on":"user_id"}}],"table":{"name":"devices","schema":"public"}},{"object_relationships":[{"name":"device","using":{"foreign_key_constraint_on":"device_id"}}],"table":{"name":"logs","schema":"public"}},{"array_relationships":[{"name":"devices","using":{"foreign_key_constraint_on":{"column":"user_id","table":{"name":"devices","schema":"public"}}}}],"select_permissions":[{"permission":{"columns":["id","password","role","username"],"filter":{"id":{"_eq":"X-Hasura-User-Id"}}},"role":"user"}],"table":{"name":"users","schema":"public"}}]}],"version":3}	14
\.


--
-- TOC entry 3450 (class 0 OID 16496)
-- Dependencies: 217
-- Data for Name: hdb_scheduled_event_invocation_logs; Type: TABLE DATA; Schema: hdb_catalog; Owner: postgres
--

COPY hdb_catalog.hdb_scheduled_event_invocation_logs (id, event_id, status, request, response, created_at) FROM stdin;
\.


--
-- TOC entry 3449 (class 0 OID 16483)
-- Dependencies: 216
-- Data for Name: hdb_scheduled_events; Type: TABLE DATA; Schema: hdb_catalog; Owner: postgres
--

COPY hdb_catalog.hdb_scheduled_events (id, webhook_conf, scheduled_time, retry_conf, payload, header_conf, status, tries, created_at, next_retry_at, comment) FROM stdin;
\.


--
-- TOC entry 3451 (class 0 OID 16510)
-- Dependencies: 218
-- Data for Name: hdb_schema_notifications; Type: TABLE DATA; Schema: hdb_catalog; Owner: postgres
--

COPY hdb_catalog.hdb_schema_notifications (id, notification, resource_version, instance_id, updated_at) FROM stdin;
1	{"metadata":false,"remote_schemas":[],"sources":[],"data_connectors":[]}	14	a4a9afbc-d4ee-4403-84cc-d07317797228	2023-04-13 16:49:18.301664+00
\.


--
-- TOC entry 3444 (class 0 OID 16423)
-- Dependencies: 211
-- Data for Name: hdb_version; Type: TABLE DATA; Schema: hdb_catalog; Owner: postgres
--

COPY hdb_catalog.hdb_version (hasura_uuid, version, upgraded_on, cli_state, console_state, ee_client_id, ee_client_secret) FROM stdin;
faf03f20-385e-46f3-bc33-cae82a53f388	48	2023-04-13 16:47:24.829946+00	{}	{"onboardingShown": true, "console_notifications": {"admin": {"date": "2023-04-14T07:27:47.286Z", "read": "default", "showBadge": false}}}	\N	\N
\.


--
-- TOC entry 3453 (class 0 OID 24576)
-- Dependencies: 220
-- Data for Name: devices; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.devices (id, name, user_id) FROM stdin;
249396	AQI249396	1
mock_device	Ryzen 7	1
\.


--
-- TOC entry 3452 (class 0 OID 16520)
-- Dependencies: 219
-- Data for Name: logs; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.logs (device_id, message, "timestamp") FROM stdin;
mock_device	{"cpu_usage": 0.58, "mem_total": 15741.32, "mem_usage": 11604.69, "timestamp": 1681409169}	2023-04-13 18:06:09+00
mock_device	{"cpu_usage": 0.87, "mem_total": 15741.32, "mem_usage": 11441.13, "timestamp": 1681409174}	2023-04-13 18:06:14+00
mock_device	{"cpu_usage": 0.39, "mem_total": 15741.32, "mem_usage": 11396.32, "timestamp": 1681409179}	2023-04-13 18:06:19+00
mock_device	{"cpu_usage": 0.78, "mem_total": 15741.32, "mem_usage": 11573.69, "timestamp": 1681409184}	2023-04-13 18:06:24+00
mock_device	{"cpu_usage": 0.39, "mem_total": 15741.32, "mem_usage": 11545.41, "timestamp": 1681409189}	2023-04-13 18:06:29+00
mock_device	{"cpu_usage": 0.77, "mem_total": 15741.32, "mem_usage": 11511.84, "timestamp": 1681409194}	2023-04-13 18:06:34+00
mock_device	{"cpu_usage": 1.46, "mem_total": 15741.32, "mem_usage": 11740.79, "timestamp": 1681409199}	2023-04-13 18:06:39+00
mock_device	{"cpu_usage": 0.28, "mem_total": 15741.32, "mem_usage": 11874.73, "timestamp": 1681409204}	2023-04-13 18:06:44+00
mock_device	{"cpu_usage": 3.59, "mem_total": 15741.32, "mem_usage": 11871.73, "timestamp": 1681409209}	2023-04-13 18:06:49+00
mock_device	{"cpu_usage": 2.06, "mem_total": 15741.32, "mem_usage": 11844.51, "timestamp": 1681409214}	2023-04-13 18:06:54+00
mock_device	{"cpu_usage": 3.94, "mem_total": 15741.32, "mem_usage": 11908.05, "timestamp": 1681409219}	2023-04-13 18:06:59+00
mock_device	{"cpu_usage": 3.84, "mem_total": 15741.32, "mem_usage": 11904.41, "timestamp": 1681409224}	2023-04-13 18:07:04+00
mock_device	{"cpu_usage": 1.65, "mem_total": 15741.32, "mem_usage": 11922.59, "timestamp": 1681409229}	2023-04-13 18:07:09+00
mock_device	{"cpu_usage": 1.86, "mem_total": 15741.32, "mem_usage": 11865.64, "timestamp": 1681409234}	2023-04-13 18:07:14+00
mock_device	{"cpu_usage": 4.64, "mem_total": 15741.32, "mem_usage": 11873.74, "timestamp": 1681409239}	2023-04-13 18:07:19+00
mock_device	{"cpu_usage": 1.07, "mem_total": 15741.32, "mem_usage": 11857.51, "timestamp": 1681409244}	2023-04-13 18:07:24+00
mock_device	{"cpu_usage": 0.96, "mem_total": 15741.32, "mem_usage": 11894.07, "timestamp": 1681409249}	2023-04-13 18:07:29+00
mock_device	{"cpu_usage": 0.97, "mem_total": 15741.32, "mem_usage": 11903.96, "timestamp": 1681409254}	2023-04-13 18:07:34+00
mock_device	{"cpu_usage": 0.68, "mem_total": 15741.32, "mem_usage": 11945.46, "timestamp": 1681409259}	2023-04-13 18:07:39+00
mock_device	{"cpu_usage": 0.48, "mem_total": 15741.32, "mem_usage": 11934.51, "timestamp": 1681409264}	2023-04-13 18:07:44+00
mock_device	{"cpu_usage": 0.49, "mem_total": 15741.32, "mem_usage": 11958.33, "timestamp": 1681409269}	2023-04-13 18:07:49+00
mock_device	{"cpu_usage": 0.19, "mem_total": 15741.32, "mem_usage": 11815.03, "timestamp": 1681409274}	2023-04-13 18:07:54+00
mock_device	{"cpu_usage": 2.32, "mem_total": 15741.32, "mem_usage": 11846.54, "timestamp": 1681409279}	2023-04-13 18:07:59+00
mock_device	{"cpu_usage": 0.090, "mem_total": 15741.32, "mem_usage": 12037.81, "timestamp": 1681409284}	2023-04-13 18:08:04+00
mock_device	{"cpu_usage": 0.68, "mem_total": 15741.32, "mem_usage": 12026.54, "timestamp": 1681409289}	2023-04-13 18:08:09+00
mock_device	{"cpu_usage": 3.07, "mem_total": 15741.32, "mem_usage": 11965.66, "timestamp": 1681409294}	2023-04-13 18:08:14+00
mock_device	{"cpu_usage": 0.39, "mem_total": 15741.32, "mem_usage": 11931.16, "timestamp": 1681409299}	2023-04-13 18:08:19+00
mock_device	{"cpu_usage": 0.87, "mem_total": 15741.32, "mem_usage": 11840.46, "timestamp": 1681409304}	2023-04-13 18:08:24+00
mock_device	{"cpu_usage": 3.85, "mem_total": 15741.32, "mem_usage": 12022.45, "timestamp": 1681409309}	2023-04-13 18:08:29+00
mock_device	{"cpu_usage": 0.68, "mem_total": 15741.32, "mem_usage": 12115.26, "timestamp": 1681409314}	2023-04-13 18:08:34+00
249396	{"pm10": 44, "pm25": 64, "pm100": 72, "timestamp": 1681412052}	2023-04-13 18:54:12+00
249396	{"pm10": 45, "pm25": 65, "pm100": 73, "timestamp": 1681412085}	2023-04-13 18:54:45+00
249396	{"pm10": 45, "pm25": 66, "pm100": 74, "timestamp": 1681412119}	2023-04-13 18:55:19+00
249396	{"pm10": 45, "pm25": 66, "pm100": 74, "timestamp": 1681412152}	2023-04-13 18:55:52+00
249396	{"pm10": 43, "pm25": 61, "pm100": 71, "timestamp": 1681412185}	2023-04-13 18:56:25+00
249396	{"pm10": 39, "pm25": 59, "pm100": 69, "timestamp": 1681412218}	2023-04-13 18:56:58+00
249396	{"pm10": 40, "pm25": 60, "pm100": 70, "timestamp": 1681412251}	2023-04-13 18:57:31+00
249396	{"pm10": 43, "pm25": 60, "pm100": 71, "timestamp": 1681412551}	2023-04-13 19:02:31+00
249396	{"pm10": 45, "pm25": 62, "pm100": 71, "timestamp": 1681412584}	2023-04-13 19:03:04+00
249396	{"pm10": 45, "pm25": 62, "pm100": 71, "timestamp": 1681412617}	2023-04-13 19:03:37+00
249396	{"pm10": 46, "pm25": 63, "pm100": 72, "timestamp": 1681412650}	2023-04-13 19:04:10+00
249396	{"pm10": 46, "pm25": 63, "pm100": 71, "timestamp": 1681412683}	2023-04-13 19:04:43+00
249396	{"pm10": 44, "pm25": 61, "pm100": 70, "timestamp": 1681412716}	2023-04-13 19:05:16+00
249396	{"pm10": 43, "pm25": 60, "pm100": 70, "timestamp": 1681412749}	2023-04-13 19:05:49+00
249396	{"pm10": 42, "pm25": 60, "pm100": 69, "timestamp": 1681412783}	2023-04-13 19:06:23+00
249396	{"pm10": 42, "pm25": 61, "pm100": 70, "timestamp": 1681412816}	2023-04-13 19:06:56+00
249396	{"pm10": 42, "pm25": 61, "pm100": 70, "timestamp": 1681412849}	2023-04-13 19:07:29+00
249396	{"pm10": 40, "pm25": 63, "pm100": 72, "timestamp": 1681412905}	2023-04-13 19:08:25+00
249396	{"pm10": 41, "pm25": 61, "pm100": 71, "timestamp": 1681412911}	2023-04-13 19:08:31+00
249396	{"pm10": 41, "pm25": 63, "pm100": 72, "timestamp": 1681412917}	2023-04-13 19:08:37+00
249396	{"pm10": 40, "pm25": 63, "pm100": 73, "timestamp": 1681412923}	2023-04-13 19:08:43+00
mock_device	{"cpu_usage": 0.090, "mem_total": 15741.32, "mem_usage": 12092.05, "timestamp": 1681409319}	2023-04-13 18:08:39+00
mock_device	{"cpu_usage": 0.28, "mem_total": 15741.32, "mem_usage": 12087.55, "timestamp": 1681409324}	2023-04-13 18:08:44+00
mock_device	{"cpu_usage": 0, "mem_total": 15741.32, "mem_usage": 12026.54, "timestamp": 1681409329}	2023-04-13 18:08:49+00
mock_device	{"cpu_usage": 0.1, "mem_total": 15741.32, "mem_usage": 12023.09, "timestamp": 1681409334}	2023-04-13 18:08:54+00
mock_device	{"cpu_usage": 0.39, "mem_total": 15741.32, "mem_usage": 12003.39, "timestamp": 1681409339}	2023-04-13 18:08:59+00
mock_device	{"cpu_usage": 0.97, "mem_total": 15741.32, "mem_usage": 12027.03, "timestamp": 1681409344}	2023-04-13 18:09:04+00
mock_device	{"cpu_usage": 0.78, "mem_total": 15741.32, "mem_usage": 12051.14, "timestamp": 1681409349}	2023-04-13 18:09:09+00
mock_device	{"cpu_usage": 2.55, "mem_total": 15741.32, "mem_usage": 12018.87, "timestamp": 1681409354}	2023-04-13 18:09:14+00
mock_device	{"cpu_usage": 1.28, "mem_total": 15741.32, "mem_usage": 12021.56, "timestamp": 1681409359}	2023-04-13 18:09:19+00
mock_device	{"cpu_usage": 0.99, "mem_total": 15741.32, "mem_usage": 12001.39, "timestamp": 1681409364}	2023-04-13 18:09:24+00
mock_device	{"cpu_usage": 0, "mem_total": 15741.32, "mem_usage": 11979.4, "timestamp": 1681409369}	2023-04-13 18:09:29+00
mock_device	{"cpu_usage": 0, "mem_total": 15741.32, "mem_usage": 11957.13, "timestamp": 1681409374}	2023-04-13 18:09:34+00
mock_device	{"cpu_usage": 3.24, "mem_total": 15741.32, "mem_usage": 11927.05, "timestamp": 1681409379}	2023-04-13 18:09:39+00
mock_device	{"cpu_usage": 3.71, "mem_total": 15741.32, "mem_usage": 11940.45, "timestamp": 1681409384}	2023-04-13 18:09:44+00
mock_device	{"cpu_usage": 1.08, "mem_total": 15741.32, "mem_usage": 11987.19, "timestamp": 1681409389}	2023-04-13 18:09:49+00
mock_device	{"cpu_usage": 0.28, "mem_total": 15741.32, "mem_usage": 11991.97, "timestamp": 1681409394}	2023-04-13 18:09:54+00
mock_device	{"cpu_usage": 1.35, "mem_total": 15741.32, "mem_usage": 11998.51, "timestamp": 1681409399}	2023-04-13 18:09:59+00
mock_device	{"cpu_usage": 0, "mem_total": 15741.32, "mem_usage": 11983.17, "timestamp": 1681409404}	2023-04-13 18:10:04+00
mock_device	{"cpu_usage": 0.67, "mem_total": 15741.32, "mem_usage": 11984.75, "timestamp": 1681409409}	2023-04-13 18:10:09+00
mock_device	{"cpu_usage": 0.86, "mem_total": 15741.32, "mem_usage": 11969.63, "timestamp": 1681409414}	2023-04-13 18:10:14+00
mock_device	{"cpu_usage": 0.1, "mem_total": 15741.32, "mem_usage": 11996.47, "timestamp": 1681409419}	2023-04-13 18:10:19+00
mock_device	{"cpu_usage": 0.49, "mem_total": 15741.32, "mem_usage": 12022.59, "timestamp": 1681409424}	2023-04-13 18:10:24+00
mock_device	{"cpu_usage": 1.25, "mem_total": 15741.32, "mem_usage": 11982.69, "timestamp": 1681409429}	2023-04-13 18:10:29+00
mock_device	{"cpu_usage": 0.38, "mem_total": 15741.32, "mem_usage": 12046.54, "timestamp": 1681409434}	2023-04-13 18:10:34+00
mock_device	{"cpu_usage": 1.16, "mem_total": 15741.32, "mem_usage": 12050.82, "timestamp": 1681409439}	2023-04-13 18:10:39+00
mock_device	{"cpu_usage": 0.59, "mem_total": 15741.32, "mem_usage": 11964.9, "timestamp": 1681409444}	2023-04-13 18:10:44+00
mock_device	{"cpu_usage": 1.25, "mem_total": 15741.32, "mem_usage": 11944.39, "timestamp": 1681409449}	2023-04-13 18:10:49+00
mock_device	{"cpu_usage": 0.69, "mem_total": 15741.32, "mem_usage": 11892.11, "timestamp": 1681409454}	2023-04-13 18:10:54+00
mock_device	{"cpu_usage": 1.75, "mem_total": 15741.32, "mem_usage": 11867.5, "timestamp": 1681409459}	2023-04-13 18:10:59+00
mock_device	{"cpu_usage": 0.49, "mem_total": 15741.32, "mem_usage": 11854.05, "timestamp": 1681409464}	2023-04-13 18:11:04+00
mock_device	{"cpu_usage": 3.32, "mem_total": 15741.32, "mem_usage": 12054.61, "timestamp": 1681409469}	2023-04-13 18:11:09+00
mock_device	{"cpu_usage": 6.19, "mem_total": 15741.32, "mem_usage": 11859.4, "timestamp": 1681409474}	2023-04-13 18:11:14+00
mock_device	{"cpu_usage": 6.25, "mem_total": 15741.32, "mem_usage": 11811.86, "timestamp": 1681409479}	2023-04-13 18:11:19+00
mock_device	{"cpu_usage": 5.85, "mem_total": 15741.32, "mem_usage": 11774.56, "timestamp": 1681409484}	2023-04-13 18:11:24+00
mock_device	{"cpu_usage": 6.73, "mem_total": 15741.32, "mem_usage": 11816.66, "timestamp": 1681409489}	2023-04-13 18:11:29+00
mock_device	{"cpu_usage": 4.83, "mem_total": 15741.32, "mem_usage": 11677.73, "timestamp": 1681409494}	2023-04-13 18:11:34+00
mock_device	{"cpu_usage": 12.03, "mem_total": 15741.32, "mem_usage": 11973.88, "timestamp": 1681409499}	2023-04-13 18:11:39+00
mock_device	{"cpu_usage": 10.23, "mem_total": 15741.32, "mem_usage": 11877.59, "timestamp": 1681409504}	2023-04-13 18:11:44+00
mock_device	{"cpu_usage": 10.37, "mem_total": 15741.32, "mem_usage": 11862.27, "timestamp": 1681409509}	2023-04-13 18:11:49+00
mock_device	{"cpu_usage": 5.58, "mem_total": 15741.32, "mem_usage": 11806.63, "timestamp": 1681409514}	2023-04-13 18:11:54+00
mock_device	{"cpu_usage": 0.87, "mem_total": 15741.32, "mem_usage": 11813.95, "timestamp": 1681409519}	2023-04-13 18:11:59+00
mock_device	{"cpu_usage": 4.82, "mem_total": 15741.32, "mem_usage": 11803.3, "timestamp": 1681409524}	2023-04-13 18:12:04+00
mock_device	{"cpu_usage": 0.96, "mem_total": 15741.32, "mem_usage": 11859.06, "timestamp": 1681409529}	2023-04-13 18:12:09+00
mock_device	{"cpu_usage": 5.85, "mem_total": 15741.32, "mem_usage": 11933.66, "timestamp": 1681409534}	2023-04-13 18:12:14+00
mock_device	{"cpu_usage": 2.9, "mem_total": 15741.32, "mem_usage": 11890.29, "timestamp": 1681409539}	2023-04-13 18:12:19+00
mock_device	{"cpu_usage": 1.27, "mem_total": 15741.32, "mem_usage": 11926.79, "timestamp": 1681409545}	2023-04-13 18:12:25+00
mock_device	{"cpu_usage": 0.29, "mem_total": 15741.32, "mem_usage": 11854.31, "timestamp": 1681409550}	2023-04-13 18:12:30+00
mock_device	{"cpu_usage": 0.1, "mem_total": 15741.32, "mem_usage": 11832.7, "timestamp": 1681409555}	2023-04-13 18:12:35+00
mock_device	{"cpu_usage": 5.56, "mem_total": 15741.32, "mem_usage": 11787.96, "timestamp": 1681409560}	2023-04-13 18:12:40+00
mock_device	{"cpu_usage": 5.66, "mem_total": 15741.32, "mem_usage": 11777.27, "timestamp": 1681409565}	2023-04-13 18:12:45+00
mock_device	{"cpu_usage": 5.6, "mem_total": 15741.32, "mem_usage": 11780.43, "timestamp": 1681409570}	2023-04-13 18:12:50+00
mock_device	{"cpu_usage": 1.37, "mem_total": 15741.32, "mem_usage": 11833.41, "timestamp": 1681409575}	2023-04-13 18:12:55+00
mock_device	{"cpu_usage": 0.29, "mem_total": 15741.32, "mem_usage": 11832.65, "timestamp": 1681409580}	2023-04-13 18:13:00+00
mock_device	{"cpu_usage": 0.39, "mem_total": 15741.32, "mem_usage": 11846.18, "timestamp": 1681409585}	2023-04-13 18:13:05+00
mock_device	{"cpu_usage": 0.78, "mem_total": 15741.32, "mem_usage": 11792.29, "timestamp": 1681409590}	2023-04-13 18:13:10+00
mock_device	{"cpu_usage": 0.76, "mem_total": 15741.32, "mem_usage": 11839.91, "timestamp": 1681409595}	2023-04-13 18:13:15+00
mock_device	{"cpu_usage": 6.28, "mem_total": 15741.32, "mem_usage": 11865.59, "timestamp": 1681409600}	2023-04-13 18:13:20+00
mock_device	{"cpu_usage": 6.73, "mem_total": 15741.32, "mem_usage": 11841.55, "timestamp": 1681409605}	2023-04-13 18:13:25+00
mock_device	{"cpu_usage": 6.53, "mem_total": 15741.32, "mem_usage": 11817.58, "timestamp": 1681409610}	2023-04-13 18:13:30+00
mock_device	{"cpu_usage": 6.46, "mem_total": 15741.32, "mem_usage": 11780.13, "timestamp": 1681409615}	2023-04-13 18:13:35+00
mock_device	{"cpu_usage": 6.61, "mem_total": 15741.32, "mem_usage": 11776.55, "timestamp": 1681409620}	2023-04-13 18:13:40+00
mock_device	{"cpu_usage": 6.46, "mem_total": 15741.32, "mem_usage": 11802.91, "timestamp": 1681409625}	2023-04-13 18:13:45+00
mock_device	{"cpu_usage": 8.69, "mem_total": 15741.32, "mem_usage": 11765.05, "timestamp": 1681409630}	2023-04-13 18:13:50+00
mock_device	{"cpu_usage": 11.29, "mem_total": 15741.32, "mem_usage": 11973.01, "timestamp": 1681409635}	2023-04-13 18:13:55+00
mock_device	{"cpu_usage": 5.53, "mem_total": 15741.32, "mem_usage": 11750.03, "timestamp": 1681409640}	2023-04-13 18:14:00+00
mock_device	{"cpu_usage": 2.03, "mem_total": 15741.32, "mem_usage": 11759.11, "timestamp": 1681409645}	2023-04-13 18:14:05+00
mock_device	{"cpu_usage": 5.1, "mem_total": 15741.32, "mem_usage": 11788.53, "timestamp": 1681409650}	2023-04-13 18:14:10+00
mock_device	{"cpu_usage": 2.44, "mem_total": 15741.32, "mem_usage": 11798.28, "timestamp": 1681409655}	2023-04-13 18:14:15+00
mock_device	{"cpu_usage": 4.68, "mem_total": 15741.32, "mem_usage": 11792.61, "timestamp": 1681409660}	2023-04-13 18:14:20+00
mock_device	{"cpu_usage": 4.26, "mem_total": 15741.32, "mem_usage": 11814.61, "timestamp": 1681409665}	2023-04-13 18:14:25+00
mock_device	{"cpu_usage": 4.8, "mem_total": 15741.32, "mem_usage": 11792.8, "timestamp": 1681409670}	2023-04-13 18:14:30+00
mock_device	{"cpu_usage": 1.91, "mem_total": 15741.32, "mem_usage": 11795.72, "timestamp": 1681409675}	2023-04-13 18:14:35+00
mock_device	{"cpu_usage": 1.56, "mem_total": 15741.32, "mem_usage": 11770.47, "timestamp": 1681409680}	2023-04-13 18:14:40+00
mock_device	{"cpu_usage": 0.29, "mem_total": 15741.32, "mem_usage": 11761.56, "timestamp": 1681409685}	2023-04-13 18:14:45+00
mock_device	{"cpu_usage": 0.5, "mem_total": 15741.32, "mem_usage": 11778.2, "timestamp": 1681409690}	2023-04-13 18:14:50+00
mock_device	{"cpu_usage": 0.57, "mem_total": 15741.32, "mem_usage": 11775.59, "timestamp": 1681409695}	2023-04-13 18:14:55+00
mock_device	{"cpu_usage": 0.2, "mem_total": 15741.32, "mem_usage": 11766.24, "timestamp": 1681409700}	2023-04-13 18:15:00+00
mock_device	{"cpu_usage": 0.39, "mem_total": 15741.32, "mem_usage": 11767.07, "timestamp": 1681409705}	2023-04-13 18:15:05+00
mock_device	{"cpu_usage": 0.38, "mem_total": 15741.32, "mem_usage": 11770.09, "timestamp": 1681409710}	2023-04-13 18:15:10+00
mock_device	{"cpu_usage": 0.3, "mem_total": 15741.32, "mem_usage": 11771.47, "timestamp": 1681409715}	2023-04-13 18:15:15+00
mock_device	{"cpu_usage": 0.090, "mem_total": 15741.32, "mem_usage": 11771.77, "timestamp": 1681409720}	2023-04-13 18:15:20+00
mock_device	{"cpu_usage": 0.69, "mem_total": 15741.32, "mem_usage": 11784, "timestamp": 1681409725}	2023-04-13 18:15:25+00
mock_device	{"cpu_usage": 0.39, "mem_total": 15741.32, "mem_usage": 11794.43, "timestamp": 1681409730}	2023-04-13 18:15:30+00
mock_device	{"cpu_usage": 0.2, "mem_total": 15741.32, "mem_usage": 11782.23, "timestamp": 1681409735}	2023-04-13 18:15:35+00
mock_device	{"cpu_usage": 1.76, "mem_total": 15741.32, "mem_usage": 11765.17, "timestamp": 1681409740}	2023-04-13 18:15:40+00
mock_device	{"cpu_usage": 0.4, "mem_total": 15741.32, "mem_usage": 11789.26, "timestamp": 1681409745}	2023-04-13 18:15:45+00
mock_device	{"cpu_usage": 0.58, "mem_total": 15741.32, "mem_usage": 11765.7, "timestamp": 1681409750}	2023-04-13 18:15:50+00
mock_device	{"cpu_usage": 6.51, "mem_total": 15741.32, "mem_usage": 11802.98, "timestamp": 1681409755}	2023-04-13 18:15:55+00
mock_device	{"cpu_usage": 6.42, "mem_total": 15741.32, "mem_usage": 11831.03, "timestamp": 1681409760}	2023-04-13 18:16:00+00
mock_device	{"cpu_usage": 3.26, "mem_total": 15741.32, "mem_usage": 11927.63, "timestamp": 1681409765}	2023-04-13 18:16:05+00
mock_device	{"cpu_usage": 4.37, "mem_total": 15741.32, "mem_usage": 11726.04, "timestamp": 1681409770}	2023-04-13 18:16:10+00
mock_device	{"cpu_usage": 3.5, "mem_total": 15741.32, "mem_usage": 11694.11, "timestamp": 1681409775}	2023-04-13 18:16:15+00
mock_device	{"cpu_usage": 6.07, "mem_total": 15741.32, "mem_usage": 11694.23, "timestamp": 1681409780}	2023-04-13 18:16:20+00
mock_device	{"cpu_usage": 6.26, "mem_total": 15741.32, "mem_usage": 11678.71, "timestamp": 1681409785}	2023-04-13 18:16:25+00
mock_device	{"cpu_usage": 6.23, "mem_total": 15741.32, "mem_usage": 11887.83, "timestamp": 1681409790}	2023-04-13 18:16:30+00
mock_device	{"cpu_usage": 5.09, "mem_total": 15741.32, "mem_usage": 11830.13, "timestamp": 1681409795}	2023-04-13 18:16:35+00
249396	{"pm10": 45, "pm25": 66, "pm100": 73, "timestamp": 1681409843}	2023-04-13 18:17:23+00
249396	{"pm10": 45, "pm25": 67, "pm100": 74, "timestamp": 1681410035}	2023-04-13 18:20:35+00
249396	{"pm10": 45, "pm25": 65, "pm100": 74, "timestamp": 1681410128}	2023-04-13 18:22:08+00
249396	{"pm10": 45, "pm25": 65, "pm100": 73, "timestamp": 1681410221}	2023-04-13 18:23:41+00
249396	{"pm10": 44, "pm25": 68, "pm100": 74, "timestamp": 1681410324}	2023-04-13 18:25:24+00
249396	{"pm10": 44, "pm25": 68, "pm100": 74, "timestamp": 1681410357}	2023-04-13 18:25:57+00
249396	{"pm10": 43, "pm25": 68, "pm100": 74, "timestamp": 1681410390}	2023-04-13 18:26:30+00
249396	{"pm10": 42, "pm25": 66, "pm100": 73, "timestamp": 1681410423}	2023-04-13 18:27:03+00
249396	{"pm10": 42, "pm25": 64, "pm100": 72, "timestamp": 1681410456}	2023-04-13 18:27:36+00
249396	{"pm10": 41, "pm25": 63, "pm100": 71, "timestamp": 1681410489}	2023-04-13 18:28:09+00
249396	{"pm10": 42, "pm25": 64, "pm100": 72, "timestamp": 1681410522}	2023-04-13 18:28:42+00
249396	{"pm10": 41, "pm25": 63, "pm100": 72, "timestamp": 1681410556}	2023-04-13 18:29:16+00
249396	{"pm10": 43, "pm25": 66, "pm100": 74, "timestamp": 1681410589}	2023-04-13 18:29:49+00
249396	{"pm10": 44, "pm25": 68, "pm100": 75, "timestamp": 1681410622}	2023-04-13 18:30:22+00
249396	{"pm10": 46, "pm25": 67, "pm100": 75, "timestamp": 1681410693}	2023-04-13 18:31:33+00
249396	{"pm10": 45, "pm25": 65, "pm100": 73, "timestamp": 1681410726}	2023-04-13 18:32:06+00
249396	{"pm10": 46, "pm25": 67, "pm100": 75, "timestamp": 1681410759}	2023-04-13 18:32:39+00
249396	{"pm10": 47, "pm25": 67, "pm100": 75, "timestamp": 1681410792}	2023-04-13 18:33:12+00
249396	{"pm10": 47, "pm25": 69, "pm100": 76, "timestamp": 1681410825}	2023-04-13 18:33:45+00
249396	{"pm10": 47, "pm25": 67, "pm100": 75, "timestamp": 1681410858}	2023-04-13 18:34:18+00
249396	{"pm10": 46, "pm25": 67, "pm100": 75, "timestamp": 1681410891}	2023-04-13 18:34:51+00
249396	{"pm10": 47, "pm25": 68, "pm100": 76, "timestamp": 1681410925}	2023-04-13 18:35:25+00
249396	{"pm10": 41, "pm25": 59, "pm100": 69, "timestamp": 1681410958}	2023-04-13 18:35:58+00
249396	{"pm10": 39, "pm25": 58, "pm100": 68, "timestamp": 1681410991}	2023-04-13 18:36:31+00
249396	{"pm10": 39, "pm25": 57, "pm100": 68, "timestamp": 1681411024}	2023-04-13 18:37:04+00
249396	{"pm10": 39, "pm25": 59, "pm100": 69, "timestamp": 1681411057}	2023-04-13 18:37:37+00
249396	{"pm10": 39, "pm25": 57, "pm100": 67, "timestamp": 1681411090}	2023-04-13 18:38:10+00
249396	{"pm10": 38, "pm25": 55, "pm100": 67, "timestamp": 1681411123}	2023-04-13 18:38:43+00
249396	{"pm10": 37, "pm25": 54, "pm100": 66, "timestamp": 1681411157}	2023-04-13 18:39:17+00
249396	{"pm10": 37, "pm25": 56, "pm100": 67, "timestamp": 1681411191}	2023-04-13 18:39:51+00
249396	{"pm10": 38, "pm25": 57, "pm100": 67, "timestamp": 1681411224}	2023-04-13 18:40:24+00
249396	{"pm10": 38, "pm25": 57, "pm100": 67, "timestamp": 1681411257}	2023-04-13 18:40:57+00
249396	{"pm10": 38, "pm25": 56, "pm100": 67, "timestamp": 1681411290}	2023-04-13 18:41:30+00
249396	{"pm10": 38, "pm25": 57, "pm100": 67, "timestamp": 1681411323}	2023-04-13 18:42:03+00
249396	{"pm10": 39, "pm25": 59, "pm100": 68, "timestamp": 1681411356}	2023-04-13 18:42:36+00
249396	{"pm10": 39, "pm25": 59, "pm100": 68, "timestamp": 1681411389}	2023-04-13 18:43:09+00
249396	{"pm10": 39, "pm25": 59, "pm100": 68, "timestamp": 1681411423}	2023-04-13 18:43:43+00
249396	{"pm10": 39, "pm25": 59, "pm100": 68, "timestamp": 1681411456}	2023-04-13 18:44:16+00
249396	{"pm10": 42, "pm25": 63, "pm100": 72, "timestamp": 1681411489}	2023-04-13 18:44:49+00
249396	{"pm10": 43, "pm25": 64, "pm100": 73, "timestamp": 1681411522}	2023-04-13 18:45:22+00
249396	{"pm10": 43, "pm25": 64, "pm100": 73, "timestamp": 1681411555}	2023-04-13 18:45:55+00
249396	{"pm10": 43, "pm25": 63, "pm100": 72, "timestamp": 1681411588}	2023-04-13 18:46:28+00
249396	{"pm10": 43, "pm25": 63, "pm100": 72, "timestamp": 1681411621}	2023-04-13 18:47:01+00
249396	{"pm10": 44, "pm25": 67, "pm100": 75, "timestamp": 1681411655}	2023-04-13 18:47:35+00
249396	{"pm10": 44, "pm25": 67, "pm100": 75, "timestamp": 1681411688}	2023-04-13 18:48:08+00
249396	{"pm10": 43, "pm25": 65, "pm100": 74, "timestamp": 1681411721}	2023-04-13 18:48:41+00
249396	{"pm10": 43, "pm25": 65, "pm100": 74, "timestamp": 1681411754}	2023-04-13 18:49:14+00
249396	{"pm10": 45, "pm25": 66, "pm100": 73, "timestamp": 1681411787}	2023-04-13 18:49:47+00
249396	{"pm10": 45, "pm25": 67, "pm100": 74, "timestamp": 1681411820}	2023-04-13 18:50:20+00
249396	{"pm10": 43, "pm25": 63, "pm100": 71, "timestamp": 1681411853}	2023-04-13 18:50:53+00
249396	{"pm10": 44, "pm25": 63, "pm100": 71, "timestamp": 1681411887}	2023-04-13 18:51:27+00
249396	{"pm10": 44, "pm25": 63, "pm100": 71, "timestamp": 1681411920}	2023-04-13 18:52:00+00
249396	{"pm10": 44, "pm25": 62, "pm100": 72, "timestamp": 1681411953}	2023-04-13 18:52:33+00
249396	{"pm10": 44, "pm25": 64, "pm100": 72, "timestamp": 1681411986}	2023-04-13 18:53:06+00
249396	{"pm10": 44, "pm25": 64, "pm100": 72, "timestamp": 1681412019}	2023-04-13 18:53:39+00
249396	{"pm10": 41, "pm25": 64, "pm100": 73, "timestamp": 1681412929}	2023-04-13 19:08:49+00
249396	{"pm10": 41, "pm25": 64, "pm100": 73, "timestamp": 1681412935}	2023-04-13 19:08:55+00
249396	{"pm10": 41, "pm25": 64, "pm100": 74, "timestamp": 1681412941}	2023-04-13 19:09:01+00
249396	{"pm10": 41, "pm25": 64, "pm100": 74, "timestamp": 1681412948}	2023-04-13 19:09:08+00
249396	{"pm10": 41, "pm25": 63, "pm100": 73, "timestamp": 1681412954}	2023-04-13 19:09:14+00
249396	{"pm10": 42, "pm25": 63, "pm100": 73, "timestamp": 1681412960}	2023-04-13 19:09:20+00
249396	{"pm10": 43, "pm25": 62, "pm100": 72, "timestamp": 1681412966}	2023-04-13 19:09:26+00
249396	{"pm10": 43, "pm25": 62, "pm100": 71, "timestamp": 1681412972}	2023-04-13 19:09:32+00
249396	{"pm10": 43, "pm25": 61, "pm100": 71, "timestamp": 1681412978}	2023-04-13 19:09:38+00
249396	{"pm10": 44, "pm25": 63, "pm100": 72, "timestamp": 1681412984}	2023-04-13 19:09:44+00
249396	{"pm10": 40, "pm25": 58, "pm100": 69, "timestamp": 1681412990}	2023-04-13 19:09:50+00
249396	{"pm10": 38, "pm25": 58, "pm100": 69, "timestamp": 1681412997}	2023-04-13 19:09:57+00
249396	{"pm10": 39, "pm25": 57, "pm100": 69, "timestamp": 1681413003}	2023-04-13 19:10:03+00
249396	{"pm10": 39, "pm25": 58, "pm100": 69, "timestamp": 1681413009}	2023-04-13 19:10:09+00
249396	{"pm10": 42, "pm25": 62, "pm100": 72, "timestamp": 1681413036}	2023-04-13 19:10:36+00
249396	{"pm10": 42, "pm25": 62, "pm100": 72, "timestamp": 1681413042}	2023-04-13 19:10:42+00
249396	{"pm10": 42, "pm25": 63, "pm100": 72, "timestamp": 1681413048}	2023-04-13 19:10:48+00
249396	{"pm10": 41, "pm25": 62, "pm100": 71, "timestamp": 1681413054}	2023-04-13 19:10:54+00
249396	{"pm10": 40, "pm25": 61, "pm100": 71, "timestamp": 1681413060}	2023-04-13 19:11:00+00
249396	{"pm10": 40, "pm25": 62, "pm100": 71, "timestamp": 1681413066}	2023-04-13 19:11:06+00
249396	{"pm10": 41, "pm25": 62, "pm100": 71, "timestamp": 1681413072}	2023-04-13 19:11:12+00
249396	{"pm10": 40, "pm25": 63, "pm100": 72, "timestamp": 1681413079}	2023-04-13 19:11:19+00
249396	{"pm10": 41, "pm25": 61, "pm100": 71, "timestamp": 1681413085}	2023-04-13 19:11:25+00
249396	{"pm10": 40, "pm25": 60, "pm100": 70, "timestamp": 1681413091}	2023-04-13 19:11:31+00
249396	{"pm10": 40, "pm25": 60, "pm100": 70, "timestamp": 1681413097}	2023-04-13 19:11:37+00
249396	{"pm10": 44, "pm25": 66, "pm100": 73, "timestamp": 1681413103}	2023-04-13 19:11:43+00
249396	{"pm10": 44, "pm25": 65, "pm100": 73, "timestamp": 1681413109}	2023-04-13 19:11:49+00
249396	{"pm10": 44, "pm25": 62, "pm100": 72, "timestamp": 1681413115}	2023-04-13 19:11:55+00
249396	{"pm10": 44, "pm25": 63, "pm100": 72, "timestamp": 1681413121}	2023-04-13 19:12:01+00
249396	{"pm10": 44, "pm25": 65, "pm100": 73, "timestamp": 1681413128}	2023-04-13 19:12:08+00
249396	{"pm10": 45, "pm25": 66, "pm100": 73, "timestamp": 1681413134}	2023-04-13 19:12:14+00
249396	{"pm10": 44, "pm25": 67, "pm100": 74, "timestamp": 1681413140}	2023-04-13 19:12:20+00
249396	{"pm10": 45, "pm25": 67, "pm100": 74, "timestamp": 1681413146}	2023-04-13 19:12:26+00
249396	{"pm10": 44, "pm25": 67, "pm100": 73, "timestamp": 1681413152}	2023-04-13 19:12:32+00
249396	{"pm10": 44, "pm25": 67, "pm100": 73, "timestamp": 1681413158}	2023-04-13 19:12:38+00
249396	{"pm10": 44, "pm25": 65, "pm100": 73, "timestamp": 1681413164}	2023-04-13 19:12:44+00
249396	{"pm10": 44, "pm25": 65, "pm100": 73, "timestamp": 1681413170}	2023-04-13 19:12:50+00
249396	{"pm10": 41, "pm25": 59, "pm100": 69, "timestamp": 1681413177}	2023-04-13 19:12:57+00
249396	{"pm10": 43, "pm25": 61, "pm100": 70, "timestamp": 1681413183}	2023-04-13 19:13:03+00
249396	{"pm10": 43, "pm25": 61, "pm100": 70, "timestamp": 1681413189}	2023-04-13 19:13:09+00
249396	{"pm10": 43, "pm25": 65, "pm100": 73, "timestamp": 1681413195}	2023-04-13 19:13:15+00
249396	{"pm10": 43, "pm25": 65, "pm100": 73, "timestamp": 1681413201}	2023-04-13 19:13:21+00
249396	{"pm10": 44, "pm25": 65, "pm100": 73, "timestamp": 1681413207}	2023-04-13 19:13:27+00
249396	{"pm10": 44, "pm25": 63, "pm100": 73, "timestamp": 1681413213}	2023-04-13 19:13:33+00
249396	{"pm10": 45, "pm25": 63, "pm100": 72, "timestamp": 1681413219}	2023-04-13 19:13:39+00
249396	{"pm10": 42, "pm25": 63, "pm100": 72, "timestamp": 1681413226}	2023-04-13 19:13:46+00
249396	{"pm10": 42, "pm25": 62, "pm100": 72, "timestamp": 1681413232}	2023-04-13 19:13:52+00
249396	{"pm10": 42, "pm25": 62, "pm100": 72, "timestamp": 1681413238}	2023-04-13 19:13:58+00
249396	{"pm10": 43, "pm25": 63, "pm100": 73, "timestamp": 1681413244}	2023-04-13 19:14:04+00
249396	{"pm10": 43, "pm25": 63, "pm100": 73, "timestamp": 1681413250}	2023-04-13 19:14:10+00
249396	{"pm10": 43, "pm25": 63, "pm100": 73, "timestamp": 1681413256}	2023-04-13 19:14:16+00
249396	{"pm10": 43, "pm25": 64, "pm100": 73, "timestamp": 1681413262}	2023-04-13 19:14:22+00
249396	{"pm10": 43, "pm25": 61, "pm100": 70, "timestamp": 1681413268}	2023-04-13 19:14:28+00
249396	{"pm10": 44, "pm25": 61, "pm100": 70, "timestamp": 1681413275}	2023-04-13 19:14:35+00
249396	{"pm10": 45, "pm25": 62, "pm100": 71, "timestamp": 1681413281}	2023-04-13 19:14:41+00
249396	{"pm10": 45, "pm25": 62, "pm100": 71, "timestamp": 1681413287}	2023-04-13 19:14:47+00
249396	{"pm10": 45, "pm25": 62, "pm100": 71, "timestamp": 1681413293}	2023-04-13 19:14:53+00
249396	{"pm10": 45, "pm25": 62, "pm100": 71, "timestamp": 1681413299}	2023-04-13 19:14:59+00
249396	{"pm10": 45, "pm25": 61, "pm100": 70, "timestamp": 1681413305}	2023-04-13 19:15:05+00
249396	{"pm10": 43, "pm25": 63, "pm100": 72, "timestamp": 1681413311}	2023-04-13 19:15:11+00
249396	{"pm10": 43, "pm25": 63, "pm100": 72, "timestamp": 1681413317}	2023-04-13 19:15:17+00
249396	{"pm10": 42, "pm25": 62, "pm100": 71, "timestamp": 1681413324}	2023-04-13 19:15:24+00
249396	{"pm10": 42, "pm25": 62, "pm100": 71, "timestamp": 1681413330}	2023-04-13 19:15:30+00
249396	{"pm10": 42, "pm25": 61, "pm100": 70, "timestamp": 1681413336}	2023-04-13 19:15:36+00
249396	{"pm10": 42, "pm25": 65, "pm100": 72, "timestamp": 1681413342}	2023-04-13 19:15:42+00
249396	{"pm10": 42, "pm25": 63, "pm100": 71, "timestamp": 1681413348}	2023-04-13 19:15:48+00
249396	{"pm10": 43, "pm25": 64, "pm100": 72, "timestamp": 1681413354}	2023-04-13 19:15:54+00
249396	{"pm10": 44, "pm25": 65, "pm100": 73, "timestamp": 1681413360}	2023-04-13 19:16:00+00
249396	{"pm10": 43, "pm25": 65, "pm100": 73, "timestamp": 1681413367}	2023-04-13 19:16:07+00
249396	{"pm10": 43, "pm25": 65, "pm100": 73, "timestamp": 1681413373}	2023-04-13 19:16:13+00
249396	{"pm10": 45, "pm25": 64, "pm100": 73, "timestamp": 1681413379}	2023-04-13 19:16:19+00
249396	{"pm10": 44, "pm25": 63, "pm100": 72, "timestamp": 1681413385}	2023-04-13 19:16:25+00
249396	{"pm10": 43, "pm25": 62, "pm100": 71, "timestamp": 1681413391}	2023-04-13 19:16:31+00
249396	{"pm10": 43, "pm25": 62, "pm100": 71, "timestamp": 1681413397}	2023-04-13 19:16:37+00
249396	{"pm10": 43, "pm25": 62, "pm100": 71, "timestamp": 1681413404}	2023-04-13 19:16:44+00
249396	{"pm10": 44, "pm25": 63, "pm100": 72, "timestamp": 1681413410}	2023-04-13 19:16:50+00
249396	{"pm10": 44, "pm25": 64, "pm100": 72, "timestamp": 1681413416}	2023-04-13 19:16:56+00
249396	{"pm10": 43, "pm25": 62, "pm100": 71, "timestamp": 1681413422}	2023-04-13 19:17:02+00
249396	{"pm10": 43, "pm25": 61, "pm100": 71, "timestamp": 1681413428}	2023-04-13 19:17:08+00
249396	{"pm10": 43, "pm25": 61, "pm100": 70, "timestamp": 1681413434}	2023-04-13 19:17:14+00
249396	{"pm10": 43, "pm25": 60, "pm100": 70, "timestamp": 1681413441}	2023-04-13 19:17:21+00
249396	{"pm10": 42, "pm25": 60, "pm100": 70, "timestamp": 1681413447}	2023-04-13 19:17:27+00
249396	{"pm10": 41, "pm25": 61, "pm100": 71, "timestamp": 1681413453}	2023-04-13 19:17:33+00
249396	{"pm10": 42, "pm25": 62, "pm100": 71, "timestamp": 1681413459}	2023-04-13 19:17:39+00
249396	{"pm10": 42, "pm25": 64, "pm100": 72, "timestamp": 1681413465}	2023-04-13 19:17:45+00
249396	{"pm10": 43, "pm25": 66, "pm100": 73, "timestamp": 1681413471}	2023-04-13 19:17:51+00
249396	{"pm10": 43, "pm25": 65, "pm100": 73, "timestamp": 1681413477}	2023-04-13 19:17:57+00
249396	{"pm10": 42, "pm25": 62, "pm100": 72, "timestamp": 1681413483}	2023-04-13 19:18:03+00
249396	{"pm10": 41, "pm25": 60, "pm100": 70, "timestamp": 1681413490}	2023-04-13 19:18:10+00
249396	{"pm10": 41, "pm25": 59, "pm100": 70, "timestamp": 1681413496}	2023-04-13 19:18:16+00
249396	{"pm10": 41, "pm25": 59, "pm100": 70, "timestamp": 1681413502}	2023-04-13 19:18:22+00
249396	{"pm10": 41, "pm25": 58, "pm100": 69, "timestamp": 1681413508}	2023-04-13 19:18:28+00
249396	{"pm10": 45, "pm25": 66, "pm100": 73, "timestamp": 1681413514}	2023-04-13 19:18:34+00
249396	{"pm10": 44, "pm25": 63, "pm100": 72, "timestamp": 1681413520}	2023-04-13 19:18:40+00
249396	{"pm10": 42, "pm25": 62, "pm100": 71, "timestamp": 1681413526}	2023-04-13 19:18:46+00
249396	{"pm10": 42, "pm25": 62, "pm100": 71, "timestamp": 1681413532}	2023-04-13 19:18:52+00
249396	{"pm10": 42, "pm25": 62, "pm100": 71, "timestamp": 1681413539}	2023-04-13 19:18:59+00
249396	{"pm10": 42, "pm25": 61, "pm100": 71, "timestamp": 1681413545}	2023-04-13 19:19:05+00
249396	{"pm10": 42, "pm25": 60, "pm100": 70, "timestamp": 1681413551}	2023-04-13 19:19:11+00
249396	{"pm10": 42, "pm25": 59, "pm100": 69, "timestamp": 1681413557}	2023-04-13 19:19:17+00
249396	{"pm10": 43, "pm25": 61, "pm100": 70, "timestamp": 1681413563}	2023-04-13 19:19:23+00
249396	{"pm10": 42, "pm25": 62, "pm100": 70, "timestamp": 1681413569}	2023-04-13 19:19:29+00
249396	{"pm10": 41, "pm25": 61, "pm100": 72, "timestamp": 1681413575}	2023-04-13 19:19:35+00
249396	{"pm10": 40, "pm25": 59, "pm100": 70, "timestamp": 1681413581}	2023-04-13 19:19:41+00
249396	{"pm10": 41, "pm25": 59, "pm100": 69, "timestamp": 1681413588}	2023-04-13 19:19:48+00
249396	{"pm10": 42, "pm25": 61, "pm100": 70, "timestamp": 1681413594}	2023-04-13 19:19:54+00
249396	{"pm10": 41, "pm25": 62, "pm100": 71, "timestamp": 1681413600}	2023-04-13 19:20:00+00
249396	{"pm10": 42, "pm25": 62, "pm100": 71, "timestamp": 1681413606}	2023-04-13 19:20:06+00
249396	{"pm10": 42, "pm25": 62, "pm100": 71, "timestamp": 1681413612}	2023-04-13 19:20:12+00
249396	{"pm10": 43, "pm25": 63, "pm100": 72, "timestamp": 1681413618}	2023-04-13 19:20:18+00
249396	{"pm10": 43, "pm25": 63, "pm100": 72, "timestamp": 1681413624}	2023-04-13 19:20:24+00
249396	{"pm10": 43, "pm25": 62, "pm100": 71, "timestamp": 1681413630}	2023-04-13 19:20:30+00
249396	{"pm10": 44, "pm25": 61, "pm100": 71, "timestamp": 1681413637}	2023-04-13 19:20:37+00
249396	{"pm10": 43, "pm25": 64, "pm100": 72, "timestamp": 1681413643}	2023-04-13 19:20:43+00
249396	{"pm10": 44, "pm25": 63, "pm100": 71, "timestamp": 1681413649}	2023-04-13 19:20:49+00
249396	{"pm10": 44, "pm25": 63, "pm100": 71, "timestamp": 1681413655}	2023-04-13 19:20:55+00
249396	{"pm10": 44, "pm25": 64, "pm100": 72, "timestamp": 1681413661}	2023-04-13 19:21:01+00
249396	{"pm10": 44, "pm25": 64, "pm100": 72, "timestamp": 1681413667}	2023-04-13 19:21:07+00
249396	{"pm10": 41, "pm25": 59, "pm100": 70, "timestamp": 1681413673}	2023-04-13 19:21:13+00
249396	{"pm10": 41, "pm25": 60, "pm100": 70, "timestamp": 1681413680}	2023-04-13 19:21:20+00
249396	{"pm10": 43, "pm25": 65, "pm100": 73, "timestamp": 1681413686}	2023-04-13 19:21:26+00
249396	{"pm10": 43, "pm25": 65, "pm100": 73, "timestamp": 1681413692}	2023-04-13 19:21:32+00
249396	{"pm10": 43, "pm25": 65, "pm100": 73, "timestamp": 1681413698}	2023-04-13 19:21:38+00
249396	{"pm10": 42, "pm25": 64, "pm100": 72, "timestamp": 1681413704}	2023-04-13 19:21:44+00
249396	{"pm10": 42, "pm25": 66, "pm100": 73, "timestamp": 1681413710}	2023-04-13 19:21:50+00
249396	{"pm10": 42, "pm25": 65, "pm100": 73, "timestamp": 1681413716}	2023-04-13 19:21:56+00
249396	{"pm10": 42, "pm25": 65, "pm100": 73, "timestamp": 1681413722}	2023-04-13 19:22:02+00
249396	{"pm10": 41, "pm25": 65, "pm100": 73, "timestamp": 1681413729}	2023-04-13 19:22:09+00
249396	{"pm10": 41, "pm25": 65, "pm100": 73, "timestamp": 1681413735}	2023-04-13 19:22:15+00
249396	{"pm10": 42, "pm25": 65, "pm100": 73, "timestamp": 1681413741}	2023-04-13 19:22:21+00
249396	{"pm10": 42, "pm25": 65, "pm100": 74, "timestamp": 1681413747}	2023-04-13 19:22:27+00
249396	{"pm10": 42, "pm25": 65, "pm100": 74, "timestamp": 1681413753}	2023-04-13 19:22:33+00
249396	{"pm10": 42, "pm25": 63, "pm100": 72, "timestamp": 1681413759}	2023-04-13 19:22:39+00
249396	{"pm10": 42, "pm25": 63, "pm100": 73, "timestamp": 1681413765}	2023-04-13 19:22:45+00
249396	{"pm10": 41, "pm25": 63, "pm100": 73, "timestamp": 1681413771}	2023-04-13 19:22:51+00
249396	{"pm10": 40, "pm25": 59, "pm100": 70, "timestamp": 1681413778}	2023-04-13 19:22:58+00
249396	{"pm10": 42, "pm25": 61, "pm100": 71, "timestamp": 1681413784}	2023-04-13 19:23:04+00
249396	{"pm10": 42, "pm25": 60, "pm100": 70, "timestamp": 1681413790}	2023-04-13 19:23:10+00
249396	{"pm10": 41, "pm25": 64, "pm100": 73, "timestamp": 1681413796}	2023-04-13 19:23:16+00
249396	{"pm10": 41, "pm25": 63, "pm100": 72, "timestamp": 1681413802}	2023-04-13 19:23:22+00
249396	{"pm10": 41, "pm25": 62, "pm100": 72, "timestamp": 1681413808}	2023-04-13 19:23:28+00
249396	{"pm10": 41, "pm25": 62, "pm100": 72, "timestamp": 1681413814}	2023-04-13 19:23:34+00
249396	{"pm10": 41, "pm25": 62, "pm100": 72, "timestamp": 1681413820}	2023-04-13 19:23:40+00
249396	{"pm10": 42, "pm25": 63, "pm100": 73, "timestamp": 1681413827}	2023-04-13 19:23:47+00
249396	{"pm10": 41, "pm25": 62, "pm100": 71, "timestamp": 1681413833}	2023-04-13 19:23:53+00
249396	{"pm10": 42, "pm25": 62, "pm100": 71, "timestamp": 1681413839}	2023-04-13 19:23:59+00
249396	{"pm10": 41, "pm25": 61, "pm100": 70, "timestamp": 1681413845}	2023-04-13 19:24:05+00
249396	{"pm10": 41, "pm25": 61, "pm100": 71, "timestamp": 1681413851}	2023-04-13 19:24:11+00
249396	{"pm10": 43, "pm25": 61, "pm100": 72, "timestamp": 1681413857}	2023-04-13 19:24:17+00
249396	{"pm10": 42, "pm25": 61, "pm100": 71, "timestamp": 1681413863}	2023-04-13 19:24:23+00
249396	{"pm10": 41, "pm25": 61, "pm100": 71, "timestamp": 1681413869}	2023-04-13 19:24:29+00
249396	{"pm10": 41, "pm25": 61, "pm100": 72, "timestamp": 1681413876}	2023-04-13 19:24:36+00
249396	{"pm10": 41, "pm25": 61, "pm100": 72, "timestamp": 1681413882}	2023-04-13 19:24:42+00
249396	{"pm10": 43, "pm25": 66, "pm100": 73, "timestamp": 1681413888}	2023-04-13 19:24:48+00
249396	{"pm10": 43, "pm25": 66, "pm100": 73, "timestamp": 1681413894}	2023-04-13 19:24:54+00
249396	{"pm10": 43, "pm25": 63, "pm100": 73, "timestamp": 1681413900}	2023-04-13 19:25:00+00
249396	{"pm10": 42, "pm25": 62, "pm100": 72, "timestamp": 1681413906}	2023-04-13 19:25:06+00
249396	{"pm10": 41, "pm25": 62, "pm100": 71, "timestamp": 1681413912}	2023-04-13 19:25:12+00
249396	{"pm10": 41, "pm25": 62, "pm100": 71, "timestamp": 1681413918}	2023-04-13 19:25:18+00
249396	{"pm10": 41, "pm25": 61, "pm100": 70, "timestamp": 1681413925}	2023-04-13 19:25:25+00
249396	{"pm10": 40, "pm25": 58, "pm100": 68, "timestamp": 1681413931}	2023-04-13 19:25:31+00
249396	{"pm10": 41, "pm25": 57, "pm100": 68, "timestamp": 1681413937}	2023-04-13 19:25:37+00
249396	{"pm10": 42, "pm25": 62, "pm100": 70, "timestamp": 1681413943}	2023-04-13 19:25:43+00
249396	{"pm10": 42, "pm25": 61, "pm100": 70, "timestamp": 1681413949}	2023-04-13 19:25:49+00
249396	{"pm10": 41, "pm25": 59, "pm100": 69, "timestamp": 1681413955}	2023-04-13 19:25:55+00
249396	{"pm10": 41, "pm25": 58, "pm100": 69, "timestamp": 1681413961}	2023-04-13 19:26:01+00
249396	{"pm10": 42, "pm25": 63, "pm100": 72, "timestamp": 1681413967}	2023-04-13 19:26:07+00
249396	{"pm10": 42, "pm25": 63, "pm100": 72, "timestamp": 1681413974}	2023-04-13 19:26:14+00
249396	{"pm10": 43, "pm25": 63, "pm100": 72, "timestamp": 1681413980}	2023-04-13 19:26:20+00
249396	{"pm10": 43, "pm25": 63, "pm100": 72, "timestamp": 1681413986}	2023-04-13 19:26:26+00
249396	{"pm10": 42, "pm25": 61, "pm100": 70, "timestamp": 1681413992}	2023-04-13 19:26:32+00
249396	{"pm10": 39, "pm25": 56, "pm100": 67, "timestamp": 1681413998}	2023-04-13 19:26:38+00
249396	{"pm10": 38, "pm25": 55, "pm100": 67, "timestamp": 1681414004}	2023-04-13 19:26:44+00
249396	{"pm10": 40, "pm25": 59, "pm100": 69, "timestamp": 1681414010}	2023-04-13 19:26:50+00
249396	{"pm10": 40, "pm25": 58, "pm100": 69, "timestamp": 1681414016}	2023-04-13 19:26:56+00
249396	{"pm10": 41, "pm25": 59, "pm100": 69, "timestamp": 1681414023}	2023-04-13 19:27:03+00
249396	{"pm10": 40, "pm25": 59, "pm100": 70, "timestamp": 1681414029}	2023-04-13 19:27:09+00
249396	{"pm10": 41, "pm25": 59, "pm100": 70, "timestamp": 1681414035}	2023-04-13 19:27:15+00
249396	{"pm10": 41, "pm25": 59, "pm100": 70, "timestamp": 1681414041}	2023-04-13 19:27:21+00
249396	{"pm10": 41, "pm25": 60, "pm100": 70, "timestamp": 1681414047}	2023-04-13 19:27:27+00
249396	{"pm10": 41, "pm25": 61, "pm100": 72, "timestamp": 1681414053}	2023-04-13 19:27:33+00
249396	{"pm10": 41, "pm25": 63, "pm100": 72, "timestamp": 1681414059}	2023-04-13 19:27:39+00
249396	{"pm10": 40, "pm25": 59, "pm100": 70, "timestamp": 1681414065}	2023-04-13 19:27:45+00
249396	{"pm10": 40, "pm25": 59, "pm100": 70, "timestamp": 1681414072}	2023-04-13 19:27:52+00
249396	{"pm10": 40, "pm25": 59, "pm100": 70, "timestamp": 1681414078}	2023-04-13 19:27:58+00
249396	{"pm10": 39, "pm25": 57, "pm100": 69, "timestamp": 1681414084}	2023-04-13 19:28:04+00
249396	{"pm10": 39, "pm25": 57, "pm100": 69, "timestamp": 1681414090}	2023-04-13 19:28:10+00
249396	{"pm10": 42, "pm25": 63, "pm100": 72, "timestamp": 1681414100}	2023-04-13 19:28:20+00
249396	{"pm10": 42, "pm25": 63, "pm100": 72, "timestamp": 1681414106}	2023-04-13 19:28:26+00
249396	{"pm10": 42, "pm25": 61, "pm100": 72, "timestamp": 1681414112}	2023-04-13 19:28:32+00
249396	{"pm10": 42, "pm25": 61, "pm100": 71, "timestamp": 1681414118}	2023-04-13 19:28:38+00
249396	{"pm10": 42, "pm25": 61, "pm100": 71, "timestamp": 1681414125}	2023-04-13 19:28:45+00
249396	{"pm10": 43, "pm25": 62, "pm100": 71, "timestamp": 1681414131}	2023-04-13 19:28:51+00
249396	{"pm10": 44, "pm25": 63, "pm100": 73, "timestamp": 1681414137}	2023-04-13 19:28:57+00
249396	{"pm10": 43, "pm25": 61, "pm100": 72, "timestamp": 1681414143}	2023-04-13 19:29:03+00
249396	{"pm10": 41, "pm25": 60, "pm100": 70, "timestamp": 1681414149}	2023-04-13 19:29:09+00
249396	{"pm10": 41, "pm25": 61, "pm100": 70, "timestamp": 1681414155}	2023-04-13 19:29:15+00
249396	{"pm10": 42, "pm25": 62, "pm100": 71, "timestamp": 1681414161}	2023-04-13 19:29:21+00
249396	{"pm10": 39, "pm25": 59, "pm100": 69, "timestamp": 1681414168}	2023-04-13 19:29:28+00
249396	{"pm10": 40, "pm25": 60, "pm100": 70, "timestamp": 1681414174}	2023-04-13 19:29:34+00
249396	{"pm10": 37, "pm25": 53, "pm100": 65, "timestamp": 1681414180}	2023-04-13 19:29:40+00
249396	{"pm10": 37, "pm25": 53, "pm100": 65, "timestamp": 1681414186}	2023-04-13 19:29:46+00
249396	{"pm10": 37, "pm25": 54, "pm100": 66, "timestamp": 1681414192}	2023-04-13 19:29:52+00
249396	{"pm10": 37, "pm25": 54, "pm100": 66, "timestamp": 1681414198}	2023-04-13 19:29:58+00
249396	{"pm10": 38, "pm25": 55, "pm100": 66, "timestamp": 1681414204}	2023-04-13 19:30:04+00
249396	{"pm10": 39, "pm25": 58, "pm100": 69, "timestamp": 1681414210}	2023-04-13 19:30:10+00
249396	{"pm10": 39, "pm25": 59, "pm100": 69, "timestamp": 1681414217}	2023-04-13 19:30:17+00
249396	{"pm10": 39, "pm25": 59, "pm100": 70, "timestamp": 1681414223}	2023-04-13 19:30:23+00
249396	{"pm10": 36, "pm25": 52, "pm100": 64, "timestamp": 1681414229}	2023-04-13 19:30:29+00
249396	{"pm10": 36, "pm25": 52, "pm100": 64, "timestamp": 1681414235}	2023-04-13 19:30:35+00
249396	{"pm10": 37, "pm25": 56, "pm100": 67, "timestamp": 1681414241}	2023-04-13 19:30:41+00
249396	{"pm10": 37, "pm25": 56, "pm100": 67, "timestamp": 1681414247}	2023-04-13 19:30:47+00
249396	{"pm10": 37, "pm25": 56, "pm100": 67, "timestamp": 1681414253}	2023-04-13 19:30:53+00
249396	{"pm10": 37, "pm25": 56, "pm100": 67, "timestamp": 1681414259}	2023-04-13 19:30:59+00
249396	{"pm10": 37, "pm25": 55, "pm100": 67, "timestamp": 1681414266}	2023-04-13 19:31:06+00
249396	{"pm10": 39, "pm25": 57, "pm100": 68, "timestamp": 1681414272}	2023-04-13 19:31:12+00
249396	{"pm10": 38, "pm25": 55, "pm100": 67, "timestamp": 1681414278}	2023-04-13 19:31:18+00
249396	{"pm10": 37, "pm25": 55, "pm100": 67, "timestamp": 1681414284}	2023-04-13 19:31:24+00
249396	{"pm10": 37, "pm25": 55, "pm100": 67, "timestamp": 1681414290}	2023-04-13 19:31:30+00
249396	{"pm10": 37, "pm25": 55, "pm100": 66, "timestamp": 1681414296}	2023-04-13 19:31:36+00
249396	{"pm10": 37, "pm25": 55, "pm100": 66, "timestamp": 1681414302}	2023-04-13 19:31:42+00
249396	{"pm10": 38, "pm25": 57, "pm100": 67, "timestamp": 1681414308}	2023-04-13 19:31:48+00
249396	{"pm10": 38, "pm25": 57, "pm100": 67, "timestamp": 1681414315}	2023-04-13 19:31:55+00
249396	{"pm10": 37, "pm25": 56, "pm100": 67, "timestamp": 1681414321}	2023-04-13 19:32:01+00
249396	{"pm10": 37, "pm25": 56, "pm100": 67, "timestamp": 1681414327}	2023-04-13 19:32:07+00
249396	{"pm10": 38, "pm25": 63, "pm100": 72, "timestamp": 1681414333}	2023-04-13 19:32:13+00
249396	{"pm10": 37, "pm25": 63, "pm100": 71, "timestamp": 1681414339}	2023-04-13 19:32:19+00
249396	{"pm10": 37, "pm25": 61, "pm100": 70, "timestamp": 1681414345}	2023-04-13 19:32:25+00
249396	{"pm10": 37, "pm25": 56, "pm100": 67, "timestamp": 1681414351}	2023-04-13 19:32:31+00
249396	{"pm10": 37, "pm25": 56, "pm100": 67, "timestamp": 1681414357}	2023-04-13 19:32:37+00
249396	{"pm10": 36, "pm25": 56, "pm100": 67, "timestamp": 1681414364}	2023-04-13 19:32:44+00
249396	{"pm10": 38, "pm25": 61, "pm100": 70, "timestamp": 1681414370}	2023-04-13 19:32:50+00
249396	{"pm10": 39, "pm25": 61, "pm100": 70, "timestamp": 1681414376}	2023-04-13 19:32:56+00
249396	{"pm10": 38, "pm25": 56, "pm100": 69, "timestamp": 1681414382}	2023-04-13 19:33:02+00
249396	{"pm10": 38, "pm25": 56, "pm100": 69, "timestamp": 1681414388}	2023-04-13 19:33:08+00
249396	{"pm10": 39, "pm25": 57, "pm100": 69, "timestamp": 1681414394}	2023-04-13 19:33:14+00
249396	{"pm10": 39, "pm25": 57, "pm100": 69, "timestamp": 1681414400}	2023-04-13 19:33:20+00
249396	{"pm10": 39, "pm25": 58, "pm100": 69, "timestamp": 1681414406}	2023-04-13 19:33:26+00
249396	{"pm10": 39, "pm25": 58, "pm100": 69, "timestamp": 1681414413}	2023-04-13 19:33:33+00
249396	{"pm10": 36, "pm25": 56, "pm100": 66, "timestamp": 1681414419}	2023-04-13 19:33:39+00
249396	{"pm10": 36, "pm25": 55, "pm100": 66, "timestamp": 1681414425}	2023-04-13 19:33:45+00
249396	{"pm10": 36, "pm25": 55, "pm100": 66, "timestamp": 1681414431}	2023-04-13 19:33:51+00
249396	{"pm10": 37, "pm25": 57, "pm100": 67, "timestamp": 1681414437}	2023-04-13 19:33:57+00
249396	{"pm10": 37, "pm25": 58, "pm100": 69, "timestamp": 1681414443}	2023-04-13 19:34:03+00
249396	{"pm10": 37, "pm25": 55, "pm100": 67, "timestamp": 1681414449}	2023-04-13 19:34:09+00
249396	{"pm10": 37, "pm25": 56, "pm100": 68, "timestamp": 1681414455}	2023-04-13 19:34:15+00
249396	{"pm10": 37, "pm25": 56, "pm100": 68, "timestamp": 1681414462}	2023-04-13 19:34:22+00
249396	{"pm10": 37, "pm25": 56, "pm100": 68, "timestamp": 1681414468}	2023-04-13 19:34:28+00
249396	{"pm10": 35, "pm25": 52, "pm100": 64, "timestamp": 1681414474}	2023-04-13 19:34:34+00
249396	{"pm10": 35, "pm25": 53, "pm100": 65, "timestamp": 1681414480}	2023-04-13 19:34:40+00
249396	{"pm10": 36, "pm25": 53, "pm100": 65, "timestamp": 1681414486}	2023-04-13 19:34:46+00
249396	{"pm10": 35, "pm25": 55, "pm100": 67, "timestamp": 1681414492}	2023-04-13 19:34:52+00
249396	{"pm10": 37, "pm25": 57, "pm100": 68, "timestamp": 1681414498}	2023-04-13 19:34:58+00
249396	{"pm10": 37, "pm25": 57, "pm100": 68, "timestamp": 1681414504}	2023-04-13 19:35:04+00
249396	{"pm10": 37, "pm25": 56, "pm100": 68, "timestamp": 1681414511}	2023-04-13 19:35:11+00
249396	{"pm10": 37, "pm25": 56, "pm100": 68, "timestamp": 1681414517}	2023-04-13 19:35:17+00
249396	{"pm10": 37, "pm25": 56, "pm100": 68, "timestamp": 1681414523}	2023-04-13 19:35:23+00
249396	{"pm10": 37, "pm25": 58, "pm100": 68, "timestamp": 1681414529}	2023-04-13 19:35:29+00
249396	{"pm10": 37, "pm25": 58, "pm100": 67, "timestamp": 1681414535}	2023-04-13 19:35:35+00
249396	{"pm10": 37, "pm25": 55, "pm100": 67, "timestamp": 1681414541}	2023-04-13 19:35:41+00
249396	{"pm10": 37, "pm25": 55, "pm100": 67, "timestamp": 1681414547}	2023-04-13 19:35:47+00
249396	{"pm10": 37, "pm25": 53, "pm100": 65, "timestamp": 1681414553}	2023-04-13 19:35:53+00
249396	{"pm10": 37, "pm25": 53, "pm100": 65, "timestamp": 1681414560}	2023-04-13 19:36:00+00
249396	{"pm10": 37, "pm25": 53, "pm100": 65, "timestamp": 1681414566}	2023-04-13 19:36:06+00
249396	{"pm10": 38, "pm25": 55, "pm100": 67, "timestamp": 1681414572}	2023-04-13 19:36:12+00
249396	{"pm10": 38, "pm25": 54, "pm100": 67, "timestamp": 1681414578}	2023-04-13 19:36:18+00
249396	{"pm10": 37, "pm25": 53, "pm100": 66, "timestamp": 1681414584}	2023-04-13 19:36:24+00
249396	{"pm10": 37, "pm25": 54, "pm100": 67, "timestamp": 1681414590}	2023-04-13 19:36:30+00
249396	{"pm10": 40, "pm25": 59, "pm100": 69, "timestamp": 1681414596}	2023-04-13 19:36:36+00
249396	{"pm10": 39, "pm25": 59, "pm100": 69, "timestamp": 1681414602}	2023-04-13 19:36:42+00
249396	{"pm10": 39, "pm25": 59, "pm100": 69, "timestamp": 1681414609}	2023-04-13 19:36:49+00
249396	{"pm10": 39, "pm25": 60, "pm100": 70, "timestamp": 1681414615}	2023-04-13 19:36:55+00
249396	{"pm10": 38, "pm25": 59, "pm100": 68, "timestamp": 1681414621}	2023-04-13 19:37:01+00
249396	{"pm10": 39, "pm25": 58, "pm100": 69, "timestamp": 1681414627}	2023-04-13 19:37:07+00
249396	{"pm10": 36, "pm25": 54, "pm100": 67, "timestamp": 1681414633}	2023-04-13 19:37:13+00
249396	{"pm10": 36, "pm25": 55, "pm100": 67, "timestamp": 1681414639}	2023-04-13 19:37:19+00
249396	{"pm10": 37, "pm25": 56, "pm100": 67, "timestamp": 1681414645}	2023-04-13 19:37:25+00
249396	{"pm10": 38, "pm25": 56, "pm100": 69, "timestamp": 1681414652}	2023-04-13 19:37:32+00
249396	{"pm10": 37, "pm25": 56, "pm100": 68, "timestamp": 1681414658}	2023-04-13 19:37:38+00
249396	{"pm10": 36, "pm25": 56, "pm100": 68, "timestamp": 1681414664}	2023-04-13 19:37:44+00
249396	{"pm10": 36, "pm25": 56, "pm100": 68, "timestamp": 1681414670}	2023-04-13 19:37:50+00
249396	{"pm10": 37, "pm25": 56, "pm100": 68, "timestamp": 1681414676}	2023-04-13 19:37:56+00
249396	{"pm10": 37, "pm25": 55, "pm100": 67, "timestamp": 1681414682}	2023-04-13 19:38:02+00
249396	{"pm10": 35, "pm25": 52, "pm100": 63, "timestamp": 1681414688}	2023-04-13 19:38:08+00
249396	{"pm10": 35, "pm25": 52, "pm100": 63, "timestamp": 1681414694}	2023-04-13 19:38:14+00
249396	{"pm10": 35, "pm25": 52, "pm100": 63, "timestamp": 1681414701}	2023-04-13 19:38:21+00
249396	{"pm10": 36, "pm25": 52, "pm100": 63, "timestamp": 1681414707}	2023-04-13 19:38:27+00
249396	{"pm10": 34, "pm25": 52, "pm100": 63, "timestamp": 1681414713}	2023-04-13 19:38:33+00
249396	{"pm10": 34, "pm25": 53, "pm100": 65, "timestamp": 1681414719}	2023-04-13 19:38:39+00
249396	{"pm10": 36, "pm25": 53, "pm100": 66, "timestamp": 1681414725}	2023-04-13 19:38:45+00
249396	{"pm10": 36, "pm25": 53, "pm100": 66, "timestamp": 1681414731}	2023-04-13 19:38:51+00
249396	{"pm10": 39, "pm25": 59, "pm100": 69, "timestamp": 1681414737}	2023-04-13 19:38:57+00
249396	{"pm10": 39, "pm25": 57, "pm100": 69, "timestamp": 1681414743}	2023-04-13 19:39:03+00
249396	{"pm10": 39, "pm25": 57, "pm100": 69, "timestamp": 1681414750}	2023-04-13 19:39:10+00
249396	{"pm10": 38, "pm25": 56, "pm100": 68, "timestamp": 1681414756}	2023-04-13 19:39:16+00
249396	{"pm10": 36, "pm25": 55, "pm100": 67, "timestamp": 1681414762}	2023-04-13 19:39:22+00
249396	{"pm10": 36, "pm25": 53, "pm100": 65, "timestamp": 1681414768}	2023-04-13 19:39:28+00
249396	{"pm10": 36, "pm25": 54, "pm100": 66, "timestamp": 1681414774}	2023-04-13 19:39:34+00
249396	{"pm10": 37, "pm25": 57, "pm100": 68, "timestamp": 1681414780}	2023-04-13 19:39:40+00
249396	{"pm10": 36, "pm25": 57, "pm100": 68, "timestamp": 1681414786}	2023-04-13 19:39:46+00
249396	{"pm10": 37, "pm25": 56, "pm100": 68, "timestamp": 1681414792}	2023-04-13 19:39:52+00
249396	{"pm10": 37, "pm25": 58, "pm100": 69, "timestamp": 1681414799}	2023-04-13 19:39:59+00
249396	{"pm10": 37, "pm25": 54, "pm100": 66, "timestamp": 1681414805}	2023-04-13 19:40:05+00
249396	{"pm10": 37, "pm25": 55, "pm100": 67, "timestamp": 1681414811}	2023-04-13 19:40:11+00
249396	{"pm10": 37, "pm25": 55, "pm100": 68, "timestamp": 1681414817}	2023-04-13 19:40:17+00
249396	{"pm10": 37, "pm25": 55, "pm100": 68, "timestamp": 1681414823}	2023-04-13 19:40:23+00
249396	{"pm10": 37, "pm25": 55, "pm100": 67, "timestamp": 1681414829}	2023-04-13 19:40:29+00
249396	{"pm10": 37, "pm25": 55, "pm100": 67, "timestamp": 1681414835}	2023-04-13 19:40:35+00
249396	{"pm10": 35, "pm25": 51, "pm100": 63, "timestamp": 1681414841}	2023-04-13 19:40:41+00
249396	{"pm10": 35, "pm25": 51, "pm100": 63, "timestamp": 1681414848}	2023-04-13 19:40:48+00
249396	{"pm10": 36, "pm25": 52, "pm100": 64, "timestamp": 1681414854}	2023-04-13 19:40:54+00
249396	{"pm10": 36, "pm25": 53, "pm100": 64, "timestamp": 1681414860}	2023-04-13 19:41:00+00
249396	{"pm10": 36, "pm25": 54, "pm100": 65, "timestamp": 1681414866}	2023-04-13 19:41:06+00
249396	{"pm10": 35, "pm25": 53, "pm100": 65, "timestamp": 1681414872}	2023-04-13 19:41:12+00
249396	{"pm10": 35, "pm25": 53, "pm100": 65, "timestamp": 1681414878}	2023-04-13 19:41:18+00
249396	{"pm10": 35, "pm25": 54, "pm100": 66, "timestamp": 1681414884}	2023-04-13 19:41:24+00
249396	{"pm10": 35, "pm25": 52, "pm100": 63, "timestamp": 1681414890}	2023-04-13 19:41:30+00
249396	{"pm10": 34, "pm25": 51, "pm100": 62, "timestamp": 1681414897}	2023-04-13 19:41:37+00
249396	{"pm10": 34, "pm25": 52, "pm100": 66, "timestamp": 1681414903}	2023-04-13 19:41:43+00
249396	{"pm10": 34, "pm25": 52, "pm100": 66, "timestamp": 1681414909}	2023-04-13 19:41:49+00
249396	{"pm10": 34, "pm25": 52, "pm100": 65, "timestamp": 1681414915}	2023-04-13 19:41:55+00
249396	{"pm10": 34, "pm25": 52, "pm100": 65, "timestamp": 1681414921}	2023-04-13 19:42:01+00
249396	{"pm10": 35, "pm25": 52, "pm100": 65, "timestamp": 1681414927}	2023-04-13 19:42:07+00
249396	{"pm10": 36, "pm25": 55, "pm100": 67, "timestamp": 1681414933}	2023-04-13 19:42:13+00
249396	{"pm10": 35, "pm25": 53, "pm100": 66, "timestamp": 1681414939}	2023-04-13 19:42:19+00
249396	{"pm10": 35, "pm25": 53, "pm100": 67, "timestamp": 1681414946}	2023-04-13 19:42:26+00
249396	{"pm10": 35, "pm25": 53, "pm100": 67, "timestamp": 1681414952}	2023-04-13 19:42:32+00
249396	{"pm10": 35, "pm25": 53, "pm100": 67, "timestamp": 1681414958}	2023-04-13 19:42:38+00
249396	{"pm10": 35, "pm25": 53, "pm100": 65, "timestamp": 1681414964}	2023-04-13 19:42:44+00
249396	{"pm10": 35, "pm25": 52, "pm100": 65, "timestamp": 1681414970}	2023-04-13 19:42:50+00
249396	{"pm10": 35, "pm25": 52, "pm100": 65, "timestamp": 1681414976}	2023-04-13 19:42:56+00
249396	{"pm10": 35, "pm25": 52, "pm100": 65, "timestamp": 1681414982}	2023-04-13 19:43:02+00
249396	{"pm10": 36, "pm25": 53, "pm100": 65, "timestamp": 1681414988}	2023-04-13 19:43:08+00
249396	{"pm10": 36, "pm25": 53, "pm100": 65, "timestamp": 1681414995}	2023-04-13 19:43:15+00
249396	{"pm10": 37, "pm25": 54, "pm100": 67, "timestamp": 1681415001}	2023-04-13 19:43:21+00
249396	{"pm10": 37, "pm25": 55, "pm100": 67, "timestamp": 1681415007}	2023-04-13 19:43:27+00
249396	{"pm10": 37, "pm25": 54, "pm100": 66, "timestamp": 1681415013}	2023-04-13 19:43:33+00
249396	{"pm10": 37, "pm25": 54, "pm100": 67, "timestamp": 1681415019}	2023-04-13 19:43:39+00
249396	{"pm10": 37, "pm25": 56, "pm100": 67, "timestamp": 1681415025}	2023-04-13 19:43:45+00
249396	{"pm10": 34, "pm25": 54, "pm100": 65, "timestamp": 1681415031}	2023-04-13 19:43:51+00
249396	{"pm10": 34, "pm25": 53, "pm100": 64, "timestamp": 1681415037}	2023-04-13 19:43:57+00
249396	{"pm10": 36, "pm25": 56, "pm100": 68, "timestamp": 1681415044}	2023-04-13 19:44:04+00
249396	{"pm10": 36, "pm25": 57, "pm100": 69, "timestamp": 1681415050}	2023-04-13 19:44:10+00
249396	{"pm10": 37, "pm25": 57, "pm100": 68, "timestamp": 1681415056}	2023-04-13 19:44:16+00
249396	{"pm10": 36, "pm25": 53, "pm100": 67, "timestamp": 1681415062}	2023-04-13 19:44:22+00
249396	{"pm10": 35, "pm25": 53, "pm100": 67, "timestamp": 1681415068}	2023-04-13 19:44:28+00
249396	{"pm10": 35, "pm25": 53, "pm100": 67, "timestamp": 1681415074}	2023-04-13 19:44:34+00
249396	{"pm10": 36, "pm25": 55, "pm100": 68, "timestamp": 1681415080}	2023-04-13 19:44:40+00
249396	{"pm10": 36, "pm25": 54, "pm100": 66, "timestamp": 1681415087}	2023-04-13 19:44:47+00
249396	{"pm10": 35, "pm25": 53, "pm100": 65, "timestamp": 1681415093}	2023-04-13 19:44:53+00
249396	{"pm10": 36, "pm25": 53, "pm100": 66, "timestamp": 1681415099}	2023-04-13 19:44:59+00
249396	{"pm10": 37, "pm25": 54, "pm100": 66, "timestamp": 1681415105}	2023-04-13 19:45:05+00
249396	{"pm10": 37, "pm25": 54, "pm100": 66, "timestamp": 1681415111}	2023-04-13 19:45:11+00
249396	{"pm10": 37, "pm25": 55, "pm100": 67, "timestamp": 1681415117}	2023-04-13 19:45:17+00
249396	{"pm10": 35, "pm25": 54, "pm100": 66, "timestamp": 1681415123}	2023-04-13 19:45:23+00
249396	{"pm10": 35, "pm25": 53, "pm100": 65, "timestamp": 1681415129}	2023-04-13 19:45:29+00
249396	{"pm10": 36, "pm25": 53, "pm100": 64, "timestamp": 1681415136}	2023-04-13 19:45:36+00
249396	{"pm10": 38, "pm25": 55, "pm100": 66, "timestamp": 1681415142}	2023-04-13 19:45:42+00
249396	{"pm10": 38, "pm25": 55, "pm100": 66, "timestamp": 1681415148}	2023-04-13 19:45:48+00
249396	{"pm10": 37, "pm25": 55, "pm100": 66, "timestamp": 1681415154}	2023-04-13 19:45:54+00
249396	{"pm10": 37, "pm25": 55, "pm100": 66, "timestamp": 1681415160}	2023-04-13 19:46:00+00
249396	{"pm10": 35, "pm25": 53, "pm100": 64, "timestamp": 1681415166}	2023-04-13 19:46:06+00
249396	{"pm10": 35, "pm25": 53, "pm100": 65, "timestamp": 1681415172}	2023-04-13 19:46:12+00
249396	{"pm10": 35, "pm25": 53, "pm100": 65, "timestamp": 1681415178}	2023-04-13 19:46:18+00
249396	{"pm10": 34, "pm25": 53, "pm100": 66, "timestamp": 1681415185}	2023-04-13 19:46:25+00
249396	{"pm10": 34, "pm25": 53, "pm100": 66, "timestamp": 1681415191}	2023-04-13 19:46:31+00
249396	{"pm10": 35, "pm25": 51, "pm100": 62, "timestamp": 1681415197}	2023-04-13 19:46:37+00
249396	{"pm10": 35, "pm25": 51, "pm100": 62, "timestamp": 1681415203}	2023-04-13 19:46:43+00
249396	{"pm10": 35, "pm25": 52, "pm100": 64, "timestamp": 1681415209}	2023-04-13 19:46:49+00
249396	{"pm10": 35, "pm25": 52, "pm100": 64, "timestamp": 1681415215}	2023-04-13 19:46:55+00
249396	{"pm10": 35, "pm25": 52, "pm100": 65, "timestamp": 1681415221}	2023-04-13 19:47:01+00
249396	{"pm10": 35, "pm25": 52, "pm100": 65, "timestamp": 1681415227}	2023-04-13 19:47:07+00
249396	{"pm10": 35, "pm25": 52, "pm100": 65, "timestamp": 1681415234}	2023-04-13 19:47:14+00
249396	{"pm10": 35, "pm25": 52, "pm100": 66, "timestamp": 1681415240}	2023-04-13 19:47:20+00
249396	{"pm10": 35, "pm25": 52, "pm100": 66, "timestamp": 1681415246}	2023-04-13 19:47:26+00
249396	{"pm10": 37, "pm25": 55, "pm100": 67, "timestamp": 1681415252}	2023-04-13 19:47:32+00
249396	{"pm10": 37, "pm25": 55, "pm100": 67, "timestamp": 1681415258}	2023-04-13 19:47:38+00
249396	{"pm10": 36, "pm25": 54, "pm100": 67, "timestamp": 1681415264}	2023-04-13 19:47:44+00
249396	{"pm10": 36, "pm25": 53, "pm100": 66, "timestamp": 1681415270}	2023-04-13 19:47:50+00
249396	{"pm10": 36, "pm25": 53, "pm100": 65, "timestamp": 1681415276}	2023-04-13 19:47:56+00
249396	{"pm10": 37, "pm25": 53, "pm100": 65, "timestamp": 1681415283}	2023-04-13 19:48:03+00
249396	{"pm10": 36, "pm25": 53, "pm100": 65, "timestamp": 1681415289}	2023-04-13 19:48:09+00
249396	{"pm10": 35, "pm25": 53, "pm100": 65, "timestamp": 1681415295}	2023-04-13 19:48:15+00
249396	{"pm10": 35, "pm25": 52, "pm100": 64, "timestamp": 1681415301}	2023-04-13 19:48:21+00
249396	{"pm10": 35, "pm25": 52, "pm100": 64, "timestamp": 1681415307}	2023-04-13 19:48:27+00
249396	{"pm10": 36, "pm25": 55, "pm100": 67, "timestamp": 1681415313}	2023-04-13 19:48:33+00
249396	{"pm10": 35, "pm25": 53, "pm100": 65, "timestamp": 1681415319}	2023-04-13 19:48:39+00
249396	{"pm10": 35, "pm25": 54, "pm100": 65, "timestamp": 1681415325}	2023-04-13 19:48:45+00
249396	{"pm10": 34, "pm25": 53, "pm100": 67, "timestamp": 1681415332}	2023-04-13 19:48:52+00
249396	{"pm10": 35, "pm25": 52, "pm100": 66, "timestamp": 1681415338}	2023-04-13 19:48:58+00
249396	{"pm10": 36, "pm25": 53, "pm100": 67, "timestamp": 1681415344}	2023-04-13 19:49:04+00
249396	{"pm10": 36, "pm25": 53, "pm100": 67, "timestamp": 1681415350}	2023-04-13 19:49:10+00
249396	{"pm10": 36, "pm25": 53, "pm100": 67, "timestamp": 1681415356}	2023-04-13 19:49:16+00
249396	{"pm10": 36, "pm25": 53, "pm100": 67, "timestamp": 1681415363}	2023-04-13 19:49:23+00
249396	{"pm10": 36, "pm25": 53, "pm100": 67, "timestamp": 1681415369}	2023-04-13 19:49:29+00
249396	{"pm10": 36, "pm25": 53, "pm100": 67, "timestamp": 1681415375}	2023-04-13 19:49:35+00
249396	{"pm10": 35, "pm25": 53, "pm100": 66, "timestamp": 1681415381}	2023-04-13 19:49:41+00
249396	{"pm10": 37, "pm25": 54, "pm100": 66, "timestamp": 1681415387}	2023-04-13 19:49:47+00
249396	{"pm10": 37, "pm25": 54, "pm100": 67, "timestamp": 1681415393}	2023-04-13 19:49:53+00
249396	{"pm10": 37, "pm25": 54, "pm100": 67, "timestamp": 1681415399}	2023-04-13 19:49:59+00
249396	{"pm10": 37, "pm25": 54, "pm100": 66, "timestamp": 1681415405}	2023-04-13 19:50:05+00
249396	{"pm10": 37, "pm25": 54, "pm100": 66, "timestamp": 1681415412}	2023-04-13 19:50:12+00
249396	{"pm10": 35, "pm25": 54, "pm100": 67, "timestamp": 1681415418}	2023-04-13 19:50:18+00
249396	{"pm10": 35, "pm25": 55, "pm100": 67, "timestamp": 1681415424}	2023-04-13 19:50:24+00
249396	{"pm10": 35, "pm25": 55, "pm100": 68, "timestamp": 1681415430}	2023-04-13 19:50:30+00
249396	{"pm10": 35, "pm25": 55, "pm100": 68, "timestamp": 1681415436}	2023-04-13 19:50:36+00
249396	{"pm10": 39, "pm25": 56, "pm100": 67, "timestamp": 1681415442}	2023-04-13 19:50:42+00
249396	{"pm10": 35, "pm25": 52, "pm100": 64, "timestamp": 1681415448}	2023-04-13 19:50:48+00
249396	{"pm10": 35, "pm25": 52, "pm100": 64, "timestamp": 1681415454}	2023-04-13 19:50:54+00
249396	{"pm10": 35, "pm25": 52, "pm100": 64, "timestamp": 1681415461}	2023-04-13 19:51:01+00
249396	{"pm10": 35, "pm25": 53, "pm100": 64, "timestamp": 1681415467}	2023-04-13 19:51:07+00
249396	{"pm10": 35, "pm25": 53, "pm100": 64, "timestamp": 1681415473}	2023-04-13 19:51:13+00
249396	{"pm10": 35, "pm25": 52, "pm100": 63, "timestamp": 1681415479}	2023-04-13 19:51:19+00
249396	{"pm10": 35, "pm25": 55, "pm100": 67, "timestamp": 1681415485}	2023-04-13 19:51:25+00
249396	{"pm10": 35, "pm25": 55, "pm100": 67, "timestamp": 1681415491}	2023-04-13 19:51:31+00
249396	{"pm10": 35, "pm25": 51, "pm100": 62, "timestamp": 1681415497}	2023-04-13 19:51:37+00
249396	{"pm10": 35, "pm25": 51, "pm100": 62, "timestamp": 1681415503}	2023-04-13 19:51:43+00
249396	{"pm10": 35, "pm25": 51, "pm100": 62, "timestamp": 1681415510}	2023-04-13 19:51:50+00
249396	{"pm10": 35, "pm25": 53, "pm100": 66, "timestamp": 1681415516}	2023-04-13 19:51:56+00
249396	{"pm10": 35, "pm25": 54, "pm100": 66, "timestamp": 1681415522}	2023-04-13 19:52:02+00
249396	{"pm10": 35, "pm25": 54, "pm100": 66, "timestamp": 1681415528}	2023-04-13 19:52:08+00
249396	{"pm10": 35, "pm25": 54, "pm100": 67, "timestamp": 1681415534}	2023-04-13 19:52:14+00
249396	{"pm10": 35, "pm25": 53, "pm100": 66, "timestamp": 1681415540}	2023-04-13 19:52:20+00
249396	{"pm10": 35, "pm25": 53, "pm100": 65, "timestamp": 1681415546}	2023-04-13 19:52:26+00
249396	{"pm10": 35, "pm25": 53, "pm100": 65, "timestamp": 1681415552}	2023-04-13 19:52:32+00
249396	{"pm10": 35, "pm25": 54, "pm100": 66, "timestamp": 1681415559}	2023-04-13 19:52:39+00
249396	{"pm10": 35, "pm25": 54, "pm100": 66, "timestamp": 1681415565}	2023-04-13 19:52:45+00
249396	{"pm10": 36, "pm25": 55, "pm100": 66, "timestamp": 1681415571}	2023-04-13 19:52:51+00
249396	{"pm10": 37, "pm25": 55, "pm100": 67, "timestamp": 1681415577}	2023-04-13 19:52:57+00
249396	{"pm10": 37, "pm25": 56, "pm100": 67, "timestamp": 1681415583}	2023-04-13 19:53:03+00
249396	{"pm10": 36, "pm25": 53, "pm100": 64, "timestamp": 1681415589}	2023-04-13 19:53:09+00
249396	{"pm10": 35, "pm25": 54, "pm100": 65, "timestamp": 1681415595}	2023-04-13 19:53:15+00
249396	{"pm10": 35, "pm25": 54, "pm100": 65, "timestamp": 1681415601}	2023-04-13 19:53:21+00
249396	{"pm10": 35, "pm25": 55, "pm100": 67, "timestamp": 1681415608}	2023-04-13 19:53:28+00
249396	{"pm10": 35, "pm25": 53, "pm100": 65, "timestamp": 1681415614}	2023-04-13 19:53:34+00
249396	{"pm10": 36, "pm25": 53, "pm100": 65, "timestamp": 1681415620}	2023-04-13 19:53:40+00
249396	{"pm10": 36, "pm25": 53, "pm100": 65, "timestamp": 1681415626}	2023-04-13 19:53:46+00
249396	{"pm10": 36, "pm25": 53, "pm100": 65, "timestamp": 1681415632}	2023-04-13 19:53:52+00
249396	{"pm10": 36, "pm25": 52, "pm100": 64, "timestamp": 1681415638}	2023-04-13 19:53:58+00
249396	{"pm10": 37, "pm25": 53, "pm100": 65, "timestamp": 1681415644}	2023-04-13 19:54:04+00
249396	{"pm10": 37, "pm25": 53, "pm100": 65, "timestamp": 1681415650}	2023-04-13 19:54:10+00
249396	{"pm10": 37, "pm25": 54, "pm100": 66, "timestamp": 1681415657}	2023-04-13 19:54:17+00
249396	{"pm10": 37, "pm25": 55, "pm100": 67, "timestamp": 1681415663}	2023-04-13 19:54:23+00
249396	{"pm10": 38, "pm25": 55, "pm100": 67, "timestamp": 1681415669}	2023-04-13 19:54:29+00
249396	{"pm10": 38, "pm25": 55, "pm100": 67, "timestamp": 1681415675}	2023-04-13 19:54:35+00
249396	{"pm10": 37, "pm25": 54, "pm100": 66, "timestamp": 1681415681}	2023-04-13 19:54:41+00
249396	{"pm10": 36, "pm25": 53, "pm100": 66, "timestamp": 1681415687}	2023-04-13 19:54:47+00
249396	{"pm10": 35, "pm25": 53, "pm100": 67, "timestamp": 1681415693}	2023-04-13 19:54:53+00
249396	{"pm10": 37, "pm25": 55, "pm100": 68, "timestamp": 1681415699}	2023-04-13 19:54:59+00
249396	{"pm10": 36, "pm25": 55, "pm100": 67, "timestamp": 1681415706}	2023-04-13 19:55:06+00
249396	{"pm10": 36, "pm25": 55, "pm100": 67, "timestamp": 1681415712}	2023-04-13 19:55:12+00
249396	{"pm10": 36, "pm25": 54, "pm100": 67, "timestamp": 1681415718}	2023-04-13 19:55:18+00
249396	{"pm10": 34, "pm25": 54, "pm100": 65, "timestamp": 1681415724}	2023-04-13 19:55:24+00
249396	{"pm10": 35, "pm25": 52, "pm100": 63, "timestamp": 1681415730}	2023-04-13 19:55:30+00
249396	{"pm10": 35, "pm25": 52, "pm100": 63, "timestamp": 1681415736}	2023-04-13 19:55:36+00
249396	{"pm10": 35, "pm25": 52, "pm100": 64, "timestamp": 1681415742}	2023-04-13 19:55:42+00
249396	{"pm10": 35, "pm25": 52, "pm100": 64, "timestamp": 1681415749}	2023-04-13 19:55:49+00
249396	{"pm10": 35, "pm25": 52, "pm100": 64, "timestamp": 1681415755}	2023-04-13 19:55:55+00
249396	{"pm10": 35, "pm25": 52, "pm100": 64, "timestamp": 1681415761}	2023-04-13 19:56:01+00
249396	{"pm10": 35, "pm25": 52, "pm100": 65, "timestamp": 1681415767}	2023-04-13 19:56:07+00
249396	{"pm10": 35, "pm25": 52, "pm100": 65, "timestamp": 1681415773}	2023-04-13 19:56:13+00
249396	{"pm10": 36, "pm25": 55, "pm100": 67, "timestamp": 1681415779}	2023-04-13 19:56:19+00
249396	{"pm10": 36, "pm25": 55, "pm100": 67, "timestamp": 1681415785}	2023-04-13 19:56:25+00
249396	{"pm10": 36, "pm25": 55, "pm100": 67, "timestamp": 1681415791}	2023-04-13 19:56:31+00
249396	{"pm10": 35, "pm25": 53, "pm100": 64, "timestamp": 1681415798}	2023-04-13 19:56:38+00
249396	{"pm10": 35, "pm25": 53, "pm100": 64, "timestamp": 1681415804}	2023-04-13 19:56:44+00
249396	{"pm10": 35, "pm25": 52, "pm100": 64, "timestamp": 1681415810}	2023-04-13 19:56:50+00
249396	{"pm10": 34, "pm25": 51, "pm100": 63, "timestamp": 1681415816}	2023-04-13 19:56:56+00
249396	{"pm10": 35, "pm25": 51, "pm100": 63, "timestamp": 1681415822}	2023-04-13 19:57:02+00
249396	{"pm10": 35, "pm25": 51, "pm100": 63, "timestamp": 1681415828}	2023-04-13 19:57:08+00
249396	{"pm10": 37, "pm25": 55, "pm100": 67, "timestamp": 1681415834}	2023-04-13 19:57:14+00
249396	{"pm10": 37, "pm25": 54, "pm100": 67, "timestamp": 1681415840}	2023-04-13 19:57:20+00
249396	{"pm10": 37, "pm25": 54, "pm100": 66, "timestamp": 1681415847}	2023-04-13 19:57:27+00
249396	{"pm10": 37, "pm25": 53, "pm100": 66, "timestamp": 1681415853}	2023-04-13 19:57:33+00
249396	{"pm10": 35, "pm25": 52, "pm100": 66, "timestamp": 1681415859}	2023-04-13 19:57:39+00
249396	{"pm10": 34, "pm25": 52, "pm100": 66, "timestamp": 1681415865}	2023-04-13 19:57:45+00
249396	{"pm10": 36, "pm25": 53, "pm100": 66, "timestamp": 1681415871}	2023-04-13 19:57:51+00
249396	{"pm10": 36, "pm25": 54, "pm100": 66, "timestamp": 1681415877}	2023-04-13 19:57:57+00
249396	{"pm10": 36, "pm25": 53, "pm100": 66, "timestamp": 1681415883}	2023-04-13 19:58:03+00
249396	{"pm10": 35, "pm25": 53, "pm100": 66, "timestamp": 1681415889}	2023-04-13 19:58:09+00
249396	{"pm10": 34, "pm25": 52, "pm100": 66, "timestamp": 1681415896}	2023-04-13 19:58:16+00
249396	{"pm10": 37, "pm25": 53, "pm100": 66, "timestamp": 1681415902}	2023-04-13 19:58:22+00
249396	{"pm10": 35, "pm25": 52, "pm100": 65, "timestamp": 1681415908}	2023-04-13 19:58:28+00
249396	{"pm10": 35, "pm25": 53, "pm100": 66, "timestamp": 1681415914}	2023-04-13 19:58:34+00
249396	{"pm10": 34, "pm25": 52, "pm100": 66, "timestamp": 1681415920}	2023-04-13 19:58:40+00
249396	{"pm10": 34, "pm25": 52, "pm100": 65, "timestamp": 1681415926}	2023-04-13 19:58:46+00
249396	{"pm10": 34, "pm25": 52, "pm100": 64, "timestamp": 1681415932}	2023-04-13 19:58:52+00
249396	{"pm10": 34, "pm25": 52, "pm100": 65, "timestamp": 1681415938}	2023-04-13 19:58:58+00
249396	{"pm10": 34, "pm25": 52, "pm100": 65, "timestamp": 1681415945}	2023-04-13 19:59:05+00
249396	{"pm10": 35, "pm25": 53, "pm100": 65, "timestamp": 1681415951}	2023-04-13 19:59:11+00
249396	{"pm10": 35, "pm25": 54, "pm100": 66, "timestamp": 1681415957}	2023-04-13 19:59:17+00
249396	{"pm10": 35, "pm25": 55, "pm100": 66, "timestamp": 1681415963}	2023-04-13 19:59:23+00
249396	{"pm10": 35, "pm25": 55, "pm100": 66, "timestamp": 1681415969}	2023-04-13 19:59:29+00
249396	{"pm10": 35, "pm25": 54, "pm100": 66, "timestamp": 1681415975}	2023-04-13 19:59:35+00
249396	{"pm10": 34, "pm25": 53, "pm100": 65, "timestamp": 1681415981}	2023-04-13 19:59:41+00
249396	{"pm10": 34, "pm25": 54, "pm100": 66, "timestamp": 1681415987}	2023-04-13 19:59:47+00
249396	{"pm10": 36, "pm25": 51, "pm100": 64, "timestamp": 1681415994}	2023-04-13 19:59:54+00
249396	{"pm10": 36, "pm25": 51, "pm100": 64, "timestamp": 1681416000}	2023-04-13 20:00:00+00
249396	{"pm10": 35, "pm25": 51, "pm100": 65, "timestamp": 1681416006}	2023-04-13 20:00:06+00
249396	{"pm10": 35, "pm25": 51, "pm100": 65, "timestamp": 1681416012}	2023-04-13 20:00:12+00
249396	{"pm10": 35, "pm25": 51, "pm100": 64, "timestamp": 1681416018}	2023-04-13 20:00:18+00
249396	{"pm10": 34, "pm25": 51, "pm100": 62, "timestamp": 1681416024}	2023-04-13 20:00:24+00
249396	{"pm10": 34, "pm25": 52, "pm100": 64, "timestamp": 1681416030}	2023-04-13 20:00:30+00
249396	{"pm10": 36, "pm25": 53, "pm100": 64, "timestamp": 1681416036}	2023-04-13 20:00:36+00
249396	{"pm10": 37, "pm25": 53, "pm100": 65, "timestamp": 1681416043}	2023-04-13 20:00:43+00
249396	{"pm10": 37, "pm25": 53, "pm100": 65, "timestamp": 1681416049}	2023-04-13 20:00:49+00
249396	{"pm10": 37, "pm25": 53, "pm100": 64, "timestamp": 1681416055}	2023-04-13 20:00:55+00
249396	{"pm10": 37, "pm25": 53, "pm100": 64, "timestamp": 1681416061}	2023-04-13 20:01:01+00
249396	{"pm10": 34, "pm25": 52, "pm100": 64, "timestamp": 1681416067}	2023-04-13 20:01:07+00
249396	{"pm10": 34, "pm25": 52, "pm100": 64, "timestamp": 1681416073}	2023-04-13 20:01:13+00
249396	{"pm10": 36, "pm25": 54, "pm100": 67, "timestamp": 1681416079}	2023-04-13 20:01:19+00
249396	{"pm10": 36, "pm25": 55, "pm100": 67, "timestamp": 1681416085}	2023-04-13 20:01:25+00
249396	{"pm10": 37, "pm25": 55, "pm100": 67, "timestamp": 1681416092}	2023-04-13 20:01:32+00
249396	{"pm10": 36, "pm25": 56, "pm100": 67, "timestamp": 1681416098}	2023-04-13 20:01:38+00
249396	{"pm10": 35, "pm25": 54, "pm100": 66, "timestamp": 1681416104}	2023-04-13 20:01:44+00
249396	{"pm10": 35, "pm25": 55, "pm100": 67, "timestamp": 1681416110}	2023-04-13 20:01:50+00
249396	{"pm10": 35, "pm25": 55, "pm100": 67, "timestamp": 1681416116}	2023-04-13 20:01:56+00
249396	{"pm10": 35, "pm25": 56, "pm100": 67, "timestamp": 1681416122}	2023-04-13 20:02:02+00
249396	{"pm10": 35, "pm25": 56, "pm100": 67, "timestamp": 1681416128}	2023-04-13 20:02:08+00
249396	{"pm10": 35, "pm25": 55, "pm100": 67, "timestamp": 1681416134}	2023-04-13 20:02:14+00
249396	{"pm10": 35, "pm25": 53, "pm100": 66, "timestamp": 1681416141}	2023-04-13 20:02:21+00
249396	{"pm10": 35, "pm25": 55, "pm100": 66, "timestamp": 1681416147}	2023-04-13 20:02:27+00
249396	{"pm10": 36, "pm25": 55, "pm100": 67, "timestamp": 1681416153}	2023-04-13 20:02:33+00
249396	{"pm10": 36, "pm25": 55, "pm100": 67, "timestamp": 1681416159}	2023-04-13 20:02:39+00
249396	{"pm10": 36, "pm25": 55, "pm100": 66, "timestamp": 1681416165}	2023-04-13 20:02:45+00
249396	{"pm10": 37, "pm25": 55, "pm100": 66, "timestamp": 1681416171}	2023-04-13 20:02:51+00
249396	{"pm10": 36, "pm25": 53, "pm100": 65, "timestamp": 1681416177}	2023-04-13 20:02:57+00
249396	{"pm10": 36, "pm25": 53, "pm100": 65, "timestamp": 1681416183}	2023-04-13 20:03:03+00
249396	{"pm10": 37, "pm25": 53, "pm100": 65, "timestamp": 1681416190}	2023-04-13 20:03:10+00
249396	{"pm10": 37, "pm25": 53, "pm100": 65, "timestamp": 1681416196}	2023-04-13 20:03:16+00
249396	{"pm10": 36, "pm25": 53, "pm100": 64, "timestamp": 1681416202}	2023-04-13 20:03:22+00
249396	{"pm10": 36, "pm25": 53, "pm100": 66, "timestamp": 1681416208}	2023-04-13 20:03:28+00
249396	{"pm10": 37, "pm25": 55, "pm100": 66, "timestamp": 1681416214}	2023-04-13 20:03:34+00
249396	{"pm10": 37, "pm25": 55, "pm100": 67, "timestamp": 1681416220}	2023-04-13 20:03:40+00
249396	{"pm10": 35, "pm25": 52, "pm100": 64, "timestamp": 1681416226}	2023-04-13 20:03:46+00
249396	{"pm10": 35, "pm25": 52, "pm100": 64, "timestamp": 1681416233}	2023-04-13 20:03:53+00
249396	{"pm10": 35, "pm25": 51, "pm100": 62, "timestamp": 1681416239}	2023-04-13 20:03:59+00
249396	{"pm10": 35, "pm25": 51, "pm100": 62, "timestamp": 1681416245}	2023-04-13 20:04:05+00
249396	{"pm10": 35, "pm25": 51, "pm100": 62, "timestamp": 1681416251}	2023-04-13 20:04:11+00
249396	{"pm10": 35, "pm25": 51, "pm100": 62, "timestamp": 1681416257}	2023-04-13 20:04:17+00
249396	{"pm10": 35, "pm25": 51, "pm100": 62, "timestamp": 1681416263}	2023-04-13 20:04:23+00
249396	{"pm10": 34, "pm25": 50, "pm100": 62, "timestamp": 1681416269}	2023-04-13 20:04:29+00
249396	{"pm10": 34, "pm25": 50, "pm100": 61, "timestamp": 1681416275}	2023-04-13 20:04:35+00
249396	{"pm10": 34, "pm25": 50, "pm100": 61, "timestamp": 1681416282}	2023-04-13 20:04:42+00
249396	{"pm10": 37, "pm25": 53, "pm100": 65, "timestamp": 1681416288}	2023-04-13 20:04:48+00
249396	{"pm10": 37, "pm25": 53, "pm100": 65, "timestamp": 1681416294}	2023-04-13 20:04:54+00
249396	{"pm10": 37, "pm25": 53, "pm100": 64, "timestamp": 1681416300}	2023-04-13 20:05:00+00
249396	{"pm10": 37, "pm25": 53, "pm100": 64, "timestamp": 1681416306}	2023-04-13 20:05:06+00
249396	{"pm10": 36, "pm25": 54, "pm100": 65, "timestamp": 1681416312}	2023-04-13 20:05:12+00
249396	{"pm10": 36, "pm25": 54, "pm100": 65, "timestamp": 1681416318}	2023-04-13 20:05:18+00
249396	{"pm10": 35, "pm25": 53, "pm100": 64, "timestamp": 1681416324}	2023-04-13 20:05:24+00
249396	{"pm10": 34, "pm25": 52, "pm100": 64, "timestamp": 1681416331}	2023-04-13 20:05:31+00
249396	{"pm10": 34, "pm25": 52, "pm100": 64, "timestamp": 1681416337}	2023-04-13 20:05:37+00
249396	{"pm10": 35, "pm25": 52, "pm100": 64, "timestamp": 1681416343}	2023-04-13 20:05:43+00
249396	{"pm10": 35, "pm25": 51, "pm100": 63, "timestamp": 1681416349}	2023-04-13 20:05:49+00
249396	{"pm10": 35, "pm25": 52, "pm100": 64, "timestamp": 1681416355}	2023-04-13 20:05:55+00
249396	{"pm10": 36, "pm25": 53, "pm100": 66, "timestamp": 1681416361}	2023-04-13 20:06:01+00
249396	{"pm10": 35, "pm25": 53, "pm100": 65, "timestamp": 1681416367}	2023-04-13 20:06:07+00
249396	{"pm10": 35, "pm25": 53, "pm100": 65, "timestamp": 1681416373}	2023-04-13 20:06:13+00
249396	{"pm10": 35, "pm25": 52, "pm100": 64, "timestamp": 1681416380}	2023-04-13 20:06:20+00
249396	{"pm10": 35, "pm25": 53, "pm100": 64, "timestamp": 1681416386}	2023-04-13 20:06:26+00
249396	{"pm10": 35, "pm25": 53, "pm100": 66, "timestamp": 1681416392}	2023-04-13 20:06:32+00
249396	{"pm10": 37, "pm25": 52, "pm100": 65, "timestamp": 1681416398}	2023-04-13 20:06:38+00
249396	{"pm10": 36, "pm25": 53, "pm100": 66, "timestamp": 1681416404}	2023-04-13 20:06:44+00
249396	{"pm10": 37, "pm25": 53, "pm100": 65, "timestamp": 1681416410}	2023-04-13 20:06:50+00
249396	{"pm10": 37, "pm25": 53, "pm100": 65, "timestamp": 1681416416}	2023-04-13 20:06:56+00
249396	{"pm10": 37, "pm25": 53, "pm100": 65, "timestamp": 1681416422}	2023-04-13 20:07:02+00
249396	{"pm10": 35, "pm25": 52, "pm100": 62, "timestamp": 1681416429}	2023-04-13 20:07:09+00
249396	{"pm10": 35, "pm25": 52, "pm100": 63, "timestamp": 1681416435}	2023-04-13 20:07:15+00
249396	{"pm10": 35, "pm25": 52, "pm100": 63, "timestamp": 1681416441}	2023-04-13 20:07:21+00
249396	{"pm10": 35, "pm25": 51, "pm100": 62, "timestamp": 1681416447}	2023-04-13 20:07:27+00
249396	{"pm10": 35, "pm25": 51, "pm100": 62, "timestamp": 1681416453}	2023-04-13 20:07:33+00
249396	{"pm10": 35, "pm25": 51, "pm100": 62, "timestamp": 1681416459}	2023-04-13 20:07:39+00
249396	{"pm10": 35, "pm25": 51, "pm100": 62, "timestamp": 1681416465}	2023-04-13 20:07:45+00
249396	{"pm10": 34, "pm25": 51, "pm100": 62, "timestamp": 1681416471}	2023-04-13 20:07:51+00
249396	{"pm10": 34, "pm25": 51, "pm100": 62, "timestamp": 1681416478}	2023-04-13 20:07:58+00
249396	{"pm10": 34, "pm25": 52, "pm100": 64, "timestamp": 1681416484}	2023-04-13 20:08:04+00
249396	{"pm10": 34, "pm25": 52, "pm100": 63, "timestamp": 1681416490}	2023-04-13 20:08:10+00
249396	{"pm10": 34, "pm25": 52, "pm100": 63, "timestamp": 1681416496}	2023-04-13 20:08:16+00
249396	{"pm10": 34, "pm25": 51, "pm100": 62, "timestamp": 1681416502}	2023-04-13 20:08:22+00
249396	{"pm10": 35, "pm25": 52, "pm100": 63, "timestamp": 1681416508}	2023-04-13 20:08:28+00
249396	{"pm10": 35, "pm25": 52, "pm100": 64, "timestamp": 1681416514}	2023-04-13 20:08:34+00
249396	{"pm10": 35, "pm25": 54, "pm100": 67, "timestamp": 1681416520}	2023-04-13 20:08:40+00
249396	{"pm10": 35, "pm25": 53, "pm100": 66, "timestamp": 1681416527}	2023-04-13 20:08:47+00
249396	{"pm10": 35, "pm25": 53, "pm100": 66, "timestamp": 1681416533}	2023-04-13 20:08:53+00
249396	{"pm10": 34, "pm25": 52, "pm100": 63, "timestamp": 1681416539}	2023-04-13 20:08:59+00
249396	{"pm10": 34, "pm25": 51, "pm100": 62, "timestamp": 1681416545}	2023-04-13 20:09:05+00
249396	{"pm10": 35, "pm25": 53, "pm100": 65, "timestamp": 1681416551}	2023-04-13 20:09:11+00
249396	{"pm10": 36, "pm25": 53, "pm100": 66, "timestamp": 1681416557}	2023-04-13 20:09:17+00
249396	{"pm10": 37, "pm25": 55, "pm100": 67, "timestamp": 1681416563}	2023-04-13 20:09:23+00
249396	{"pm10": 35, "pm25": 54, "pm100": 67, "timestamp": 1681416569}	2023-04-13 20:09:29+00
249396	{"pm10": 35, "pm25": 53, "pm100": 66, "timestamp": 1681416576}	2023-04-13 20:09:36+00
249396	{"pm10": 35, "pm25": 53, "pm100": 65, "timestamp": 1681416582}	2023-04-13 20:09:42+00
249396	{"pm10": 35, "pm25": 53, "pm100": 66, "timestamp": 1681416588}	2023-04-13 20:09:48+00
249396	{"pm10": 35, "pm25": 53, "pm100": 66, "timestamp": 1681416594}	2023-04-13 20:09:54+00
249396	{"pm10": 35, "pm25": 51, "pm100": 63, "timestamp": 1681416600}	2023-04-13 20:10:00+00
249396	{"pm10": 35, "pm25": 52, "pm100": 64, "timestamp": 1681416606}	2023-04-13 20:10:06+00
249396	{"pm10": 35, "pm25": 52, "pm100": 63, "timestamp": 1681416612}	2023-04-13 20:10:12+00
249396	{"pm10": 35, "pm25": 52, "pm100": 63, "timestamp": 1681416618}	2023-04-13 20:10:18+00
249396	{"pm10": 35, "pm25": 51, "pm100": 63, "timestamp": 1681416625}	2023-04-13 20:10:25+00
249396	{"pm10": 35, "pm25": 51, "pm100": 63, "timestamp": 1681416631}	2023-04-13 20:10:31+00
249396	{"pm10": 35, "pm25": 51, "pm100": 63, "timestamp": 1681416637}	2023-04-13 20:10:37+00
249396	{"pm10": 35, "pm25": 52, "pm100": 63, "timestamp": 1681416643}	2023-04-13 20:10:43+00
249396	{"pm10": 35, "pm25": 52, "pm100": 62, "timestamp": 1681416649}	2023-04-13 20:10:49+00
249396	{"pm10": 34, "pm25": 51, "pm100": 62, "timestamp": 1681416655}	2023-04-13 20:10:55+00
249396	{"pm10": 34, "pm25": 51, "pm100": 62, "timestamp": 1681416661}	2023-04-13 20:11:01+00
249396	{"pm10": 34, "pm25": 51, "pm100": 62, "timestamp": 1681416667}	2023-04-13 20:11:07+00
249396	{"pm10": 34, "pm25": 51, "pm100": 62, "timestamp": 1681416674}	2023-04-13 20:11:14+00
249396	{"pm10": 34, "pm25": 51, "pm100": 62, "timestamp": 1681416680}	2023-04-13 20:11:20+00
249396	{"pm10": 34, "pm25": 50, "pm100": 61, "timestamp": 1681416686}	2023-04-13 20:11:26+00
249396	{"pm10": 34, "pm25": 50, "pm100": 61, "timestamp": 1681416692}	2023-04-13 20:11:32+00
249396	{"pm10": 34, "pm25": 50, "pm100": 62, "timestamp": 1681416698}	2023-04-13 20:11:38+00
249396	{"pm10": 35, "pm25": 53, "pm100": 65, "timestamp": 1681416704}	2023-04-13 20:11:44+00
249396	{"pm10": 35, "pm25": 53, "pm100": 65, "timestamp": 1681416710}	2023-04-13 20:11:50+00
249396	{"pm10": 35, "pm25": 53, "pm100": 64, "timestamp": 1681416717}	2023-04-13 20:11:57+00
249396	{"pm10": 34, "pm25": 51, "pm100": 63, "timestamp": 1681416723}	2023-04-13 20:12:03+00
249396	{"pm10": 34, "pm25": 51, "pm100": 63, "timestamp": 1681416729}	2023-04-13 20:12:09+00
249396	{"pm10": 35, "pm25": 52, "pm100": 64, "timestamp": 1681416735}	2023-04-13 20:12:15+00
249396	{"pm10": 35, "pm25": 53, "pm100": 65, "timestamp": 1681416741}	2023-04-13 20:12:21+00
249396	{"pm10": 35, "pm25": 53, "pm100": 65, "timestamp": 1681416747}	2023-04-13 20:12:27+00
249396	{"pm10": 35, "pm25": 53, "pm100": 64, "timestamp": 1681416753}	2023-04-13 20:12:33+00
249396	{"pm10": 34, "pm25": 53, "pm100": 64, "timestamp": 1681416759}	2023-04-13 20:12:39+00
249396	{"pm10": 35, "pm25": 53, "pm100": 64, "timestamp": 1681416766}	2023-04-13 20:12:46+00
249396	{"pm10": 35, "pm25": 55, "pm100": 66, "timestamp": 1681416772}	2023-04-13 20:12:52+00
249396	{"pm10": 35, "pm25": 54, "pm100": 66, "timestamp": 1681416778}	2023-04-13 20:12:58+00
249396	{"pm10": 35, "pm25": 52, "pm100": 64, "timestamp": 1681416784}	2023-04-13 20:13:04+00
249396	{"pm10": 35, "pm25": 51, "pm100": 63, "timestamp": 1681416790}	2023-04-13 20:13:10+00
249396	{"pm10": 35, "pm25": 51, "pm100": 62, "timestamp": 1681416796}	2023-04-13 20:13:16+00
249396	{"pm10": 35, "pm25": 51, "pm100": 63, "timestamp": 1681416802}	2023-04-13 20:13:22+00
249396	{"pm10": 35, "pm25": 51, "pm100": 63, "timestamp": 1681416808}	2023-04-13 20:13:28+00
249396	{"pm10": 35, "pm25": 52, "pm100": 64, "timestamp": 1681416815}	2023-04-13 20:13:35+00
249396	{"pm10": 35, "pm25": 52, "pm100": 64, "timestamp": 1681416821}	2023-04-13 20:13:41+00
249396	{"pm10": 35, "pm25": 52, "pm100": 64, "timestamp": 1681416827}	2023-04-13 20:13:47+00
249396	{"pm10": 37, "pm25": 56, "pm100": 67, "timestamp": 1681416833}	2023-04-13 20:13:53+00
249396	{"pm10": 37, "pm25": 56, "pm100": 67, "timestamp": 1681416839}	2023-04-13 20:13:59+00
249396	{"pm10": 37, "pm25": 57, "pm100": 67, "timestamp": 1681416845}	2023-04-13 20:14:05+00
249396	{"pm10": 37, "pm25": 57, "pm100": 68, "timestamp": 1681416851}	2023-04-13 20:14:11+00
249396	{"pm10": 34, "pm25": 52, "pm100": 63, "timestamp": 1681416861}	2023-04-13 20:14:21+00
249396	{"pm10": 34, "pm25": 52, "pm100": 63, "timestamp": 1681416868}	2023-04-13 20:14:28+00
249396	{"pm10": 34, "pm25": 51, "pm100": 62, "timestamp": 1681416874}	2023-04-13 20:14:34+00
249396	{"pm10": 35, "pm25": 52, "pm100": 63, "timestamp": 1681416880}	2023-04-13 20:14:40+00
249396	{"pm10": 35, "pm25": 52, "pm100": 62, "timestamp": 1681416886}	2023-04-13 20:14:46+00
249396	{"pm10": 35, "pm25": 52, "pm100": 62, "timestamp": 1681416892}	2023-04-13 20:14:52+00
249396	{"pm10": 35, "pm25": 52, "pm100": 63, "timestamp": 1681416898}	2023-04-13 20:14:58+00
249396	{"pm10": 34, "pm25": 51, "pm100": 62, "timestamp": 1681416904}	2023-04-13 20:15:04+00
249396	{"pm10": 35, "pm25": 51, "pm100": 62, "timestamp": 1681416910}	2023-04-13 20:15:10+00
249396	{"pm10": 35, "pm25": 52, "pm100": 63, "timestamp": 1681416917}	2023-04-13 20:15:17+00
249396	{"pm10": 35, "pm25": 51, "pm100": 62, "timestamp": 1681416923}	2023-04-13 20:15:23+00
249396	{"pm10": 35, "pm25": 52, "pm100": 64, "timestamp": 1681416930}	2023-04-13 20:15:30+00
249396	{"pm10": 35, "pm25": 52, "pm100": 64, "timestamp": 1681416936}	2023-04-13 20:15:36+00
249396	{"pm10": 35, "pm25": 51, "pm100": 63, "timestamp": 1681416942}	2023-04-13 20:15:42+00
249396	{"pm10": 35, "pm25": 51, "pm100": 63, "timestamp": 1681416948}	2023-04-13 20:15:48+00
249396	{"pm10": 35, "pm25": 51, "pm100": 62, "timestamp": 1681416954}	2023-04-13 20:15:54+00
249396	{"pm10": 35, "pm25": 51, "pm100": 62, "timestamp": 1681416960}	2023-04-13 20:16:00+00
249396	{"pm10": 35, "pm25": 51, "pm100": 62, "timestamp": 1681416966}	2023-04-13 20:16:06+00
249396	{"pm10": 35, "pm25": 51, "pm100": 62, "timestamp": 1681416973}	2023-04-13 20:16:13+00
249396	{"pm10": 35, "pm25": 51, "pm100": 62, "timestamp": 1681416979}	2023-04-13 20:16:19+00
249396	{"pm10": 35, "pm25": 53, "pm100": 65, "timestamp": 1681416985}	2023-04-13 20:16:25+00
249396	{"pm10": 35, "pm25": 53, "pm100": 65, "timestamp": 1681416991}	2023-04-13 20:16:31+00
249396	{"pm10": 35, "pm25": 53, "pm100": 65, "timestamp": 1681416997}	2023-04-13 20:16:37+00
249396	{"pm10": 35, "pm25": 53, "pm100": 65, "timestamp": 1681417003}	2023-04-13 20:16:43+00
249396	{"pm10": 35, "pm25": 53, "pm100": 65, "timestamp": 1681417009}	2023-04-13 20:16:49+00
249396	{"pm10": 35, "pm25": 52, "pm100": 67, "timestamp": 1681417020}	2023-04-13 20:17:00+00
249396	{"pm10": 36, "pm25": 53, "pm100": 67, "timestamp": 1681417026}	2023-04-13 20:17:06+00
249396	{"pm10": 36, "pm25": 53, "pm100": 67, "timestamp": 1681417032}	2023-04-13 20:17:12+00
249396	{"pm10": 36, "pm25": 52, "pm100": 66, "timestamp": 1681417038}	2023-04-13 20:17:18+00
249396	{"pm10": 36, "pm25": 52, "pm100": 66, "timestamp": 1681417044}	2023-04-13 20:17:24+00
249396	{"pm10": 35, "pm25": 52, "pm100": 65, "timestamp": 1681417050}	2023-04-13 20:17:30+00
249396	{"pm10": 35, "pm25": 52, "pm100": 66, "timestamp": 1681417056}	2023-04-13 20:17:36+00
249396	{"pm10": 35, "pm25": 51, "pm100": 64, "timestamp": 1681417062}	2023-04-13 20:17:42+00
249396	{"pm10": 35, "pm25": 52, "pm100": 63, "timestamp": 1681417069}	2023-04-13 20:17:49+00
249396	{"pm10": 35, "pm25": 52, "pm100": 63, "timestamp": 1681417075}	2023-04-13 20:17:55+00
249396	{"pm10": 36, "pm25": 57, "pm100": 69, "timestamp": 1681417081}	2023-04-13 20:18:01+00
249396	{"pm10": 37, "pm25": 57, "pm100": 69, "timestamp": 1681417087}	2023-04-13 20:18:07+00
249396	{"pm10": 34, "pm25": 55, "pm100": 67, "timestamp": 1681417093}	2023-04-13 20:18:13+00
249396	{"pm10": 34, "pm25": 55, "pm100": 67, "timestamp": 1681417099}	2023-04-13 20:18:19+00
249396	{"pm10": 34, "pm25": 55, "pm100": 67, "timestamp": 1681417105}	2023-04-13 20:18:25+00
249396	{"pm10": 34, "pm25": 53, "pm100": 66, "timestamp": 1681417111}	2023-04-13 20:18:31+00
249396	{"pm10": 34, "pm25": 50, "pm100": 62, "timestamp": 1681417118}	2023-04-13 20:18:38+00
249396	{"pm10": 35, "pm25": 53, "pm100": 66, "timestamp": 1681417124}	2023-04-13 20:18:44+00
249396	{"pm10": 35, "pm25": 53, "pm100": 66, "timestamp": 1681417130}	2023-04-13 20:18:50+00
249396	{"pm10": 35, "pm25": 52, "pm100": 65, "timestamp": 1681417136}	2023-04-13 20:18:56+00
249396	{"pm10": 35, "pm25": 52, "pm100": 65, "timestamp": 1681417142}	2023-04-13 20:19:02+00
249396	{"pm10": 35, "pm25": 51, "pm100": 63, "timestamp": 1681417148}	2023-04-13 20:19:08+00
249396	{"pm10": 35, "pm25": 51, "pm100": 63, "timestamp": 1681417154}	2023-04-13 20:19:14+00
249396	{"pm10": 35, "pm25": 51, "pm100": 62, "timestamp": 1681417160}	2023-04-13 20:19:20+00
249396	{"pm10": 35, "pm25": 51, "pm100": 63, "timestamp": 1681417167}	2023-04-13 20:19:27+00
249396	{"pm10": 35, "pm25": 51, "pm100": 62, "timestamp": 1681417173}	2023-04-13 20:19:33+00
249396	{"pm10": 35, "pm25": 51, "pm100": 62, "timestamp": 1681417179}	2023-04-13 20:19:39+00
249396	{"pm10": 35, "pm25": 51, "pm100": 62, "timestamp": 1681417185}	2023-04-13 20:19:45+00
249396	{"pm10": 35, "pm25": 51, "pm100": 62, "timestamp": 1681417191}	2023-04-13 20:19:51+00
249396	{"pm10": 35, "pm25": 52, "pm100": 62, "timestamp": 1681417197}	2023-04-13 20:19:57+00
249396	{"pm10": 35, "pm25": 54, "pm100": 66, "timestamp": 1681417203}	2023-04-13 20:20:03+00
249396	{"pm10": 35, "pm25": 53, "pm100": 65, "timestamp": 1681417209}	2023-04-13 20:20:09+00
249396	{"pm10": 36, "pm25": 53, "pm100": 64, "timestamp": 1681417216}	2023-04-13 20:20:16+00
249396	{"pm10": 36, "pm25": 53, "pm100": 64, "timestamp": 1681417222}	2023-04-13 20:20:22+00
249396	{"pm10": 36, "pm25": 53, "pm100": 65, "timestamp": 1681417228}	2023-04-13 20:20:28+00
249396	{"pm10": 36, "pm25": 53, "pm100": 65, "timestamp": 1681417234}	2023-04-13 20:20:34+00
249396	{"pm10": 35, "pm25": 51, "pm100": 62, "timestamp": 1681417240}	2023-04-13 20:20:40+00
249396	{"pm10": 35, "pm25": 51, "pm100": 62, "timestamp": 1681417246}	2023-04-13 20:20:46+00
249396	{"pm10": 34, "pm25": 51, "pm100": 62, "timestamp": 1681417252}	2023-04-13 20:20:52+00
249396	{"pm10": 35, "pm25": 52, "pm100": 65, "timestamp": 1681417258}	2023-04-13 20:20:58+00
249396	{"pm10": 35, "pm25": 52, "pm100": 64, "timestamp": 1681417265}	2023-04-13 20:21:05+00
249396	{"pm10": 34, "pm25": 52, "pm100": 64, "timestamp": 1681417271}	2023-04-13 20:21:11+00
249396	{"pm10": 34, "pm25": 52, "pm100": 64, "timestamp": 1681417277}	2023-04-13 20:21:17+00
249396	{"pm10": 33, "pm25": 50, "pm100": 62, "timestamp": 1681417283}	2023-04-13 20:21:23+00
249396	{"pm10": 33, "pm25": 51, "pm100": 63, "timestamp": 1681417289}	2023-04-13 20:21:29+00
249396	{"pm10": 34, "pm25": 51, "pm100": 63, "timestamp": 1681417295}	2023-04-13 20:21:35+00
249396	{"pm10": 34, "pm25": 52, "pm100": 64, "timestamp": 1681417301}	2023-04-13 20:21:41+00
249396	{"pm10": 35, "pm25": 53, "pm100": 65, "timestamp": 1681417307}	2023-04-13 20:21:47+00
249396	{"pm10": 34, "pm25": 52, "pm100": 64, "timestamp": 1681417314}	2023-04-13 20:21:54+00
249396	{"pm10": 35, "pm25": 53, "pm100": 65, "timestamp": 1681417320}	2023-04-13 20:22:00+00
249396	{"pm10": 35, "pm25": 53, "pm100": 65, "timestamp": 1681417326}	2023-04-13 20:22:06+00
249396	{"pm10": 35, "pm25": 53, "pm100": 65, "timestamp": 1681417332}	2023-04-13 20:22:12+00
249396	{"pm10": 34, "pm25": 52, "pm100": 64, "timestamp": 1681417338}	2023-04-13 20:22:18+00
249396	{"pm10": 34, "pm25": 52, "pm100": 64, "timestamp": 1681417344}	2023-04-13 20:22:24+00
249396	{"pm10": 34, "pm25": 52, "pm100": 64, "timestamp": 1681417350}	2023-04-13 20:22:30+00
249396	{"pm10": 35, "pm25": 52, "pm100": 66, "timestamp": 1681417356}	2023-04-13 20:22:36+00
249396	{"pm10": 36, "pm25": 52, "pm100": 66, "timestamp": 1681417363}	2023-04-13 20:22:43+00
249396	{"pm10": 35, "pm25": 52, "pm100": 66, "timestamp": 1681417369}	2023-04-13 20:22:49+00
249396	{"pm10": 36, "pm25": 53, "pm100": 66, "timestamp": 1681417375}	2023-04-13 20:22:55+00
249396	{"pm10": 34, "pm25": 51, "pm100": 62, "timestamp": 1681417381}	2023-04-13 20:23:01+00
249396	{"pm10": 34, "pm25": 51, "pm100": 62, "timestamp": 1681417387}	2023-04-13 20:23:07+00
249396	{"pm10": 35, "pm25": 52, "pm100": 63, "timestamp": 1681417393}	2023-04-13 20:23:13+00
249396	{"pm10": 35, "pm25": 52, "pm100": 64, "timestamp": 1681417399}	2023-04-13 20:23:19+00
249396	{"pm10": 35, "pm25": 52, "pm100": 63, "timestamp": 1681417405}	2023-04-13 20:23:25+00
249396	{"pm10": 35, "pm25": 52, "pm100": 65, "timestamp": 1681417412}	2023-04-13 20:23:32+00
249396	{"pm10": 35, "pm25": 52, "pm100": 65, "timestamp": 1681417419}	2023-04-13 20:23:39+00
249396	{"pm10": 35, "pm25": 52, "pm100": 65, "timestamp": 1681417425}	2023-04-13 20:23:45+00
249396	{"pm10": 35, "pm25": 52, "pm100": 65, "timestamp": 1681417431}	2023-04-13 20:23:51+00
249396	{"pm10": 35, "pm25": 52, "pm100": 64, "timestamp": 1681417437}	2023-04-13 20:23:57+00
249396	{"pm10": 35, "pm25": 52, "pm100": 64, "timestamp": 1681417443}	2023-04-13 20:24:03+00
249396	{"pm10": 35, "pm25": 52, "pm100": 64, "timestamp": 1681417449}	2023-04-13 20:24:09+00
249396	{"pm10": 35, "pm25": 52, "pm100": 64, "timestamp": 1681417455}	2023-04-13 20:24:15+00
249396	{"pm10": 35, "pm25": 52, "pm100": 64, "timestamp": 1681417461}	2023-04-13 20:24:21+00
249396	{"pm10": 36, "pm25": 53, "pm100": 66, "timestamp": 1681417468}	2023-04-13 20:24:28+00
249396	{"pm10": 36, "pm25": 54, "pm100": 66, "timestamp": 1681417474}	2023-04-13 20:24:34+00
249396	{"pm10": 36, "pm25": 55, "pm100": 67, "timestamp": 1681417480}	2023-04-13 20:24:40+00
249396	{"pm10": 37, "pm25": 56, "pm100": 67, "timestamp": 1681417486}	2023-04-13 20:24:46+00
249396	{"pm10": 34, "pm25": 51, "pm100": 63, "timestamp": 1681417492}	2023-04-13 20:24:52+00
249396	{"pm10": 34, "pm25": 51, "pm100": 63, "timestamp": 1681417498}	2023-04-13 20:24:58+00
249396	{"pm10": 36, "pm25": 53, "pm100": 66, "timestamp": 1681417504}	2023-04-13 20:25:04+00
249396	{"pm10": 36, "pm25": 53, "pm100": 66, "timestamp": 1681417510}	2023-04-13 20:25:10+00
249396	{"pm10": 35, "pm25": 52, "pm100": 65, "timestamp": 1681417517}	2023-04-13 20:25:17+00
249396	{"pm10": 35, "pm25": 53, "pm100": 65, "timestamp": 1681417523}	2023-04-13 20:25:23+00
249396	{"pm10": 35, "pm25": 52, "pm100": 64, "timestamp": 1681417529}	2023-04-13 20:25:29+00
249396	{"pm10": 35, "pm25": 53, "pm100": 65, "timestamp": 1681417535}	2023-04-13 20:25:35+00
249396	{"pm10": 35, "pm25": 53, "pm100": 66, "timestamp": 1681417541}	2023-04-13 20:25:41+00
249396	{"pm10": 35, "pm25": 52, "pm100": 63, "timestamp": 1681417547}	2023-04-13 20:25:47+00
249396	{"pm10": 34, "pm25": 51, "pm100": 64, "timestamp": 1681417553}	2023-04-13 20:25:53+00
249396	{"pm10": 34, "pm25": 52, "pm100": 64, "timestamp": 1681417559}	2023-04-13 20:25:59+00
249396	{"pm10": 34, "pm25": 51, "pm100": 63, "timestamp": 1681417566}	2023-04-13 20:26:06+00
249396	{"pm10": 34, "pm25": 51, "pm100": 63, "timestamp": 1681417572}	2023-04-13 20:26:12+00
249396	{"pm10": 34, "pm25": 51, "pm100": 63, "timestamp": 1681417578}	2023-04-13 20:26:18+00
249396	{"pm10": 34, "pm25": 51, "pm100": 62, "timestamp": 1681417584}	2023-04-13 20:26:24+00
249396	{"pm10": 34, "pm25": 51, "pm100": 62, "timestamp": 1681417590}	2023-04-13 20:26:30+00
249396	{"pm10": 34, "pm25": 51, "pm100": 62, "timestamp": 1681417596}	2023-04-13 20:26:36+00
249396	{"pm10": 34, "pm25": 51, "pm100": 62, "timestamp": 1681417602}	2023-04-13 20:26:42+00
249396	{"pm10": 37, "pm25": 55, "pm100": 67, "timestamp": 1681417608}	2023-04-13 20:26:48+00
249396	{"pm10": 35, "pm25": 54, "pm100": 66, "timestamp": 1681417615}	2023-04-13 20:26:55+00
249396	{"pm10": 36, "pm25": 53, "pm100": 65, "timestamp": 1681417621}	2023-04-13 20:27:01+00
249396	{"pm10": 36, "pm25": 54, "pm100": 66, "timestamp": 1681417627}	2023-04-13 20:27:07+00
249396	{"pm10": 33, "pm25": 52, "pm100": 64, "timestamp": 1681417633}	2023-04-13 20:27:13+00
249396	{"pm10": 33, "pm25": 52, "pm100": 64, "timestamp": 1681417639}	2023-04-13 20:27:19+00
249396	{"pm10": 33, "pm25": 52, "pm100": 64, "timestamp": 1681417645}	2023-04-13 20:27:25+00
249396	{"pm10": 34, "pm25": 54, "pm100": 66, "timestamp": 1681417651}	2023-04-13 20:27:31+00
249396	{"pm10": 35, "pm25": 55, "pm100": 66, "timestamp": 1681417657}	2023-04-13 20:27:37+00
249396	{"pm10": 34, "pm25": 53, "pm100": 64, "timestamp": 1681417664}	2023-04-13 20:27:44+00
249396	{"pm10": 34, "pm25": 52, "pm100": 64, "timestamp": 1681417670}	2023-04-13 20:27:50+00
249396	{"pm10": 34, "pm25": 52, "pm100": 64, "timestamp": 1681417676}	2023-04-13 20:27:56+00
249396	{"pm10": 34, "pm25": 52, "pm100": 64, "timestamp": 1681417682}	2023-04-13 20:28:02+00
249396	{"pm10": 34, "pm25": 52, "pm100": 64, "timestamp": 1681417688}	2023-04-13 20:28:08+00
249396	{"pm10": 34, "pm25": 51, "pm100": 63, "timestamp": 1681417694}	2023-04-13 20:28:14+00
249396	{"pm10": 34, "pm25": 52, "pm100": 64, "timestamp": 1681417700}	2023-04-13 20:28:20+00
249396	{"pm10": 35, "pm25": 52, "pm100": 65, "timestamp": 1681417706}	2023-04-13 20:28:26+00
249396	{"pm10": 35, "pm25": 52, "pm100": 65, "timestamp": 1681417713}	2023-04-13 20:28:33+00
249396	{"pm10": 35, "pm25": 53, "pm100": 65, "timestamp": 1681417719}	2023-04-13 20:28:39+00
249396	{"pm10": 35, "pm25": 53, "pm100": 65, "timestamp": 1681417725}	2023-04-13 20:28:45+00
249396	{"pm10": 35, "pm25": 53, "pm100": 64, "timestamp": 1681417731}	2023-04-13 20:28:51+00
249396	{"pm10": 34, "pm25": 53, "pm100": 65, "timestamp": 1681417737}	2023-04-13 20:28:57+00
249396	{"pm10": 35, "pm25": 53, "pm100": 66, "timestamp": 1681417743}	2023-04-13 20:29:03+00
249396	{"pm10": 35, "pm25": 53, "pm100": 66, "timestamp": 1681417749}	2023-04-13 20:29:09+00
249396	{"pm10": 37, "pm25": 54, "pm100": 66, "timestamp": 1681417755}	2023-04-13 20:29:15+00
249396	{"pm10": 37, "pm25": 54, "pm100": 66, "timestamp": 1681417762}	2023-04-13 20:29:22+00
249396	{"pm10": 35, "pm25": 53, "pm100": 65, "timestamp": 1681417768}	2023-04-13 20:29:28+00
249396	{"pm10": 36, "pm25": 53, "pm100": 66, "timestamp": 1681417774}	2023-04-13 20:29:34+00
249396	{"pm10": 35, "pm25": 53, "pm100": 65, "timestamp": 1681417780}	2023-04-13 20:29:40+00
249396	{"pm10": 36, "pm25": 53, "pm100": 66, "timestamp": 1681417786}	2023-04-13 20:29:46+00
249396	{"pm10": 35, "pm25": 53, "pm100": 66, "timestamp": 1681417792}	2023-04-13 20:29:52+00
249396	{"pm10": 35, "pm25": 52, "pm100": 65, "timestamp": 1681417798}	2023-04-13 20:29:58+00
249396	{"pm10": 35, "pm25": 52, "pm100": 64, "timestamp": 1681417804}	2023-04-13 20:30:04+00
249396	{"pm10": 35, "pm25": 52, "pm100": 64, "timestamp": 1681417811}	2023-04-13 20:30:11+00
249396	{"pm10": 35, "pm25": 52, "pm100": 64, "timestamp": 1681417817}	2023-04-13 20:30:17+00
249396	{"pm10": 36, "pm25": 53, "pm100": 67, "timestamp": 1681417823}	2023-04-13 20:30:23+00
249396	{"pm10": 37, "pm25": 55, "pm100": 68, "timestamp": 1681417829}	2023-04-13 20:30:29+00
249396	{"pm10": 36, "pm25": 53, "pm100": 67, "timestamp": 1681417835}	2023-04-13 20:30:35+00
249396	{"pm10": 36, "pm25": 53, "pm100": 67, "timestamp": 1681417841}	2023-04-13 20:30:41+00
249396	{"pm10": 37, "pm25": 55, "pm100": 67, "timestamp": 1681417847}	2023-04-13 20:30:47+00
249396	{"pm10": 36, "pm25": 51, "pm100": 62, "timestamp": 1681417853}	2023-04-13 20:30:53+00
249396	{"pm10": 36, "pm25": 51, "pm100": 62, "timestamp": 1681417860}	2023-04-13 20:31:00+00
249396	{"pm10": 34, "pm25": 51, "pm100": 63, "timestamp": 1681417866}	2023-04-13 20:31:06+00
249396	{"pm10": 34, "pm25": 51, "pm100": 63, "timestamp": 1681417872}	2023-04-13 20:31:12+00
249396	{"pm10": 34, "pm25": 52, "pm100": 64, "timestamp": 1681417878}	2023-04-13 20:31:18+00
249396	{"pm10": 35, "pm25": 53, "pm100": 66, "timestamp": 1681417884}	2023-04-13 20:31:24+00
249396	{"pm10": 34, "pm25": 52, "pm100": 65, "timestamp": 1681417890}	2023-04-13 20:31:30+00
249396	{"pm10": 34, "pm25": 51, "pm100": 63, "timestamp": 1681417896}	2023-04-13 20:31:36+00
249396	{"pm10": 34, "pm25": 52, "pm100": 63, "timestamp": 1681417903}	2023-04-13 20:31:43+00
249396	{"pm10": 35, "pm25": 54, "pm100": 66, "timestamp": 1681417909}	2023-04-13 20:31:49+00
249396	{"pm10": 35, "pm25": 52, "pm100": 63, "timestamp": 1681417915}	2023-04-13 20:31:55+00
249396	{"pm10": 35, "pm25": 51, "pm100": 62, "timestamp": 1681417921}	2023-04-13 20:32:01+00
249396	{"pm10": 34, "pm25": 51, "pm100": 62, "timestamp": 1681417927}	2023-04-13 20:32:07+00
249396	{"pm10": 34, "pm25": 51, "pm100": 62, "timestamp": 1681417933}	2023-04-13 20:32:13+00
249396	{"pm10": 33, "pm25": 49, "pm100": 60, "timestamp": 1681417939}	2023-04-13 20:32:19+00
249396	{"pm10": 35, "pm25": 50, "pm100": 63, "timestamp": 1681417945}	2023-04-13 20:32:25+00
249396	{"pm10": 34, "pm25": 50, "pm100": 63, "timestamp": 1681417952}	2023-04-13 20:32:32+00
249396	{"pm10": 34, "pm25": 50, "pm100": 63, "timestamp": 1681417958}	2023-04-13 20:32:38+00
249396	{"pm10": 35, "pm25": 50, "pm100": 62, "timestamp": 1681417964}	2023-04-13 20:32:44+00
249396	{"pm10": 35, "pm25": 50, "pm100": 62, "timestamp": 1681417970}	2023-04-13 20:32:50+00
249396	{"pm10": 35, "pm25": 50, "pm100": 62, "timestamp": 1681417976}	2023-04-13 20:32:56+00
249396	{"pm10": 35, "pm25": 50, "pm100": 62, "timestamp": 1681417982}	2023-04-13 20:33:02+00
249396	{"pm10": 35, "pm25": 50, "pm100": 62, "timestamp": 1681417988}	2023-04-13 20:33:08+00
249396	{"pm10": 35, "pm25": 50, "pm100": 62, "timestamp": 1681417994}	2023-04-13 20:33:14+00
249396	{"pm10": 35, "pm25": 50, "pm100": 61, "timestamp": 1681418001}	2023-04-13 20:33:21+00
249396	{"pm10": 35, "pm25": 51, "pm100": 62, "timestamp": 1681418007}	2023-04-13 20:33:27+00
249396	{"pm10": 35, "pm25": 51, "pm100": 62, "timestamp": 1681418013}	2023-04-13 20:33:33+00
249396	{"pm10": 35, "pm25": 51, "pm100": 63, "timestamp": 1681418019}	2023-04-13 20:33:39+00
249396	{"pm10": 35, "pm25": 51, "pm100": 63, "timestamp": 1681418025}	2023-04-13 20:33:45+00
249396	{"pm10": 35, "pm25": 53, "pm100": 65, "timestamp": 1681418031}	2023-04-13 20:33:51+00
249396	{"pm10": 35, "pm25": 53, "pm100": 65, "timestamp": 1681418037}	2023-04-13 20:33:57+00
249396	{"pm10": 35, "pm25": 53, "pm100": 65, "timestamp": 1681418043}	2023-04-13 20:34:03+00
249396	{"pm10": 35, "pm25": 53, "pm100": 65, "timestamp": 1681418050}	2023-04-13 20:34:10+00
249396	{"pm10": 35, "pm25": 53, "pm100": 65, "timestamp": 1681418056}	2023-04-13 20:34:16+00
249396	{"pm10": 35, "pm25": 53, "pm100": 65, "timestamp": 1681418062}	2023-04-13 20:34:22+00
249396	{"pm10": 35, "pm25": 53, "pm100": 66, "timestamp": 1681418068}	2023-04-13 20:34:28+00
249396	{"pm10": 35, "pm25": 53, "pm100": 66, "timestamp": 1681418074}	2023-04-13 20:34:34+00
249396	{"pm10": 34, "pm25": 53, "pm100": 65, "timestamp": 1681418080}	2023-04-13 20:34:40+00
249396	{"pm10": 35, "pm25": 51, "pm100": 62, "timestamp": 1681418086}	2023-04-13 20:34:46+00
249396	{"pm10": 35, "pm25": 51, "pm100": 62, "timestamp": 1681418092}	2023-04-13 20:34:52+00
249396	{"pm10": 34, "pm25": 51, "pm100": 62, "timestamp": 1681418099}	2023-04-13 20:34:59+00
249396	{"pm10": 34, "pm25": 51, "pm100": 62, "timestamp": 1681418105}	2023-04-13 20:35:05+00
249396	{"pm10": 34, "pm25": 52, "pm100": 63, "timestamp": 1681418111}	2023-04-13 20:35:11+00
249396	{"pm10": 34, "pm25": 52, "pm100": 63, "timestamp": 1681418117}	2023-04-13 20:35:17+00
249396	{"pm10": 34, "pm25": 52, "pm100": 62, "timestamp": 1681418123}	2023-04-13 20:35:23+00
249396	{"pm10": 35, "pm25": 52, "pm100": 63, "timestamp": 1681418129}	2023-04-13 20:35:29+00
249396	{"pm10": 35, "pm25": 52, "pm100": 63, "timestamp": 1681418135}	2023-04-13 20:35:35+00
249396	{"pm10": 35, "pm25": 52, "pm100": 63, "timestamp": 1681418141}	2023-04-13 20:35:41+00
249396	{"pm10": 35, "pm25": 52, "pm100": 63, "timestamp": 1681418148}	2023-04-13 20:35:48+00
249396	{"pm10": 35, "pm25": 53, "pm100": 66, "timestamp": 1681418154}	2023-04-13 20:35:54+00
249396	{"pm10": 35, "pm25": 54, "pm100": 67, "timestamp": 1681418160}	2023-04-13 20:36:00+00
249396	{"pm10": 35, "pm25": 54, "pm100": 67, "timestamp": 1681418166}	2023-04-13 20:36:06+00
249396	{"pm10": 35, "pm25": 55, "pm100": 67, "timestamp": 1681418172}	2023-04-13 20:36:12+00
249396	{"pm10": 35, "pm25": 53, "pm100": 67, "timestamp": 1681418178}	2023-04-13 20:36:18+00
249396	{"pm10": 35, "pm25": 53, "pm100": 64, "timestamp": 1681418184}	2023-04-13 20:36:24+00
249396	{"pm10": 35, "pm25": 53, "pm100": 64, "timestamp": 1681418190}	2023-04-13 20:36:30+00
249396	{"pm10": 33, "pm25": 51, "pm100": 62, "timestamp": 1681418197}	2023-04-13 20:36:37+00
249396	{"pm10": 34, "pm25": 51, "pm100": 63, "timestamp": 1681418203}	2023-04-13 20:36:43+00
249396	{"pm10": 34, "pm25": 53, "pm100": 66, "timestamp": 1681418209}	2023-04-13 20:36:49+00
249396	{"pm10": 34, "pm25": 51, "pm100": 63, "timestamp": 1681418215}	2023-04-13 20:36:55+00
249396	{"pm10": 34, "pm25": 51, "pm100": 62, "timestamp": 1681418221}	2023-04-13 20:37:01+00
249396	{"pm10": 34, "pm25": 50, "pm100": 62, "timestamp": 1681418227}	2023-04-13 20:37:07+00
249396	{"pm10": 35, "pm25": 50, "pm100": 62, "timestamp": 1681418233}	2023-04-13 20:37:13+00
249396	{"pm10": 35, "pm25": 51, "pm100": 62, "timestamp": 1681418239}	2023-04-13 20:37:19+00
249396	{"pm10": 34, "pm25": 51, "pm100": 63, "timestamp": 1681418246}	2023-04-13 20:37:26+00
249396	{"pm10": 35, "pm25": 52, "pm100": 65, "timestamp": 1681418252}	2023-04-13 20:37:32+00
249396	{"pm10": 35, "pm25": 52, "pm100": 65, "timestamp": 1681418258}	2023-04-13 20:37:38+00
249396	{"pm10": 35, "pm25": 52, "pm100": 64, "timestamp": 1681418264}	2023-04-13 20:37:44+00
249396	{"pm10": 35, "pm25": 52, "pm100": 64, "timestamp": 1681418270}	2023-04-13 20:37:50+00
249396	{"pm10": 35, "pm25": 52, "pm100": 64, "timestamp": 1681418276}	2023-04-13 20:37:56+00
249396	{"pm10": 35, "pm25": 52, "pm100": 64, "timestamp": 1681418282}	2023-04-13 20:38:02+00
249396	{"pm10": 35, "pm25": 52, "pm100": 64, "timestamp": 1681418288}	2023-04-13 20:38:08+00
249396	{"pm10": 35, "pm25": 51, "pm100": 62, "timestamp": 1681418295}	2023-04-13 20:38:15+00
249396	{"pm10": 35, "pm25": 51, "pm100": 62, "timestamp": 1681418301}	2023-04-13 20:38:21+00
249396	{"pm10": 33, "pm25": 49, "pm100": 60, "timestamp": 1681418307}	2023-04-13 20:38:27+00
249396	{"pm10": 33, "pm25": 49, "pm100": 60, "timestamp": 1681418313}	2023-04-13 20:38:33+00
249396	{"pm10": 34, "pm25": 50, "pm100": 61, "timestamp": 1681418319}	2023-04-13 20:38:39+00
249396	{"pm10": 34, "pm25": 50, "pm100": 61, "timestamp": 1681418325}	2023-04-13 20:38:45+00
249396	{"pm10": 34, "pm25": 52, "pm100": 64, "timestamp": 1681418331}	2023-04-13 20:38:51+00
249396	{"pm10": 35, "pm25": 53, "pm100": 65, "timestamp": 1681418337}	2023-04-13 20:38:57+00
249396	{"pm10": 35, "pm25": 53, "pm100": 66, "timestamp": 1681418344}	2023-04-13 20:39:04+00
249396	{"pm10": 35, "pm25": 53, "pm100": 66, "timestamp": 1681418350}	2023-04-13 20:39:10+00
249396	{"pm10": 35, "pm25": 53, "pm100": 66, "timestamp": 1681418356}	2023-04-13 20:39:16+00
249396	{"pm10": 35, "pm25": 51, "pm100": 62, "timestamp": 1681418362}	2023-04-13 20:39:22+00
249396	{"pm10": 35, "pm25": 52, "pm100": 63, "timestamp": 1681418368}	2023-04-13 20:39:28+00
249396	{"pm10": 35, "pm25": 52, "pm100": 64, "timestamp": 1681418374}	2023-04-13 20:39:34+00
249396	{"pm10": 35, "pm25": 52, "pm100": 64, "timestamp": 1681418380}	2023-04-13 20:39:40+00
249396	{"pm10": 34, "pm25": 51, "pm100": 63, "timestamp": 1681418387}	2023-04-13 20:39:47+00
249396	{"pm10": 34, "pm25": 51, "pm100": 62, "timestamp": 1681418393}	2023-04-13 20:39:53+00
249396	{"pm10": 34, "pm25": 51, "pm100": 63, "timestamp": 1681418399}	2023-04-13 20:39:59+00
249396	{"pm10": 35, "pm25": 51, "pm100": 63, "timestamp": 1681418405}	2023-04-13 20:40:05+00
249396	{"pm10": 35, "pm25": 52, "pm100": 64, "timestamp": 1681418411}	2023-04-13 20:40:11+00
249396	{"pm10": 35, "pm25": 52, "pm100": 65, "timestamp": 1681418417}	2023-04-13 20:40:17+00
249396	{"pm10": 34, "pm25": 50, "pm100": 61, "timestamp": 1681418423}	2023-04-13 20:40:23+00
249396	{"pm10": 34, "pm25": 51, "pm100": 62, "timestamp": 1681418429}	2023-04-13 20:40:29+00
249396	{"pm10": 34, "pm25": 51, "pm100": 62, "timestamp": 1681418436}	2023-04-13 20:40:36+00
249396	{"pm10": 34, "pm25": 51, "pm100": 62, "timestamp": 1681418442}	2023-04-13 20:40:42+00
249396	{"pm10": 35, "pm25": 51, "pm100": 61, "timestamp": 1681418448}	2023-04-13 20:40:48+00
249396	{"pm10": 35, "pm25": 51, "pm100": 62, "timestamp": 1681418454}	2023-04-13 20:40:54+00
249396	{"pm10": 37, "pm25": 53, "pm100": 65, "timestamp": 1681418460}	2023-04-13 20:41:00+00
249396	{"pm10": 36, "pm25": 53, "pm100": 65, "timestamp": 1681418466}	2023-04-13 20:41:06+00
249396	{"pm10": 34, "pm25": 51, "pm100": 62, "timestamp": 1681418472}	2023-04-13 20:41:12+00
249396	{"pm10": 34, "pm25": 50, "pm100": 62, "timestamp": 1681418478}	2023-04-13 20:41:18+00
249396	{"pm10": 34, "pm25": 50, "pm100": 62, "timestamp": 1681418485}	2023-04-13 20:41:25+00
249396	{"pm10": 35, "pm25": 51, "pm100": 63, "timestamp": 1681418491}	2023-04-13 20:41:31+00
249396	{"pm10": 35, "pm25": 52, "pm100": 64, "timestamp": 1681418497}	2023-04-13 20:41:37+00
249396	{"pm10": 35, "pm25": 53, "pm100": 65, "timestamp": 1681418503}	2023-04-13 20:41:43+00
249396	{"pm10": 36, "pm25": 53, "pm100": 65, "timestamp": 1681418509}	2023-04-13 20:41:49+00
249396	{"pm10": 36, "pm25": 53, "pm100": 65, "timestamp": 1681418515}	2023-04-13 20:41:55+00
249396	{"pm10": 36, "pm25": 52, "pm100": 63, "timestamp": 1681418521}	2023-04-13 20:42:01+00
249396	{"pm10": 36, "pm25": 52, "pm100": 63, "timestamp": 1681418527}	2023-04-13 20:42:07+00
249396	{"pm10": 36, "pm25": 52, "pm100": 63, "timestamp": 1681418534}	2023-04-13 20:42:14+00
249396	{"pm10": 35, "pm25": 52, "pm100": 64, "timestamp": 1681418540}	2023-04-13 20:42:20+00
249396	{"pm10": 35, "pm25": 51, "pm100": 63, "timestamp": 1681418546}	2023-04-13 20:42:26+00
249396	{"pm10": 36, "pm25": 52, "pm100": 64, "timestamp": 1681418552}	2023-04-13 20:42:32+00
249396	{"pm10": 34, "pm25": 50, "pm100": 62, "timestamp": 1681418558}	2023-04-13 20:42:38+00
249396	{"pm10": 35, "pm25": 52, "pm100": 64, "timestamp": 1681418564}	2023-04-13 20:42:44+00
249396	{"pm10": 35, "pm25": 52, "pm100": 64, "timestamp": 1681418570}	2023-04-13 20:42:50+00
249396	{"pm10": 34, "pm25": 51, "pm100": 64, "timestamp": 1681418576}	2023-04-13 20:42:56+00
249396	{"pm10": 34, "pm25": 51, "pm100": 64, "timestamp": 1681418583}	2023-04-13 20:43:03+00
249396	{"pm10": 34, "pm25": 51, "pm100": 64, "timestamp": 1681418589}	2023-04-13 20:43:09+00
249396	{"pm10": 34, "pm25": 51, "pm100": 62, "timestamp": 1681418595}	2023-04-13 20:43:15+00
249396	{"pm10": 34, "pm25": 53, "pm100": 65, "timestamp": 1681418601}	2023-04-13 20:43:21+00
249396	{"pm10": 34, "pm25": 53, "pm100": 65, "timestamp": 1681418607}	2023-04-13 20:43:27+00
249396	{"pm10": 34, "pm25": 52, "pm100": 64, "timestamp": 1681418613}	2023-04-13 20:43:33+00
249396	{"pm10": 34, "pm25": 52, "pm100": 64, "timestamp": 1681418619}	2023-04-13 20:43:39+00
249396	{"pm10": 34, "pm25": 52, "pm100": 64, "timestamp": 1681418625}	2023-04-13 20:43:45+00
249396	{"pm10": 34, "pm25": 52, "pm100": 64, "timestamp": 1681418632}	2023-04-13 20:43:52+00
249396	{"pm10": 34, "pm25": 52, "pm100": 64, "timestamp": 1681418638}	2023-04-13 20:43:58+00
249396	{"pm10": 34, "pm25": 52, "pm100": 64, "timestamp": 1681418644}	2023-04-13 20:44:04+00
249396	{"pm10": 35, "pm25": 52, "pm100": 63, "timestamp": 1681418650}	2023-04-13 20:44:10+00
249396	{"pm10": 35, "pm25": 51, "pm100": 63, "timestamp": 1681418656}	2023-04-13 20:44:16+00
249396	{"pm10": 35, "pm25": 51, "pm100": 63, "timestamp": 1681418662}	2023-04-13 20:44:22+00
249396	{"pm10": 34, "pm25": 52, "pm100": 63, "timestamp": 1681418668}	2023-04-13 20:44:28+00
249396	{"pm10": 35, "pm25": 52, "pm100": 63, "timestamp": 1681418674}	2023-04-13 20:44:34+00
249396	{"pm10": 35, "pm25": 52, "pm100": 63, "timestamp": 1681418681}	2023-04-13 20:44:41+00
249396	{"pm10": 35, "pm25": 52, "pm100": 63, "timestamp": 1681418687}	2023-04-13 20:44:47+00
249396	{"pm10": 35, "pm25": 52, "pm100": 64, "timestamp": 1681418693}	2023-04-13 20:44:53+00
249396	{"pm10": 35, "pm25": 52, "pm100": 64, "timestamp": 1681418699}	2023-04-13 20:44:59+00
249396	{"pm10": 34, "pm25": 50, "pm100": 62, "timestamp": 1681418705}	2023-04-13 20:45:05+00
249396	{"pm10": 36, "pm25": 52, "pm100": 63, "timestamp": 1681418711}	2023-04-13 20:45:11+00
249396	{"pm10": 36, "pm25": 52, "pm100": 63, "timestamp": 1681418717}	2023-04-13 20:45:17+00
249396	{"pm10": 35, "pm25": 52, "pm100": 64, "timestamp": 1681418723}	2023-04-13 20:45:23+00
249396	{"pm10": 35, "pm25": 55, "pm100": 66, "timestamp": 1681418730}	2023-04-13 20:45:30+00
249396	{"pm10": 35, "pm25": 55, "pm100": 66, "timestamp": 1681418736}	2023-04-13 20:45:36+00
249396	{"pm10": 34, "pm25": 54, "pm100": 66, "timestamp": 1681418742}	2023-04-13 20:45:42+00
249396	{"pm10": 36, "pm25": 52, "pm100": 64, "timestamp": 1681418748}	2023-04-13 20:45:48+00
249396	{"pm10": 35, "pm25": 52, "pm100": 64, "timestamp": 1681418754}	2023-04-13 20:45:54+00
249396	{"pm10": 35, "pm25": 52, "pm100": 64, "timestamp": 1681418760}	2023-04-13 20:46:00+00
249396	{"pm10": 35, "pm25": 52, "pm100": 64, "timestamp": 1681418766}	2023-04-13 20:46:06+00
249396	{"pm10": 35, "pm25": 52, "pm100": 63, "timestamp": 1681418772}	2023-04-13 20:46:12+00
249396	{"pm10": 35, "pm25": 51, "pm100": 62, "timestamp": 1681418779}	2023-04-13 20:46:19+00
249396	{"pm10": 35, "pm25": 51, "pm100": 63, "timestamp": 1681418785}	2023-04-13 20:46:25+00
249396	{"pm10": 34, "pm25": 51, "pm100": 62, "timestamp": 1681418791}	2023-04-13 20:46:31+00
249396	{"pm10": 35, "pm25": 51, "pm100": 62, "timestamp": 1681418797}	2023-04-13 20:46:37+00
249396	{"pm10": 35, "pm25": 52, "pm100": 63, "timestamp": 1681418803}	2023-04-13 20:46:43+00
249396	{"pm10": 35, "pm25": 52, "pm100": 65, "timestamp": 1681418809}	2023-04-13 20:46:49+00
249396	{"pm10": 35, "pm25": 52, "pm100": 65, "timestamp": 1681418815}	2023-04-13 20:46:55+00
249396	{"pm10": 35, "pm25": 52, "pm100": 65, "timestamp": 1681418822}	2023-04-13 20:47:02+00
249396	{"pm10": 34, "pm25": 52, "pm100": 65, "timestamp": 1681418828}	2023-04-13 20:47:08+00
249396	{"pm10": 34, "pm25": 52, "pm100": 64, "timestamp": 1681418834}	2023-04-13 20:47:14+00
249396	{"pm10": 34, "pm25": 52, "pm100": 64, "timestamp": 1681418840}	2023-04-13 20:47:20+00
249396	{"pm10": 34, "pm25": 52, "pm100": 64, "timestamp": 1681418846}	2023-04-13 20:47:26+00
249396	{"pm10": 35, "pm25": 53, "pm100": 65, "timestamp": 1681418852}	2023-04-13 20:47:32+00
249396	{"pm10": 35, "pm25": 52, "pm100": 64, "timestamp": 1681418858}	2023-04-13 20:47:38+00
249396	{"pm10": 35, "pm25": 52, "pm100": 64, "timestamp": 1681418864}	2023-04-13 20:47:44+00
249396	{"pm10": 34, "pm25": 51, "pm100": 62, "timestamp": 1681418871}	2023-04-13 20:47:51+00
249396	{"pm10": 34, "pm25": 51, "pm100": 62, "timestamp": 1681418877}	2023-04-13 20:47:57+00
249396	{"pm10": 34, "pm25": 51, "pm100": 63, "timestamp": 1681418883}	2023-04-13 20:48:03+00
249396	{"pm10": 35, "pm25": 52, "pm100": 64, "timestamp": 1681418889}	2023-04-13 20:48:09+00
249396	{"pm10": 35, "pm25": 52, "pm100": 63, "timestamp": 1681418895}	2023-04-13 20:48:15+00
249396	{"pm10": 35, "pm25": 52, "pm100": 63, "timestamp": 1681418901}	2023-04-13 20:48:21+00
249396	{"pm10": 34, "pm25": 52, "pm100": 63, "timestamp": 1681418907}	2023-04-13 20:48:27+00
249396	{"pm10": 34, "pm25": 53, "pm100": 64, "timestamp": 1681418913}	2023-04-13 20:48:33+00
249396	{"pm10": 34, "pm25": 52, "pm100": 64, "timestamp": 1681418920}	2023-04-13 20:48:40+00
249396	{"pm10": 34, "pm25": 52, "pm100": 64, "timestamp": 1681418926}	2023-04-13 20:48:46+00
249396	{"pm10": 34, "pm25": 53, "pm100": 64, "timestamp": 1681418932}	2023-04-13 20:48:52+00
249396	{"pm10": 35, "pm25": 52, "pm100": 63, "timestamp": 1681418938}	2023-04-13 20:48:58+00
249396	{"pm10": 33, "pm25": 51, "pm100": 62, "timestamp": 1681418944}	2023-04-13 20:49:04+00
249396	{"pm10": 33, "pm25": 51, "pm100": 62, "timestamp": 1681418950}	2023-04-13 20:49:10+00
249396	{"pm10": 33, "pm25": 51, "pm100": 62, "timestamp": 1681418956}	2023-04-13 20:49:16+00
249396	{"pm10": 33, "pm25": 51, "pm100": 62, "timestamp": 1681418962}	2023-04-13 20:49:22+00
249396	{"pm10": 34, "pm25": 51, "pm100": 62, "timestamp": 1681418969}	2023-04-13 20:49:29+00
249396	{"pm10": 34, "pm25": 51, "pm100": 62, "timestamp": 1681418975}	2023-04-13 20:49:35+00
249396	{"pm10": 35, "pm25": 50, "pm100": 62, "timestamp": 1681418981}	2023-04-13 20:49:41+00
249396	{"pm10": 35, "pm25": 50, "pm100": 62, "timestamp": 1681418987}	2023-04-13 20:49:47+00
249396	{"pm10": 34, "pm25": 50, "pm100": 61, "timestamp": 1681418993}	2023-04-13 20:49:53+00
249396	{"pm10": 34, "pm25": 53, "pm100": 64, "timestamp": 1681418999}	2023-04-13 20:49:59+00
249396	{"pm10": 34, "pm25": 53, "pm100": 64, "timestamp": 1681419005}	2023-04-13 20:50:05+00
249396	{"pm10": 35, "pm25": 53, "pm100": 65, "timestamp": 1681419011}	2023-04-13 20:50:11+00
249396	{"pm10": 35, "pm25": 53, "pm100": 65, "timestamp": 1681419018}	2023-04-13 20:50:18+00
249396	{"pm10": 35, "pm25": 53, "pm100": 66, "timestamp": 1681419024}	2023-04-13 20:50:24+00
249396	{"pm10": 35, "pm25": 53, "pm100": 66, "timestamp": 1681419030}	2023-04-13 20:50:30+00
249396	{"pm10": 35, "pm25": 54, "pm100": 66, "timestamp": 1681419036}	2023-04-13 20:50:36+00
249396	{"pm10": 35, "pm25": 54, "pm100": 66, "timestamp": 1681419042}	2023-04-13 20:50:42+00
249396	{"pm10": 35, "pm25": 54, "pm100": 66, "timestamp": 1681419048}	2023-04-13 20:50:48+00
249396	{"pm10": 35, "pm25": 54, "pm100": 66, "timestamp": 1681419054}	2023-04-13 20:50:54+00
249396	{"pm10": 33, "pm25": 51, "pm100": 63, "timestamp": 1681419060}	2023-04-13 20:51:00+00
249396	{"pm10": 33, "pm25": 51, "pm100": 64, "timestamp": 1681419067}	2023-04-13 20:51:07+00
249396	{"pm10": 33, "pm25": 51, "pm100": 64, "timestamp": 1681419073}	2023-04-13 20:51:13+00
249396	{"pm10": 33, "pm25": 51, "pm100": 63, "timestamp": 1681419079}	2023-04-13 20:51:19+00
249396	{"pm10": 35, "pm25": 51, "pm100": 62, "timestamp": 1681419085}	2023-04-13 20:51:25+00
249396	{"pm10": 34, "pm25": 51, "pm100": 62, "timestamp": 1681419091}	2023-04-13 20:51:31+00
249396	{"pm10": 34, "pm25": 51, "pm100": 62, "timestamp": 1681419097}	2023-04-13 20:51:37+00
249396	{"pm10": 34, "pm25": 51, "pm100": 62, "timestamp": 1681419103}	2023-04-13 20:51:43+00
249396	{"pm10": 35, "pm25": 52, "pm100": 63, "timestamp": 1681419109}	2023-04-13 20:51:49+00
249396	{"pm10": 35, "pm25": 52, "pm100": 65, "timestamp": 1681419116}	2023-04-13 20:51:56+00
249396	{"pm10": 35, "pm25": 52, "pm100": 65, "timestamp": 1681419122}	2023-04-13 20:52:02+00
249396	{"pm10": 34, "pm25": 51, "pm100": 63, "timestamp": 1681419128}	2023-04-13 20:52:08+00
249396	{"pm10": 33, "pm25": 51, "pm100": 63, "timestamp": 1681419134}	2023-04-13 20:52:14+00
249396	{"pm10": 33, "pm25": 51, "pm100": 63, "timestamp": 1681419140}	2023-04-13 20:52:20+00
249396	{"pm10": 34, "pm25": 53, "pm100": 66, "timestamp": 1681419146}	2023-04-13 20:52:26+00
249396	{"pm10": 34, "pm25": 53, "pm100": 66, "timestamp": 1681419152}	2023-04-13 20:52:32+00
249396	{"pm10": 34, "pm25": 51, "pm100": 63, "timestamp": 1681419158}	2023-04-13 20:52:38+00
249396	{"pm10": 35, "pm25": 52, "pm100": 65, "timestamp": 1681419165}	2023-04-13 20:52:45+00
249396	{"pm10": 35, "pm25": 52, "pm100": 65, "timestamp": 1681419171}	2023-04-13 20:52:51+00
249396	{"pm10": 35, "pm25": 52, "pm100": 65, "timestamp": 1681419177}	2023-04-13 20:52:57+00
249396	{"pm10": 35, "pm25": 52, "pm100": 64, "timestamp": 1681419183}	2023-04-13 20:53:03+00
249396	{"pm10": 35, "pm25": 52, "pm100": 63, "timestamp": 1681419189}	2023-04-13 20:53:09+00
249396	{"pm10": 34, "pm25": 51, "pm100": 62, "timestamp": 1681419195}	2023-04-13 20:53:15+00
249396	{"pm10": 34, "pm25": 51, "pm100": 62, "timestamp": 1681419201}	2023-04-13 20:53:21+00
249396	{"pm10": 34, "pm25": 51, "pm100": 62, "timestamp": 1681419207}	2023-04-13 20:53:27+00
249396	{"pm10": 34, "pm25": 50, "pm100": 61, "timestamp": 1681419214}	2023-04-13 20:53:34+00
249396	{"pm10": 34, "pm25": 52, "pm100": 63, "timestamp": 1681419220}	2023-04-13 20:53:40+00
249396	{"pm10": 34, "pm25": 52, "pm100": 63, "timestamp": 1681419226}	2023-04-13 20:53:46+00
249396	{"pm10": 34, "pm25": 52, "pm100": 63, "timestamp": 1681419232}	2023-04-13 20:53:52+00
249396	{"pm10": 34, "pm25": 52, "pm100": 63, "timestamp": 1681419238}	2023-04-13 20:53:58+00
249396	{"pm10": 34, "pm25": 52, "pm100": 64, "timestamp": 1681419244}	2023-04-13 20:54:04+00
249396	{"pm10": 35, "pm25": 52, "pm100": 64, "timestamp": 1681419250}	2023-04-13 20:54:10+00
249396	{"pm10": 34, "pm25": 51, "pm100": 63, "timestamp": 1681419256}	2023-04-13 20:54:16+00
249396	{"pm10": 34, "pm25": 50, "pm100": 62, "timestamp": 1681419263}	2023-04-13 20:54:23+00
249396	{"pm10": 34, "pm25": 50, "pm100": 62, "timestamp": 1681419269}	2023-04-13 20:54:29+00
249396	{"pm10": 37, "pm25": 52, "pm100": 64, "timestamp": 1681419275}	2023-04-13 20:54:35+00
249396	{"pm10": 36, "pm25": 52, "pm100": 63, "timestamp": 1681419281}	2023-04-13 20:54:41+00
249396	{"pm10": 35, "pm25": 52, "pm100": 63, "timestamp": 1681419287}	2023-04-13 20:54:47+00
249396	{"pm10": 35, "pm25": 52, "pm100": 62, "timestamp": 1681419293}	2023-04-13 20:54:53+00
249396	{"pm10": 35, "pm25": 51, "pm100": 62, "timestamp": 1681419299}	2023-04-13 20:54:59+00
249396	{"pm10": 34, "pm25": 52, "pm100": 65, "timestamp": 1681419305}	2023-04-13 20:55:05+00
249396	{"pm10": 33, "pm25": 49, "pm100": 59, "timestamp": 1681419312}	2023-04-13 20:55:12+00
249396	{"pm10": 33, "pm25": 49, "pm100": 59, "timestamp": 1681419318}	2023-04-13 20:55:18+00
249396	{"pm10": 33, "pm25": 49, "pm100": 60, "timestamp": 1681419324}	2023-04-13 20:55:24+00
249396	{"pm10": 34, "pm25": 50, "pm100": 61, "timestamp": 1681419330}	2023-04-13 20:55:30+00
249396	{"pm10": 34, "pm25": 50, "pm100": 61, "timestamp": 1681419336}	2023-04-13 20:55:36+00
249396	{"pm10": 34, "pm25": 50, "pm100": 61, "timestamp": 1681419342}	2023-04-13 20:55:42+00
249396	{"pm10": 34, "pm25": 49, "pm100": 60, "timestamp": 1681419348}	2023-04-13 20:55:48+00
249396	{"pm10": 34, "pm25": 49, "pm100": 60, "timestamp": 1681419355}	2023-04-13 20:55:55+00
249396	{"pm10": 35, "pm25": 51, "pm100": 63, "timestamp": 1681419361}	2023-04-13 20:56:01+00
249396	{"pm10": 35, "pm25": 51, "pm100": 63, "timestamp": 1681419367}	2023-04-13 20:56:07+00
249396	{"pm10": 36, "pm25": 52, "pm100": 64, "timestamp": 1681419373}	2023-04-13 20:56:13+00
249396	{"pm10": 36, "pm25": 52, "pm100": 64, "timestamp": 1681419379}	2023-04-13 20:56:19+00
249396	{"pm10": 36, "pm25": 52, "pm100": 64, "timestamp": 1681419385}	2023-04-13 20:56:25+00
249396	{"pm10": 36, "pm25": 53, "pm100": 65, "timestamp": 1681419391}	2023-04-13 20:56:31+00
249396	{"pm10": 35, "pm25": 53, "pm100": 66, "timestamp": 1681419398}	2023-04-13 20:56:38+00
249396	{"pm10": 35, "pm25": 53, "pm100": 66, "timestamp": 1681419404}	2023-04-13 20:56:44+00
249396	{"pm10": 35, "pm25": 53, "pm100": 66, "timestamp": 1681419410}	2023-04-13 20:56:50+00
249396	{"pm10": 35, "pm25": 53, "pm100": 65, "timestamp": 1681419417}	2023-04-13 20:56:57+00
249396	{"pm10": 35, "pm25": 53, "pm100": 65, "timestamp": 1681419423}	2023-04-13 20:57:03+00
249396	{"pm10": 34, "pm25": 51, "pm100": 64, "timestamp": 1681419429}	2023-04-13 20:57:09+00
249396	{"pm10": 34, "pm25": 51, "pm100": 64, "timestamp": 1681419435}	2023-04-13 20:57:15+00
249396	{"pm10": 34, "pm25": 52, "pm100": 64, "timestamp": 1681419441}	2023-04-13 20:57:21+00
249396	{"pm10": 34, "pm25": 52, "pm100": 64, "timestamp": 1681419447}	2023-04-13 20:57:27+00
249396	{"pm10": 34, "pm25": 51, "pm100": 63, "timestamp": 1681419453}	2023-04-13 20:57:33+00
249396	{"pm10": 35, "pm25": 51, "pm100": 63, "timestamp": 1681419459}	2023-04-13 20:57:39+00
249396	{"pm10": 34, "pm25": 51, "pm100": 62, "timestamp": 1681419466}	2023-04-13 20:57:46+00
249396	{"pm10": 34, "pm25": 50, "pm100": 61, "timestamp": 1681419472}	2023-04-13 20:57:52+00
249396	{"pm10": 34, "pm25": 51, "pm100": 62, "timestamp": 1681419478}	2023-04-13 20:57:58+00
249396	{"pm10": 34, "pm25": 51, "pm100": 62, "timestamp": 1681419484}	2023-04-13 20:58:04+00
249396	{"pm10": 35, "pm25": 52, "pm100": 66, "timestamp": 1681419490}	2023-04-13 20:58:10+00
249396	{"pm10": 35, "pm25": 52, "pm100": 66, "timestamp": 1681419496}	2023-04-13 20:58:16+00
249396	{"pm10": 35, "pm25": 52, "pm100": 65, "timestamp": 1681419502}	2023-04-13 20:58:22+00
249396	{"pm10": 35, "pm25": 52, "pm100": 65, "timestamp": 1681419508}	2023-04-13 20:58:28+00
249396	{"pm10": 35, "pm25": 52, "pm100": 65, "timestamp": 1681419515}	2023-04-13 20:58:35+00
249396	{"pm10": 35, "pm25": 52, "pm100": 65, "timestamp": 1681419521}	2023-04-13 20:58:41+00
249396	{"pm10": 35, "pm25": 52, "pm100": 64, "timestamp": 1681419527}	2023-04-13 20:58:47+00
249396	{"pm10": 34, "pm25": 52, "pm100": 64, "timestamp": 1681419533}	2023-04-13 20:58:53+00
249396	{"pm10": 35, "pm25": 52, "pm100": 64, "timestamp": 1681419539}	2023-04-13 20:58:59+00
249396	{"pm10": 34, "pm25": 51, "pm100": 62, "timestamp": 1681419545}	2023-04-13 20:59:05+00
249396	{"pm10": 34, "pm25": 50, "pm100": 62, "timestamp": 1681419551}	2023-04-13 20:59:11+00
249396	{"pm10": 35, "pm25": 52, "pm100": 64, "timestamp": 1681419557}	2023-04-13 20:59:17+00
249396	{"pm10": 34, "pm25": 51, "pm100": 63, "timestamp": 1681419564}	2023-04-13 20:59:24+00
249396	{"pm10": 34, "pm25": 51, "pm100": 63, "timestamp": 1681419570}	2023-04-13 20:59:30+00
249396	{"pm10": 34, "pm25": 51, "pm100": 63, "timestamp": 1681419576}	2023-04-13 20:59:36+00
249396	{"pm10": 34, "pm25": 51, "pm100": 62, "timestamp": 1681419582}	2023-04-13 20:59:42+00
249396	{"pm10": 35, "pm25": 52, "pm100": 63, "timestamp": 1681419588}	2023-04-13 20:59:48+00
249396	{"pm10": 34, "pm25": 52, "pm100": 64, "timestamp": 1681419594}	2023-04-13 20:59:54+00
249396	{"pm10": 35, "pm25": 51, "pm100": 64, "timestamp": 1681419600}	2023-04-13 21:00:00+00
249396	{"pm10": 34, "pm25": 51, "pm100": 64, "timestamp": 1681419607}	2023-04-13 21:00:07+00
249396	{"pm10": 35, "pm25": 51, "pm100": 63, "timestamp": 1681419613}	2023-04-13 21:00:13+00
249396	{"pm10": 35, "pm25": 51, "pm100": 63, "timestamp": 1681419619}	2023-04-13 21:00:19+00
249396	{"pm10": 35, "pm25": 51, "pm100": 63, "timestamp": 1681419625}	2023-04-13 21:00:25+00
249396	{"pm10": 34, "pm25": 51, "pm100": 62, "timestamp": 1681419631}	2023-04-13 21:00:31+00
249396	{"pm10": 34, "pm25": 50, "pm100": 61, "timestamp": 1681419637}	2023-04-13 21:00:37+00
249396	{"pm10": 34, "pm25": 50, "pm100": 61, "timestamp": 1681419643}	2023-04-13 21:00:43+00
249396	{"pm10": 35, "pm25": 52, "pm100": 63, "timestamp": 1681419649}	2023-04-13 21:00:49+00
249396	{"pm10": 35, "pm25": 51, "pm100": 63, "timestamp": 1681419656}	2023-04-13 21:00:56+00
249396	{"pm10": 35, "pm25": 52, "pm100": 64, "timestamp": 1681419662}	2023-04-13 21:01:02+00
249396	{"pm10": 34, "pm25": 52, "pm100": 62, "timestamp": 1681419668}	2023-04-13 21:01:08+00
249396	{"pm10": 34, "pm25": 52, "pm100": 62, "timestamp": 1681419674}	2023-04-13 21:01:14+00
249396	{"pm10": 34, "pm25": 51, "pm100": 62, "timestamp": 1681419680}	2023-04-13 21:01:20+00
249396	{"pm10": 35, "pm25": 52, "pm100": 62, "timestamp": 1681419686}	2023-04-13 21:01:26+00
249396	{"pm10": 36, "pm25": 53, "pm100": 67, "timestamp": 1681419692}	2023-04-13 21:01:32+00
249396	{"pm10": 36, "pm25": 56, "pm100": 67, "timestamp": 1681419698}	2023-04-13 21:01:38+00
249396	{"pm10": 37, "pm25": 56, "pm100": 67, "timestamp": 1681419705}	2023-04-13 21:01:45+00
249396	{"pm10": 35, "pm25": 54, "pm100": 67, "timestamp": 1681419711}	2023-04-13 21:01:51+00
249396	{"pm10": 35, "pm25": 54, "pm100": 67, "timestamp": 1681419717}	2023-04-13 21:01:57+00
249396	{"pm10": 35, "pm25": 53, "pm100": 66, "timestamp": 1681419723}	2023-04-13 21:02:03+00
249396	{"pm10": 35, "pm25": 53, "pm100": 67, "timestamp": 1681419729}	2023-04-13 21:02:09+00
249396	{"pm10": 35, "pm25": 53, "pm100": 68, "timestamp": 1681419735}	2023-04-13 21:02:15+00
249396	{"pm10": 35, "pm25": 52, "pm100": 66, "timestamp": 1681419741}	2023-04-13 21:02:21+00
249396	{"pm10": 35, "pm25": 52, "pm100": 66, "timestamp": 1681419747}	2023-04-13 21:02:27+00
249396	{"pm10": 34, "pm25": 51, "pm100": 62, "timestamp": 1681419754}	2023-04-13 21:02:34+00
249396	{"pm10": 35, "pm25": 51, "pm100": 62, "timestamp": 1681419760}	2023-04-13 21:02:40+00
249396	{"pm10": 35, "pm25": 51, "pm100": 62, "timestamp": 1681419766}	2023-04-13 21:02:46+00
249396	{"pm10": 35, "pm25": 51, "pm100": 62, "timestamp": 1681419772}	2023-04-13 21:02:52+00
249396	{"pm10": 35, "pm25": 52, "pm100": 62, "timestamp": 1681419778}	2023-04-13 21:02:58+00
249396	{"pm10": 35, "pm25": 51, "pm100": 62, "timestamp": 1681419784}	2023-04-13 21:03:04+00
249396	{"pm10": 34, "pm25": 51, "pm100": 62, "timestamp": 1681419790}	2023-04-13 21:03:10+00
249396	{"pm10": 33, "pm25": 50, "pm100": 61, "timestamp": 1681419796}	2023-04-13 21:03:16+00
249396	{"pm10": 34, "pm25": 52, "pm100": 64, "timestamp": 1681419803}	2023-04-13 21:03:23+00
249396	{"pm10": 34, "pm25": 51, "pm100": 63, "timestamp": 1681419809}	2023-04-13 21:03:29+00
249396	{"pm10": 34, "pm25": 52, "pm100": 65, "timestamp": 1681419815}	2023-04-13 21:03:35+00
249396	{"pm10": 35, "pm25": 52, "pm100": 65, "timestamp": 1681419821}	2023-04-13 21:03:41+00
249396	{"pm10": 35, "pm25": 52, "pm100": 64, "timestamp": 1681419827}	2023-04-13 21:03:47+00
249396	{"pm10": 35, "pm25": 52, "pm100": 64, "timestamp": 1681419833}	2023-04-13 21:03:53+00
249396	{"pm10": 34, "pm25": 53, "pm100": 64, "timestamp": 1681419839}	2023-04-13 21:03:59+00
249396	{"pm10": 35, "pm25": 52, "pm100": 64, "timestamp": 1681419845}	2023-04-13 21:04:05+00
249396	{"pm10": 35, "pm25": 53, "pm100": 64, "timestamp": 1681419852}	2023-04-13 21:04:12+00
249396	{"pm10": 34, "pm25": 51, "pm100": 62, "timestamp": 1681419858}	2023-04-13 21:04:18+00
249396	{"pm10": 34, "pm25": 51, "pm100": 62, "timestamp": 1681419864}	2023-04-13 21:04:24+00
249396	{"pm10": 35, "pm25": 51, "pm100": 62, "timestamp": 1681419870}	2023-04-13 21:04:30+00
249396	{"pm10": 35, "pm25": 51, "pm100": 62, "timestamp": 1681419876}	2023-04-13 21:04:36+00
249396	{"pm10": 34, "pm25": 51, "pm100": 62, "timestamp": 1681419882}	2023-04-13 21:04:42+00
249396	{"pm10": 35, "pm25": 52, "pm100": 64, "timestamp": 1681419888}	2023-04-13 21:04:48+00
249396	{"pm10": 35, "pm25": 53, "pm100": 65, "timestamp": 1681419894}	2023-04-13 21:04:54+00
249396	{"pm10": 34, "pm25": 52, "pm100": 63, "timestamp": 1681419901}	2023-04-13 21:05:01+00
249396	{"pm10": 34, "pm25": 52, "pm100": 63, "timestamp": 1681419907}	2023-04-13 21:05:07+00
249396	{"pm10": 34, "pm25": 52, "pm100": 64, "timestamp": 1681419913}	2023-04-13 21:05:13+00
249396	{"pm10": 35, "pm25": 53, "pm100": 66, "timestamp": 1681419919}	2023-04-13 21:05:19+00
249396	{"pm10": 35, "pm25": 53, "pm100": 66, "timestamp": 1681419925}	2023-04-13 21:05:25+00
249396	{"pm10": 35, "pm25": 52, "pm100": 65, "timestamp": 1681419931}	2023-04-13 21:05:31+00
249396	{"pm10": 34, "pm25": 52, "pm100": 64, "timestamp": 1681419937}	2023-04-13 21:05:37+00
249396	{"pm10": 35, "pm25": 53, "pm100": 65, "timestamp": 1681419943}	2023-04-13 21:05:43+00
249396	{"pm10": 35, "pm25": 52, "pm100": 63, "timestamp": 1681419950}	2023-04-13 21:05:50+00
249396	{"pm10": 35, "pm25": 52, "pm100": 64, "timestamp": 1681419956}	2023-04-13 21:05:56+00
249396	{"pm10": 35, "pm25": 52, "pm100": 64, "timestamp": 1681419962}	2023-04-13 21:06:02+00
249396	{"pm10": 35, "pm25": 52, "pm100": 63, "timestamp": 1681419968}	2023-04-13 21:06:08+00
249396	{"pm10": 35, "pm25": 52, "pm100": 63, "timestamp": 1681419974}	2023-04-13 21:06:14+00
249396	{"pm10": 34, "pm25": 52, "pm100": 63, "timestamp": 1681419980}	2023-04-13 21:06:20+00
249396	{"pm10": 34, "pm25": 52, "pm100": 63, "timestamp": 1681419986}	2023-04-13 21:06:26+00
249396	{"pm10": 34, "pm25": 51, "pm100": 63, "timestamp": 1681419992}	2023-04-13 21:06:32+00
249396	{"pm10": 37, "pm25": 57, "pm100": 68, "timestamp": 1681419999}	2023-04-13 21:06:39+00
249396	{"pm10": 37, "pm25": 56, "pm100": 68, "timestamp": 1681420005}	2023-04-13 21:06:45+00
249396	{"pm10": 37, "pm25": 56, "pm100": 68, "timestamp": 1681420011}	2023-04-13 21:06:51+00
249396	{"pm10": 38, "pm25": 56, "pm100": 68, "timestamp": 1681420017}	2023-04-13 21:06:57+00
249396	{"pm10": 37, "pm25": 56, "pm100": 68, "timestamp": 1681420023}	2023-04-13 21:07:03+00
249396	{"pm10": 37, "pm25": 56, "pm100": 68, "timestamp": 1681420029}	2023-04-13 21:07:09+00
249396	{"pm10": 35, "pm25": 53, "pm100": 66, "timestamp": 1681420035}	2023-04-13 21:07:15+00
249396	{"pm10": 35, "pm25": 53, "pm100": 66, "timestamp": 1681420041}	2023-04-13 21:07:21+00
249396	{"pm10": 34, "pm25": 53, "pm100": 64, "timestamp": 1681420048}	2023-04-13 21:07:28+00
249396	{"pm10": 34, "pm25": 52, "pm100": 64, "timestamp": 1681420054}	2023-04-13 21:07:34+00
249396	{"pm10": 34, "pm25": 53, "pm100": 65, "timestamp": 1681420060}	2023-04-13 21:07:40+00
249396	{"pm10": 35, "pm25": 52, "pm100": 64, "timestamp": 1681420066}	2023-04-13 21:07:46+00
249396	{"pm10": 35, "pm25": 52, "pm100": 66, "timestamp": 1681420072}	2023-04-13 21:07:52+00
249396	{"pm10": 35, "pm25": 53, "pm100": 66, "timestamp": 1681420078}	2023-04-13 21:07:58+00
249396	{"pm10": 35, "pm25": 53, "pm100": 66, "timestamp": 1681420084}	2023-04-13 21:08:04+00
249396	{"pm10": 35, "pm25": 53, "pm100": 66, "timestamp": 1681420091}	2023-04-13 21:08:11+00
249396	{"pm10": 35, "pm25": 53, "pm100": 66, "timestamp": 1681420097}	2023-04-13 21:08:17+00
249396	{"pm10": 35, "pm25": 53, "pm100": 66, "timestamp": 1681420103}	2023-04-13 21:08:23+00
249396	{"pm10": 35, "pm25": 54, "pm100": 66, "timestamp": 1681420109}	2023-04-13 21:08:29+00
249396	{"pm10": 35, "pm25": 54, "pm100": 66, "timestamp": 1681420115}	2023-04-13 21:08:35+00
249396	{"pm10": 35, "pm25": 53, "pm100": 64, "timestamp": 1681420121}	2023-04-13 21:08:41+00
249396	{"pm10": 35, "pm25": 51, "pm100": 62, "timestamp": 1681420127}	2023-04-13 21:08:47+00
249396	{"pm10": 35, "pm25": 51, "pm100": 62, "timestamp": 1681420133}	2023-04-13 21:08:53+00
249396	{"pm10": 35, "pm25": 51, "pm100": 62, "timestamp": 1681420140}	2023-04-13 21:09:00+00
249396	{"pm10": 35, "pm25": 51, "pm100": 62, "timestamp": 1681420146}	2023-04-13 21:09:06+00
249396	{"pm10": 37, "pm25": 52, "pm100": 63, "timestamp": 1681420152}	2023-04-13 21:09:12+00
249396	{"pm10": 37, "pm25": 52, "pm100": 63, "timestamp": 1681420158}	2023-04-13 21:09:18+00
249396	{"pm10": 36, "pm25": 51, "pm100": 63, "timestamp": 1681420164}	2023-04-13 21:09:24+00
249396	{"pm10": 35, "pm25": 52, "pm100": 63, "timestamp": 1681420170}	2023-04-13 21:09:30+00
249396	{"pm10": 34, "pm25": 51, "pm100": 62, "timestamp": 1681420176}	2023-04-13 21:09:36+00
249396	{"pm10": 34, "pm25": 52, "pm100": 63, "timestamp": 1681420182}	2023-04-13 21:09:42+00
249396	{"pm10": 34, "pm25": 52, "pm100": 63, "timestamp": 1681420189}	2023-04-13 21:09:49+00
249396	{"pm10": 34, "pm25": 51, "pm100": 62, "timestamp": 1681420195}	2023-04-13 21:09:55+00
249396	{"pm10": 34, "pm25": 51, "pm100": 62, "timestamp": 1681420201}	2023-04-13 21:10:01+00
249396	{"pm10": 34, "pm25": 52, "pm100": 62, "timestamp": 1681420207}	2023-04-13 21:10:07+00
249396	{"pm10": 33, "pm25": 51, "pm100": 62, "timestamp": 1681420213}	2023-04-13 21:10:13+00
249396	{"pm10": 35, "pm25": 52, "pm100": 64, "timestamp": 1681420219}	2023-04-13 21:10:19+00
249396	{"pm10": 34, "pm25": 52, "pm100": 62, "timestamp": 1681420225}	2023-04-13 21:10:25+00
249396	{"pm10": 34, "pm25": 52, "pm100": 62, "timestamp": 1681420231}	2023-04-13 21:10:31+00
249396	{"pm10": 34, "pm25": 51, "pm100": 63, "timestamp": 1681420238}	2023-04-13 21:10:38+00
249396	{"pm10": 34, "pm25": 52, "pm100": 64, "timestamp": 1681420244}	2023-04-13 21:10:44+00
249396	{"pm10": 34, "pm25": 52, "pm100": 64, "timestamp": 1681420250}	2023-04-13 21:10:50+00
249396	{"pm10": 35, "pm25": 53, "pm100": 65, "timestamp": 1681420256}	2023-04-13 21:10:56+00
249396	{"pm10": 35, "pm25": 53, "pm100": 64, "timestamp": 1681420262}	2023-04-13 21:11:02+00
249396	{"pm10": 35, "pm25": 53, "pm100": 65, "timestamp": 1681420268}	2023-04-13 21:11:08+00
249396	{"pm10": 35, "pm25": 51, "pm100": 63, "timestamp": 1681420274}	2023-04-13 21:11:14+00
249396	{"pm10": 35, "pm25": 51, "pm100": 63, "timestamp": 1681420280}	2023-04-13 21:11:20+00
249396	{"pm10": 35, "pm25": 51, "pm100": 63, "timestamp": 1681420287}	2023-04-13 21:11:27+00
249396	{"pm10": 35, "pm25": 52, "pm100": 64, "timestamp": 1681420293}	2023-04-13 21:11:33+00
249396	{"pm10": 35, "pm25": 52, "pm100": 64, "timestamp": 1681420299}	2023-04-13 21:11:39+00
249396	{"pm10": 35, "pm25": 52, "pm100": 64, "timestamp": 1681420305}	2023-04-13 21:11:45+00
249396	{"pm10": 35, "pm25": 51, "pm100": 65, "timestamp": 1681420311}	2023-04-13 21:11:51+00
249396	{"pm10": 35, "pm25": 52, "pm100": 65, "timestamp": 1681420317}	2023-04-13 21:11:57+00
249396	{"pm10": 35, "pm25": 51, "pm100": 64, "timestamp": 1681420323}	2023-04-13 21:12:03+00
249396	{"pm10": 34, "pm25": 51, "pm100": 63, "timestamp": 1681420329}	2023-04-13 21:12:09+00
249396	{"pm10": 33, "pm25": 51, "pm100": 63, "timestamp": 1681420336}	2023-04-13 21:12:16+00
249396	{"pm10": 33, "pm25": 51, "pm100": 63, "timestamp": 1681420342}	2023-04-13 21:12:22+00
249396	{"pm10": 34, "pm25": 51, "pm100": 63, "timestamp": 1681420348}	2023-04-13 21:12:28+00
249396	{"pm10": 34, "pm25": 51, "pm100": 63, "timestamp": 1681420354}	2023-04-13 21:12:34+00
249396	{"pm10": 34, "pm25": 52, "pm100": 64, "timestamp": 1681420360}	2023-04-13 21:12:40+00
249396	{"pm10": 34, "pm25": 52, "pm100": 64, "timestamp": 1681420366}	2023-04-13 21:12:46+00
249396	{"pm10": 34, "pm25": 52, "pm100": 64, "timestamp": 1681420372}	2023-04-13 21:12:52+00
249396	{"pm10": 36, "pm25": 55, "pm100": 67, "timestamp": 1681420378}	2023-04-13 21:12:58+00
249396	{"pm10": 35, "pm25": 54, "pm100": 66, "timestamp": 1681420385}	2023-04-13 21:13:05+00
249396	{"pm10": 34, "pm25": 52, "pm100": 64, "timestamp": 1681420391}	2023-04-13 21:13:11+00
249396	{"pm10": 35, "pm25": 53, "pm100": 65, "timestamp": 1681420397}	2023-04-13 21:13:17+00
249396	{"pm10": 35, "pm25": 53, "pm100": 66, "timestamp": 1681420404}	2023-04-13 21:13:24+00
249396	{"pm10": 35, "pm25": 52, "pm100": 65, "timestamp": 1681420410}	2023-04-13 21:13:30+00
249396	{"pm10": 35, "pm25": 53, "pm100": 65, "timestamp": 1681420416}	2023-04-13 21:13:36+00
249396	{"pm10": 35, "pm25": 54, "pm100": 66, "timestamp": 1681420422}	2023-04-13 21:13:42+00
249396	{"pm10": 35, "pm25": 54, "pm100": 66, "timestamp": 1681420428}	2023-04-13 21:13:48+00
249396	{"pm10": 36, "pm25": 54, "pm100": 66, "timestamp": 1681420434}	2023-04-13 21:13:54+00
249396	{"pm10": 36, "pm25": 54, "pm100": 66, "timestamp": 1681420440}	2023-04-13 21:14:00+00
249396	{"pm10": 35, "pm25": 54, "pm100": 66, "timestamp": 1681420446}	2023-04-13 21:14:06+00
249396	{"pm10": 34, "pm25": 50, "pm100": 61, "timestamp": 1681420453}	2023-04-13 21:14:13+00
249396	{"pm10": 34, "pm25": 50, "pm100": 61, "timestamp": 1681420459}	2023-04-13 21:14:19+00
249396	{"pm10": 34, "pm25": 50, "pm100": 60, "timestamp": 1681420465}	2023-04-13 21:14:25+00
249396	{"pm10": 34, "pm25": 50, "pm100": 60, "timestamp": 1681420471}	2023-04-13 21:14:31+00
249396	{"pm10": 34, "pm25": 50, "pm100": 62, "timestamp": 1681420477}	2023-04-13 21:14:37+00
249396	{"pm10": 35, "pm25": 52, "pm100": 63, "timestamp": 1681420484}	2023-04-13 21:14:44+00
249396	{"pm10": 35, "pm25": 52, "pm100": 63, "timestamp": 1681420490}	2023-04-13 21:14:50+00
249396	{"pm10": 35, "pm25": 52, "pm100": 63, "timestamp": 1681420496}	2023-04-13 21:14:56+00
249396	{"pm10": 35, "pm25": 51, "pm100": 62, "timestamp": 1681420502}	2023-04-13 21:15:02+00
249396	{"pm10": 35, "pm25": 51, "pm100": 62, "timestamp": 1681420509}	2023-04-13 21:15:09+00
249396	{"pm10": 35, "pm25": 52, "pm100": 63, "timestamp": 1681420515}	2023-04-13 21:15:15+00
249396	{"pm10": 35, "pm25": 52, "pm100": 63, "timestamp": 1681420521}	2023-04-13 21:15:21+00
249396	{"pm10": 35, "pm25": 52, "pm100": 64, "timestamp": 1681420527}	2023-04-13 21:15:27+00
249396	{"pm10": 35, "pm25": 52, "pm100": 64, "timestamp": 1681420533}	2023-04-13 21:15:33+00
249396	{"pm10": 34, "pm25": 49, "pm100": 59, "timestamp": 1681420539}	2023-04-13 21:15:39+00
249396	{"pm10": 34, "pm25": 50, "pm100": 61, "timestamp": 1681420545}	2023-04-13 21:15:45+00
249396	{"pm10": 34, "pm25": 49, "pm100": 61, "timestamp": 1681420551}	2023-04-13 21:15:51+00
249396	{"pm10": 33, "pm25": 49, "pm100": 60, "timestamp": 1681420558}	2023-04-13 21:15:58+00
249396	{"pm10": 33, "pm25": 52, "pm100": 65, "timestamp": 1681420564}	2023-04-13 21:16:04+00
249396	{"pm10": 33, "pm25": 51, "pm100": 64, "timestamp": 1681420570}	2023-04-13 21:16:10+00
249396	{"pm10": 35, "pm25": 54, "pm100": 68, "timestamp": 1681420576}	2023-04-13 21:16:16+00
249396	{"pm10": 35, "pm25": 54, "pm100": 67, "timestamp": 1681420582}	2023-04-13 21:16:22+00
249396	{"pm10": 35, "pm25": 54, "pm100": 67, "timestamp": 1681420588}	2023-04-13 21:16:28+00
249396	{"pm10": 35, "pm25": 53, "pm100": 66, "timestamp": 1681420594}	2023-04-13 21:16:34+00
249396	{"pm10": 35, "pm25": 53, "pm100": 66, "timestamp": 1681420600}	2023-04-13 21:16:40+00
249396	{"pm10": 34, "pm25": 52, "pm100": 63, "timestamp": 1681420607}	2023-04-13 21:16:47+00
249396	{"pm10": 34, "pm25": 52, "pm100": 63, "timestamp": 1681420613}	2023-04-13 21:16:53+00
249396	{"pm10": 34, "pm25": 53, "pm100": 64, "timestamp": 1681420619}	2023-04-13 21:16:59+00
249396	{"pm10": 35, "pm25": 53, "pm100": 65, "timestamp": 1681420625}	2023-04-13 21:17:05+00
249396	{"pm10": 35, "pm25": 53, "pm100": 64, "timestamp": 1681420631}	2023-04-13 21:17:11+00
249396	{"pm10": 35, "pm25": 52, "pm100": 63, "timestamp": 1681420637}	2023-04-13 21:17:17+00
249396	{"pm10": 35, "pm25": 52, "pm100": 64, "timestamp": 1681420643}	2023-04-13 21:17:23+00
249396	{"pm10": 35, "pm25": 53, "pm100": 65, "timestamp": 1681420650}	2023-04-13 21:17:30+00
249396	{"pm10": 36, "pm25": 53, "pm100": 65, "timestamp": 1681420656}	2023-04-13 21:17:36+00
249396	{"pm10": 36, "pm25": 53, "pm100": 65, "timestamp": 1681420662}	2023-04-13 21:17:42+00
249396	{"pm10": 35, "pm25": 52, "pm100": 65, "timestamp": 1681420668}	2023-04-13 21:17:48+00
249396	{"pm10": 35, "pm25": 52, "pm100": 65, "timestamp": 1681420674}	2023-04-13 21:17:54+00
249396	{"pm10": 36, "pm25": 52, "pm100": 65, "timestamp": 1681420680}	2023-04-13 21:18:00+00
249396	{"pm10": 36, "pm25": 52, "pm100": 64, "timestamp": 1681420686}	2023-04-13 21:18:06+00
249396	{"pm10": 37, "pm25": 52, "pm100": 64, "timestamp": 1681420692}	2023-04-13 21:18:12+00
249396	{"pm10": 37, "pm25": 52, "pm100": 64, "timestamp": 1681420699}	2023-04-13 21:18:19+00
249396	{"pm10": 36, "pm25": 52, "pm100": 63, "timestamp": 1681420705}	2023-04-13 21:18:25+00
249396	{"pm10": 36, "pm25": 52, "pm100": 63, "timestamp": 1681420711}	2023-04-13 21:18:31+00
249396	{"pm10": 37, "pm25": 52, "pm100": 64, "timestamp": 1681420717}	2023-04-13 21:18:37+00
249396	{"pm10": 36, "pm25": 52, "pm100": 64, "timestamp": 1681420723}	2023-04-13 21:18:43+00
249396	{"pm10": 35, "pm25": 53, "pm100": 65, "timestamp": 1681420729}	2023-04-13 21:18:49+00
249396	{"pm10": 35, "pm25": 52, "pm100": 65, "timestamp": 1681420735}	2023-04-13 21:18:55+00
249396	{"pm10": 35, "pm25": 52, "pm100": 65, "timestamp": 1681420741}	2023-04-13 21:19:01+00
249396	{"pm10": 35, "pm25": 51, "pm100": 63, "timestamp": 1681420748}	2023-04-13 21:19:08+00
249396	{"pm10": 36, "pm25": 53, "pm100": 65, "timestamp": 1681420754}	2023-04-13 21:19:14+00
249396	{"pm10": 36, "pm25": 53, "pm100": 65, "timestamp": 1681420760}	2023-04-13 21:19:20+00
249396	{"pm10": 36, "pm25": 53, "pm100": 64, "timestamp": 1681420766}	2023-04-13 21:19:26+00
249396	{"pm10": 36, "pm25": 53, "pm100": 64, "timestamp": 1681420772}	2023-04-13 21:19:32+00
249396	{"pm10": 34, "pm25": 51, "pm100": 62, "timestamp": 1681420778}	2023-04-13 21:19:38+00
249396	{"pm10": 36, "pm25": 53, "pm100": 64, "timestamp": 1681420784}	2023-04-13 21:19:44+00
249396	{"pm10": 35, "pm25": 53, "pm100": 65, "timestamp": 1681420790}	2023-04-13 21:19:50+00
249396	{"pm10": 35, "pm25": 53, "pm100": 65, "timestamp": 1681420797}	2023-04-13 21:19:57+00
249396	{"pm10": 36, "pm25": 53, "pm100": 65, "timestamp": 1681420803}	2023-04-13 21:20:03+00
249396	{"pm10": 36, "pm25": 53, "pm100": 65, "timestamp": 1681420809}	2023-04-13 21:20:09+00
249396	{"pm10": 37, "pm25": 53, "pm100": 64, "timestamp": 1681420815}	2023-04-13 21:20:15+00
249396	{"pm10": 34, "pm25": 52, "pm100": 63, "timestamp": 1681420821}	2023-04-13 21:20:21+00
249396	{"pm10": 34, "pm25": 52, "pm100": 63, "timestamp": 1681420827}	2023-04-13 21:20:27+00
249396	{"pm10": 35, "pm25": 52, "pm100": 64, "timestamp": 1681420833}	2023-04-13 21:20:33+00
249396	{"pm10": 35, "pm25": 52, "pm100": 64, "timestamp": 1681420839}	2023-04-13 21:20:39+00
249396	{"pm10": 36, "pm25": 53, "pm100": 66, "timestamp": 1681420846}	2023-04-13 21:20:46+00
249396	{"pm10": 36, "pm25": 53, "pm100": 66, "timestamp": 1681420852}	2023-04-13 21:20:52+00
249396	{"pm10": 35, "pm25": 51, "pm100": 63, "timestamp": 1681420858}	2023-04-13 21:20:58+00
249396	{"pm10": 35, "pm25": 52, "pm100": 63, "timestamp": 1681420864}	2023-04-13 21:21:04+00
249396	{"pm10": 35, "pm25": 51, "pm100": 63, "timestamp": 1681420870}	2023-04-13 21:21:10+00
249396	{"pm10": 34, "pm25": 51, "pm100": 62, "timestamp": 1681420876}	2023-04-13 21:21:16+00
249396	{"pm10": 35, "pm25": 51, "pm100": 63, "timestamp": 1681420882}	2023-04-13 21:21:22+00
249396	{"pm10": 35, "pm25": 52, "pm100": 64, "timestamp": 1681420888}	2023-04-13 21:21:28+00
249396	{"pm10": 35, "pm25": 52, "pm100": 64, "timestamp": 1681420895}	2023-04-13 21:21:35+00
249396	{"pm10": 35, "pm25": 52, "pm100": 64, "timestamp": 1681420901}	2023-04-13 21:21:41+00
249396	{"pm10": 35, "pm25": 53, "pm100": 65, "timestamp": 1681420907}	2023-04-13 21:21:47+00
249396	{"pm10": 33, "pm25": 52, "pm100": 63, "timestamp": 1681420913}	2023-04-13 21:21:53+00
249396	{"pm10": 33, "pm25": 52, "pm100": 63, "timestamp": 1681420919}	2023-04-13 21:21:59+00
249396	{"pm10": 34, "pm25": 51, "pm100": 63, "timestamp": 1681420925}	2023-04-13 21:22:05+00
249396	{"pm10": 34, "pm25": 51, "pm100": 63, "timestamp": 1681420931}	2023-04-13 21:22:11+00
249396	{"pm10": 33, "pm25": 51, "pm100": 63, "timestamp": 1681420937}	2023-04-13 21:22:17+00
249396	{"pm10": 33, "pm25": 51, "pm100": 63, "timestamp": 1681420944}	2023-04-13 21:22:24+00
249396	{"pm10": 33, "pm25": 51, "pm100": 63, "timestamp": 1681420950}	2023-04-13 21:22:30+00
249396	{"pm10": 35, "pm25": 53, "pm100": 65, "timestamp": 1681420956}	2023-04-13 21:22:36+00
249396	{"pm10": 35, "pm25": 52, "pm100": 65, "timestamp": 1681420962}	2023-04-13 21:22:42+00
249396	{"pm10": 35, "pm25": 52, "pm100": 64, "timestamp": 1681420968}	2023-04-13 21:22:48+00
249396	{"pm10": 35, "pm25": 51, "pm100": 62, "timestamp": 1681420974}	2023-04-13 21:22:54+00
249396	{"pm10": 35, "pm25": 52, "pm100": 64, "timestamp": 1681420980}	2023-04-13 21:23:00+00
249396	{"pm10": 35, "pm25": 51, "pm100": 61, "timestamp": 1681420986}	2023-04-13 21:23:06+00
249396	{"pm10": 34, "pm25": 50, "pm100": 61, "timestamp": 1681420993}	2023-04-13 21:23:13+00
249396	{"pm10": 35, "pm25": 51, "pm100": 62, "timestamp": 1681420999}	2023-04-13 21:23:19+00
249396	{"pm10": 35, "pm25": 51, "pm100": 62, "timestamp": 1681421005}	2023-04-13 21:23:25+00
249396	{"pm10": 35, "pm25": 52, "pm100": 65, "timestamp": 1681421011}	2023-04-13 21:23:31+00
249396	{"pm10": 33, "pm25": 51, "pm100": 64, "timestamp": 1681421017}	2023-04-13 21:23:37+00
249396	{"pm10": 33, "pm25": 52, "pm100": 64, "timestamp": 1681421023}	2023-04-13 21:23:43+00
249396	{"pm10": 33, "pm25": 51, "pm100": 62, "timestamp": 1681421029}	2023-04-13 21:23:49+00
249396	{"pm10": 33, "pm25": 52, "pm100": 64, "timestamp": 1681421035}	2023-04-13 21:23:55+00
249396	{"pm10": 34, "pm25": 52, "pm100": 64, "timestamp": 1681421042}	2023-04-13 21:24:02+00
249396	{"pm10": 33, "pm25": 51, "pm100": 63, "timestamp": 1681421048}	2023-04-13 21:24:08+00
249396	{"pm10": 33, "pm25": 51, "pm100": 63, "timestamp": 1681421054}	2023-04-13 21:24:14+00
249396	{"pm10": 33, "pm25": 51, "pm100": 63, "timestamp": 1681421060}	2023-04-13 21:24:20+00
249396	{"pm10": 35, "pm25": 52, "pm100": 63, "timestamp": 1681421066}	2023-04-13 21:24:26+00
249396	{"pm10": 35, "pm25": 52, "pm100": 63, "timestamp": 1681421072}	2023-04-13 21:24:32+00
249396	{"pm10": 35, "pm25": 52, "pm100": 64, "timestamp": 1681421078}	2023-04-13 21:24:38+00
249396	{"pm10": 35, "pm25": 52, "pm100": 64, "timestamp": 1681421084}	2023-04-13 21:24:44+00
249396	{"pm10": 35, "pm25": 52, "pm100": 64, "timestamp": 1681421091}	2023-04-13 21:24:51+00
249396	{"pm10": 33, "pm25": 50, "pm100": 61, "timestamp": 1681421097}	2023-04-13 21:24:57+00
249396	{"pm10": 33, "pm25": 49, "pm100": 61, "timestamp": 1681421103}	2023-04-13 21:25:03+00
249396	{"pm10": 33, "pm25": 49, "pm100": 61, "timestamp": 1681421109}	2023-04-13 21:25:09+00
249396	{"pm10": 33, "pm25": 50, "pm100": 62, "timestamp": 1681421115}	2023-04-13 21:25:15+00
249396	{"pm10": 33, "pm25": 50, "pm100": 62, "timestamp": 1681421122}	2023-04-13 21:25:22+00
249396	{"pm10": 33, "pm25": 50, "pm100": 63, "timestamp": 1681421128}	2023-04-13 21:25:28+00
249396	{"pm10": 33, "pm25": 51, "pm100": 63, "timestamp": 1681421134}	2023-04-13 21:25:34+00
249396	{"pm10": 33, "pm25": 51, "pm100": 63, "timestamp": 1681421140}	2023-04-13 21:25:40+00
249396	{"pm10": 34, "pm25": 51, "pm100": 64, "timestamp": 1681421146}	2023-04-13 21:25:46+00
249396	{"pm10": 34, "pm25": 49, "pm100": 62, "timestamp": 1681421152}	2023-04-13 21:25:52+00
249396	{"pm10": 33, "pm25": 49, "pm100": 61, "timestamp": 1681421158}	2023-04-13 21:25:58+00
249396	{"pm10": 35, "pm25": 51, "pm100": 63, "timestamp": 1681421164}	2023-04-13 21:26:04+00
249396	{"pm10": 34, "pm25": 51, "pm100": 63, "timestamp": 1681421171}	2023-04-13 21:26:11+00
249396	{"pm10": 34, "pm25": 51, "pm100": 63, "timestamp": 1681421177}	2023-04-13 21:26:17+00
249396	{"pm10": 34, "pm25": 51, "pm100": 62, "timestamp": 1681421183}	2023-04-13 21:26:23+00
249396	{"pm10": 35, "pm25": 53, "pm100": 65, "timestamp": 1681421189}	2023-04-13 21:26:29+00
249396	{"pm10": 35, "pm25": 54, "pm100": 66, "timestamp": 1681421195}	2023-04-13 21:26:35+00
249396	{"pm10": 34, "pm25": 54, "pm100": 65, "timestamp": 1681421201}	2023-04-13 21:26:41+00
249396	{"pm10": 33, "pm25": 52, "pm100": 64, "timestamp": 1681421207}	2023-04-13 21:26:47+00
249396	{"pm10": 33, "pm25": 51, "pm100": 63, "timestamp": 1681421213}	2023-04-13 21:26:53+00
249396	{"pm10": 33, "pm25": 52, "pm100": 65, "timestamp": 1681421220}	2023-04-13 21:27:00+00
249396	{"pm10": 34, "pm25": 52, "pm100": 65, "timestamp": 1681421226}	2023-04-13 21:27:06+00
249396	{"pm10": 34, "pm25": 53, "pm100": 66, "timestamp": 1681421232}	2023-04-13 21:27:12+00
249396	{"pm10": 34, "pm25": 52, "pm100": 65, "timestamp": 1681421238}	2023-04-13 21:27:18+00
249396	{"pm10": 35, "pm25": 53, "pm100": 65, "timestamp": 1681421244}	2023-04-13 21:27:24+00
249396	{"pm10": 35, "pm25": 53, "pm100": 65, "timestamp": 1681421250}	2023-04-13 21:27:30+00
249396	{"pm10": 36, "pm25": 53, "pm100": 66, "timestamp": 1681421256}	2023-04-13 21:27:36+00
249396	{"pm10": 36, "pm25": 53, "pm100": 66, "timestamp": 1681421262}	2023-04-13 21:27:42+00
249396	{"pm10": 36, "pm25": 51, "pm100": 65, "timestamp": 1681421269}	2023-04-13 21:27:49+00
249396	{"pm10": 37, "pm25": 52, "pm100": 66, "timestamp": 1681421275}	2023-04-13 21:27:55+00
249396	{"pm10": 35, "pm25": 51, "pm100": 62, "timestamp": 1681421281}	2023-04-13 21:28:01+00
249396	{"pm10": 35, "pm25": 51, "pm100": 62, "timestamp": 1681421287}	2023-04-13 21:28:07+00
249396	{"pm10": 35, "pm25": 52, "pm100": 63, "timestamp": 1681421293}	2023-04-13 21:28:13+00
249396	{"pm10": 34, "pm25": 51, "pm100": 62, "timestamp": 1681421299}	2023-04-13 21:28:19+00
249396	{"pm10": 34, "pm25": 51, "pm100": 63, "timestamp": 1681421305}	2023-04-13 21:28:25+00
249396	{"pm10": 33, "pm25": 50, "pm100": 61, "timestamp": 1681421311}	2023-04-13 21:28:31+00
249396	{"pm10": 34, "pm25": 50, "pm100": 61, "timestamp": 1681421318}	2023-04-13 21:28:38+00
249396	{"pm10": 33, "pm25": 50, "pm100": 60, "timestamp": 1681421324}	2023-04-13 21:28:44+00
249396	{"pm10": 33, "pm25": 50, "pm100": 61, "timestamp": 1681421330}	2023-04-13 21:28:50+00
249396	{"pm10": 34, "pm25": 51, "pm100": 62, "timestamp": 1681421337}	2023-04-13 21:28:57+00
249396	{"pm10": 34, "pm25": 51, "pm100": 62, "timestamp": 1681421343}	2023-04-13 21:29:03+00
249396	{"pm10": 34, "pm25": 51, "pm100": 62, "timestamp": 1681421349}	2023-04-13 21:29:09+00
249396	{"pm10": 34, "pm25": 51, "pm100": 62, "timestamp": 1681421355}	2023-04-13 21:29:15+00
249396	{"pm10": 34, "pm25": 51, "pm100": 62, "timestamp": 1681421361}	2023-04-13 21:29:21+00
249396	{"pm10": 34, "pm25": 51, "pm100": 62, "timestamp": 1681421367}	2023-04-13 21:29:27+00
249396	{"pm10": 34, "pm25": 51, "pm100": 62, "timestamp": 1681421374}	2023-04-13 21:29:34+00
249396	{"pm10": 34, "pm25": 51, "pm100": 62, "timestamp": 1681421380}	2023-04-13 21:29:40+00
249396	{"pm10": 34, "pm25": 51, "pm100": 62, "timestamp": 1681421386}	2023-04-13 21:29:46+00
249396	{"pm10": 33, "pm25": 51, "pm100": 62, "timestamp": 1681421392}	2023-04-13 21:29:52+00
249396	{"pm10": 33, "pm25": 51, "pm100": 63, "timestamp": 1681421398}	2023-04-13 21:29:58+00
249396	{"pm10": 33, "pm25": 51, "pm100": 63, "timestamp": 1681421404}	2023-04-13 21:30:04+00
249396	{"pm10": 33, "pm25": 51, "pm100": 62, "timestamp": 1681421410}	2023-04-13 21:30:10+00
249396	{"pm10": 34, "pm25": 51, "pm100": 62, "timestamp": 1681421416}	2023-04-13 21:30:16+00
249396	{"pm10": 34, "pm25": 51, "pm100": 62, "timestamp": 1681421423}	2023-04-13 21:30:23+00
249396	{"pm10": 33, "pm25": 49, "pm100": 60, "timestamp": 1681421429}	2023-04-13 21:30:29+00
249396	{"pm10": 34, "pm25": 50, "pm100": 61, "timestamp": 1681421435}	2023-04-13 21:30:35+00
249396	{"pm10": 34, "pm25": 51, "pm100": 62, "timestamp": 1681421441}	2023-04-13 21:30:41+00
249396	{"pm10": 35, "pm25": 53, "pm100": 66, "timestamp": 1681421447}	2023-04-13 21:30:47+00
249396	{"pm10": 34, "pm25": 52, "pm100": 65, "timestamp": 1681421453}	2023-04-13 21:30:53+00
249396	{"pm10": 35, "pm25": 52, "pm100": 64, "timestamp": 1681421459}	2023-04-13 21:30:59+00
249396	{"pm10": 35, "pm25": 52, "pm100": 64, "timestamp": 1681421465}	2023-04-13 21:31:05+00
249396	{"pm10": 34, "pm25": 51, "pm100": 62, "timestamp": 1681421472}	2023-04-13 21:31:12+00
249396	{"pm10": 34, "pm25": 51, "pm100": 62, "timestamp": 1681421478}	2023-04-13 21:31:18+00
249396	{"pm10": 34, "pm25": 51, "pm100": 62, "timestamp": 1681421484}	2023-04-13 21:31:24+00
249396	{"pm10": 35, "pm25": 53, "pm100": 64, "timestamp": 1681421490}	2023-04-13 21:31:30+00
249396	{"pm10": 35, "pm25": 53, "pm100": 64, "timestamp": 1681421496}	2023-04-13 21:31:36+00
249396	{"pm10": 35, "pm25": 50, "pm100": 62, "timestamp": 1681421502}	2023-04-13 21:31:42+00
249396	{"pm10": 35, "pm25": 50, "pm100": 63, "timestamp": 1681421508}	2023-04-13 21:31:48+00
249396	{"pm10": 35, "pm25": 51, "pm100": 63, "timestamp": 1681421514}	2023-04-13 21:31:54+00
249396	{"pm10": 34, "pm25": 50, "pm100": 62, "timestamp": 1681421521}	2023-04-13 21:32:01+00
249396	{"pm10": 34, "pm25": 50, "pm100": 62, "timestamp": 1681421527}	2023-04-13 21:32:07+00
249396	{"pm10": 34, "pm25": 50, "pm100": 62, "timestamp": 1681421533}	2023-04-13 21:32:13+00
249396	{"pm10": 35, "pm25": 51, "pm100": 63, "timestamp": 1681421539}	2023-04-13 21:32:19+00
249396	{"pm10": 35, "pm25": 51, "pm100": 64, "timestamp": 1681421545}	2023-04-13 21:32:25+00
249396	{"pm10": 35, "pm25": 52, "pm100": 64, "timestamp": 1681421551}	2023-04-13 21:32:31+00
249396	{"pm10": 35, "pm25": 52, "pm100": 64, "timestamp": 1681421557}	2023-04-13 21:32:37+00
249396	{"pm10": 35, "pm25": 53, "pm100": 66, "timestamp": 1681421563}	2023-04-13 21:32:43+00
249396	{"pm10": 36, "pm25": 54, "pm100": 67, "timestamp": 1681421570}	2023-04-13 21:32:50+00
249396	{"pm10": 36, "pm25": 54, "pm100": 67, "timestamp": 1681421576}	2023-04-13 21:32:56+00
249396	{"pm10": 37, "pm25": 55, "pm100": 67, "timestamp": 1681421582}	2023-04-13 21:33:02+00
249396	{"pm10": 37, "pm25": 55, "pm100": 67, "timestamp": 1681421588}	2023-04-13 21:33:08+00
249396	{"pm10": 37, "pm25": 55, "pm100": 67, "timestamp": 1681421594}	2023-04-13 21:33:14+00
249396	{"pm10": 37, "pm25": 55, "pm100": 67, "timestamp": 1681421600}	2023-04-13 21:33:20+00
249396	{"pm10": 34, "pm25": 51, "pm100": 64, "timestamp": 1681421606}	2023-04-13 21:33:26+00
249396	{"pm10": 34, "pm25": 51, "pm100": 63, "timestamp": 1681421612}	2023-04-13 21:33:32+00
249396	{"pm10": 33, "pm25": 51, "pm100": 64, "timestamp": 1681421619}	2023-04-13 21:33:39+00
249396	{"pm10": 34, "pm25": 52, "pm100": 65, "timestamp": 1681421625}	2023-04-13 21:33:45+00
249396	{"pm10": 34, "pm25": 52, "pm100": 66, "timestamp": 1681421631}	2023-04-13 21:33:51+00
249396	{"pm10": 35, "pm25": 52, "pm100": 66, "timestamp": 1681421637}	2023-04-13 21:33:57+00
249396	{"pm10": 35, "pm25": 52, "pm100": 65, "timestamp": 1681421643}	2023-04-13 21:34:03+00
249396	{"pm10": 35, "pm25": 52, "pm100": 63, "timestamp": 1681421649}	2023-04-13 21:34:09+00
249396	{"pm10": 36, "pm25": 52, "pm100": 63, "timestamp": 1681421655}	2023-04-13 21:34:15+00
249396	{"pm10": 36, "pm25": 52, "pm100": 63, "timestamp": 1681421661}	2023-04-13 21:34:21+00
249396	{"pm10": 36, "pm25": 52, "pm100": 64, "timestamp": 1681421668}	2023-04-13 21:34:28+00
249396	{"pm10": 36, "pm25": 52, "pm100": 64, "timestamp": 1681421674}	2023-04-13 21:34:34+00
249396	{"pm10": 36, "pm25": 52, "pm100": 64, "timestamp": 1681421680}	2023-04-13 21:34:40+00
249396	{"pm10": 36, "pm25": 52, "pm100": 64, "timestamp": 1681421686}	2023-04-13 21:34:46+00
249396	{"pm10": 36, "pm25": 52, "pm100": 64, "timestamp": 1681421692}	2023-04-13 21:34:52+00
249396	{"pm10": 36, "pm25": 52, "pm100": 65, "timestamp": 1681421698}	2023-04-13 21:34:58+00
249396	{"pm10": 36, "pm25": 53, "pm100": 65, "timestamp": 1681421704}	2023-04-13 21:35:04+00
249396	{"pm10": 35, "pm25": 52, "pm100": 64, "timestamp": 1681421711}	2023-04-13 21:35:11+00
249396	{"pm10": 36, "pm25": 52, "pm100": 64, "timestamp": 1681421717}	2023-04-13 21:35:17+00
249396	{"pm10": 37, "pm25": 53, "pm100": 64, "timestamp": 1681421723}	2023-04-13 21:35:23+00
249396	{"pm10": 36, "pm25": 52, "pm100": 63, "timestamp": 1681421729}	2023-04-13 21:35:29+00
249396	{"pm10": 35, "pm25": 52, "pm100": 65, "timestamp": 1681421735}	2023-04-13 21:35:35+00
249396	{"pm10": 35, "pm25": 52, "pm100": 66, "timestamp": 1681421741}	2023-04-13 21:35:41+00
249396	{"pm10": 35, "pm25": 52, "pm100": 66, "timestamp": 1681421747}	2023-04-13 21:35:47+00
249396	{"pm10": 35, "pm25": 53, "pm100": 65, "timestamp": 1681421753}	2023-04-13 21:35:53+00
249396	{"pm10": 36, "pm25": 53, "pm100": 65, "timestamp": 1681421760}	2023-04-13 21:36:00+00
249396	{"pm10": 35, "pm25": 51, "pm100": 62, "timestamp": 1681421767}	2023-04-13 21:36:07+00
249396	{"pm10": 35, "pm25": 51, "pm100": 62, "timestamp": 1681421773}	2023-04-13 21:36:13+00
249396	{"pm10": 36, "pm25": 51, "pm100": 62, "timestamp": 1681421779}	2023-04-13 21:36:19+00
249396	{"pm10": 36, "pm25": 51, "pm100": 62, "timestamp": 1681421785}	2023-04-13 21:36:25+00
249396	{"pm10": 36, "pm25": 52, "pm100": 63, "timestamp": 1681421791}	2023-04-13 21:36:31+00
249396	{"pm10": 36, "pm25": 52, "pm100": 63, "timestamp": 1681421797}	2023-04-13 21:36:37+00
249396	{"pm10": 35, "pm25": 52, "pm100": 63, "timestamp": 1681421803}	2023-04-13 21:36:43+00
249396	{"pm10": 35, "pm25": 52, "pm100": 63, "timestamp": 1681421809}	2023-04-13 21:36:49+00
249396	{"pm10": 35, "pm25": 51, "pm100": 62, "timestamp": 1681421816}	2023-04-13 21:36:56+00
249396	{"pm10": 34, "pm25": 53, "pm100": 65, "timestamp": 1681421822}	2023-04-13 21:37:02+00
249396	{"pm10": 34, "pm25": 53, "pm100": 65, "timestamp": 1681421828}	2023-04-13 21:37:08+00
249396	{"pm10": 34, "pm25": 52, "pm100": 65, "timestamp": 1681421834}	2023-04-13 21:37:14+00
249396	{"pm10": 34, "pm25": 52, "pm100": 65, "timestamp": 1681421840}	2023-04-13 21:37:20+00
249396	{"pm10": 35, "pm25": 52, "pm100": 63, "timestamp": 1681421846}	2023-04-13 21:37:26+00
249396	{"pm10": 35, "pm25": 52, "pm100": 63, "timestamp": 1681421852}	2023-04-13 21:37:32+00
249396	{"pm10": 35, "pm25": 52, "pm100": 63, "timestamp": 1681421858}	2023-04-13 21:37:38+00
249396	{"pm10": 35, "pm25": 52, "pm100": 63, "timestamp": 1681421865}	2023-04-13 21:37:45+00
249396	{"pm10": 35, "pm25": 51, "pm100": 63, "timestamp": 1681421871}	2023-04-13 21:37:51+00
249396	{"pm10": 34, "pm25": 52, "pm100": 63, "timestamp": 1681421877}	2023-04-13 21:37:57+00
249396	{"pm10": 35, "pm25": 51, "pm100": 62, "timestamp": 1681421883}	2023-04-13 21:38:03+00
249396	{"pm10": 35, "pm25": 51, "pm100": 62, "timestamp": 1681421889}	2023-04-13 21:38:09+00
249396	{"pm10": 34, "pm25": 51, "pm100": 62, "timestamp": 1681421895}	2023-04-13 21:38:15+00
249396	{"pm10": 34, "pm25": 51, "pm100": 62, "timestamp": 1681421901}	2023-04-13 21:38:21+00
249396	{"pm10": 35, "pm25": 52, "pm100": 64, "timestamp": 1681421907}	2023-04-13 21:38:27+00
249396	{"pm10": 35, "pm25": 52, "pm100": 64, "timestamp": 1681421914}	2023-04-13 21:38:34+00
249396	{"pm10": 34, "pm25": 51, "pm100": 63, "timestamp": 1681421920}	2023-04-13 21:38:40+00
249396	{"pm10": 34, "pm25": 51, "pm100": 63, "timestamp": 1681421926}	2023-04-13 21:38:46+00
249396	{"pm10": 34, "pm25": 51, "pm100": 63, "timestamp": 1681421932}	2023-04-13 21:38:52+00
249396	{"pm10": 34, "pm25": 51, "pm100": 63, "timestamp": 1681421938}	2023-04-13 21:38:58+00
249396	{"pm10": 34, "pm25": 51, "pm100": 63, "timestamp": 1681421944}	2023-04-13 21:39:04+00
249396	{"pm10": 36, "pm25": 51, "pm100": 63, "timestamp": 1681421950}	2023-04-13 21:39:10+00
249396	{"pm10": 36, "pm25": 51, "pm100": 63, "timestamp": 1681421956}	2023-04-13 21:39:16+00
249396	{"pm10": 35, "pm25": 53, "pm100": 67, "timestamp": 1681421963}	2023-04-13 21:39:23+00
249396	{"pm10": 35, "pm25": 52, "pm100": 65, "timestamp": 1681421969}	2023-04-13 21:39:29+00
249396	{"pm10": 35, "pm25": 52, "pm100": 65, "timestamp": 1681421975}	2023-04-13 21:39:35+00
249396	{"pm10": 35, "pm25": 52, "pm100": 65, "timestamp": 1681421981}	2023-04-13 21:39:41+00
249396	{"pm10": 34, "pm25": 51, "pm100": 64, "timestamp": 1681421987}	2023-04-13 21:39:47+00
249396	{"pm10": 34, "pm25": 52, "pm100": 64, "timestamp": 1681421993}	2023-04-13 21:39:53+00
249396	{"pm10": 34, "pm25": 51, "pm100": 63, "timestamp": 1681421999}	2023-04-13 21:39:59+00
249396	{"pm10": 34, "pm25": 51, "pm100": 62, "timestamp": 1681422005}	2023-04-13 21:40:05+00
249396	{"pm10": 34, "pm25": 51, "pm100": 62, "timestamp": 1681422012}	2023-04-13 21:40:12+00
249396	{"pm10": 36, "pm25": 54, "pm100": 66, "timestamp": 1681422018}	2023-04-13 21:40:18+00
249396	{"pm10": 35, "pm25": 55, "pm100": 66, "timestamp": 1681422024}	2023-04-13 21:40:24+00
249396	{"pm10": 35, "pm25": 55, "pm100": 66, "timestamp": 1681422030}	2023-04-13 21:40:30+00
249396	{"pm10": 35, "pm25": 53, "pm100": 65, "timestamp": 1681422036}	2023-04-13 21:40:36+00
249396	{"pm10": 35, "pm25": 53, "pm100": 65, "timestamp": 1681422042}	2023-04-13 21:40:42+00
249396	{"pm10": 34, "pm25": 51, "pm100": 63, "timestamp": 1681422048}	2023-04-13 21:40:48+00
249396	{"pm10": 34, "pm25": 51, "pm100": 63, "timestamp": 1681422054}	2023-04-13 21:40:54+00
249396	{"pm10": 34, "pm25": 51, "pm100": 63, "timestamp": 1681422061}	2023-04-13 21:41:01+00
249396	{"pm10": 34, "pm25": 51, "pm100": 63, "timestamp": 1681422067}	2023-04-13 21:41:07+00
249396	{"pm10": 34, "pm25": 50, "pm100": 62, "timestamp": 1681422073}	2023-04-13 21:41:13+00
249396	{"pm10": 34, "pm25": 50, "pm100": 62, "timestamp": 1681422079}	2023-04-13 21:41:19+00
249396	{"pm10": 34, "pm25": 50, "pm100": 62, "timestamp": 1681422085}	2023-04-13 21:41:25+00
249396	{"pm10": 34, "pm25": 50, "pm100": 62, "timestamp": 1681422091}	2023-04-13 21:41:31+00
249396	{"pm10": 34, "pm25": 50, "pm100": 61, "timestamp": 1681422097}	2023-04-13 21:41:37+00
249396	{"pm10": 34, "pm25": 51, "pm100": 63, "timestamp": 1681422104}	2023-04-13 21:41:44+00
249396	{"pm10": 34, "pm25": 51, "pm100": 63, "timestamp": 1681422110}	2023-04-13 21:41:50+00
249396	{"pm10": 35, "pm25": 51, "pm100": 64, "timestamp": 1681422116}	2023-04-13 21:41:56+00
249396	{"pm10": 35, "pm25": 51, "pm100": 64, "timestamp": 1681422122}	2023-04-13 21:42:02+00
249396	{"pm10": 35, "pm25": 51, "pm100": 62, "timestamp": 1681422128}	2023-04-13 21:42:08+00
249396	{"pm10": 35, "pm25": 51, "pm100": 62, "timestamp": 1681422134}	2023-04-13 21:42:14+00
249396	{"pm10": 35, "pm25": 51, "pm100": 62, "timestamp": 1681422140}	2023-04-13 21:42:20+00
249396	{"pm10": 35, "pm25": 51, "pm100": 62, "timestamp": 1681422146}	2023-04-13 21:42:26+00
249396	{"pm10": 34, "pm25": 50, "pm100": 62, "timestamp": 1681422153}	2023-04-13 21:42:33+00
249396	{"pm10": 34, "pm25": 52, "pm100": 64, "timestamp": 1681422159}	2023-04-13 21:42:39+00
249396	{"pm10": 35, "pm25": 53, "pm100": 65, "timestamp": 1681422165}	2023-04-13 21:42:45+00
249396	{"pm10": 35, "pm25": 53, "pm100": 66, "timestamp": 1681422171}	2023-04-13 21:42:51+00
249396	{"pm10": 35, "pm25": 53, "pm100": 66, "timestamp": 1681422177}	2023-04-13 21:42:57+00
249396	{"pm10": 35, "pm25": 53, "pm100": 65, "timestamp": 1681422183}	2023-04-13 21:43:03+00
249396	{"pm10": 35, "pm25": 53, "pm100": 64, "timestamp": 1681422189}	2023-04-13 21:43:09+00
249396	{"pm10": 35, "pm25": 53, "pm100": 64, "timestamp": 1681422195}	2023-04-13 21:43:15+00
249396	{"pm10": 36, "pm25": 52, "pm100": 64, "timestamp": 1681422202}	2023-04-13 21:43:22+00
249396	{"pm10": 36, "pm25": 52, "pm100": 64, "timestamp": 1681422208}	2023-04-13 21:43:28+00
249396	{"pm10": 36, "pm25": 52, "pm100": 63, "timestamp": 1681422214}	2023-04-13 21:43:34+00
249396	{"pm10": 36, "pm25": 52, "pm100": 63, "timestamp": 1681422220}	2023-04-13 21:43:40+00
249396	{"pm10": 37, "pm25": 53, "pm100": 64, "timestamp": 1681422226}	2023-04-13 21:43:46+00
249396	{"pm10": 37, "pm25": 53, "pm100": 64, "timestamp": 1681422232}	2023-04-13 21:43:52+00
249396	{"pm10": 35, "pm25": 52, "pm100": 63, "timestamp": 1681422238}	2023-04-13 21:43:58+00
249396	{"pm10": 35, "pm25": 53, "pm100": 64, "timestamp": 1681422244}	2023-04-13 21:44:04+00
249396	{"pm10": 35, "pm25": 53, "pm100": 64, "timestamp": 1681422251}	2023-04-13 21:44:11+00
249396	{"pm10": 35, "pm25": 53, "pm100": 64, "timestamp": 1681422257}	2023-04-13 21:44:17+00
249396	{"pm10": 35, "pm25": 53, "pm100": 64, "timestamp": 1681422263}	2023-04-13 21:44:23+00
249396	{"pm10": 35, "pm25": 53, "pm100": 64, "timestamp": 1681422269}	2023-04-13 21:44:29+00
249396	{"pm10": 35, "pm25": 53, "pm100": 64, "timestamp": 1681422275}	2023-04-13 21:44:35+00
249396	{"pm10": 34, "pm25": 52, "pm100": 63, "timestamp": 1681422281}	2023-04-13 21:44:41+00
249396	{"pm10": 34, "pm25": 52, "pm100": 64, "timestamp": 1681422287}	2023-04-13 21:44:47+00
249396	{"pm10": 34, "pm25": 52, "pm100": 64, "timestamp": 1681422293}	2023-04-13 21:44:53+00
249396	{"pm10": 35, "pm25": 52, "pm100": 64, "timestamp": 1681422300}	2023-04-13 21:45:00+00
249396	{"pm10": 35, "pm25": 52, "pm100": 64, "timestamp": 1681422306}	2023-04-13 21:45:06+00
249396	{"pm10": 35, "pm25": 52, "pm100": 64, "timestamp": 1681422312}	2023-04-13 21:45:12+00
249396	{"pm10": 35, "pm25": 52, "pm100": 64, "timestamp": 1681422318}	2023-04-13 21:45:18+00
249396	{"pm10": 35, "pm25": 51, "pm100": 62, "timestamp": 1681422324}	2023-04-13 21:45:24+00
249396	{"pm10": 35, "pm25": 52, "pm100": 63, "timestamp": 1681422330}	2023-04-13 21:45:30+00
249396	{"pm10": 35, "pm25": 52, "pm100": 64, "timestamp": 1681422336}	2023-04-13 21:45:36+00
249396	{"pm10": 35, "pm25": 54, "pm100": 66, "timestamp": 1681422342}	2023-04-13 21:45:42+00
249396	{"pm10": 35, "pm25": 51, "pm100": 62, "timestamp": 1681422349}	2023-04-13 21:45:49+00
249396	{"pm10": 35, "pm25": 51, "pm100": 62, "timestamp": 1681422355}	2023-04-13 21:45:55+00
249396	{"pm10": 35, "pm25": 51, "pm100": 62, "timestamp": 1681422361}	2023-04-13 21:46:01+00
249396	{"pm10": 35, "pm25": 52, "pm100": 62, "timestamp": 1681422367}	2023-04-13 21:46:07+00
249396	{"pm10": 35, "pm25": 51, "pm100": 62, "timestamp": 1681422373}	2023-04-13 21:46:13+00
249396	{"pm10": 35, "pm25": 51, "pm100": 62, "timestamp": 1681422379}	2023-04-13 21:46:19+00
249396	{"pm10": 34, "pm25": 51, "pm100": 62, "timestamp": 1681422385}	2023-04-13 21:46:25+00
249396	{"pm10": 35, "pm25": 52, "pm100": 62, "timestamp": 1681422391}	2023-04-13 21:46:31+00
249396	{"pm10": 33, "pm25": 51, "pm100": 64, "timestamp": 1681422398}	2023-04-13 21:46:38+00
249396	{"pm10": 33, "pm25": 50, "pm100": 64, "timestamp": 1681422404}	2023-04-13 21:46:44+00
249396	{"pm10": 34, "pm25": 51, "pm100": 66, "timestamp": 1681422410}	2023-04-13 21:46:50+00
249396	{"pm10": 34, "pm25": 52, "pm100": 66, "timestamp": 1681422416}	2023-04-13 21:46:56+00
249396	{"pm10": 35, "pm25": 53, "pm100": 67, "timestamp": 1681422422}	2023-04-13 21:47:02+00
249396	{"pm10": 35, "pm25": 54, "pm100": 68, "timestamp": 1681422428}	2023-04-13 21:47:08+00
249396	{"pm10": 35, "pm25": 54, "pm100": 68, "timestamp": 1681422434}	2023-04-13 21:47:14+00
249396	{"pm10": 35, "pm25": 53, "pm100": 66, "timestamp": 1681422440}	2023-04-13 21:47:20+00
249396	{"pm10": 35, "pm25": 51, "pm100": 62, "timestamp": 1681422447}	2023-04-13 21:47:27+00
249396	{"pm10": 35, "pm25": 51, "pm100": 62, "timestamp": 1681422453}	2023-04-13 21:47:33+00
249396	{"pm10": 35, "pm25": 51, "pm100": 62, "timestamp": 1681422459}	2023-04-13 21:47:39+00
249396	{"pm10": 35, "pm25": 51, "pm100": 62, "timestamp": 1681422465}	2023-04-13 21:47:45+00
249396	{"pm10": 35, "pm25": 51, "pm100": 62, "timestamp": 1681422471}	2023-04-13 21:47:51+00
249396	{"pm10": 35, "pm25": 51, "pm100": 62, "timestamp": 1681422477}	2023-04-13 21:47:57+00
249396	{"pm10": 35, "pm25": 51, "pm100": 62, "timestamp": 1681422483}	2023-04-13 21:48:03+00
249396	{"pm10": 34, "pm25": 52, "pm100": 65, "timestamp": 1681422489}	2023-04-13 21:48:09+00
249396	{"pm10": 34, "pm25": 52, "pm100": 65, "timestamp": 1681422496}	2023-04-13 21:48:16+00
249396	{"pm10": 34, "pm25": 52, "pm100": 65, "timestamp": 1681422502}	2023-04-13 21:48:22+00
249396	{"pm10": 34, "pm25": 52, "pm100": 65, "timestamp": 1681422508}	2023-04-13 21:48:28+00
249396	{"pm10": 35, "pm25": 52, "pm100": 65, "timestamp": 1681422515}	2023-04-13 21:48:35+00
249396	{"pm10": 34, "pm25": 51, "pm100": 63, "timestamp": 1681422521}	2023-04-13 21:48:41+00
249396	{"pm10": 34, "pm25": 51, "pm100": 63, "timestamp": 1681422527}	2023-04-13 21:48:47+00
249396	{"pm10": 33, "pm25": 50, "pm100": 61, "timestamp": 1681422533}	2023-04-13 21:48:53+00
249396	{"pm10": 34, "pm25": 51, "pm100": 63, "timestamp": 1681422539}	2023-04-13 21:48:59+00
249396	{"pm10": 34, "pm25": 51, "pm100": 62, "timestamp": 1681422545}	2023-04-13 21:49:05+00
249396	{"pm10": 34, "pm25": 50, "pm100": 62, "timestamp": 1681422552}	2023-04-13 21:49:12+00
249396	{"pm10": 34, "pm25": 50, "pm100": 62, "timestamp": 1681422558}	2023-04-13 21:49:18+00
249396	{"pm10": 34, "pm25": 50, "pm100": 62, "timestamp": 1681422564}	2023-04-13 21:49:24+00
249396	{"pm10": 34, "pm25": 51, "pm100": 62, "timestamp": 1681422570}	2023-04-13 21:49:30+00
249396	{"pm10": 34, "pm25": 51, "pm100": 63, "timestamp": 1681422576}	2023-04-13 21:49:36+00
249396	{"pm10": 35, "pm25": 52, "pm100": 64, "timestamp": 1681422582}	2023-04-13 21:49:42+00
249396	{"pm10": 34, "pm25": 51, "pm100": 62, "timestamp": 1681422588}	2023-04-13 21:49:48+00
249396	{"pm10": 34, "pm25": 51, "pm100": 62, "timestamp": 1681422594}	2023-04-13 21:49:54+00
249396	{"pm10": 34, "pm25": 51, "pm100": 63, "timestamp": 1681422601}	2023-04-13 21:50:01+00
249396	{"pm10": 34, "pm25": 51, "pm100": 63, "timestamp": 1681422607}	2023-04-13 21:50:07+00
249396	{"pm10": 34, "pm25": 51, "pm100": 63, "timestamp": 1681422613}	2023-04-13 21:50:13+00
249396	{"pm10": 34, "pm25": 51, "pm100": 63, "timestamp": 1681422619}	2023-04-13 21:50:19+00
249396	{"pm10": 34, "pm25": 51, "pm100": 63, "timestamp": 1681422625}	2023-04-13 21:50:25+00
249396	{"pm10": 34, "pm25": 51, "pm100": 63, "timestamp": 1681422631}	2023-04-13 21:50:31+00
249396	{"pm10": 34, "pm25": 52, "pm100": 64, "timestamp": 1681422637}	2023-04-13 21:50:37+00
249396	{"pm10": 34, "pm25": 52, "pm100": 64, "timestamp": 1681422643}	2023-04-13 21:50:43+00
249396	{"pm10": 34, "pm25": 52, "pm100": 64, "timestamp": 1681422650}	2023-04-13 21:50:50+00
249396	{"pm10": 34, "pm25": 52, "pm100": 64, "timestamp": 1681422656}	2023-04-13 21:50:56+00
249396	{"pm10": 33, "pm25": 51, "pm100": 63, "timestamp": 1681422662}	2023-04-13 21:51:02+00
249396	{"pm10": 33, "pm25": 51, "pm100": 63, "timestamp": 1681422668}	2023-04-13 21:51:08+00
249396	{"pm10": 33, "pm25": 51, "pm100": 63, "timestamp": 1681422674}	2023-04-13 21:51:14+00
249396	{"pm10": 34, "pm25": 52, "pm100": 64, "timestamp": 1681422680}	2023-04-13 21:51:20+00
249396	{"pm10": 33, "pm25": 50, "pm100": 62, "timestamp": 1681422686}	2023-04-13 21:51:26+00
249396	{"pm10": 33, "pm25": 51, "pm100": 63, "timestamp": 1681422692}	2023-04-13 21:51:32+00
249396	{"pm10": 34, "pm25": 52, "pm100": 64, "timestamp": 1681422699}	2023-04-13 21:51:39+00
249396	{"pm10": 35, "pm25": 53, "pm100": 65, "timestamp": 1681422705}	2023-04-13 21:51:45+00
249396	{"pm10": 35, "pm25": 53, "pm100": 65, "timestamp": 1681422711}	2023-04-13 21:51:51+00
249396	{"pm10": 34, "pm25": 53, "pm100": 65, "timestamp": 1681422717}	2023-04-13 21:51:57+00
249396	{"pm10": 34, "pm25": 52, "pm100": 64, "timestamp": 1681422723}	2023-04-13 21:52:03+00
249396	{"pm10": 34, "pm25": 52, "pm100": 64, "timestamp": 1681422729}	2023-04-13 21:52:09+00
249396	{"pm10": 34, "pm25": 52, "pm100": 63, "timestamp": 1681422735}	2023-04-13 21:52:15+00
249396	{"pm10": 35, "pm25": 52, "pm100": 64, "timestamp": 1681422741}	2023-04-13 21:52:21+00
249396	{"pm10": 34, "pm25": 51, "pm100": 64, "timestamp": 1681422748}	2023-04-13 21:52:28+00
249396	{"pm10": 33, "pm25": 52, "pm100": 64, "timestamp": 1681422754}	2023-04-13 21:52:34+00
249396	{"pm10": 33, "pm25": 51, "pm100": 62, "timestamp": 1681422760}	2023-04-13 21:52:40+00
249396	{"pm10": 33, "pm25": 51, "pm100": 62, "timestamp": 1681422766}	2023-04-13 21:52:46+00
249396	{"pm10": 35, "pm25": 52, "pm100": 64, "timestamp": 1681422772}	2023-04-13 21:52:52+00
249396	{"pm10": 35, "pm25": 52, "pm100": 64, "timestamp": 1681422778}	2023-04-13 21:52:58+00
249396	{"pm10": 35, "pm25": 53, "pm100": 64, "timestamp": 1681422784}	2023-04-13 21:53:04+00
249396	{"pm10": 35, "pm25": 53, "pm100": 64, "timestamp": 1681422790}	2023-04-13 21:53:10+00
249396	{"pm10": 35, "pm25": 52, "pm100": 63, "timestamp": 1681422797}	2023-04-13 21:53:17+00
249396	{"pm10": 35, "pm25": 52, "pm100": 63, "timestamp": 1681422803}	2023-04-13 21:53:23+00
249396	{"pm10": 33, "pm25": 51, "pm100": 62, "timestamp": 1681422809}	2023-04-13 21:53:29+00
249396	{"pm10": 33, "pm25": 51, "pm100": 62, "timestamp": 1681422815}	2023-04-13 21:53:35+00
249396	{"pm10": 35, "pm25": 54, "pm100": 66, "timestamp": 1681422821}	2023-04-13 21:53:41+00
249396	{"pm10": 35, "pm25": 53, "pm100": 65, "timestamp": 1681422827}	2023-04-13 21:53:47+00
249396	{"pm10": 35, "pm25": 52, "pm100": 64, "timestamp": 1681422833}	2023-04-13 21:53:53+00
249396	{"pm10": 35, "pm25": 52, "pm100": 64, "timestamp": 1681422839}	2023-04-13 21:53:59+00
249396	{"pm10": 35, "pm25": 52, "pm100": 64, "timestamp": 1681422846}	2023-04-13 21:54:06+00
249396	{"pm10": 35, "pm25": 52, "pm100": 63, "timestamp": 1681422852}	2023-04-13 21:54:12+00
249396	{"pm10": 34, "pm25": 51, "pm100": 62, "timestamp": 1681422858}	2023-04-13 21:54:18+00
249396	{"pm10": 34, "pm25": 50, "pm100": 62, "timestamp": 1681422864}	2023-04-13 21:54:24+00
249396	{"pm10": 34, "pm25": 50, "pm100": 62, "timestamp": 1681422870}	2023-04-13 21:54:30+00
249396	{"pm10": 33, "pm25": 51, "pm100": 64, "timestamp": 1681422876}	2023-04-13 21:54:36+00
249396	{"pm10": 33, "pm25": 51, "pm100": 64, "timestamp": 1681422882}	2023-04-13 21:54:42+00
249396	{"pm10": 34, "pm25": 52, "pm100": 65, "timestamp": 1681422888}	2023-04-13 21:54:48+00
249396	{"pm10": 35, "pm25": 52, "pm100": 64, "timestamp": 1681422895}	2023-04-13 21:54:55+00
249396	{"pm10": 35, "pm25": 52, "pm100": 64, "timestamp": 1681422901}	2023-04-13 21:55:01+00
249396	{"pm10": 35, "pm25": 51, "pm100": 64, "timestamp": 1681422907}	2023-04-13 21:55:07+00
249396	{"pm10": 35, "pm25": 51, "pm100": 64, "timestamp": 1681422913}	2023-04-13 21:55:13+00
249396	{"pm10": 35, "pm25": 52, "pm100": 63, "timestamp": 1681422919}	2023-04-13 21:55:19+00
249396	{"pm10": 35, "pm25": 52, "pm100": 63, "timestamp": 1681422925}	2023-04-13 21:55:25+00
249396	{"pm10": 35, "pm25": 52, "pm100": 63, "timestamp": 1681422931}	2023-04-13 21:55:31+00
249396	{"pm10": 35, "pm25": 52, "pm100": 63, "timestamp": 1681422937}	2023-04-13 21:55:37+00
249396	{"pm10": 34, "pm25": 52, "pm100": 64, "timestamp": 1681422944}	2023-04-13 21:55:44+00
249396	{"pm10": 35, "pm25": 53, "pm100": 66, "timestamp": 1681422950}	2023-04-13 21:55:50+00
249396	{"pm10": 34, "pm25": 52, "pm100": 64, "timestamp": 1681422956}	2023-04-13 21:55:56+00
249396	{"pm10": 33, "pm25": 52, "pm100": 65, "timestamp": 1681422963}	2023-04-13 21:56:03+00
249396	{"pm10": 34, "pm25": 52, "pm100": 66, "timestamp": 1681422969}	2023-04-13 21:56:09+00
249396	{"pm10": 34, "pm25": 52, "pm100": 64, "timestamp": 1681422975}	2023-04-13 21:56:15+00
249396	{"pm10": 35, "pm25": 53, "pm100": 67, "timestamp": 1681422981}	2023-04-13 21:56:21+00
249396	{"pm10": 35, "pm25": 53, "pm100": 67, "timestamp": 1681422987}	2023-04-13 21:56:27+00
249396	{"pm10": 35, "pm25": 53, "pm100": 67, "timestamp": 1681422993}	2023-04-13 21:56:33+00
249396	{"pm10": 35, "pm25": 52, "pm100": 63, "timestamp": 1681422999}	2023-04-13 21:56:39+00
249396	{"pm10": 35, "pm25": 52, "pm100": 63, "timestamp": 1681423006}	2023-04-13 21:56:46+00
249396	{"pm10": 35, "pm25": 52, "pm100": 63, "timestamp": 1681423012}	2023-04-13 21:56:52+00
249396	{"pm10": 35, "pm25": 52, "pm100": 63, "timestamp": 1681423018}	2023-04-13 21:56:58+00
249396	{"pm10": 35, "pm25": 52, "pm100": 63, "timestamp": 1681423024}	2023-04-13 21:57:04+00
249396	{"pm10": 35, "pm25": 52, "pm100": 63, "timestamp": 1681423030}	2023-04-13 21:57:10+00
249396	{"pm10": 35, "pm25": 52, "pm100": 63, "timestamp": 1681423036}	2023-04-13 21:57:16+00
249396	{"pm10": 34, "pm25": 53, "pm100": 66, "timestamp": 1681423042}	2023-04-13 21:57:22+00
249396	{"pm10": 34, "pm25": 53, "pm100": 65, "timestamp": 1681423048}	2023-04-13 21:57:28+00
249396	{"pm10": 34, "pm25": 53, "pm100": 66, "timestamp": 1681423055}	2023-04-13 21:57:35+00
249396	{"pm10": 34, "pm25": 53, "pm100": 65, "timestamp": 1681423061}	2023-04-13 21:57:41+00
249396	{"pm10": 34, "pm25": 53, "pm100": 65, "timestamp": 1681423067}	2023-04-13 21:57:47+00
249396	{"pm10": 34, "pm25": 52, "pm100": 64, "timestamp": 1681423073}	2023-04-13 21:57:53+00
249396	{"pm10": 34, "pm25": 52, "pm100": 64, "timestamp": 1681423079}	2023-04-13 21:57:59+00
249396	{"pm10": 34, "pm25": 52, "pm100": 64, "timestamp": 1681423085}	2023-04-13 21:58:05+00
249396	{"pm10": 34, "pm25": 52, "pm100": 65, "timestamp": 1681423091}	2023-04-13 21:58:11+00
249396	{"pm10": 35, "pm25": 51, "pm100": 62, "timestamp": 1681423097}	2023-04-13 21:58:17+00
249396	{"pm10": 35, "pm25": 51, "pm100": 62, "timestamp": 1681423104}	2023-04-13 21:58:24+00
249396	{"pm10": 35, "pm25": 51, "pm100": 62, "timestamp": 1681423110}	2023-04-13 21:58:30+00
249396	{"pm10": 34, "pm25": 51, "pm100": 61, "timestamp": 1681423116}	2023-04-13 21:58:36+00
249396	{"pm10": 34, "pm25": 53, "pm100": 64, "timestamp": 1681423122}	2023-04-13 21:58:42+00
249396	{"pm10": 34, "pm25": 53, "pm100": 64, "timestamp": 1681423128}	2023-04-13 21:58:48+00
249396	{"pm10": 34, "pm25": 52, "pm100": 63, "timestamp": 1681423134}	2023-04-13 21:58:54+00
249396	{"pm10": 33, "pm25": 51, "pm100": 62, "timestamp": 1681423140}	2023-04-13 21:59:00+00
249396	{"pm10": 34, "pm25": 51, "pm100": 63, "timestamp": 1681423146}	2023-04-13 21:59:06+00
249396	{"pm10": 34, "pm25": 51, "pm100": 63, "timestamp": 1681423153}	2023-04-13 21:59:13+00
249396	{"pm10": 34, "pm25": 52, "pm100": 64, "timestamp": 1681423159}	2023-04-13 21:59:19+00
249396	{"pm10": 34, "pm25": 52, "pm100": 64, "timestamp": 1681423165}	2023-04-13 21:59:25+00
249396	{"pm10": 37, "pm25": 52, "pm100": 64, "timestamp": 1681423171}	2023-04-13 21:59:31+00
249396	{"pm10": 38, "pm25": 53, "pm100": 65, "timestamp": 1681423177}	2023-04-13 21:59:37+00
249396	{"pm10": 38, "pm25": 54, "pm100": 66, "timestamp": 1681423183}	2023-04-13 21:59:43+00
249396	{"pm10": 38, "pm25": 54, "pm100": 66, "timestamp": 1681423189}	2023-04-13 21:59:49+00
249396	{"pm10": 37, "pm25": 55, "pm100": 66, "timestamp": 1681423195}	2023-04-13 21:59:55+00
249396	{"pm10": 34, "pm25": 50, "pm100": 62, "timestamp": 1681423202}	2023-04-13 22:00:02+00
249396	{"pm10": 34, "pm25": 51, "pm100": 62, "timestamp": 1681423208}	2023-04-13 22:00:08+00
249396	{"pm10": 34, "pm25": 51, "pm100": 62, "timestamp": 1681423214}	2023-04-13 22:00:14+00
249396	{"pm10": 34, "pm25": 51, "pm100": 63, "timestamp": 1681423220}	2023-04-13 22:00:20+00
249396	{"pm10": 33, "pm25": 49, "pm100": 60, "timestamp": 1681423226}	2023-04-13 22:00:26+00
249396	{"pm10": 33, "pm25": 49, "pm100": 60, "timestamp": 1681423232}	2023-04-13 22:00:32+00
249396	{"pm10": 34, "pm25": 53, "pm100": 66, "timestamp": 1681423238}	2023-04-13 22:00:38+00
249396	{"pm10": 34, "pm25": 53, "pm100": 65, "timestamp": 1681423244}	2023-04-13 22:00:44+00
249396	{"pm10": 34, "pm25": 52, "pm100": 64, "timestamp": 1681423251}	2023-04-13 22:00:51+00
249396	{"pm10": 34, "pm25": 52, "pm100": 64, "timestamp": 1681423257}	2023-04-13 22:00:57+00
249396	{"pm10": 34, "pm25": 52, "pm100": 63, "timestamp": 1681423263}	2023-04-13 22:01:03+00
249396	{"pm10": 34, "pm25": 50, "pm100": 62, "timestamp": 1681423269}	2023-04-13 22:01:09+00
249396	{"pm10": 34, "pm25": 50, "pm100": 62, "timestamp": 1681423275}	2023-04-13 22:01:15+00
249396	{"pm10": 34, "pm25": 49, "pm100": 61, "timestamp": 1681423281}	2023-04-13 22:01:21+00
249396	{"pm10": 34, "pm25": 49, "pm100": 61, "timestamp": 1681423287}	2023-04-13 22:01:27+00
249396	{"pm10": 35, "pm25": 53, "pm100": 65, "timestamp": 1681423293}	2023-04-13 22:01:33+00
249396	{"pm10": 35, "pm25": 53, "pm100": 65, "timestamp": 1681423300}	2023-04-13 22:01:40+00
249396	{"pm10": 33, "pm25": 50, "pm100": 62, "timestamp": 1681423306}	2023-04-13 22:01:46+00
249396	{"pm10": 33, "pm25": 50, "pm100": 62, "timestamp": 1681423312}	2023-04-13 22:01:52+00
249396	{"pm10": 33, "pm25": 50, "pm100": 62, "timestamp": 1681423318}	2023-04-13 22:01:58+00
249396	{"pm10": 33, "pm25": 49, "pm100": 61, "timestamp": 1681423324}	2023-04-13 22:02:04+00
249396	{"pm10": 34, "pm25": 52, "pm100": 64, "timestamp": 1681423330}	2023-04-13 22:02:10+00
249396	{"pm10": 34, "pm25": 52, "pm100": 64, "timestamp": 1681423336}	2023-04-13 22:02:16+00
249396	{"pm10": 34, "pm25": 52, "pm100": 64, "timestamp": 1681423342}	2023-04-13 22:02:22+00
249396	{"pm10": 34, "pm25": 52, "pm100": 64, "timestamp": 1681423349}	2023-04-13 22:02:29+00
249396	{"pm10": 34, "pm25": 52, "pm100": 64, "timestamp": 1681423355}	2023-04-13 22:02:35+00
249396	{"pm10": 34, "pm25": 51, "pm100": 63, "timestamp": 1681423361}	2023-04-13 22:02:41+00
249396	{"pm10": 34, "pm25": 52, "pm100": 65, "timestamp": 1681423367}	2023-04-13 22:02:47+00
249396	{"pm10": 34, "pm25": 52, "pm100": 65, "timestamp": 1681423373}	2023-04-13 22:02:53+00
249396	{"pm10": 34, "pm25": 51, "pm100": 64, "timestamp": 1681423379}	2023-04-13 22:02:59+00
249396	{"pm10": 34, "pm25": 50, "pm100": 64, "timestamp": 1681423385}	2023-04-13 22:03:05+00
249396	{"pm10": 33, "pm25": 50, "pm100": 64, "timestamp": 1681423391}	2023-04-13 22:03:11+00
249396	{"pm10": 34, "pm25": 50, "pm100": 65, "timestamp": 1681423398}	2023-04-13 22:03:18+00
249396	{"pm10": 33, "pm25": 51, "pm100": 65, "timestamp": 1681423404}	2023-04-13 22:03:24+00
249396	{"pm10": 33, "pm25": 51, "pm100": 64, "timestamp": 1681423410}	2023-04-13 22:03:30+00
249396	{"pm10": 33, "pm25": 50, "pm100": 64, "timestamp": 1681423416}	2023-04-13 22:03:36+00
249396	{"pm10": 33, "pm25": 50, "pm100": 62, "timestamp": 1681423422}	2023-04-13 22:03:42+00
249396	{"pm10": 34, "pm25": 50, "pm100": 61, "timestamp": 1681423428}	2023-04-13 22:03:48+00
249396	{"pm10": 33, "pm25": 50, "pm100": 61, "timestamp": 1681423434}	2023-04-13 22:03:54+00
249396	{"pm10": 33, "pm25": 50, "pm100": 61, "timestamp": 1681423440}	2023-04-13 22:04:00+00
249396	{"pm10": 34, "pm25": 51, "pm100": 61, "timestamp": 1681423447}	2023-04-13 22:04:07+00
249396	{"pm10": 34, "pm25": 51, "pm100": 61, "timestamp": 1681423453}	2023-04-13 22:04:13+00
249396	{"pm10": 34, "pm25": 50, "pm100": 61, "timestamp": 1681423459}	2023-04-13 22:04:19+00
249396	{"pm10": 34, "pm25": 51, "pm100": 62, "timestamp": 1681423465}	2023-04-13 22:04:25+00
249396	{"pm10": 35, "pm25": 51, "pm100": 62, "timestamp": 1681423471}	2023-04-13 22:04:31+00
249396	{"pm10": 35, "pm25": 51, "pm100": 62, "timestamp": 1681423477}	2023-04-13 22:04:37+00
249396	{"pm10": 34, "pm25": 50, "pm100": 61, "timestamp": 1681423483}	2023-04-13 22:04:43+00
249396	{"pm10": 34, "pm25": 50, "pm100": 61, "timestamp": 1681423490}	2023-04-13 22:04:50+00
249396	{"pm10": 35, "pm25": 52, "pm100": 66, "timestamp": 1681423496}	2023-04-13 22:04:56+00
249396	{"pm10": 35, "pm25": 52, "pm100": 66, "timestamp": 1681423502}	2023-04-13 22:05:02+00
249396	{"pm10": 35, "pm25": 52, "pm100": 66, "timestamp": 1681423508}	2023-04-13 22:05:08+00
249396	{"pm10": 35, "pm25": 51, "pm100": 65, "timestamp": 1681423514}	2023-04-13 22:05:14+00
249396	{"pm10": 35, "pm25": 51, "pm100": 65, "timestamp": 1681423520}	2023-04-13 22:05:20+00
249396	{"pm10": 35, "pm25": 51, "pm100": 64, "timestamp": 1681423526}	2023-04-13 22:05:26+00
249396	{"pm10": 35, "pm25": 51, "pm100": 64, "timestamp": 1681423532}	2023-04-13 22:05:32+00
249396	{"pm10": 34, "pm25": 50, "pm100": 64, "timestamp": 1681423539}	2023-04-13 22:05:39+00
249396	{"pm10": 34, "pm25": 50, "pm100": 64, "timestamp": 1681423545}	2023-04-13 22:05:45+00
249396	{"pm10": 35, "pm25": 52, "pm100": 65, "timestamp": 1681423551}	2023-04-13 22:05:51+00
249396	{"pm10": 35, "pm25": 52, "pm100": 65, "timestamp": 1681423557}	2023-04-13 22:05:57+00
249396	{"pm10": 35, "pm25": 52, "pm100": 64, "timestamp": 1681423563}	2023-04-13 22:06:03+00
249396	{"pm10": 36, "pm25": 52, "pm100": 64, "timestamp": 1681423569}	2023-04-13 22:06:09+00
249396	{"pm10": 36, "pm25": 52, "pm100": 64, "timestamp": 1681423575}	2023-04-13 22:06:15+00
249396	{"pm10": 35, "pm25": 52, "pm100": 64, "timestamp": 1681423581}	2023-04-13 22:06:21+00
249396	{"pm10": 34, "pm25": 51, "pm100": 64, "timestamp": 1681423588}	2023-04-13 22:06:28+00
249396	{"pm10": 34, "pm25": 51, "pm100": 63, "timestamp": 1681423594}	2023-04-13 22:06:34+00
249396	{"pm10": 34, "pm25": 51, "pm100": 63, "timestamp": 1681423600}	2023-04-13 22:06:40+00
249396	{"pm10": 34, "pm25": 51, "pm100": 63, "timestamp": 1681423606}	2023-04-13 22:06:46+00
249396	{"pm10": 35, "pm25": 52, "pm100": 64, "timestamp": 1681423612}	2023-04-13 22:06:52+00
249396	{"pm10": 35, "pm25": 52, "pm100": 65, "timestamp": 1681423618}	2023-04-13 22:06:58+00
249396	{"pm10": 35, "pm25": 52, "pm100": 65, "timestamp": 1681423624}	2023-04-13 22:07:04+00
249396	{"pm10": 35, "pm25": 52, "pm100": 64, "timestamp": 1681423630}	2023-04-13 22:07:10+00
249396	{"pm10": 35, "pm25": 52, "pm100": 63, "timestamp": 1681423637}	2023-04-13 22:07:17+00
249396	{"pm10": 35, "pm25": 51, "pm100": 62, "timestamp": 1681423643}	2023-04-13 22:07:23+00
249396	{"pm10": 34, "pm25": 50, "pm100": 61, "timestamp": 1681423649}	2023-04-13 22:07:29+00
249396	{"pm10": 34, "pm25": 51, "pm100": 62, "timestamp": 1681423655}	2023-04-13 22:07:35+00
249396	{"pm10": 34, "pm25": 50, "pm100": 62, "timestamp": 1681423661}	2023-04-13 22:07:41+00
249396	{"pm10": 34, "pm25": 51, "pm100": 62, "timestamp": 1681423667}	2023-04-13 22:07:47+00
249396	{"pm10": 34, "pm25": 51, "pm100": 63, "timestamp": 1681423673}	2023-04-13 22:07:53+00
249396	{"pm10": 35, "pm25": 52, "pm100": 63, "timestamp": 1681423679}	2023-04-13 22:07:59+00
249396	{"pm10": 36, "pm25": 53, "pm100": 66, "timestamp": 1681423686}	2023-04-13 22:08:06+00
249396	{"pm10": 36, "pm25": 53, "pm100": 64, "timestamp": 1681423692}	2023-04-13 22:08:12+00
249396	{"pm10": 36, "pm25": 53, "pm100": 64, "timestamp": 1681423698}	2023-04-13 22:08:18+00
249396	{"pm10": 35, "pm25": 52, "pm100": 64, "timestamp": 1681423704}	2023-04-13 22:08:24+00
249396	{"pm10": 35, "pm25": 52, "pm100": 64, "timestamp": 1681423710}	2023-04-13 22:08:30+00
249396	{"pm10": 34, "pm25": 50, "pm100": 61, "timestamp": 1681423716}	2023-04-13 22:08:36+00
249396	{"pm10": 34, "pm25": 50, "pm100": 61, "timestamp": 1681423722}	2023-04-13 22:08:42+00
249396	{"pm10": 35, "pm25": 52, "pm100": 65, "timestamp": 1681423728}	2023-04-13 22:08:48+00
249396	{"pm10": 35, "pm25": 52, "pm100": 64, "timestamp": 1681423735}	2023-04-13 22:08:55+00
249396	{"pm10": 34, "pm25": 51, "pm100": 63, "timestamp": 1681423741}	2023-04-13 22:09:01+00
249396	{"pm10": 35, "pm25": 52, "pm100": 63, "timestamp": 1681423747}	2023-04-13 22:09:07+00
249396	{"pm10": 35, "pm25": 52, "pm100": 63, "timestamp": 1681423753}	2023-04-13 22:09:13+00
249396	{"pm10": 35, "pm25": 51, "pm100": 62, "timestamp": 1681423759}	2023-04-13 22:09:19+00
249396	{"pm10": 34, "pm25": 50, "pm100": 61, "timestamp": 1681423765}	2023-04-13 22:09:25+00
249396	{"pm10": 33, "pm25": 50, "pm100": 61, "timestamp": 1681423771}	2023-04-13 22:09:31+00
249396	{"pm10": 34, "pm25": 51, "pm100": 62, "timestamp": 1681423777}	2023-04-13 22:09:37+00
249396	{"pm10": 33, "pm25": 51, "pm100": 63, "timestamp": 1681423784}	2023-04-13 22:09:44+00
249396	{"pm10": 35, "pm25": 53, "pm100": 64, "timestamp": 1681423790}	2023-04-13 22:09:50+00
249396	{"pm10": 35, "pm25": 52, "pm100": 64, "timestamp": 1681423796}	2023-04-13 22:09:56+00
249396	{"pm10": 34, "pm25": 52, "pm100": 64, "timestamp": 1681423802}	2023-04-13 22:10:02+00
249396	{"pm10": 33, "pm25": 51, "pm100": 61, "timestamp": 1681423808}	2023-04-13 22:10:08+00
249396	{"pm10": 33, "pm25": 51, "pm100": 61, "timestamp": 1681423814}	2023-04-13 22:10:14+00
249396	{"pm10": 34, "pm25": 50, "pm100": 61, "timestamp": 1681423820}	2023-04-13 22:10:20+00
249396	{"pm10": 34, "pm25": 50, "pm100": 61, "timestamp": 1681423826}	2023-04-13 22:10:26+00
249396	{"pm10": 33, "pm25": 50, "pm100": 61, "timestamp": 1681423833}	2023-04-13 22:10:33+00
249396	{"pm10": 33, "pm25": 50, "pm100": 61, "timestamp": 1681423839}	2023-04-13 22:10:39+00
249396	{"pm10": 33, "pm25": 50, "pm100": 61, "timestamp": 1681423845}	2023-04-13 22:10:45+00
249396	{"pm10": 34, "pm25": 51, "pm100": 62, "timestamp": 1681423851}	2023-04-13 22:10:51+00
249396	{"pm10": 34, "pm25": 51, "pm100": 62, "timestamp": 1681423857}	2023-04-13 22:10:57+00
249396	{"pm10": 34, "pm25": 51, "pm100": 62, "timestamp": 1681423863}	2023-04-13 22:11:03+00
249396	{"pm10": 33, "pm25": 49, "pm100": 61, "timestamp": 1681423869}	2023-04-13 22:11:09+00
249396	{"pm10": 33, "pm25": 49, "pm100": 61, "timestamp": 1681423875}	2023-04-13 22:11:15+00
249396	{"pm10": 35, "pm25": 52, "pm100": 64, "timestamp": 1681423882}	2023-04-13 22:11:22+00
249396	{"pm10": 35, "pm25": 52, "pm100": 64, "timestamp": 1681423888}	2023-04-13 22:11:28+00
249396	{"pm10": 35, "pm25": 53, "pm100": 64, "timestamp": 1681423894}	2023-04-13 22:11:34+00
249396	{"pm10": 35, "pm25": 52, "pm100": 63, "timestamp": 1681423900}	2023-04-13 22:11:40+00
249396	{"pm10": 35, "pm25": 51, "pm100": 63, "timestamp": 1681423906}	2023-04-13 22:11:46+00
249396	{"pm10": 34, "pm25": 50, "pm100": 62, "timestamp": 1681423912}	2023-04-13 22:11:52+00
249396	{"pm10": 34, "pm25": 52, "pm100": 64, "timestamp": 1681423918}	2023-04-13 22:11:58+00
249396	{"pm10": 34, "pm25": 52, "pm100": 64, "timestamp": 1681423924}	2023-04-13 22:12:04+00
249396	{"pm10": 35, "pm25": 52, "pm100": 64, "timestamp": 1681423931}	2023-04-13 22:12:11+00
249396	{"pm10": 35, "pm25": 52, "pm100": 64, "timestamp": 1681423937}	2023-04-13 22:12:17+00
249396	{"pm10": 35, "pm25": 52, "pm100": 64, "timestamp": 1681423943}	2023-04-13 22:12:23+00
249396	{"pm10": 32, "pm25": 50, "pm100": 61, "timestamp": 1681423949}	2023-04-13 22:12:29+00
249396	{"pm10": 32, "pm25": 50, "pm100": 61, "timestamp": 1681423955}	2023-04-13 22:12:35+00
249396	{"pm10": 34, "pm25": 51, "pm100": 63, "timestamp": 1681423961}	2023-04-13 22:12:41+00
249396	{"pm10": 34, "pm25": 51, "pm100": 63, "timestamp": 1681423967}	2023-04-13 22:12:47+00
249396	{"pm10": 34, "pm25": 51, "pm100": 63, "timestamp": 1681423973}	2023-04-13 22:12:53+00
249396	{"pm10": 33, "pm25": 51, "pm100": 63, "timestamp": 1681423980}	2023-04-13 22:13:00+00
249396	{"pm10": 35, "pm25": 52, "pm100": 65, "timestamp": 1681423986}	2023-04-13 22:13:06+00
249396	{"pm10": 33, "pm25": 50, "pm100": 61, "timestamp": 1681423992}	2023-04-13 22:13:12+00
249396	{"pm10": 33, "pm25": 50, "pm100": 61, "timestamp": 1681423998}	2023-04-13 22:13:18+00
249396	{"pm10": 33, "pm25": 49, "pm100": 61, "timestamp": 1681424004}	2023-04-13 22:13:24+00
249396	{"pm10": 33, "pm25": 49, "pm100": 61, "timestamp": 1681424010}	2023-04-13 22:13:30+00
249396	{"pm10": 35, "pm25": 51, "pm100": 63, "timestamp": 1681424016}	2023-04-13 22:13:36+00
249396	{"pm10": 35, "pm25": 51, "pm100": 63, "timestamp": 1681424022}	2023-04-13 22:13:42+00
249396	{"pm10": 34, "pm25": 51, "pm100": 63, "timestamp": 1681424029}	2023-04-13 22:13:49+00
249396	{"pm10": 34, "pm25": 51, "pm100": 63, "timestamp": 1681424035}	2023-04-13 22:13:55+00
249396	{"pm10": 35, "pm25": 52, "pm100": 64, "timestamp": 1681424041}	2023-04-13 22:14:01+00
249396	{"pm10": 35, "pm25": 52, "pm100": 64, "timestamp": 1681424047}	2023-04-13 22:14:07+00
249396	{"pm10": 34, "pm25": 52, "pm100": 63, "timestamp": 1681424053}	2023-04-13 22:14:13+00
249396	{"pm10": 34, "pm25": 52, "pm100": 63, "timestamp": 1681424059}	2023-04-13 22:14:19+00
249396	{"pm10": 34, "pm25": 50, "pm100": 61, "timestamp": 1681424066}	2023-04-13 22:14:26+00
249396	{"pm10": 34, "pm25": 50, "pm100": 61, "timestamp": 1681424072}	2023-04-13 22:14:32+00
249396	{"pm10": 34, "pm25": 50, "pm100": 61, "timestamp": 1681424078}	2023-04-13 22:14:38+00
249396	{"pm10": 34, "pm25": 50, "pm100": 61, "timestamp": 1681424084}	2023-04-13 22:14:44+00
249396	{"pm10": 33, "pm25": 50, "pm100": 61, "timestamp": 1681424090}	2023-04-13 22:14:50+00
249396	{"pm10": 34, "pm25": 50, "pm100": 61, "timestamp": 1681424096}	2023-04-13 22:14:56+00
249396	{"pm10": 35, "pm25": 50, "pm100": 62, "timestamp": 1681424102}	2023-04-13 22:15:02+00
249396	{"pm10": 34, "pm25": 50, "pm100": 61, "timestamp": 1681424108}	2023-04-13 22:15:08+00
249396	{"pm10": 34, "pm25": 50, "pm100": 61, "timestamp": 1681424115}	2023-04-13 22:15:15+00
249396	{"pm10": 33, "pm25": 49, "pm100": 60, "timestamp": 1681424121}	2023-04-13 22:15:21+00
249396	{"pm10": 33, "pm25": 49, "pm100": 60, "timestamp": 1681424127}	2023-04-13 22:15:27+00
249396	{"pm10": 33, "pm25": 49, "pm100": 60, "timestamp": 1681424133}	2023-04-13 22:15:33+00
249396	{"pm10": 34, "pm25": 50, "pm100": 61, "timestamp": 1681424139}	2023-04-13 22:15:39+00
249396	{"pm10": 34, "pm25": 50, "pm100": 61, "timestamp": 1681424145}	2023-04-13 22:15:45+00
249396	{"pm10": 34, "pm25": 50, "pm100": 62, "timestamp": 1681424151}	2023-04-13 22:15:51+00
249396	{"pm10": 33, "pm25": 50, "pm100": 61, "timestamp": 1681424157}	2023-04-13 22:15:57+00
249396	{"pm10": 33, "pm25": 54, "pm100": 67, "timestamp": 1681424164}	2023-04-13 22:16:04+00
249396	{"pm10": 33, "pm25": 54, "pm100": 67, "timestamp": 1681424170}	2023-04-13 22:16:10+00
249396	{"pm10": 33, "pm25": 54, "pm100": 67, "timestamp": 1681424176}	2023-04-13 22:16:16+00
249396	{"pm10": 33, "pm25": 54, "pm100": 67, "timestamp": 1681424182}	2023-04-13 22:16:22+00
249396	{"pm10": 33, "pm25": 53, "pm100": 65, "timestamp": 1681424188}	2023-04-13 22:16:28+00
249396	{"pm10": 33, "pm25": 50, "pm100": 62, "timestamp": 1681424194}	2023-04-13 22:16:34+00
249396	{"pm10": 33, "pm25": 50, "pm100": 62, "timestamp": 1681424200}	2023-04-13 22:16:40+00
249396	{"pm10": 34, "pm25": 51, "pm100": 62, "timestamp": 1681424206}	2023-04-13 22:16:46+00
249396	{"pm10": 34, "pm25": 51, "pm100": 62, "timestamp": 1681424213}	2023-04-13 22:16:53+00
249396	{"pm10": 35, "pm25": 51, "pm100": 62, "timestamp": 1681424219}	2023-04-13 22:16:59+00
249396	{"pm10": 34, "pm25": 50, "pm100": 63, "timestamp": 1681424225}	2023-04-13 22:17:05+00
249396	{"pm10": 34, "pm25": 50, "pm100": 61, "timestamp": 1681424231}	2023-04-13 22:17:11+00
249396	{"pm10": 34, "pm25": 50, "pm100": 61, "timestamp": 1681424237}	2023-04-13 22:17:17+00
249396	{"pm10": 34, "pm25": 49, "pm100": 60, "timestamp": 1681424243}	2023-04-13 22:17:23+00
249396	{"pm10": 34, "pm25": 50, "pm100": 61, "timestamp": 1681424249}	2023-04-13 22:17:29+00
249396	{"pm10": 34, "pm25": 50, "pm100": 61, "timestamp": 1681424256}	2023-04-13 22:17:36+00
249396	{"pm10": 34, "pm25": 50, "pm100": 61, "timestamp": 1681424262}	2023-04-13 22:17:42+00
249396	{"pm10": 34, "pm25": 50, "pm100": 61, "timestamp": 1681424268}	2023-04-13 22:17:48+00
249396	{"pm10": 34, "pm25": 50, "pm100": 61, "timestamp": 1681424274}	2023-04-13 22:17:54+00
249396	{"pm10": 33, "pm25": 49, "pm100": 60, "timestamp": 1681424280}	2023-04-13 22:18:00+00
249396	{"pm10": 34, "pm25": 51, "pm100": 63, "timestamp": 1681424286}	2023-04-13 22:18:06+00
249396	{"pm10": 34, "pm25": 51, "pm100": 63, "timestamp": 1681424292}	2023-04-13 22:18:12+00
249396	{"pm10": 34, "pm25": 51, "pm100": 63, "timestamp": 1681424298}	2023-04-13 22:18:18+00
249396	{"pm10": 34, "pm25": 51, "pm100": 63, "timestamp": 1681424305}	2023-04-13 22:18:25+00
249396	{"pm10": 34, "pm25": 51, "pm100": 63, "timestamp": 1681424311}	2023-04-13 22:18:31+00
249396	{"pm10": 35, "pm25": 51, "pm100": 62, "timestamp": 1681424317}	2023-04-13 22:18:37+00
249396	{"pm10": 35, "pm25": 51, "pm100": 62, "timestamp": 1681424323}	2023-04-13 22:18:43+00
249396	{"pm10": 35, "pm25": 51, "pm100": 62, "timestamp": 1681424329}	2023-04-13 22:18:49+00
249396	{"pm10": 35, "pm25": 51, "pm100": 62, "timestamp": 1681424335}	2023-04-13 22:18:55+00
249396	{"pm10": 34, "pm25": 51, "pm100": 62, "timestamp": 1681424341}	2023-04-13 22:19:01+00
249396	{"pm10": 33, "pm25": 50, "pm100": 61, "timestamp": 1681424347}	2023-04-13 22:19:07+00
249396	{"pm10": 32, "pm25": 49, "pm100": 60, "timestamp": 1681424354}	2023-04-13 22:19:14+00
249396	{"pm10": 32, "pm25": 49, "pm100": 60, "timestamp": 1681424360}	2023-04-13 22:19:20+00
249396	{"pm10": 32, "pm25": 49, "pm100": 60, "timestamp": 1681424366}	2023-04-13 22:19:26+00
249396	{"pm10": 33, "pm25": 49, "pm100": 59, "timestamp": 1681424372}	2023-04-13 22:19:32+00
249396	{"pm10": 33, "pm25": 49, "pm100": 59, "timestamp": 1681424378}	2023-04-13 22:19:38+00
249396	{"pm10": 34, "pm25": 49, "pm100": 60, "timestamp": 1681424384}	2023-04-13 22:19:44+00
249396	{"pm10": 34, "pm25": 50, "pm100": 61, "timestamp": 1681424390}	2023-04-13 22:19:50+00
249396	{"pm10": 34, "pm25": 52, "pm100": 63, "timestamp": 1681424396}	2023-04-13 22:19:56+00
249396	{"pm10": 34, "pm25": 52, "pm100": 63, "timestamp": 1681424403}	2023-04-13 22:20:03+00
249396	{"pm10": 33, "pm25": 50, "pm100": 61, "timestamp": 1681424409}	2023-04-13 22:20:09+00
249396	{"pm10": 33, "pm25": 51, "pm100": 62, "timestamp": 1681424415}	2023-04-13 22:20:15+00
249396	{"pm10": 33, "pm25": 51, "pm100": 63, "timestamp": 1681424421}	2023-04-13 22:20:21+00
249396	{"pm10": 33, "pm25": 51, "pm100": 64, "timestamp": 1681424427}	2023-04-13 22:20:27+00
249396	{"pm10": 33, "pm25": 50, "pm100": 63, "timestamp": 1681424433}	2023-04-13 22:20:33+00
249396	{"pm10": 33, "pm25": 51, "pm100": 63, "timestamp": 1681424439}	2023-04-13 22:20:39+00
249396	{"pm10": 33, "pm25": 50, "pm100": 61, "timestamp": 1681424445}	2023-04-13 22:20:45+00
249396	{"pm10": 33, "pm25": 50, "pm100": 60, "timestamp": 1681424452}	2023-04-13 22:20:52+00
249396	{"pm10": 32, "pm25": 50, "pm100": 60, "timestamp": 1681424458}	2023-04-13 22:20:58+00
249396	{"pm10": 34, "pm25": 51, "pm100": 63, "timestamp": 1681424464}	2023-04-13 22:21:04+00
249396	{"pm10": 34, "pm25": 51, "pm100": 63, "timestamp": 1681424470}	2023-04-13 22:21:10+00
249396	{"pm10": 34, "pm25": 51, "pm100": 63, "timestamp": 1681424476}	2023-04-13 22:21:16+00
249396	{"pm10": 34, "pm25": 51, "pm100": 62, "timestamp": 1681424482}	2023-04-13 22:21:22+00
249396	{"pm10": 34, "pm25": 51, "pm100": 62, "timestamp": 1681424488}	2023-04-13 22:21:28+00
249396	{"pm10": 34, "pm25": 51, "pm100": 62, "timestamp": 1681424494}	2023-04-13 22:21:34+00
249396	{"pm10": 34, "pm25": 51, "pm100": 63, "timestamp": 1681424501}	2023-04-13 22:21:41+00
249396	{"pm10": 34, "pm25": 50, "pm100": 62, "timestamp": 1681424507}	2023-04-13 22:21:47+00
249396	{"pm10": 34, "pm25": 50, "pm100": 62, "timestamp": 1681424513}	2023-04-13 22:21:53+00
249396	{"pm10": 34, "pm25": 51, "pm100": 62, "timestamp": 1681424519}	2023-04-13 22:21:59+00
249396	{"pm10": 34, "pm25": 50, "pm100": 62, "timestamp": 1681424525}	2023-04-13 22:22:05+00
249396	{"pm10": 34, "pm25": 51, "pm100": 63, "timestamp": 1681424531}	2023-04-13 22:22:11+00
249396	{"pm10": 33, "pm25": 51, "pm100": 63, "timestamp": 1681424537}	2023-04-13 22:22:17+00
249396	{"pm10": 33, "pm25": 51, "pm100": 63, "timestamp": 1681424543}	2023-04-13 22:22:23+00
249396	{"pm10": 34, "pm25": 51, "pm100": 63, "timestamp": 1681424550}	2023-04-13 22:22:30+00
249396	{"pm10": 34, "pm25": 50, "pm100": 61, "timestamp": 1681424556}	2023-04-13 22:22:36+00
249396	{"pm10": 34, "pm25": 50, "pm100": 61, "timestamp": 1681424562}	2023-04-13 22:22:42+00
249396	{"pm10": 32, "pm25": 48, "pm100": 59, "timestamp": 1681424568}	2023-04-13 22:22:48+00
249396	{"pm10": 32, "pm25": 48, "pm100": 58, "timestamp": 1681424574}	2023-04-13 22:22:54+00
249396	{"pm10": 32, "pm25": 48, "pm100": 59, "timestamp": 1681424580}	2023-04-13 22:23:00+00
249396	{"pm10": 34, "pm25": 50, "pm100": 60, "timestamp": 1681424586}	2023-04-13 22:23:06+00
249396	{"pm10": 34, "pm25": 49, "pm100": 60, "timestamp": 1681424592}	2023-04-13 22:23:12+00
249396	{"pm10": 33, "pm25": 51, "pm100": 62, "timestamp": 1681424599}	2023-04-13 22:23:19+00
249396	{"pm10": 33, "pm25": 51, "pm100": 62, "timestamp": 1681424605}	2023-04-13 22:23:25+00
249396	{"pm10": 34, "pm25": 51, "pm100": 63, "timestamp": 1681424611}	2023-04-13 22:23:31+00
249396	{"pm10": 34, "pm25": 48, "pm100": 61, "timestamp": 1681424617}	2023-04-13 22:23:37+00
249396	{"pm10": 34, "pm25": 48, "pm100": 61, "timestamp": 1681424623}	2023-04-13 22:23:43+00
249396	{"pm10": 34, "pm25": 48, "pm100": 60, "timestamp": 1681424629}	2023-04-13 22:23:49+00
249396	{"pm10": 34, "pm25": 48, "pm100": 60, "timestamp": 1681424635}	2023-04-13 22:23:55+00
249396	{"pm10": 34, "pm25": 48, "pm100": 60, "timestamp": 1681424641}	2023-04-13 22:24:01+00
249396	{"pm10": 34, "pm25": 48, "pm100": 60, "timestamp": 1681424648}	2023-04-13 22:24:08+00
249396	{"pm10": 34, "pm25": 48, "pm100": 61, "timestamp": 1681424654}	2023-04-13 22:24:14+00
249396	{"pm10": 34, "pm25": 49, "pm100": 62, "timestamp": 1681424660}	2023-04-13 22:24:20+00
249396	{"pm10": 34, "pm25": 49, "pm100": 62, "timestamp": 1681424666}	2023-04-13 22:24:26+00
249396	{"pm10": 34, "pm25": 49, "pm100": 62, "timestamp": 1681424672}	2023-04-13 22:24:32+00
249396	{"pm10": 33, "pm25": 53, "pm100": 64, "timestamp": 1681424678}	2023-04-13 22:24:38+00
249396	{"pm10": 33, "pm25": 52, "pm100": 64, "timestamp": 1681424684}	2023-04-13 22:24:44+00
249396	{"pm10": 33, "pm25": 53, "pm100": 64, "timestamp": 1681424690}	2023-04-13 22:24:50+00
249396	{"pm10": 34, "pm25": 50, "pm100": 61, "timestamp": 1681424697}	2023-04-13 22:24:57+00
249396	{"pm10": 34, "pm25": 50, "pm100": 61, "timestamp": 1681424703}	2023-04-13 22:25:03+00
249396	{"pm10": 34, "pm25": 50, "pm100": 61, "timestamp": 1681424709}	2023-04-13 22:25:09+00
249396	{"pm10": 35, "pm25": 50, "pm100": 61, "timestamp": 1681424715}	2023-04-13 22:25:15+00
249396	{"pm10": 34, "pm25": 50, "pm100": 61, "timestamp": 1681424721}	2023-04-13 22:25:21+00
249396	{"pm10": 33, "pm25": 49, "pm100": 61, "timestamp": 1681424727}	2023-04-13 22:25:27+00
249396	{"pm10": 33, "pm25": 50, "pm100": 62, "timestamp": 1681424733}	2023-04-13 22:25:33+00
249396	{"pm10": 33, "pm25": 49, "pm100": 61, "timestamp": 1681424740}	2023-04-13 22:25:40+00
249396	{"pm10": 33, "pm25": 50, "pm100": 62, "timestamp": 1681424746}	2023-04-13 22:25:46+00
249396	{"pm10": 32, "pm25": 49, "pm100": 61, "timestamp": 1681424752}	2023-04-13 22:25:52+00
249396	{"pm10": 32, "pm25": 49, "pm100": 61, "timestamp": 1681424758}	2023-04-13 22:25:58+00
249396	{"pm10": 32, "pm25": 49, "pm100": 61, "timestamp": 1681424764}	2023-04-13 22:26:04+00
249396	{"pm10": 33, "pm25": 50, "pm100": 61, "timestamp": 1681424770}	2023-04-13 22:26:10+00
249396	{"pm10": 33, "pm25": 50, "pm100": 61, "timestamp": 1681424776}	2023-04-13 22:26:16+00
249396	{"pm10": 33, "pm25": 50, "pm100": 61, "timestamp": 1681424782}	2023-04-13 22:26:22+00
249396	{"pm10": 34, "pm25": 51, "pm100": 62, "timestamp": 1681424789}	2023-04-13 22:26:29+00
249396	{"pm10": 34, "pm25": 51, "pm100": 62, "timestamp": 1681424795}	2023-04-13 22:26:35+00
249396	{"pm10": 34, "pm25": 50, "pm100": 61, "timestamp": 1681424801}	2023-04-13 22:26:41+00
249396	{"pm10": 33, "pm25": 50, "pm100": 61, "timestamp": 1681424807}	2023-04-13 22:26:47+00
249396	{"pm10": 34, "pm25": 51, "pm100": 62, "timestamp": 1681424813}	2023-04-13 22:26:53+00
249396	{"pm10": 34, "pm25": 50, "pm100": 61, "timestamp": 1681424819}	2023-04-13 22:26:59+00
249396	{"pm10": 34, "pm25": 50, "pm100": 61, "timestamp": 1681424825}	2023-04-13 22:27:05+00
249396	{"pm10": 33, "pm25": 50, "pm100": 60, "timestamp": 1681424831}	2023-04-13 22:27:11+00
249396	{"pm10": 34, "pm25": 50, "pm100": 61, "timestamp": 1681424838}	2023-04-13 22:27:18+00
249396	{"pm10": 33, "pm25": 49, "pm100": 59, "timestamp": 1681424844}	2023-04-13 22:27:24+00
249396	{"pm10": 33, "pm25": 49, "pm100": 59, "timestamp": 1681424850}	2023-04-13 22:27:30+00
249396	{"pm10": 34, "pm25": 49, "pm100": 60, "timestamp": 1681424856}	2023-04-13 22:27:36+00
249396	{"pm10": 34, "pm25": 49, "pm100": 60, "timestamp": 1681424862}	2023-04-13 22:27:42+00
249396	{"pm10": 33, "pm25": 50, "pm100": 61, "timestamp": 1681424868}	2023-04-13 22:27:48+00
249396	{"pm10": 33, "pm25": 50, "pm100": 61, "timestamp": 1681424874}	2023-04-13 22:27:54+00
249396	{"pm10": 32, "pm25": 50, "pm100": 61, "timestamp": 1681424880}	2023-04-13 22:28:00+00
249396	{"pm10": 33, "pm25": 51, "pm100": 62, "timestamp": 1681424887}	2023-04-13 22:28:07+00
249396	{"pm10": 33, "pm25": 51, "pm100": 62, "timestamp": 1681424893}	2023-04-13 22:28:13+00
249396	{"pm10": 33, "pm25": 51, "pm100": 62, "timestamp": 1681424899}	2023-04-13 22:28:19+00
249396	{"pm10": 33, "pm25": 51, "pm100": 62, "timestamp": 1681424905}	2023-04-13 22:28:25+00
249396	{"pm10": 33, "pm25": 51, "pm100": 62, "timestamp": 1681424911}	2023-04-13 22:28:31+00
249396	{"pm10": 33, "pm25": 51, "pm100": 62, "timestamp": 1681424917}	2023-04-13 22:28:37+00
249396	{"pm10": 34, "pm25": 50, "pm100": 61, "timestamp": 1681424923}	2023-04-13 22:28:43+00
249396	{"pm10": 34, "pm25": 50, "pm100": 61, "timestamp": 1681424929}	2023-04-13 22:28:49+00
249396	{"pm10": 34, "pm25": 50, "pm100": 61, "timestamp": 1681424936}	2023-04-13 22:28:56+00
249396	{"pm10": 34, "pm25": 50, "pm100": 61, "timestamp": 1681424942}	2023-04-13 22:29:02+00
249396	{"pm10": 34, "pm25": 50, "pm100": 61, "timestamp": 1681424948}	2023-04-13 22:29:08+00
249396	{"pm10": 32, "pm25": 49, "pm100": 60, "timestamp": 1681424954}	2023-04-13 22:29:14+00
249396	{"pm10": 32, "pm25": 49, "pm100": 60, "timestamp": 1681424960}	2023-04-13 22:29:20+00
249396	{"pm10": 34, "pm25": 50, "pm100": 62, "timestamp": 1681424966}	2023-04-13 22:29:26+00
249396	{"pm10": 34, "pm25": 50, "pm100": 60, "timestamp": 1681424972}	2023-04-13 22:29:32+00
249396	{"pm10": 34, "pm25": 50, "pm100": 61, "timestamp": 1681424978}	2023-04-13 22:29:38+00
249396	{"pm10": 34, "pm25": 51, "pm100": 63, "timestamp": 1681424985}	2023-04-13 22:29:45+00
249396	{"pm10": 34, "pm25": 51, "pm100": 62, "timestamp": 1681424991}	2023-04-13 22:29:51+00
249396	{"pm10": 34, "pm25": 51, "pm100": 62, "timestamp": 1681424997}	2023-04-13 22:29:57+00
249396	{"pm10": 34, "pm25": 51, "pm100": 62, "timestamp": 1681425003}	2023-04-13 22:30:03+00
249396	{"pm10": 33, "pm25": 48, "pm100": 57, "timestamp": 1681425009}	2023-04-13 22:30:09+00
249396	{"pm10": 32, "pm25": 48, "pm100": 57, "timestamp": 1681425015}	2023-04-13 22:30:15+00
249396	{"pm10": 32, "pm25": 47, "pm100": 57, "timestamp": 1681425021}	2023-04-13 22:30:21+00
249396	{"pm10": 32, "pm25": 47, "pm100": 57, "timestamp": 1681425027}	2023-04-13 22:30:27+00
249396	{"pm10": 31, "pm25": 47, "pm100": 57, "timestamp": 1681425034}	2023-04-13 22:30:34+00
249396	{"pm10": 31, "pm25": 47, "pm100": 57, "timestamp": 1681425040}	2023-04-13 22:30:40+00
249396	{"pm10": 31, "pm25": 47, "pm100": 58, "timestamp": 1681425046}	2023-04-13 22:30:46+00
249396	{"pm10": 33, "pm25": 51, "pm100": 63, "timestamp": 1681425052}	2023-04-13 22:30:52+00
249396	{"pm10": 33, "pm25": 51, "pm100": 62, "timestamp": 1681425058}	2023-04-13 22:30:58+00
249396	{"pm10": 32, "pm25": 50, "pm100": 61, "timestamp": 1681425064}	2023-04-13 22:31:04+00
249396	{"pm10": 32, "pm25": 50, "pm100": 61, "timestamp": 1681425070}	2023-04-13 22:31:10+00
249396	{"pm10": 32, "pm25": 49, "pm100": 60, "timestamp": 1681425077}	2023-04-13 22:31:17+00
249396	{"pm10": 32, "pm25": 49, "pm100": 60, "timestamp": 1681425083}	2023-04-13 22:31:23+00
249396	{"pm10": 33, "pm25": 49, "pm100": 60, "timestamp": 1681425089}	2023-04-13 22:31:29+00
249396	{"pm10": 33, "pm25": 49, "pm100": 60, "timestamp": 1681425095}	2023-04-13 22:31:35+00
249396	{"pm10": 32, "pm25": 48, "pm100": 59, "timestamp": 1681425101}	2023-04-13 22:31:41+00
249396	{"pm10": 32, "pm25": 48, "pm100": 60, "timestamp": 1681425107}	2023-04-13 22:31:47+00
249396	{"pm10": 32, "pm25": 48, "pm100": 59, "timestamp": 1681425113}	2023-04-13 22:31:53+00
249396	{"pm10": 32, "pm25": 47, "pm100": 57, "timestamp": 1681425119}	2023-04-13 22:31:59+00
249396	{"pm10": 32, "pm25": 47, "pm100": 57, "timestamp": 1681425126}	2023-04-13 22:32:06+00
249396	{"pm10": 32, "pm25": 47, "pm100": 57, "timestamp": 1681425132}	2023-04-13 22:32:12+00
249396	{"pm10": 32, "pm25": 47, "pm100": 57, "timestamp": 1681425138}	2023-04-13 22:32:18+00
249396	{"pm10": 34, "pm25": 50, "pm100": 61, "timestamp": 1681425144}	2023-04-13 22:32:24+00
249396	{"pm10": 33, "pm25": 49, "pm100": 61, "timestamp": 1681425150}	2023-04-13 22:32:30+00
249396	{"pm10": 33, "pm25": 49, "pm100": 61, "timestamp": 1681425156}	2023-04-13 22:32:36+00
249396	{"pm10": 33, "pm25": 47, "pm100": 58, "timestamp": 1681425162}	2023-04-13 22:32:42+00
249396	{"pm10": 33, "pm25": 47, "pm100": 58, "timestamp": 1681425168}	2023-04-13 22:32:48+00
249396	{"pm10": 33, "pm25": 46, "pm100": 57, "timestamp": 1681425175}	2023-04-13 22:32:55+00
249396	{"pm10": 33, "pm25": 46, "pm100": 57, "timestamp": 1681425181}	2023-04-13 22:33:01+00
249396	{"pm10": 34, "pm25": 51, "pm100": 62, "timestamp": 1681425187}	2023-04-13 22:33:07+00
249396	{"pm10": 33, "pm25": 51, "pm100": 63, "timestamp": 1681425193}	2023-04-13 22:33:13+00
249396	{"pm10": 33, "pm25": 51, "pm100": 62, "timestamp": 1681425199}	2023-04-13 22:33:19+00
249396	{"pm10": 33, "pm25": 51, "pm100": 62, "timestamp": 1681425205}	2023-04-13 22:33:25+00
249396	{"pm10": 33, "pm25": 50, "pm100": 60, "timestamp": 1681425211}	2023-04-13 22:33:31+00
249396	{"pm10": 33, "pm25": 49, "pm100": 59, "timestamp": 1681425217}	2023-04-13 22:33:37+00
249396	{"pm10": 32, "pm25": 47, "pm100": 57, "timestamp": 1681425224}	2023-04-13 22:33:44+00
249396	{"pm10": 32, "pm25": 47, "pm100": 57, "timestamp": 1681425230}	2023-04-13 22:33:50+00
249396	{"pm10": 32, "pm25": 47, "pm100": 57, "timestamp": 1681425236}	2023-04-13 22:33:56+00
249396	{"pm10": 32, "pm25": 50, "pm100": 61, "timestamp": 1681425242}	2023-04-13 22:34:02+00
249396	{"pm10": 32, "pm25": 47, "pm100": 57, "timestamp": 1681425248}	2023-04-13 22:34:08+00
249396	{"pm10": 32, "pm25": 47, "pm100": 58, "timestamp": 1681425254}	2023-04-13 22:34:14+00
249396	{"pm10": 32, "pm25": 47, "pm100": 58, "timestamp": 1681425260}	2023-04-13 22:34:20+00
249396	{"pm10": 33, "pm25": 48, "pm100": 60, "timestamp": 1681425266}	2023-04-13 22:34:26+00
249396	{"pm10": 33, "pm25": 48, "pm100": 60, "timestamp": 1681425273}	2023-04-13 22:34:33+00
249396	{"pm10": 32, "pm25": 50, "pm100": 61, "timestamp": 1681425279}	2023-04-13 22:34:39+00
249396	{"pm10": 32, "pm25": 50, "pm100": 60, "timestamp": 1681425285}	2023-04-13 22:34:45+00
249396	{"pm10": 32, "pm25": 50, "pm100": 61, "timestamp": 1681425291}	2023-04-13 22:34:51+00
249396	{"pm10": 33, "pm25": 49, "pm100": 60, "timestamp": 1681425297}	2023-04-13 22:34:57+00
249396	{"pm10": 34, "pm25": 51, "pm100": 62, "timestamp": 1681425303}	2023-04-13 22:35:03+00
249396	{"pm10": 34, "pm25": 50, "pm100": 62, "timestamp": 1681425309}	2023-04-13 22:35:09+00
249396	{"pm10": 32, "pm25": 48, "pm100": 59, "timestamp": 1681425315}	2023-04-13 22:35:15+00
249396	{"pm10": 32, "pm25": 49, "pm100": 61, "timestamp": 1681425322}	2023-04-13 22:35:22+00
249396	{"pm10": 32, "pm25": 49, "pm100": 61, "timestamp": 1681425328}	2023-04-13 22:35:28+00
249396	{"pm10": 33, "pm25": 48, "pm100": 58, "timestamp": 1681425334}	2023-04-13 22:35:34+00
249396	{"pm10": 33, "pm25": 48, "pm100": 58, "timestamp": 1681425340}	2023-04-13 22:35:40+00
249396	{"pm10": 33, "pm25": 51, "pm100": 62, "timestamp": 1681425346}	2023-04-13 22:35:46+00
249396	{"pm10": 33, "pm25": 51, "pm100": 62, "timestamp": 1681425352}	2023-04-13 22:35:52+00
249396	{"pm10": 33, "pm25": 51, "pm100": 62, "timestamp": 1681425358}	2023-04-13 22:35:58+00
249396	{"pm10": 33, "pm25": 50, "pm100": 61, "timestamp": 1681425365}	2023-04-13 22:36:05+00
249396	{"pm10": 33, "pm25": 50, "pm100": 61, "timestamp": 1681425371}	2023-04-13 22:36:11+00
249396	{"pm10": 33, "pm25": 50, "pm100": 61, "timestamp": 1681425377}	2023-04-13 22:36:17+00
249396	{"pm10": 32, "pm25": 49, "pm100": 60, "timestamp": 1681425383}	2023-04-13 22:36:23+00
249396	{"pm10": 34, "pm25": 50, "pm100": 62, "timestamp": 1681425389}	2023-04-13 22:36:29+00
249396	{"pm10": 34, "pm25": 50, "pm100": 61, "timestamp": 1681425395}	2023-04-13 22:36:35+00
249396	{"pm10": 33, "pm25": 50, "pm100": 62, "timestamp": 1681425401}	2023-04-13 22:36:41+00
249396	{"pm10": 31, "pm25": 47, "pm100": 58, "timestamp": 1681425407}	2023-04-13 22:36:47+00
249396	{"pm10": 31, "pm25": 47, "pm100": 57, "timestamp": 1681425414}	2023-04-13 22:36:54+00
249396	{"pm10": 33, "pm25": 50, "pm100": 62, "timestamp": 1681425420}	2023-04-13 22:37:00+00
249396	{"pm10": 33, "pm25": 50, "pm100": 61, "timestamp": 1681425426}	2023-04-13 22:37:06+00
249396	{"pm10": 33, "pm25": 50, "pm100": 61, "timestamp": 1681425432}	2023-04-13 22:37:12+00
249396	{"pm10": 33, "pm25": 50, "pm100": 61, "timestamp": 1681425438}	2023-04-13 22:37:18+00
249396	{"pm10": 33, "pm25": 49, "pm100": 60, "timestamp": 1681425444}	2023-04-13 22:37:24+00
249396	{"pm10": 33, "pm25": 49, "pm100": 59, "timestamp": 1681425450}	2023-04-13 22:37:30+00
249396	{"pm10": 33, "pm25": 51, "pm100": 62, "timestamp": 1681425456}	2023-04-13 22:37:36+00
249396	{"pm10": 33, "pm25": 51, "pm100": 62, "timestamp": 1681425463}	2023-04-13 22:37:43+00
249396	{"pm10": 33, "pm25": 51, "pm100": 62, "timestamp": 1681425469}	2023-04-13 22:37:49+00
249396	{"pm10": 33, "pm25": 51, "pm100": 62, "timestamp": 1681425475}	2023-04-13 22:37:55+00
249396	{"pm10": 33, "pm25": 51, "pm100": 62, "timestamp": 1681425481}	2023-04-13 22:38:01+00
249396	{"pm10": 33, "pm25": 50, "pm100": 61, "timestamp": 1681425487}	2023-04-13 22:38:07+00
249396	{"pm10": 33, "pm25": 49, "pm100": 60, "timestamp": 1681425493}	2023-04-13 22:38:13+00
249396	{"pm10": 33, "pm25": 48, "pm100": 58, "timestamp": 1681425499}	2023-04-13 22:38:19+00
249396	{"pm10": 33, "pm25": 48, "pm100": 58, "timestamp": 1681425505}	2023-04-13 22:38:25+00
249396	{"pm10": 33, "pm25": 48, "pm100": 59, "timestamp": 1681425512}	2023-04-13 22:38:32+00
249396	{"pm10": 33, "pm25": 48, "pm100": 58, "timestamp": 1681425518}	2023-04-13 22:38:38+00
249396	{"pm10": 33, "pm25": 48, "pm100": 58, "timestamp": 1681425524}	2023-04-13 22:38:44+00
249396	{"pm10": 33, "pm25": 48, "pm100": 58, "timestamp": 1681425530}	2023-04-13 22:38:50+00
249396	{"pm10": 33, "pm25": 48, "pm100": 58, "timestamp": 1681425536}	2023-04-13 22:38:56+00
249396	{"pm10": 32, "pm25": 48, "pm100": 58, "timestamp": 1681425542}	2023-04-13 22:39:02+00
249396	{"pm10": 33, "pm25": 51, "pm100": 62, "timestamp": 1681425548}	2023-04-13 22:39:08+00
249396	{"pm10": 33, "pm25": 51, "pm100": 62, "timestamp": 1681425554}	2023-04-13 22:39:14+00
249396	{"pm10": 33, "pm25": 51, "pm100": 62, "timestamp": 1681425561}	2023-04-13 22:39:21+00
249396	{"pm10": 33, "pm25": 51, "pm100": 62, "timestamp": 1681425567}	2023-04-13 22:39:27+00
249396	{"pm10": 34, "pm25": 49, "pm100": 59, "timestamp": 1681425573}	2023-04-13 22:39:33+00
249396	{"pm10": 34, "pm25": 49, "pm100": 60, "timestamp": 1681425579}	2023-04-13 22:39:39+00
249396	{"pm10": 34, "pm25": 49, "pm100": 59, "timestamp": 1681425585}	2023-04-13 22:39:45+00
249396	{"pm10": 34, "pm25": 49, "pm100": 60, "timestamp": 1681425591}	2023-04-13 22:39:51+00
249396	{"pm10": 33, "pm25": 49, "pm100": 60, "timestamp": 1681425597}	2023-04-13 22:39:57+00
249396	{"pm10": 33, "pm25": 49, "pm100": 59, "timestamp": 1681425603}	2023-04-13 22:40:03+00
249396	{"pm10": 33, "pm25": 49, "pm100": 61, "timestamp": 1681425610}	2023-04-13 22:40:10+00
249396	{"pm10": 33, "pm25": 50, "pm100": 61, "timestamp": 1681425616}	2023-04-13 22:40:16+00
249396	{"pm10": 33, "pm25": 50, "pm100": 61, "timestamp": 1681425622}	2023-04-13 22:40:22+00
249396	{"pm10": 33, "pm25": 49, "pm100": 60, "timestamp": 1681425628}	2023-04-13 22:40:28+00
249396	{"pm10": 33, "pm25": 49, "pm100": 60, "timestamp": 1681425634}	2023-04-13 22:40:34+00
249396	{"pm10": 33, "pm25": 49, "pm100": 60, "timestamp": 1681425640}	2023-04-13 22:40:40+00
249396	{"pm10": 33, "pm25": 49, "pm100": 60, "timestamp": 1681425646}	2023-04-13 22:40:46+00
249396	{"pm10": 33, "pm25": 48, "pm100": 60, "timestamp": 1681425652}	2023-04-13 22:40:52+00
249396	{"pm10": 33, "pm25": 48, "pm100": 60, "timestamp": 1681425659}	2023-04-13 22:40:59+00
249396	{"pm10": 33, "pm25": 48, "pm100": 58, "timestamp": 1681425665}	2023-04-13 22:41:05+00
249396	{"pm10": 33, "pm25": 49, "pm100": 59, "timestamp": 1681425671}	2023-04-13 22:41:11+00
249396	{"pm10": 33, "pm25": 49, "pm100": 60, "timestamp": 1681425677}	2023-04-13 22:41:17+00
249396	{"pm10": 33, "pm25": 48, "pm100": 58, "timestamp": 1681425683}	2023-04-13 22:41:23+00
249396	{"pm10": 32, "pm25": 48, "pm100": 59, "timestamp": 1681425689}	2023-04-13 22:41:29+00
249396	{"pm10": 33, "pm25": 50, "pm100": 61, "timestamp": 1681425695}	2023-04-13 22:41:35+00
249396	{"pm10": 33, "pm25": 51, "pm100": 61, "timestamp": 1681425701}	2023-04-13 22:41:41+00
249396	{"pm10": 33, "pm25": 51, "pm100": 62, "timestamp": 1681425708}	2023-04-13 22:41:48+00
249396	{"pm10": 33, "pm25": 50, "pm100": 60, "timestamp": 1681425714}	2023-04-13 22:41:54+00
249396	{"pm10": 32, "pm25": 48, "pm100": 60, "timestamp": 1681425720}	2023-04-13 22:42:00+00
249396	{"pm10": 32, "pm25": 47, "pm100": 59, "timestamp": 1681425726}	2023-04-13 22:42:06+00
249396	{"pm10": 32, "pm25": 50, "pm100": 60, "timestamp": 1681425732}	2023-04-13 22:42:12+00
249396	{"pm10": 32, "pm25": 48, "pm100": 59, "timestamp": 1681425738}	2023-04-13 22:42:18+00
249396	{"pm10": 31, "pm25": 47, "pm100": 57, "timestamp": 1681425744}	2023-04-13 22:42:24+00
249396	{"pm10": 32, "pm25": 47, "pm100": 57, "timestamp": 1681425750}	2023-04-13 22:42:30+00
249396	{"pm10": 32, "pm25": 47, "pm100": 57, "timestamp": 1681425757}	2023-04-13 22:42:37+00
249396	{"pm10": 32, "pm25": 50, "pm100": 61, "timestamp": 1681425763}	2023-04-13 22:42:43+00
249396	{"pm10": 31, "pm25": 49, "pm100": 60, "timestamp": 1681425769}	2023-04-13 22:42:49+00
249396	{"pm10": 32, "pm25": 49, "pm100": 61, "timestamp": 1681425775}	2023-04-13 22:42:55+00
249396	{"pm10": 33, "pm25": 50, "pm100": 62, "timestamp": 1681425781}	2023-04-13 22:43:01+00
249396	{"pm10": 33, "pm25": 49, "pm100": 61, "timestamp": 1681425787}	2023-04-13 22:43:07+00
249396	{"pm10": 33, "pm25": 50, "pm100": 60, "timestamp": 1681425793}	2023-04-13 22:43:13+00
249396	{"pm10": 33, "pm25": 49, "pm100": 60, "timestamp": 1681425799}	2023-04-13 22:43:19+00
249396	{"pm10": 33, "pm25": 49, "pm100": 59, "timestamp": 1681425806}	2023-04-13 22:43:26+00
249396	{"pm10": 33, "pm25": 49, "pm100": 59, "timestamp": 1681425812}	2023-04-13 22:43:32+00
249396	{"pm10": 33, "pm25": 49, "pm100": 60, "timestamp": 1681425818}	2023-04-13 22:43:38+00
249396	{"pm10": 32, "pm25": 48, "pm100": 57, "timestamp": 1681425824}	2023-04-13 22:43:44+00
249396	{"pm10": 32, "pm25": 48, "pm100": 57, "timestamp": 1681425830}	2023-04-13 22:43:50+00
249396	{"pm10": 32, "pm25": 48, "pm100": 58, "timestamp": 1681425836}	2023-04-13 22:43:56+00
249396	{"pm10": 32, "pm25": 48, "pm100": 58, "timestamp": 1681425842}	2023-04-13 22:44:02+00
249396	{"pm10": 32, "pm25": 48, "pm100": 59, "timestamp": 1681425849}	2023-04-13 22:44:09+00
249396	{"pm10": 30, "pm25": 47, "pm100": 58, "timestamp": 1681425855}	2023-04-13 22:44:15+00
249396	{"pm10": 30, "pm25": 47, "pm100": 58, "timestamp": 1681425861}	2023-04-13 22:44:21+00
249396	{"pm10": 30, "pm25": 47, "pm100": 57, "timestamp": 1681425867}	2023-04-13 22:44:27+00
249396	{"pm10": 31, "pm25": 48, "pm100": 58, "timestamp": 1681425873}	2023-04-13 22:44:33+00
249396	{"pm10": 31, "pm25": 48, "pm100": 58, "timestamp": 1681425879}	2023-04-13 22:44:39+00
249396	{"pm10": 31, "pm25": 48, "pm100": 58, "timestamp": 1681425885}	2023-04-13 22:44:45+00
249396	{"pm10": 31, "pm25": 48, "pm100": 58, "timestamp": 1681425891}	2023-04-13 22:44:51+00
249396	{"pm10": 31, "pm25": 48, "pm100": 58, "timestamp": 1681425898}	2023-04-13 22:44:58+00
249396	{"pm10": 31, "pm25": 48, "pm100": 59, "timestamp": 1681425904}	2023-04-13 22:45:04+00
249396	{"pm10": 32, "pm25": 49, "pm100": 59, "timestamp": 1681425910}	2023-04-13 22:45:10+00
249396	{"pm10": 32, "pm25": 49, "pm100": 59, "timestamp": 1681425916}	2023-04-13 22:45:16+00
249396	{"pm10": 32, "pm25": 49, "pm100": 59, "timestamp": 1681425922}	2023-04-13 22:45:22+00
249396	{"pm10": 32, "pm25": 49, "pm100": 59, "timestamp": 1681425928}	2023-04-13 22:45:28+00
249396	{"pm10": 32, "pm25": 48, "pm100": 57, "timestamp": 1681425934}	2023-04-13 22:45:34+00
249396	{"pm10": 33, "pm25": 50, "pm100": 60, "timestamp": 1681425940}	2023-04-13 22:45:40+00
249396	{"pm10": 32, "pm25": 49, "pm100": 60, "timestamp": 1681425947}	2023-04-13 22:45:47+00
249396	{"pm10": 32, "pm25": 49, "pm100": 59, "timestamp": 1681425953}	2023-04-13 22:45:53+00
249396	{"pm10": 32, "pm25": 48, "pm100": 59, "timestamp": 1681425959}	2023-04-13 22:45:59+00
249396	{"pm10": 32, "pm25": 48, "pm100": 59, "timestamp": 1681425965}	2023-04-13 22:46:05+00
249396	{"pm10": 32, "pm25": 49, "pm100": 60, "timestamp": 1681425971}	2023-04-13 22:46:11+00
249396	{"pm10": 32, "pm25": 49, "pm100": 60, "timestamp": 1681425977}	2023-04-13 22:46:17+00
249396	{"pm10": 31, "pm25": 48, "pm100": 59, "timestamp": 1681425983}	2023-04-13 22:46:23+00
249396	{"pm10": 31, "pm25": 48, "pm100": 59, "timestamp": 1681425989}	2023-04-13 22:46:29+00
249396	{"pm10": 31, "pm25": 48, "pm100": 59, "timestamp": 1681425996}	2023-04-13 22:46:36+00
249396	{"pm10": 32, "pm25": 50, "pm100": 60, "timestamp": 1681426002}	2023-04-13 22:46:42+00
249396	{"pm10": 32, "pm25": 50, "pm100": 60, "timestamp": 1681426008}	2023-04-13 22:46:48+00
249396	{"pm10": 31, "pm25": 47, "pm100": 57, "timestamp": 1681426014}	2023-04-13 22:46:54+00
249396	{"pm10": 32, "pm25": 47, "pm100": 57, "timestamp": 1681426020}	2023-04-13 22:47:00+00
249396	{"pm10": 32, "pm25": 47, "pm100": 57, "timestamp": 1681426026}	2023-04-13 22:47:06+00
249396	{"pm10": 31, "pm25": 47, "pm100": 56, "timestamp": 1681426032}	2023-04-13 22:47:12+00
249396	{"pm10": 31, "pm25": 47, "pm100": 56, "timestamp": 1681426038}	2023-04-13 22:47:18+00
249396	{"pm10": 33, "pm25": 49, "pm100": 59, "timestamp": 1681426045}	2023-04-13 22:47:25+00
249396	{"pm10": 33, "pm25": 49, "pm100": 60, "timestamp": 1681426051}	2023-04-13 22:47:31+00
249396	{"pm10": 32, "pm25": 47, "pm100": 58, "timestamp": 1681426057}	2023-04-13 22:47:37+00
249396	{"pm10": 32, "pm25": 47, "pm100": 57, "timestamp": 1681426063}	2023-04-13 22:47:43+00
249396	{"pm10": 32, "pm25": 47, "pm100": 57, "timestamp": 1681426069}	2023-04-13 22:47:49+00
249396	{"pm10": 32, "pm25": 47, "pm100": 58, "timestamp": 1681426075}	2023-04-13 22:47:55+00
249396	{"pm10": 32, "pm25": 47, "pm100": 58, "timestamp": 1681426082}	2023-04-13 22:48:02+00
249396	{"pm10": 33, "pm25": 48, "pm100": 59, "timestamp": 1681426088}	2023-04-13 22:48:08+00
249396	{"pm10": 33, "pm25": 48, "pm100": 58, "timestamp": 1681426094}	2023-04-13 22:48:14+00
249396	{"pm10": 33, "pm25": 48, "pm100": 58, "timestamp": 1681426100}	2023-04-13 22:48:20+00
249396	{"pm10": 32, "pm25": 48, "pm100": 58, "timestamp": 1681426106}	2023-04-13 22:48:26+00
249396	{"pm10": 32, "pm25": 48, "pm100": 58, "timestamp": 1681426113}	2023-04-13 22:48:33+00
249396	{"pm10": 32, "pm25": 47, "pm100": 57, "timestamp": 1681426119}	2023-04-13 22:48:39+00
249396	{"pm10": 32, "pm25": 47, "pm100": 57, "timestamp": 1681426125}	2023-04-13 22:48:45+00
249396	{"pm10": 32, "pm25": 48, "pm100": 58, "timestamp": 1681426131}	2023-04-13 22:48:51+00
249396	{"pm10": 33, "pm25": 49, "pm100": 59, "timestamp": 1681426137}	2023-04-13 22:48:57+00
249396	{"pm10": 33, "pm25": 49, "pm100": 59, "timestamp": 1681426143}	2023-04-13 22:49:03+00
249396	{"pm10": 33, "pm25": 49, "pm100": 60, "timestamp": 1681426149}	2023-04-13 22:49:09+00
249396	{"pm10": 33, "pm25": 49, "pm100": 60, "timestamp": 1681426155}	2023-04-13 22:49:15+00
249396	{"pm10": 33, "pm25": 49, "pm100": 59, "timestamp": 1681426162}	2023-04-13 22:49:22+00
249396	{"pm10": 32, "pm25": 49, "pm100": 60, "timestamp": 1681426168}	2023-04-13 22:49:28+00
249396	{"pm10": 32, "pm25": 49, "pm100": 60, "timestamp": 1681426174}	2023-04-13 22:49:34+00
249396	{"pm10": 32, "pm25": 48, "pm100": 58, "timestamp": 1681426180}	2023-04-13 22:49:40+00
249396	{"pm10": 33, "pm25": 48, "pm100": 58, "timestamp": 1681426186}	2023-04-13 22:49:46+00
249396	{"pm10": 33, "pm25": 49, "pm100": 60, "timestamp": 1681426192}	2023-04-13 22:49:52+00
249396	{"pm10": 33, "pm25": 48, "pm100": 60, "timestamp": 1681426198}	2023-04-13 22:49:58+00
249396	{"pm10": 32, "pm25": 47, "pm100": 57, "timestamp": 1681426204}	2023-04-13 22:50:04+00
249396	{"pm10": 33, "pm25": 47, "pm100": 56, "timestamp": 1681426211}	2023-04-13 22:50:11+00
249396	{"pm10": 33, "pm25": 47, "pm100": 56, "timestamp": 1681426217}	2023-04-13 22:50:17+00
249396	{"pm10": 33, "pm25": 48, "pm100": 57, "timestamp": 1681426223}	2023-04-13 22:50:23+00
249396	{"pm10": 32, "pm25": 47, "pm100": 56, "timestamp": 1681426229}	2023-04-13 22:50:29+00
249396	{"pm10": 32, "pm25": 47, "pm100": 56, "timestamp": 1681426235}	2023-04-13 22:50:35+00
249396	{"pm10": 32, "pm25": 46, "pm100": 56, "timestamp": 1681426241}	2023-04-13 22:50:41+00
249396	{"pm10": 31, "pm25": 46, "pm100": 55, "timestamp": 1681426247}	2023-04-13 22:50:47+00
249396	{"pm10": 31, "pm25": 45, "pm100": 55, "timestamp": 1681426253}	2023-04-13 22:50:53+00
249396	{"pm10": 31, "pm25": 46, "pm100": 56, "timestamp": 1681426260}	2023-04-13 22:51:00+00
249396	{"pm10": 31, "pm25": 47, "pm100": 58, "timestamp": 1681426266}	2023-04-13 22:51:06+00
249396	{"pm10": 31, "pm25": 47, "pm100": 57, "timestamp": 1681426272}	2023-04-13 22:51:12+00
249396	{"pm10": 32, "pm25": 48, "pm100": 59, "timestamp": 1681426278}	2023-04-13 22:51:18+00
249396	{"pm10": 32, "pm25": 48, "pm100": 57, "timestamp": 1681426284}	2023-04-13 22:51:24+00
249396	{"pm10": 32, "pm25": 48, "pm100": 58, "timestamp": 1681426290}	2023-04-13 22:51:30+00
249396	{"pm10": 33, "pm25": 48, "pm100": 58, "timestamp": 1681426296}	2023-04-13 22:51:36+00
249396	{"pm10": 32, "pm25": 48, "pm100": 58, "timestamp": 1681426303}	2023-04-13 22:51:43+00
249396	{"pm10": 32, "pm25": 48, "pm100": 59, "timestamp": 1681426309}	2023-04-13 22:51:49+00
249396	{"pm10": 32, "pm25": 49, "pm100": 60, "timestamp": 1681426315}	2023-04-13 22:51:55+00
249396	{"pm10": 33, "pm25": 49, "pm100": 60, "timestamp": 1681426321}	2023-04-13 22:52:01+00
249396	{"pm10": 32, "pm25": 49, "pm100": 60, "timestamp": 1681426327}	2023-04-13 22:52:07+00
249396	{"pm10": 33, "pm25": 50, "pm100": 61, "timestamp": 1681426333}	2023-04-13 22:52:13+00
249396	{"pm10": 33, "pm25": 50, "pm100": 61, "timestamp": 1681426339}	2023-04-13 22:52:19+00
249396	{"pm10": 34, "pm25": 50, "pm100": 61, "timestamp": 1681426345}	2023-04-13 22:52:25+00
249396	{"pm10": 34, "pm25": 50, "pm100": 61, "timestamp": 1681426352}	2023-04-13 22:52:32+00
249396	{"pm10": 33, "pm25": 50, "pm100": 61, "timestamp": 1681426358}	2023-04-13 22:52:38+00
249396	{"pm10": 33, "pm25": 50, "pm100": 60, "timestamp": 1681426364}	2023-04-13 22:52:44+00
249396	{"pm10": 32, "pm25": 48, "pm100": 59, "timestamp": 1681426370}	2023-04-13 22:52:50+00
249396	{"pm10": 32, "pm25": 48, "pm100": 59, "timestamp": 1681426376}	2023-04-13 22:52:56+00
249396	{"pm10": 32, "pm25": 48, "pm100": 60, "timestamp": 1681426382}	2023-04-13 22:53:02+00
249396	{"pm10": 32, "pm25": 49, "pm100": 60, "timestamp": 1681426388}	2023-04-13 22:53:08+00
249396	{"pm10": 32, "pm25": 49, "pm100": 60, "timestamp": 1681426394}	2023-04-13 22:53:14+00
249396	{"pm10": 32, "pm25": 49, "pm100": 60, "timestamp": 1681426401}	2023-04-13 22:53:21+00
249396	{"pm10": 32, "pm25": 48, "pm100": 60, "timestamp": 1681426407}	2023-04-13 22:53:27+00
249396	{"pm10": 31, "pm25": 48, "pm100": 58, "timestamp": 1681426413}	2023-04-13 22:53:33+00
249396	{"pm10": 31, "pm25": 48, "pm100": 59, "timestamp": 1681426419}	2023-04-13 22:53:39+00
249396	{"pm10": 32, "pm25": 48, "pm100": 57, "timestamp": 1681426425}	2023-04-13 22:53:45+00
249396	{"pm10": 32, "pm25": 48, "pm100": 57, "timestamp": 1681426431}	2023-04-13 22:53:51+00
249396	{"pm10": 32, "pm25": 47, "pm100": 56, "timestamp": 1681426437}	2023-04-13 22:53:57+00
249396	{"pm10": 32, "pm25": 47, "pm100": 56, "timestamp": 1681426443}	2023-04-13 22:54:03+00
249396	{"pm10": 32, "pm25": 47, "pm100": 56, "timestamp": 1681426450}	2023-04-13 22:54:10+00
249396	{"pm10": 32, "pm25": 47, "pm100": 56, "timestamp": 1681426456}	2023-04-13 22:54:16+00
249396	{"pm10": 33, "pm25": 47, "pm100": 56, "timestamp": 1681426462}	2023-04-13 22:54:22+00
249396	{"pm10": 32, "pm25": 50, "pm100": 61, "timestamp": 1681426468}	2023-04-13 22:54:28+00
249396	{"pm10": 33, "pm25": 50, "pm100": 62, "timestamp": 1681426474}	2023-04-13 22:54:34+00
249396	{"pm10": 31, "pm25": 46, "pm100": 57, "timestamp": 1681426484}	2023-04-13 22:54:44+00
249396	{"pm10": 31, "pm25": 46, "pm100": 57, "timestamp": 1681426490}	2023-04-13 22:54:50+00
249396	{"pm10": 31, "pm25": 46, "pm100": 59, "timestamp": 1681426496}	2023-04-13 22:54:56+00
249396	{"pm10": 32, "pm25": 48, "pm100": 60, "timestamp": 1681426503}	2023-04-13 22:55:03+00
249396	{"pm10": 32, "pm25": 48, "pm100": 59, "timestamp": 1681426509}	2023-04-13 22:55:09+00
249396	{"pm10": 33, "pm25": 49, "pm100": 60, "timestamp": 1681426515}	2023-04-13 22:55:15+00
249396	{"pm10": 33, "pm25": 49, "pm100": 59, "timestamp": 1681426521}	2023-04-13 22:55:21+00
249396	{"pm10": 33, "pm25": 49, "pm100": 59, "timestamp": 1681426527}	2023-04-13 22:55:27+00
249396	{"pm10": 33, "pm25": 48, "pm100": 58, "timestamp": 1681426533}	2023-04-13 22:55:33+00
249396	{"pm10": 33, "pm25": 48, "pm100": 60, "timestamp": 1681426539}	2023-04-13 22:55:39+00
249396	{"pm10": 32, "pm25": 47, "pm100": 58, "timestamp": 1681426545}	2023-04-13 22:55:45+00
249396	{"pm10": 32, "pm25": 47, "pm100": 57, "timestamp": 1681426552}	2023-04-13 22:55:52+00
249396	{"pm10": 31, "pm25": 48, "pm100": 59, "timestamp": 1681426558}	2023-04-13 22:55:58+00
249396	{"pm10": 31, "pm25": 47, "pm100": 58, "timestamp": 1681426564}	2023-04-13 22:56:04+00
249396	{"pm10": 32, "pm25": 48, "pm100": 57, "timestamp": 1681426570}	2023-04-13 22:56:10+00
249396	{"pm10": 32, "pm25": 47, "pm100": 57, "timestamp": 1681426576}	2023-04-13 22:56:16+00
249396	{"pm10": 32, "pm25": 49, "pm100": 60, "timestamp": 1681426582}	2023-04-13 22:56:22+00
249396	{"pm10": 33, "pm25": 48, "pm100": 58, "timestamp": 1681426588}	2023-04-13 22:56:28+00
249396	{"pm10": 33, "pm25": 48, "pm100": 57, "timestamp": 1681426594}	2023-04-13 22:56:34+00
249396	{"pm10": 33, "pm25": 48, "pm100": 57, "timestamp": 1681426601}	2023-04-13 22:56:41+00
249396	{"pm10": 33, "pm25": 47, "pm100": 57, "timestamp": 1681426607}	2023-04-13 22:56:47+00
249396	{"pm10": 33, "pm25": 47, "pm100": 57, "timestamp": 1681426613}	2023-04-13 22:56:53+00
249396	{"pm10": 32, "pm25": 47, "pm100": 57, "timestamp": 1681426619}	2023-04-13 22:56:59+00
249396	{"pm10": 33, "pm25": 48, "pm100": 58, "timestamp": 1681426625}	2023-04-13 22:57:05+00
249396	{"pm10": 33, "pm25": 48, "pm100": 58, "timestamp": 1681426631}	2023-04-13 22:57:11+00
249396	{"pm10": 32, "pm25": 48, "pm100": 58, "timestamp": 1681426637}	2023-04-13 22:57:17+00
249396	{"pm10": 32, "pm25": 48, "pm100": 58, "timestamp": 1681426643}	2023-04-13 22:57:23+00
249396	{"pm10": 32, "pm25": 48, "pm100": 58, "timestamp": 1681426650}	2023-04-13 22:57:30+00
249396	{"pm10": 32, "pm25": 48, "pm100": 58, "timestamp": 1681426656}	2023-04-13 22:57:36+00
249396	{"pm10": 32, "pm25": 48, "pm100": 58, "timestamp": 1681426662}	2023-04-13 22:57:42+00
249396	{"pm10": 33, "pm25": 48, "pm100": 59, "timestamp": 1681426668}	2023-04-13 22:57:48+00
249396	{"pm10": 33, "pm25": 48, "pm100": 60, "timestamp": 1681426674}	2023-04-13 22:57:54+00
249396	{"pm10": 33, "pm25": 49, "pm100": 62, "timestamp": 1681426680}	2023-04-13 22:58:00+00
249396	{"pm10": 32, "pm25": 49, "pm100": 60, "timestamp": 1681426686}	2023-04-13 22:58:06+00
249396	{"pm10": 32, "pm25": 49, "pm100": 60, "timestamp": 1681426692}	2023-04-13 22:58:12+00
249396	{"pm10": 32, "pm25": 49, "pm100": 60, "timestamp": 1681426699}	2023-04-13 22:58:19+00
249396	{"pm10": 32, "pm25": 49, "pm100": 60, "timestamp": 1681426705}	2023-04-13 22:58:25+00
249396	{"pm10": 33, "pm25": 49, "pm100": 60, "timestamp": 1681426711}	2023-04-13 22:58:31+00
249396	{"pm10": 33, "pm25": 50, "pm100": 61, "timestamp": 1681426717}	2023-04-13 22:58:37+00
249396	{"pm10": 33, "pm25": 49, "pm100": 60, "timestamp": 1681426723}	2023-04-13 22:58:43+00
249396	{"pm10": 33, "pm25": 49, "pm100": 60, "timestamp": 1681426729}	2023-04-13 22:58:49+00
249396	{"pm10": 33, "pm25": 49, "pm100": 61, "timestamp": 1681426735}	2023-04-13 22:58:55+00
249396	{"pm10": 33, "pm25": 49, "pm100": 61, "timestamp": 1681426741}	2023-04-13 22:59:01+00
249396	{"pm10": 33, "pm25": 48, "pm100": 60, "timestamp": 1681426748}	2023-04-13 22:59:08+00
249396	{"pm10": 32, "pm25": 48, "pm100": 60, "timestamp": 1681426754}	2023-04-13 22:59:14+00
249396	{"pm10": 32, "pm25": 48, "pm100": 59, "timestamp": 1681426760}	2023-04-13 22:59:20+00
249396	{"pm10": 32, "pm25": 48, "pm100": 59, "timestamp": 1681426766}	2023-04-13 22:59:26+00
249396	{"pm10": 33, "pm25": 48, "pm100": 58, "timestamp": 1681426772}	2023-04-13 22:59:32+00
249396	{"pm10": 31, "pm25": 47, "pm100": 57, "timestamp": 1681426778}	2023-04-13 22:59:38+00
249396	{"pm10": 31, "pm25": 48, "pm100": 57, "timestamp": 1681426784}	2023-04-13 22:59:44+00
249396	{"pm10": 31, "pm25": 48, "pm100": 57, "timestamp": 1681426791}	2023-04-13 22:59:51+00
249396	{"pm10": 31, "pm25": 47, "pm100": 57, "timestamp": 1681426797}	2023-04-13 22:59:57+00
249396	{"pm10": 31, "pm25": 47, "pm100": 57, "timestamp": 1681426803}	2023-04-13 23:00:03+00
249396	{"pm10": 32, "pm25": 48, "pm100": 58, "timestamp": 1681426809}	2023-04-13 23:00:09+00
249396	{"pm10": 33, "pm25": 49, "pm100": 60, "timestamp": 1681426815}	2023-04-13 23:00:15+00
249396	{"pm10": 33, "pm25": 50, "pm100": 60, "timestamp": 1681426821}	2023-04-13 23:00:21+00
249396	{"pm10": 34, "pm25": 50, "pm100": 61, "timestamp": 1681426827}	2023-04-13 23:00:27+00
249396	{"pm10": 33, "pm25": 49, "pm100": 60, "timestamp": 1681426833}	2023-04-13 23:00:33+00
249396	{"pm10": 33, "pm25": 50, "pm100": 61, "timestamp": 1681426840}	2023-04-13 23:00:40+00
249396	{"pm10": 33, "pm25": 50, "pm100": 61, "timestamp": 1681426846}	2023-04-13 23:00:46+00
249396	{"pm10": 33, "pm25": 49, "pm100": 61, "timestamp": 1681426852}	2023-04-13 23:00:52+00
249396	{"pm10": 33, "pm25": 49, "pm100": 60, "timestamp": 1681426858}	2023-04-13 23:00:58+00
249396	{"pm10": 32, "pm25": 48, "pm100": 58, "timestamp": 1681426864}	2023-04-13 23:01:04+00
249396	{"pm10": 31, "pm25": 47, "pm100": 57, "timestamp": 1681426870}	2023-04-13 23:01:10+00
249396	{"pm10": 32, "pm25": 47, "pm100": 58, "timestamp": 1681426876}	2023-04-13 23:01:16+00
249396	{"pm10": 32, "pm25": 48, "pm100": 60, "timestamp": 1681430022}	2023-04-13 23:53:42+00
249396	{"pm10": 32, "pm25": 48, "pm100": 60, "timestamp": 1681430028}	2023-04-13 23:53:48+00
249396	{"pm10": 32, "pm25": 48, "pm100": 58, "timestamp": 1681430034}	2023-04-13 23:53:54+00
249396	{"pm10": 32, "pm25": 48, "pm100": 58, "timestamp": 1681430040}	2023-04-13 23:54:00+00
249396	{"pm10": 30, "pm25": 47, "pm100": 57, "timestamp": 1681430046}	2023-04-13 23:54:06+00
249396	{"pm10": 30, "pm25": 47, "pm100": 57, "timestamp": 1681430052}	2023-04-13 23:54:12+00
249396	{"pm10": 31, "pm25": 47, "pm100": 57, "timestamp": 1681430058}	2023-04-13 23:54:18+00
249396	{"pm10": 31, "pm25": 46, "pm100": 56, "timestamp": 1681430064}	2023-04-13 23:54:24+00
249396	{"pm10": 31, "pm25": 46, "pm100": 56, "timestamp": 1681430071}	2023-04-13 23:54:31+00
249396	{"pm10": 31, "pm25": 47, "pm100": 57, "timestamp": 1681430077}	2023-04-13 23:54:37+00
249396	{"pm10": 31, "pm25": 47, "pm100": 57, "timestamp": 1681430083}	2023-04-13 23:54:43+00
249396	{"pm10": 32, "pm25": 46, "pm100": 55, "timestamp": 1681430089}	2023-04-13 23:54:49+00
249396	{"pm10": 32, "pm25": 46, "pm100": 55, "timestamp": 1681430095}	2023-04-13 23:54:55+00
249396	{"pm10": 33, "pm25": 48, "pm100": 58, "timestamp": 1681430101}	2023-04-13 23:55:01+00
249396	{"pm10": 33, "pm25": 47, "pm100": 57, "timestamp": 1681430107}	2023-04-13 23:55:07+00
249396	{"pm10": 33, "pm25": 48, "pm100": 58, "timestamp": 1681430113}	2023-04-13 23:55:13+00
249396	{"pm10": 30, "pm25": 44, "pm100": 53, "timestamp": 1681430120}	2023-04-13 23:55:20+00
249396	{"pm10": 30, "pm25": 44, "pm100": 53, "timestamp": 1681430126}	2023-04-13 23:55:26+00
249396	{"pm10": 30, "pm25": 44, "pm100": 53, "timestamp": 1681430132}	2023-04-13 23:55:32+00
249396	{"pm10": 30, "pm25": 44, "pm100": 53, "timestamp": 1681430138}	2023-04-13 23:55:38+00
249396	{"pm10": 30, "pm25": 45, "pm100": 54, "timestamp": 1681430144}	2023-04-13 23:55:44+00
249396	{"pm10": 30, "pm25": 45, "pm100": 54, "timestamp": 1681430150}	2023-04-13 23:55:50+00
249396	{"pm10": 30, "pm25": 45, "pm100": 55, "timestamp": 1681430156}	2023-04-13 23:55:56+00
249396	{"pm10": 30, "pm25": 45, "pm100": 55, "timestamp": 1681430162}	2023-04-13 23:56:02+00
249396	{"pm10": 31, "pm25": 46, "pm100": 55, "timestamp": 1681430169}	2023-04-13 23:56:09+00
249396	{"pm10": 31, "pm25": 46, "pm100": 55, "timestamp": 1681430175}	2023-04-13 23:56:15+00
249396	{"pm10": 31, "pm25": 46, "pm100": 55, "timestamp": 1681430181}	2023-04-13 23:56:21+00
249396	{"pm10": 31, "pm25": 47, "pm100": 56, "timestamp": 1681430187}	2023-04-13 23:56:27+00
249396	{"pm10": 31, "pm25": 47, "pm100": 56, "timestamp": 1681430193}	2023-04-13 23:56:33+00
249396	{"pm10": 31, "pm25": 47, "pm100": 56, "timestamp": 1681430199}	2023-04-13 23:56:39+00
249396	{"pm10": 30, "pm25": 45, "pm100": 54, "timestamp": 1681430205}	2023-04-13 23:56:45+00
249396	{"pm10": 30, "pm25": 46, "pm100": 55, "timestamp": 1681430211}	2023-04-13 23:56:51+00
249396	{"pm10": 32, "pm25": 48, "pm100": 58, "timestamp": 1681430218}	2023-04-13 23:56:58+00
249396	{"pm10": 31, "pm25": 47, "pm100": 57, "timestamp": 1681430224}	2023-04-13 23:57:04+00
249396	{"pm10": 31, "pm25": 47, "pm100": 57, "timestamp": 1681430230}	2023-04-13 23:57:10+00
249396	{"pm10": 30, "pm25": 45, "pm100": 55, "timestamp": 1681430236}	2023-04-13 23:57:16+00
249396	{"pm10": 30, "pm25": 45, "pm100": 53, "timestamp": 1681430242}	2023-04-13 23:57:22+00
249396	{"pm10": 29, "pm25": 45, "pm100": 53, "timestamp": 1681430248}	2023-04-13 23:57:28+00
249396	{"pm10": 31, "pm25": 48, "pm100": 58, "timestamp": 1681430254}	2023-04-13 23:57:34+00
249396	{"pm10": 31, "pm25": 48, "pm100": 58, "timestamp": 1681430261}	2023-04-13 23:57:41+00
249396	{"pm10": 32, "pm25": 48, "pm100": 59, "timestamp": 1681430267}	2023-04-13 23:57:47+00
249396	{"pm10": 32, "pm25": 48, "pm100": 59, "timestamp": 1681430273}	2023-04-13 23:57:53+00
249396	{"pm10": 32, "pm25": 48, "pm100": 59, "timestamp": 1681430279}	2023-04-13 23:57:59+00
249396	{"pm10": 32, "pm25": 48, "pm100": 58, "timestamp": 1681430285}	2023-04-13 23:58:05+00
249396	{"pm10": 32, "pm25": 47, "pm100": 56, "timestamp": 1681430291}	2023-04-13 23:58:11+00
249396	{"pm10": 32, "pm25": 46, "pm100": 55, "timestamp": 1681430297}	2023-04-13 23:58:17+00
249396	{"pm10": 32, "pm25": 47, "pm100": 57, "timestamp": 1681430303}	2023-04-13 23:58:23+00
249396	{"pm10": 32, "pm25": 47, "pm100": 57, "timestamp": 1681430310}	2023-04-13 23:58:30+00
249396	{"pm10": 31, "pm25": 47, "pm100": 57, "timestamp": 1681430316}	2023-04-13 23:58:36+00
249396	{"pm10": 31, "pm25": 47, "pm100": 57, "timestamp": 1681430322}	2023-04-13 23:58:42+00
249396	{"pm10": 32, "pm25": 46, "pm100": 56, "timestamp": 1681426882}	2023-04-13 23:01:22+00
249396	{"pm10": 31, "pm25": 45, "pm100": 55, "timestamp": 1681426889}	2023-04-13 23:01:29+00
249396	{"pm10": 32, "pm25": 46, "pm100": 57, "timestamp": 1681426895}	2023-04-13 23:01:35+00
249396	{"pm10": 33, "pm25": 49, "pm100": 61, "timestamp": 1681426901}	2023-04-13 23:01:41+00
249396	{"pm10": 33, "pm25": 49, "pm100": 60, "timestamp": 1681426907}	2023-04-13 23:01:47+00
249396	{"pm10": 32, "pm25": 48, "pm100": 59, "timestamp": 1681426913}	2023-04-13 23:01:53+00
249396	{"pm10": 31, "pm25": 47, "pm100": 58, "timestamp": 1681426919}	2023-04-13 23:01:59+00
249396	{"pm10": 30, "pm25": 47, "pm100": 58, "timestamp": 1681426925}	2023-04-13 23:02:05+00
249396	{"pm10": 30, "pm25": 47, "pm100": 58, "timestamp": 1681426931}	2023-04-13 23:02:11+00
249396	{"pm10": 31, "pm25": 47, "pm100": 57, "timestamp": 1681426938}	2023-04-13 23:02:18+00
249396	{"pm10": 31, "pm25": 47, "pm100": 57, "timestamp": 1681426944}	2023-04-13 23:02:24+00
249396	{"pm10": 31, "pm25": 47, "pm100": 57, "timestamp": 1681426950}	2023-04-13 23:02:30+00
249396	{"pm10": 31, "pm25": 47, "pm100": 57, "timestamp": 1681426956}	2023-04-13 23:02:36+00
249396	{"pm10": 32, "pm25": 47, "pm100": 57, "timestamp": 1681426962}	2023-04-13 23:02:42+00
249396	{"pm10": 32, "pm25": 47, "pm100": 57, "timestamp": 1681426968}	2023-04-13 23:02:48+00
249396	{"pm10": 31, "pm25": 48, "pm100": 58, "timestamp": 1681426974}	2023-04-13 23:02:54+00
249396	{"pm10": 31, "pm25": 48, "pm100": 58, "timestamp": 1681426980}	2023-04-13 23:03:00+00
249396	{"pm10": 31, "pm25": 48, "pm100": 57, "timestamp": 1681426987}	2023-04-13 23:03:07+00
249396	{"pm10": 31, "pm25": 49, "pm100": 59, "timestamp": 1681426993}	2023-04-13 23:03:13+00
249396	{"pm10": 31, "pm25": 48, "pm100": 58, "timestamp": 1681426999}	2023-04-13 23:03:19+00
249396	{"pm10": 32, "pm25": 49, "pm100": 60, "timestamp": 1681427005}	2023-04-13 23:03:25+00
249396	{"pm10": 32, "pm25": 49, "pm100": 60, "timestamp": 1681427011}	2023-04-13 23:03:31+00
249396	{"pm10": 32, "pm25": 49, "pm100": 58, "timestamp": 1681427017}	2023-04-13 23:03:37+00
249396	{"pm10": 32, "pm25": 49, "pm100": 58, "timestamp": 1681427023}	2023-04-13 23:03:43+00
249396	{"pm10": 31, "pm25": 49, "pm100": 58, "timestamp": 1681427030}	2023-04-13 23:03:50+00
249396	{"pm10": 31, "pm25": 49, "pm100": 58, "timestamp": 1681427036}	2023-04-13 23:03:56+00
249396	{"pm10": 31, "pm25": 48, "pm100": 57, "timestamp": 1681427042}	2023-04-13 23:04:02+00
249396	{"pm10": 31, "pm25": 47, "pm100": 56, "timestamp": 1681427052}	2023-04-13 23:04:12+00
249396	{"pm10": 31, "pm25": 46, "pm100": 55, "timestamp": 1681427058}	2023-04-13 23:04:18+00
249396	{"pm10": 31, "pm25": 46, "pm100": 55, "timestamp": 1681427064}	2023-04-13 23:04:24+00
249396	{"pm10": 31, "pm25": 46, "pm100": 55, "timestamp": 1681427070}	2023-04-13 23:04:30+00
249396	{"pm10": 31, "pm25": 46, "pm100": 55, "timestamp": 1681427076}	2023-04-13 23:04:36+00
249396	{"pm10": 31, "pm25": 46, "pm100": 55, "timestamp": 1681427083}	2023-04-13 23:04:43+00
249396	{"pm10": 31, "pm25": 46, "pm100": 55, "timestamp": 1681427089}	2023-04-13 23:04:49+00
249396	{"pm10": 32, "pm25": 46, "pm100": 56, "timestamp": 1681427095}	2023-04-13 23:04:55+00
249396	{"pm10": 33, "pm25": 47, "pm100": 56, "timestamp": 1681427101}	2023-04-13 23:05:01+00
249396	{"pm10": 33, "pm25": 48, "pm100": 58, "timestamp": 1681427107}	2023-04-13 23:05:07+00
249396	{"pm10": 33, "pm25": 48, "pm100": 58, "timestamp": 1681427113}	2023-04-13 23:05:13+00
249396	{"pm10": 32, "pm25": 49, "pm100": 59, "timestamp": 1681427119}	2023-04-13 23:05:19+00
249396	{"pm10": 32, "pm25": 48, "pm100": 59, "timestamp": 1681427125}	2023-04-13 23:05:25+00
249396	{"pm10": 32, "pm25": 48, "pm100": 58, "timestamp": 1681427132}	2023-04-13 23:05:32+00
249396	{"pm10": 32, "pm25": 48, "pm100": 59, "timestamp": 1681427138}	2023-04-13 23:05:38+00
249396	{"pm10": 32, "pm25": 48, "pm100": 58, "timestamp": 1681427144}	2023-04-13 23:05:44+00
249396	{"pm10": 32, "pm25": 47, "pm100": 59, "timestamp": 1681427150}	2023-04-13 23:05:50+00
249396	{"pm10": 32, "pm25": 47, "pm100": 57, "timestamp": 1681427156}	2023-04-13 23:05:56+00
249396	{"pm10": 32, "pm25": 47, "pm100": 57, "timestamp": 1681427162}	2023-04-13 23:06:02+00
249396	{"pm10": 32, "pm25": 49, "pm100": 59, "timestamp": 1681427168}	2023-04-13 23:06:08+00
249396	{"pm10": 32, "pm25": 49, "pm100": 59, "timestamp": 1681427174}	2023-04-13 23:06:14+00
249396	{"pm10": 31, "pm25": 46, "pm100": 57, "timestamp": 1681427181}	2023-04-13 23:06:21+00
249396	{"pm10": 31, "pm25": 46, "pm100": 57, "timestamp": 1681427187}	2023-04-13 23:06:27+00
249396	{"pm10": 31, "pm25": 46, "pm100": 57, "timestamp": 1681427193}	2023-04-13 23:06:33+00
249396	{"pm10": 30, "pm25": 47, "pm100": 57, "timestamp": 1681427199}	2023-04-13 23:06:39+00
249396	{"pm10": 31, "pm25": 47, "pm100": 58, "timestamp": 1681427205}	2023-04-13 23:06:45+00
249396	{"pm10": 32, "pm25": 47, "pm100": 58, "timestamp": 1681427211}	2023-04-13 23:06:51+00
249396	{"pm10": 31, "pm25": 48, "pm100": 59, "timestamp": 1681427217}	2023-04-13 23:06:57+00
249396	{"pm10": 32, "pm25": 48, "pm100": 58, "timestamp": 1681427223}	2023-04-13 23:07:03+00
249396	{"pm10": 32, "pm25": 48, "pm100": 58, "timestamp": 1681427230}	2023-04-13 23:07:10+00
249396	{"pm10": 32, "pm25": 48, "pm100": 59, "timestamp": 1681427236}	2023-04-13 23:07:16+00
249396	{"pm10": 32, "pm25": 48, "pm100": 59, "timestamp": 1681427242}	2023-04-13 23:07:22+00
249396	{"pm10": 33, "pm25": 49, "pm100": 60, "timestamp": 1681427248}	2023-04-13 23:07:28+00
249396	{"pm10": 33, "pm25": 49, "pm100": 60, "timestamp": 1681427254}	2023-04-13 23:07:34+00
249396	{"pm10": 32, "pm25": 48, "pm100": 58, "timestamp": 1681427260}	2023-04-13 23:07:40+00
249396	{"pm10": 33, "pm25": 48, "pm100": 58, "timestamp": 1681427266}	2023-04-13 23:07:46+00
249396	{"pm10": 33, "pm25": 48, "pm100": 58, "timestamp": 1681427272}	2023-04-13 23:07:52+00
249396	{"pm10": 33, "pm25": 48, "pm100": 58, "timestamp": 1681427279}	2023-04-13 23:07:59+00
249396	{"pm10": 33, "pm25": 48, "pm100": 58, "timestamp": 1681427285}	2023-04-13 23:08:05+00
249396	{"pm10": 33, "pm25": 48, "pm100": 59, "timestamp": 1681427291}	2023-04-13 23:08:11+00
249396	{"pm10": 32, "pm25": 48, "pm100": 57, "timestamp": 1681427297}	2023-04-13 23:08:17+00
249396	{"pm10": 32, "pm25": 48, "pm100": 57, "timestamp": 1681427303}	2023-04-13 23:08:23+00
249396	{"pm10": 32, "pm25": 48, "pm100": 57, "timestamp": 1681427309}	2023-04-13 23:08:29+00
249396	{"pm10": 32, "pm25": 48, "pm100": 57, "timestamp": 1681427315}	2023-04-13 23:08:35+00
249396	{"pm10": 32, "pm25": 48, "pm100": 57, "timestamp": 1681427321}	2023-04-13 23:08:41+00
249396	{"pm10": 33, "pm25": 48, "pm100": 59, "timestamp": 1681427332}	2023-04-13 23:08:52+00
249396	{"pm10": 33, "pm25": 48, "pm100": 58, "timestamp": 1681427338}	2023-04-13 23:08:58+00
249396	{"pm10": 33, "pm25": 48, "pm100": 58, "timestamp": 1681427344}	2023-04-13 23:09:04+00
249396	{"pm10": 33, "pm25": 48, "pm100": 58, "timestamp": 1681427350}	2023-04-13 23:09:10+00
249396	{"pm10": 33, "pm25": 48, "pm100": 58, "timestamp": 1681427356}	2023-04-13 23:09:16+00
249396	{"pm10": 34, "pm25": 48, "pm100": 59, "timestamp": 1681427362}	2023-04-13 23:09:22+00
249396	{"pm10": 34, "pm25": 48, "pm100": 59, "timestamp": 1681427368}	2023-04-13 23:09:28+00
249396	{"pm10": 34, "pm25": 49, "pm100": 60, "timestamp": 1681427374}	2023-04-13 23:09:34+00
249396	{"pm10": 33, "pm25": 48, "pm100": 58, "timestamp": 1681427381}	2023-04-13 23:09:41+00
249396	{"pm10": 33, "pm25": 48, "pm100": 58, "timestamp": 1681427387}	2023-04-13 23:09:47+00
249396	{"pm10": 32, "pm25": 50, "pm100": 61, "timestamp": 1681427393}	2023-04-13 23:09:53+00
249396	{"pm10": 33, "pm25": 51, "pm100": 61, "timestamp": 1681427399}	2023-04-13 23:09:59+00
249396	{"pm10": 32, "pm25": 49, "pm100": 60, "timestamp": 1681427405}	2023-04-13 23:10:05+00
249396	{"pm10": 32, "pm25": 48, "pm100": 59, "timestamp": 1681427411}	2023-04-13 23:10:11+00
249396	{"pm10": 32, "pm25": 48, "pm100": 61, "timestamp": 1681427417}	2023-04-13 23:10:17+00
249396	{"pm10": 32, "pm25": 49, "pm100": 61, "timestamp": 1681427423}	2023-04-13 23:10:23+00
249396	{"pm10": 33, "pm25": 49, "pm100": 61, "timestamp": 1681427430}	2023-04-13 23:10:30+00
249396	{"pm10": 33, "pm25": 48, "pm100": 60, "timestamp": 1681427436}	2023-04-13 23:10:36+00
249396	{"pm10": 33, "pm25": 49, "pm100": 61, "timestamp": 1681427442}	2023-04-13 23:10:42+00
249396	{"pm10": 31, "pm25": 48, "pm100": 57, "timestamp": 1681427448}	2023-04-13 23:10:48+00
249396	{"pm10": 32, "pm25": 49, "pm100": 58, "timestamp": 1681427454}	2023-04-13 23:10:54+00
249396	{"pm10": 32, "pm25": 49, "pm100": 59, "timestamp": 1681427460}	2023-04-13 23:11:00+00
249396	{"pm10": 32, "pm25": 49, "pm100": 59, "timestamp": 1681427466}	2023-04-13 23:11:06+00
249396	{"pm10": 32, "pm25": 50, "pm100": 60, "timestamp": 1681427472}	2023-04-13 23:11:12+00
249396	{"pm10": 32, "pm25": 46, "pm100": 56, "timestamp": 1681427479}	2023-04-13 23:11:19+00
249396	{"pm10": 32, "pm25": 46, "pm100": 56, "timestamp": 1681427485}	2023-04-13 23:11:25+00
249396	{"pm10": 32, "pm25": 46, "pm100": 56, "timestamp": 1681427491}	2023-04-13 23:11:31+00
249396	{"pm10": 30, "pm25": 45, "pm100": 55, "timestamp": 1681427497}	2023-04-13 23:11:37+00
249396	{"pm10": 30, "pm25": 46, "pm100": 55, "timestamp": 1681427503}	2023-04-13 23:11:43+00
249396	{"pm10": 31, "pm25": 46, "pm100": 56, "timestamp": 1681427509}	2023-04-13 23:11:49+00
249396	{"pm10": 31, "pm25": 47, "pm100": 57, "timestamp": 1681427515}	2023-04-13 23:11:55+00
249396	{"pm10": 31, "pm25": 47, "pm100": 57, "timestamp": 1681427521}	2023-04-13 23:12:01+00
249396	{"pm10": 31, "pm25": 48, "pm100": 58, "timestamp": 1681427528}	2023-04-13 23:12:08+00
249396	{"pm10": 32, "pm25": 49, "pm100": 59, "timestamp": 1681427534}	2023-04-13 23:12:14+00
249396	{"pm10": 32, "pm25": 49, "pm100": 60, "timestamp": 1681427540}	2023-04-13 23:12:20+00
249396	{"pm10": 32, "pm25": 49, "pm100": 59, "timestamp": 1681427546}	2023-04-13 23:12:26+00
249396	{"pm10": 32, "pm25": 49, "pm100": 59, "timestamp": 1681427552}	2023-04-13 23:12:32+00
249396	{"pm10": 32, "pm25": 49, "pm100": 59, "timestamp": 1681427558}	2023-04-13 23:12:38+00
249396	{"pm10": 32, "pm25": 49, "pm100": 59, "timestamp": 1681427564}	2023-04-13 23:12:44+00
249396	{"pm10": 31, "pm25": 48, "pm100": 58, "timestamp": 1681427571}	2023-04-13 23:12:51+00
249396	{"pm10": 31, "pm25": 48, "pm100": 58, "timestamp": 1681427577}	2023-04-13 23:12:57+00
249396	{"pm10": 31, "pm25": 48, "pm100": 58, "timestamp": 1681427583}	2023-04-13 23:13:03+00
249396	{"pm10": 31, "pm25": 47, "pm100": 56, "timestamp": 1681427589}	2023-04-13 23:13:09+00
249396	{"pm10": 31, "pm25": 47, "pm100": 56, "timestamp": 1681427595}	2023-04-13 23:13:15+00
249396	{"pm10": 31, "pm25": 47, "pm100": 57, "timestamp": 1681427601}	2023-04-13 23:13:21+00
249396	{"pm10": 31, "pm25": 47, "pm100": 57, "timestamp": 1681427607}	2023-04-13 23:13:27+00
249396	{"pm10": 31, "pm25": 47, "pm100": 57, "timestamp": 1681427613}	2023-04-13 23:13:33+00
249396	{"pm10": 32, "pm25": 47, "pm100": 57, "timestamp": 1681427620}	2023-04-13 23:13:40+00
249396	{"pm10": 32, "pm25": 47, "pm100": 57, "timestamp": 1681427626}	2023-04-13 23:13:46+00
249396	{"pm10": 31, "pm25": 45, "pm100": 54, "timestamp": 1681427632}	2023-04-13 23:13:52+00
249396	{"pm10": 31, "pm25": 47, "pm100": 56, "timestamp": 1681427638}	2023-04-13 23:13:58+00
249396	{"pm10": 31, "pm25": 47, "pm100": 56, "timestamp": 1681427644}	2023-04-13 23:14:04+00
249396	{"pm10": 32, "pm25": 49, "pm100": 60, "timestamp": 1681427650}	2023-04-13 23:14:10+00
249396	{"pm10": 32, "pm25": 49, "pm100": 61, "timestamp": 1681427656}	2023-04-13 23:14:16+00
249396	{"pm10": 33, "pm25": 50, "pm100": 61, "timestamp": 1681427662}	2023-04-13 23:14:22+00
249396	{"pm10": 33, "pm25": 50, "pm100": 62, "timestamp": 1681427669}	2023-04-13 23:14:29+00
249396	{"pm10": 32, "pm25": 48, "pm100": 58, "timestamp": 1681427675}	2023-04-13 23:14:35+00
249396	{"pm10": 31, "pm25": 47, "pm100": 56, "timestamp": 1681427681}	2023-04-13 23:14:41+00
249396	{"pm10": 31, "pm25": 47, "pm100": 57, "timestamp": 1681427687}	2023-04-13 23:14:47+00
249396	{"pm10": 31, "pm25": 47, "pm100": 57, "timestamp": 1681427693}	2023-04-13 23:14:53+00
249396	{"pm10": 31, "pm25": 47, "pm100": 57, "timestamp": 1681427699}	2023-04-13 23:14:59+00
249396	{"pm10": 31, "pm25": 47, "pm100": 57, "timestamp": 1681427705}	2023-04-13 23:15:05+00
249396	{"pm10": 32, "pm25": 47, "pm100": 57, "timestamp": 1681427711}	2023-04-13 23:15:11+00
249396	{"pm10": 32, "pm25": 47, "pm100": 57, "timestamp": 1681427718}	2023-04-13 23:15:18+00
249396	{"pm10": 31, "pm25": 47, "pm100": 57, "timestamp": 1681427724}	2023-04-13 23:15:24+00
249396	{"pm10": 32, "pm25": 48, "pm100": 59, "timestamp": 1681427730}	2023-04-13 23:15:30+00
249396	{"pm10": 32, "pm25": 48, "pm100": 59, "timestamp": 1681427736}	2023-04-13 23:15:36+00
249396	{"pm10": 32, "pm25": 48, "pm100": 58, "timestamp": 1681427742}	2023-04-13 23:15:42+00
249396	{"pm10": 32, "pm25": 48, "pm100": 58, "timestamp": 1681427748}	2023-04-13 23:15:48+00
249396	{"pm10": 32, "pm25": 48, "pm100": 60, "timestamp": 1681427754}	2023-04-13 23:15:54+00
249396	{"pm10": 32, "pm25": 48, "pm100": 60, "timestamp": 1681427760}	2023-04-13 23:16:00+00
249396	{"pm10": 33, "pm25": 48, "pm100": 60, "timestamp": 1681427767}	2023-04-13 23:16:07+00
249396	{"pm10": 33, "pm25": 49, "pm100": 60, "timestamp": 1681427773}	2023-04-13 23:16:13+00
249396	{"pm10": 32, "pm25": 50, "pm100": 62, "timestamp": 1681427779}	2023-04-13 23:16:19+00
249396	{"pm10": 32, "pm25": 49, "pm100": 61, "timestamp": 1681427785}	2023-04-13 23:16:25+00
249396	{"pm10": 32, "pm25": 49, "pm100": 61, "timestamp": 1681427791}	2023-04-13 23:16:31+00
249396	{"pm10": 33, "pm25": 47, "pm100": 58, "timestamp": 1681427797}	2023-04-13 23:16:37+00
249396	{"pm10": 33, "pm25": 48, "pm100": 58, "timestamp": 1681427803}	2023-04-13 23:16:43+00
249396	{"pm10": 32, "pm25": 48, "pm100": 59, "timestamp": 1681427809}	2023-04-13 23:16:49+00
249396	{"pm10": 32, "pm25": 50, "pm100": 62, "timestamp": 1681427816}	2023-04-13 23:16:56+00
249396	{"pm10": 32, "pm25": 50, "pm100": 62, "timestamp": 1681427822}	2023-04-13 23:17:02+00
249396	{"pm10": 33, "pm25": 47, "pm100": 56, "timestamp": 1681427828}	2023-04-13 23:17:08+00
249396	{"pm10": 33, "pm25": 48, "pm100": 57, "timestamp": 1681427834}	2023-04-13 23:17:14+00
249396	{"pm10": 33, "pm25": 47, "pm100": 56, "timestamp": 1681427840}	2023-04-13 23:17:20+00
249396	{"pm10": 33, "pm25": 47, "pm100": 56, "timestamp": 1681427846}	2023-04-13 23:17:26+00
249396	{"pm10": 32, "pm25": 47, "pm100": 56, "timestamp": 1681427852}	2023-04-13 23:17:32+00
249396	{"pm10": 32, "pm25": 47, "pm100": 56, "timestamp": 1681427858}	2023-04-13 23:17:38+00
249396	{"pm10": 32, "pm25": 47, "pm100": 56, "timestamp": 1681427865}	2023-04-13 23:17:45+00
249396	{"pm10": 32, "pm25": 47, "pm100": 57, "timestamp": 1681427871}	2023-04-13 23:17:51+00
249396	{"pm10": 31, "pm25": 46, "pm100": 56, "timestamp": 1681427877}	2023-04-13 23:17:57+00
249396	{"pm10": 31, "pm25": 47, "pm100": 56, "timestamp": 1681427883}	2023-04-13 23:18:03+00
249396	{"pm10": 31, "pm25": 47, "pm100": 56, "timestamp": 1681427889}	2023-04-13 23:18:09+00
249396	{"pm10": 32, "pm25": 48, "pm100": 59, "timestamp": 1681427895}	2023-04-13 23:18:15+00
249396	{"pm10": 32, "pm25": 48, "pm100": 59, "timestamp": 1681427901}	2023-04-13 23:18:21+00
249396	{"pm10": 32, "pm25": 48, "pm100": 59, "timestamp": 1681427907}	2023-04-13 23:18:27+00
249396	{"pm10": 33, "pm25": 49, "pm100": 60, "timestamp": 1681427914}	2023-04-13 23:18:34+00
249396	{"pm10": 32, "pm25": 49, "pm100": 60, "timestamp": 1681427920}	2023-04-13 23:18:40+00
249396	{"pm10": 32, "pm25": 48, "pm100": 58, "timestamp": 1681427926}	2023-04-13 23:18:46+00
249396	{"pm10": 32, "pm25": 48, "pm100": 58, "timestamp": 1681427932}	2023-04-13 23:18:52+00
249396	{"pm10": 32, "pm25": 48, "pm100": 58, "timestamp": 1681427938}	2023-04-13 23:18:58+00
249396	{"pm10": 33, "pm25": 48, "pm100": 58, "timestamp": 1681427944}	2023-04-13 23:19:04+00
249396	{"pm10": 33, "pm25": 48, "pm100": 58, "timestamp": 1681427950}	2023-04-13 23:19:10+00
249396	{"pm10": 33, "pm25": 48, "pm100": 58, "timestamp": 1681427956}	2023-04-13 23:19:16+00
249396	{"pm10": 33, "pm25": 48, "pm100": 57, "timestamp": 1681427963}	2023-04-13 23:19:23+00
249396	{"pm10": 30, "pm25": 47, "pm100": 57, "timestamp": 1681427969}	2023-04-13 23:19:29+00
249396	{"pm10": 32, "pm25": 49, "pm100": 60, "timestamp": 1681427975}	2023-04-13 23:19:35+00
249396	{"pm10": 32, "pm25": 49, "pm100": 60, "timestamp": 1681427981}	2023-04-13 23:19:41+00
249396	{"pm10": 32, "pm25": 50, "pm100": 61, "timestamp": 1681427987}	2023-04-13 23:19:47+00
249396	{"pm10": 32, "pm25": 50, "pm100": 61, "timestamp": 1681427993}	2023-04-13 23:19:53+00
249396	{"pm10": 33, "pm25": 50, "pm100": 61, "timestamp": 1681427999}	2023-04-13 23:19:59+00
249396	{"pm10": 32, "pm25": 48, "pm100": 58, "timestamp": 1681428005}	2023-04-13 23:20:05+00
249396	{"pm10": 32, "pm25": 47, "pm100": 57, "timestamp": 1681428012}	2023-04-13 23:20:12+00
249396	{"pm10": 32, "pm25": 47, "pm100": 57, "timestamp": 1681428018}	2023-04-13 23:20:18+00
249396	{"pm10": 31, "pm25": 46, "pm100": 57, "timestamp": 1681428024}	2023-04-13 23:20:24+00
249396	{"pm10": 31, "pm25": 46, "pm100": 57, "timestamp": 1681428030}	2023-04-13 23:20:30+00
249396	{"pm10": 31, "pm25": 46, "pm100": 57, "timestamp": 1681428036}	2023-04-13 23:20:36+00
249396	{"pm10": 32, "pm25": 47, "pm100": 57, "timestamp": 1681428042}	2023-04-13 23:20:42+00
249396	{"pm10": 32, "pm25": 47, "pm100": 57, "timestamp": 1681428048}	2023-04-13 23:20:48+00
249396	{"pm10": 32, "pm25": 46, "pm100": 56, "timestamp": 1681428055}	2023-04-13 23:20:55+00
249396	{"pm10": 31, "pm25": 46, "pm100": 55, "timestamp": 1681428061}	2023-04-13 23:21:01+00
249396	{"pm10": 33, "pm25": 50, "pm100": 60, "timestamp": 1681428067}	2023-04-13 23:21:07+00
249396	{"pm10": 33, "pm25": 50, "pm100": 61, "timestamp": 1681428073}	2023-04-13 23:21:13+00
249396	{"pm10": 33, "pm25": 50, "pm100": 60, "timestamp": 1681428079}	2023-04-13 23:21:19+00
249396	{"pm10": 33, "pm25": 50, "pm100": 60, "timestamp": 1681428085}	2023-04-13 23:21:25+00
249396	{"pm10": 33, "pm25": 50, "pm100": 62, "timestamp": 1681428091}	2023-04-13 23:21:31+00
249396	{"pm10": 33, "pm25": 50, "pm100": 62, "timestamp": 1681428097}	2023-04-13 23:21:37+00
249396	{"pm10": 33, "pm25": 50, "pm100": 62, "timestamp": 1681428104}	2023-04-13 23:21:44+00
249396	{"pm10": 31, "pm25": 46, "pm100": 55, "timestamp": 1681428110}	2023-04-13 23:21:50+00
249396	{"pm10": 31, "pm25": 46, "pm100": 55, "timestamp": 1681428116}	2023-04-13 23:21:56+00
249396	{"pm10": 31, "pm25": 46, "pm100": 54, "timestamp": 1681428122}	2023-04-13 23:22:02+00
249396	{"pm10": 30, "pm25": 45, "pm100": 54, "timestamp": 1681428128}	2023-04-13 23:22:08+00
249396	{"pm10": 31, "pm25": 47, "pm100": 57, "timestamp": 1681428134}	2023-04-13 23:22:14+00
249396	{"pm10": 31, "pm25": 47, "pm100": 57, "timestamp": 1681428140}	2023-04-13 23:22:20+00
249396	{"pm10": 33, "pm25": 48, "pm100": 59, "timestamp": 1681428146}	2023-04-13 23:22:26+00
249396	{"pm10": 32, "pm25": 48, "pm100": 59, "timestamp": 1681428153}	2023-04-13 23:22:33+00
249396	{"pm10": 33, "pm25": 49, "pm100": 60, "timestamp": 1681428159}	2023-04-13 23:22:39+00
249396	{"pm10": 33, "pm25": 49, "pm100": 61, "timestamp": 1681428165}	2023-04-13 23:22:45+00
249396	{"pm10": 33, "pm25": 49, "pm100": 60, "timestamp": 1681428171}	2023-04-13 23:22:51+00
249396	{"pm10": 33, "pm25": 49, "pm100": 61, "timestamp": 1681428177}	2023-04-13 23:22:57+00
249396	{"pm10": 32, "pm25": 48, "pm100": 58, "timestamp": 1681428183}	2023-04-13 23:23:03+00
249396	{"pm10": 32, "pm25": 48, "pm100": 58, "timestamp": 1681428189}	2023-04-13 23:23:09+00
249396	{"pm10": 32, "pm25": 48, "pm100": 58, "timestamp": 1681428195}	2023-04-13 23:23:15+00
249396	{"pm10": 33, "pm25": 48, "pm100": 58, "timestamp": 1681428202}	2023-04-13 23:23:22+00
249396	{"pm10": 31, "pm25": 47, "pm100": 57, "timestamp": 1681428208}	2023-04-13 23:23:28+00
249396	{"pm10": 32, "pm25": 49, "pm100": 60, "timestamp": 1681428214}	2023-04-13 23:23:34+00
249396	{"pm10": 32, "pm25": 49, "pm100": 60, "timestamp": 1681428220}	2023-04-13 23:23:40+00
249396	{"pm10": 32, "pm25": 49, "pm100": 60, "timestamp": 1681428226}	2023-04-13 23:23:46+00
249396	{"pm10": 32, "pm25": 49, "pm100": 60, "timestamp": 1681428232}	2023-04-13 23:23:52+00
249396	{"pm10": 31, "pm25": 47, "pm100": 58, "timestamp": 1681428238}	2023-04-13 23:23:58+00
249396	{"pm10": 31, "pm25": 49, "pm100": 59, "timestamp": 1681428244}	2023-04-13 23:24:04+00
249396	{"pm10": 32, "pm25": 49, "pm100": 60, "timestamp": 1681428251}	2023-04-13 23:24:11+00
249396	{"pm10": 32, "pm25": 49, "pm100": 59, "timestamp": 1681428257}	2023-04-13 23:24:17+00
249396	{"pm10": 32, "pm25": 49, "pm100": 60, "timestamp": 1681428263}	2023-04-13 23:24:23+00
249396	{"pm10": 33, "pm25": 51, "pm100": 62, "timestamp": 1681428269}	2023-04-13 23:24:29+00
249396	{"pm10": 33, "pm25": 51, "pm100": 62, "timestamp": 1681428275}	2023-04-13 23:24:35+00
249396	{"pm10": 32, "pm25": 48, "pm100": 58, "timestamp": 1681428281}	2023-04-13 23:24:41+00
249396	{"pm10": 32, "pm25": 47, "pm100": 57, "timestamp": 1681428287}	2023-04-13 23:24:47+00
249396	{"pm10": 34, "pm25": 50, "pm100": 61, "timestamp": 1681428293}	2023-04-13 23:24:53+00
249396	{"pm10": 34, "pm25": 50, "pm100": 61, "timestamp": 1681428300}	2023-04-13 23:25:00+00
249396	{"pm10": 33, "pm25": 50, "pm100": 61, "timestamp": 1681428306}	2023-04-13 23:25:06+00
249396	{"pm10": 33, "pm25": 50, "pm100": 61, "timestamp": 1681428312}	2023-04-13 23:25:12+00
249396	{"pm10": 32, "pm25": 48, "pm100": 57, "timestamp": 1681428318}	2023-04-13 23:25:18+00
249396	{"pm10": 32, "pm25": 47, "pm100": 56, "timestamp": 1681428324}	2023-04-13 23:25:24+00
249396	{"pm10": 32, "pm25": 47, "pm100": 56, "timestamp": 1681428330}	2023-04-13 23:25:30+00
249396	{"pm10": 30, "pm25": 46, "pm100": 56, "timestamp": 1681428336}	2023-04-13 23:25:36+00
249396	{"pm10": 31, "pm25": 46, "pm100": 56, "timestamp": 1681428342}	2023-04-13 23:25:42+00
249396	{"pm10": 31, "pm25": 46, "pm100": 56, "timestamp": 1681428349}	2023-04-13 23:25:49+00
249396	{"pm10": 30, "pm25": 45, "pm100": 54, "timestamp": 1681428355}	2023-04-13 23:25:55+00
249396	{"pm10": 30, "pm25": 45, "pm100": 54, "timestamp": 1681428361}	2023-04-13 23:26:01+00
249396	{"pm10": 30, "pm25": 44, "pm100": 54, "timestamp": 1681428367}	2023-04-13 23:26:07+00
249396	{"pm10": 30, "pm25": 44, "pm100": 54, "timestamp": 1681428373}	2023-04-13 23:26:13+00
249396	{"pm10": 30, "pm25": 44, "pm100": 54, "timestamp": 1681428379}	2023-04-13 23:26:19+00
249396	{"pm10": 30, "pm25": 44, "pm100": 54, "timestamp": 1681428385}	2023-04-13 23:26:25+00
249396	{"pm10": 30, "pm25": 44, "pm100": 54, "timestamp": 1681428391}	2023-04-13 23:26:31+00
249396	{"pm10": 30, "pm25": 44, "pm100": 54, "timestamp": 1681428398}	2023-04-13 23:26:38+00
249396	{"pm10": 33, "pm25": 48, "pm100": 58, "timestamp": 1681428404}	2023-04-13 23:26:44+00
249396	{"pm10": 33, "pm25": 48, "pm100": 59, "timestamp": 1681428410}	2023-04-13 23:26:50+00
249396	{"pm10": 33, "pm25": 48, "pm100": 59, "timestamp": 1681428416}	2023-04-13 23:26:56+00
249396	{"pm10": 33, "pm25": 49, "pm100": 60, "timestamp": 1681428422}	2023-04-13 23:27:02+00
249396	{"pm10": 33, "pm25": 49, "pm100": 60, "timestamp": 1681428428}	2023-04-13 23:27:08+00
249396	{"pm10": 33, "pm25": 51, "pm100": 63, "timestamp": 1681428434}	2023-04-13 23:27:14+00
249396	{"pm10": 33, "pm25": 51, "pm100": 63, "timestamp": 1681428440}	2023-04-13 23:27:20+00
249396	{"pm10": 31, "pm25": 47, "pm100": 56, "timestamp": 1681428447}	2023-04-13 23:27:27+00
249396	{"pm10": 31, "pm25": 47, "pm100": 57, "timestamp": 1681428453}	2023-04-13 23:27:33+00
249396	{"pm10": 31, "pm25": 47, "pm100": 56, "timestamp": 1681428459}	2023-04-13 23:27:39+00
249396	{"pm10": 32, "pm25": 48, "pm100": 58, "timestamp": 1681428465}	2023-04-13 23:27:45+00
249396	{"pm10": 32, "pm25": 48, "pm100": 58, "timestamp": 1681428471}	2023-04-13 23:27:51+00
249396	{"pm10": 31, "pm25": 48, "pm100": 58, "timestamp": 1681428477}	2023-04-13 23:27:57+00
249396	{"pm10": 31, "pm25": 48, "pm100": 57, "timestamp": 1681428483}	2023-04-13 23:28:03+00
249396	{"pm10": 31, "pm25": 49, "pm100": 58, "timestamp": 1681428489}	2023-04-13 23:28:09+00
249396	{"pm10": 33, "pm25": 48, "pm100": 58, "timestamp": 1681428496}	2023-04-13 23:28:16+00
249396	{"pm10": 33, "pm25": 48, "pm100": 59, "timestamp": 1681428502}	2023-04-13 23:28:22+00
249396	{"pm10": 33, "pm25": 48, "pm100": 59, "timestamp": 1681428508}	2023-04-13 23:28:28+00
249396	{"pm10": 33, "pm25": 48, "pm100": 59, "timestamp": 1681428514}	2023-04-13 23:28:34+00
249396	{"pm10": 33, "pm25": 48, "pm100": 59, "timestamp": 1681428520}	2023-04-13 23:28:40+00
249396	{"pm10": 33, "pm25": 48, "pm100": 58, "timestamp": 1681428526}	2023-04-13 23:28:46+00
249396	{"pm10": 33, "pm25": 48, "pm100": 58, "timestamp": 1681428532}	2023-04-13 23:28:52+00
249396	{"pm10": 33, "pm25": 48, "pm100": 58, "timestamp": 1681428539}	2023-04-13 23:28:59+00
249396	{"pm10": 32, "pm25": 48, "pm100": 57, "timestamp": 1681428545}	2023-04-13 23:29:05+00
249396	{"pm10": 31, "pm25": 48, "pm100": 57, "timestamp": 1681428551}	2023-04-13 23:29:11+00
249396	{"pm10": 32, "pm25": 48, "pm100": 57, "timestamp": 1681428557}	2023-04-13 23:29:17+00
249396	{"pm10": 32, "pm25": 48, "pm100": 57, "timestamp": 1681428563}	2023-04-13 23:29:23+00
249396	{"pm10": 31, "pm25": 47, "pm100": 56, "timestamp": 1681428569}	2023-04-13 23:29:29+00
249396	{"pm10": 31, "pm25": 47, "pm100": 56, "timestamp": 1681428575}	2023-04-13 23:29:35+00
249396	{"pm10": 30, "pm25": 46, "pm100": 56, "timestamp": 1681428581}	2023-04-13 23:29:41+00
249396	{"pm10": 31, "pm25": 47, "pm100": 57, "timestamp": 1681428588}	2023-04-13 23:29:48+00
249396	{"pm10": 32, "pm25": 48, "pm100": 59, "timestamp": 1681428594}	2023-04-13 23:29:54+00
249396	{"pm10": 33, "pm25": 48, "pm100": 58, "timestamp": 1681428600}	2023-04-13 23:30:00+00
249396	{"pm10": 33, "pm25": 48, "pm100": 58, "timestamp": 1681428606}	2023-04-13 23:30:06+00
249396	{"pm10": 32, "pm25": 47, "pm100": 57, "timestamp": 1681428612}	2023-04-13 23:30:12+00
249396	{"pm10": 32, "pm25": 47, "pm100": 57, "timestamp": 1681428618}	2023-04-13 23:30:18+00
249396	{"pm10": 32, "pm25": 47, "pm100": 56, "timestamp": 1681428624}	2023-04-13 23:30:24+00
249396	{"pm10": 32, "pm25": 47, "pm100": 56, "timestamp": 1681428630}	2023-04-13 23:30:30+00
249396	{"pm10": 32, "pm25": 48, "pm100": 59, "timestamp": 1681428637}	2023-04-13 23:30:37+00
249396	{"pm10": 32, "pm25": 48, "pm100": 60, "timestamp": 1681428643}	2023-04-13 23:30:43+00
249396	{"pm10": 32, "pm25": 48, "pm100": 60, "timestamp": 1681428649}	2023-04-13 23:30:49+00
249396	{"pm10": 32, "pm25": 48, "pm100": 59, "timestamp": 1681428655}	2023-04-13 23:30:55+00
249396	{"pm10": 32, "pm25": 47, "pm100": 57, "timestamp": 1681428661}	2023-04-13 23:31:01+00
249396	{"pm10": 32, "pm25": 47, "pm100": 57, "timestamp": 1681428668}	2023-04-13 23:31:08+00
249396	{"pm10": 33, "pm25": 48, "pm100": 58, "timestamp": 1681428674}	2023-04-13 23:31:14+00
249396	{"pm10": 33, "pm25": 48, "pm100": 59, "timestamp": 1681428680}	2023-04-13 23:31:20+00
249396	{"pm10": 33, "pm25": 49, "pm100": 59, "timestamp": 1681428686}	2023-04-13 23:31:26+00
249396	{"pm10": 31, "pm25": 48, "pm100": 59, "timestamp": 1681428692}	2023-04-13 23:31:32+00
249396	{"pm10": 31, "pm25": 48, "pm100": 59, "timestamp": 1681428698}	2023-04-13 23:31:38+00
249396	{"pm10": 31, "pm25": 48, "pm100": 59, "timestamp": 1681428704}	2023-04-13 23:31:44+00
249396	{"pm10": 31, "pm25": 48, "pm100": 59, "timestamp": 1681428710}	2023-04-13 23:31:50+00
249396	{"pm10": 32, "pm25": 47, "pm100": 57, "timestamp": 1681428717}	2023-04-13 23:31:57+00
249396	{"pm10": 32, "pm25": 47, "pm100": 57, "timestamp": 1681428723}	2023-04-13 23:32:03+00
249396	{"pm10": 32, "pm25": 48, "pm100": 58, "timestamp": 1681428729}	2023-04-13 23:32:09+00
249396	{"pm10": 32, "pm25": 48, "pm100": 58, "timestamp": 1681428735}	2023-04-13 23:32:15+00
249396	{"pm10": 32, "pm25": 48, "pm100": 58, "timestamp": 1681428741}	2023-04-13 23:32:21+00
249396	{"pm10": 32, "pm25": 48, "pm100": 60, "timestamp": 1681428747}	2023-04-13 23:32:27+00
249396	{"pm10": 32, "pm25": 48, "pm100": 60, "timestamp": 1681428753}	2023-04-13 23:32:33+00
249396	{"pm10": 32, "pm25": 48, "pm100": 59, "timestamp": 1681428759}	2023-04-13 23:32:39+00
249396	{"pm10": 32, "pm25": 48, "pm100": 58, "timestamp": 1681428766}	2023-04-13 23:32:46+00
249396	{"pm10": 32, "pm25": 48, "pm100": 57, "timestamp": 1681428772}	2023-04-13 23:32:52+00
249396	{"pm10": 31, "pm25": 46, "pm100": 56, "timestamp": 1681428778}	2023-04-13 23:32:58+00
249396	{"pm10": 31, "pm25": 46, "pm100": 56, "timestamp": 1681428784}	2023-04-13 23:33:04+00
249396	{"pm10": 30, "pm25": 48, "pm100": 60, "timestamp": 1681428790}	2023-04-13 23:33:10+00
249396	{"pm10": 30, "pm25": 48, "pm100": 60, "timestamp": 1681428796}	2023-04-13 23:33:16+00
249396	{"pm10": 31, "pm25": 47, "pm100": 58, "timestamp": 1681428802}	2023-04-13 23:33:22+00
249396	{"pm10": 31, "pm25": 47, "pm100": 58, "timestamp": 1681428808}	2023-04-13 23:33:28+00
249396	{"pm10": 30, "pm25": 47, "pm100": 57, "timestamp": 1681428815}	2023-04-13 23:33:35+00
249396	{"pm10": 30, "pm25": 46, "pm100": 55, "timestamp": 1681428821}	2023-04-13 23:33:41+00
249396	{"pm10": 32, "pm25": 49, "pm100": 59, "timestamp": 1681428827}	2023-04-13 23:33:47+00
249396	{"pm10": 32, "pm25": 48, "pm100": 58, "timestamp": 1681428833}	2023-04-13 23:33:53+00
249396	{"pm10": 31, "pm25": 47, "pm100": 57, "timestamp": 1681428839}	2023-04-13 23:33:59+00
249396	{"pm10": 31, "pm25": 47, "pm100": 57, "timestamp": 1681428845}	2023-04-13 23:34:05+00
249396	{"pm10": 31, "pm25": 46, "pm100": 56, "timestamp": 1681428851}	2023-04-13 23:34:11+00
249396	{"pm10": 31, "pm25": 47, "pm100": 56, "timestamp": 1681428857}	2023-04-13 23:34:17+00
249396	{"pm10": 31, "pm25": 47, "pm100": 57, "timestamp": 1681428864}	2023-04-13 23:34:24+00
249396	{"pm10": 31, "pm25": 47, "pm100": 57, "timestamp": 1681428870}	2023-04-13 23:34:30+00
249396	{"pm10": 30, "pm25": 46, "pm100": 55, "timestamp": 1681428876}	2023-04-13 23:34:36+00
249396	{"pm10": 32, "pm25": 50, "pm100": 61, "timestamp": 1681428882}	2023-04-13 23:34:42+00
249396	{"pm10": 31, "pm25": 48, "pm100": 59, "timestamp": 1681428888}	2023-04-13 23:34:48+00
249396	{"pm10": 32, "pm25": 49, "pm100": 59, "timestamp": 1681428894}	2023-04-13 23:34:54+00
249396	{"pm10": 32, "pm25": 49, "pm100": 60, "timestamp": 1681428900}	2023-04-13 23:35:00+00
249396	{"pm10": 32, "pm25": 48, "pm100": 58, "timestamp": 1681428906}	2023-04-13 23:35:06+00
249396	{"pm10": 31, "pm25": 47, "pm100": 57, "timestamp": 1681428913}	2023-04-13 23:35:13+00
249396	{"pm10": 31, "pm25": 47, "pm100": 57, "timestamp": 1681428919}	2023-04-13 23:35:19+00
249396	{"pm10": 32, "pm25": 47, "pm100": 57, "timestamp": 1681428925}	2023-04-13 23:35:25+00
249396	{"pm10": 32, "pm25": 47, "pm100": 57, "timestamp": 1681428931}	2023-04-13 23:35:31+00
249396	{"pm10": 31, "pm25": 45, "pm100": 53, "timestamp": 1681428937}	2023-04-13 23:35:37+00
249396	{"pm10": 32, "pm25": 45, "pm100": 54, "timestamp": 1681428943}	2023-04-13 23:35:43+00
249396	{"pm10": 32, "pm25": 45, "pm100": 54, "timestamp": 1681428949}	2023-04-13 23:35:49+00
249396	{"pm10": 33, "pm25": 46, "pm100": 56, "timestamp": 1681428955}	2023-04-13 23:35:55+00
249396	{"pm10": 33, "pm25": 46, "pm100": 56, "timestamp": 1681428962}	2023-04-13 23:36:02+00
249396	{"pm10": 31, "pm25": 46, "pm100": 56, "timestamp": 1681428968}	2023-04-13 23:36:08+00
249396	{"pm10": 31, "pm25": 47, "pm100": 57, "timestamp": 1681428974}	2023-04-13 23:36:14+00
249396	{"pm10": 31, "pm25": 47, "pm100": 56, "timestamp": 1681428980}	2023-04-13 23:36:20+00
249396	{"pm10": 31, "pm25": 46, "pm100": 56, "timestamp": 1681428986}	2023-04-13 23:36:26+00
249396	{"pm10": 31, "pm25": 47, "pm100": 56, "timestamp": 1681428992}	2023-04-13 23:36:32+00
249396	{"pm10": 32, "pm25": 47, "pm100": 56, "timestamp": 1681428998}	2023-04-13 23:36:38+00
249396	{"pm10": 32, "pm25": 48, "pm100": 59, "timestamp": 1681429004}	2023-04-13 23:36:44+00
249396	{"pm10": 32, "pm25": 48, "pm100": 60, "timestamp": 1681429011}	2023-04-13 23:36:51+00
249396	{"pm10": 32, "pm25": 48, "pm100": 60, "timestamp": 1681429017}	2023-04-13 23:36:57+00
249396	{"pm10": 33, "pm25": 48, "pm100": 60, "timestamp": 1681429023}	2023-04-13 23:37:03+00
249396	{"pm10": 33, "pm25": 48, "pm100": 60, "timestamp": 1681429029}	2023-04-13 23:37:09+00
249396	{"pm10": 33, "pm25": 49, "pm100": 61, "timestamp": 1681429035}	2023-04-13 23:37:15+00
249396	{"pm10": 32, "pm25": 50, "pm100": 61, "timestamp": 1681429041}	2023-04-13 23:37:21+00
249396	{"pm10": 32, "pm25": 50, "pm100": 61, "timestamp": 1681429047}	2023-04-13 23:37:27+00
249396	{"pm10": 32, "pm25": 49, "pm100": 60, "timestamp": 1681429053}	2023-04-13 23:37:33+00
249396	{"pm10": 32, "pm25": 49, "pm100": 60, "timestamp": 1681429060}	2023-04-13 23:37:40+00
249396	{"pm10": 33, "pm25": 49, "pm100": 60, "timestamp": 1681429066}	2023-04-13 23:37:46+00
249396	{"pm10": 32, "pm25": 48, "pm100": 59, "timestamp": 1681429072}	2023-04-13 23:37:52+00
249396	{"pm10": 32, "pm25": 49, "pm100": 59, "timestamp": 1681429078}	2023-04-13 23:37:58+00
249396	{"pm10": 32, "pm25": 49, "pm100": 60, "timestamp": 1681429084}	2023-04-13 23:38:04+00
249396	{"pm10": 32, "pm25": 49, "pm100": 59, "timestamp": 1681429090}	2023-04-13 23:38:10+00
249396	{"pm10": 33, "pm25": 48, "pm100": 58, "timestamp": 1681429096}	2023-04-13 23:38:16+00
249396	{"pm10": 32, "pm25": 48, "pm100": 58, "timestamp": 1681429102}	2023-04-13 23:38:22+00
249396	{"pm10": 32, "pm25": 48, "pm100": 58, "timestamp": 1681429109}	2023-04-13 23:38:29+00
249396	{"pm10": 33, "pm25": 49, "pm100": 60, "timestamp": 1681429115}	2023-04-13 23:38:35+00
249396	{"pm10": 30, "pm25": 45, "pm100": 56, "timestamp": 1681429121}	2023-04-13 23:38:41+00
249396	{"pm10": 31, "pm25": 46, "pm100": 57, "timestamp": 1681429127}	2023-04-13 23:38:47+00
249396	{"pm10": 31, "pm25": 47, "pm100": 56, "timestamp": 1681429133}	2023-04-13 23:38:53+00
249396	{"pm10": 31, "pm25": 47, "pm100": 56, "timestamp": 1681429139}	2023-04-13 23:38:59+00
249396	{"pm10": 31, "pm25": 46, "pm100": 55, "timestamp": 1681429145}	2023-04-13 23:39:05+00
249396	{"pm10": 31, "pm25": 46, "pm100": 55, "timestamp": 1681429151}	2023-04-13 23:39:11+00
249396	{"pm10": 31, "pm25": 46, "pm100": 55, "timestamp": 1681429158}	2023-04-13 23:39:18+00
249396	{"pm10": 31, "pm25": 46, "pm100": 56, "timestamp": 1681429164}	2023-04-13 23:39:24+00
249396	{"pm10": 31, "pm25": 46, "pm100": 56, "timestamp": 1681429170}	2023-04-13 23:39:30+00
249396	{"pm10": 31, "pm25": 46, "pm100": 56, "timestamp": 1681429176}	2023-04-13 23:39:36+00
249396	{"pm10": 31, "pm25": 46, "pm100": 56, "timestamp": 1681429182}	2023-04-13 23:39:42+00
249396	{"pm10": 31, "pm25": 46, "pm100": 56, "timestamp": 1681429188}	2023-04-13 23:39:48+00
249396	{"pm10": 31, "pm25": 46, "pm100": 56, "timestamp": 1681429194}	2023-04-13 23:39:54+00
249396	{"pm10": 31, "pm25": 46, "pm100": 56, "timestamp": 1681429200}	2023-04-13 23:40:00+00
249396	{"pm10": 30, "pm25": 48, "pm100": 59, "timestamp": 1681429207}	2023-04-13 23:40:07+00
249396	{"pm10": 30, "pm25": 47, "pm100": 58, "timestamp": 1681429213}	2023-04-13 23:40:13+00
249396	{"pm10": 30, "pm25": 47, "pm100": 58, "timestamp": 1681429219}	2023-04-13 23:40:19+00
249396	{"pm10": 30, "pm25": 47, "pm100": 58, "timestamp": 1681429225}	2023-04-13 23:40:25+00
249396	{"pm10": 30, "pm25": 48, "pm100": 59, "timestamp": 1681429231}	2023-04-13 23:40:31+00
249396	{"pm10": 31, "pm25": 49, "pm100": 60, "timestamp": 1681429237}	2023-04-13 23:40:37+00
249396	{"pm10": 31, "pm25": 48, "pm100": 59, "timestamp": 1681429243}	2023-04-13 23:40:43+00
249396	{"pm10": 32, "pm25": 47, "pm100": 57, "timestamp": 1681429249}	2023-04-13 23:40:49+00
249396	{"pm10": 32, "pm25": 47, "pm100": 57, "timestamp": 1681429256}	2023-04-13 23:40:56+00
249396	{"pm10": 32, "pm25": 47, "pm100": 56, "timestamp": 1681429262}	2023-04-13 23:41:02+00
249396	{"pm10": 32, "pm25": 47, "pm100": 56, "timestamp": 1681429268}	2023-04-13 23:41:08+00
249396	{"pm10": 32, "pm25": 49, "pm100": 59, "timestamp": 1681429274}	2023-04-13 23:41:14+00
249396	{"pm10": 32, "pm25": 49, "pm100": 59, "timestamp": 1681429280}	2023-04-13 23:41:20+00
249396	{"pm10": 30, "pm25": 46, "pm100": 56, "timestamp": 1681429286}	2023-04-13 23:41:26+00
249396	{"pm10": 30, "pm25": 45, "pm100": 55, "timestamp": 1681429292}	2023-04-13 23:41:32+00
249396	{"pm10": 31, "pm25": 46, "pm100": 55, "timestamp": 1681429299}	2023-04-13 23:41:39+00
249396	{"pm10": 31, "pm25": 46, "pm100": 55, "timestamp": 1681429305}	2023-04-13 23:41:45+00
249396	{"pm10": 31, "pm25": 47, "pm100": 57, "timestamp": 1681429311}	2023-04-13 23:41:51+00
249396	{"pm10": 30, "pm25": 46, "pm100": 55, "timestamp": 1681429317}	2023-04-13 23:41:57+00
249396	{"pm10": 30, "pm25": 46, "pm100": 56, "timestamp": 1681429323}	2023-04-13 23:42:03+00
249396	{"pm10": 31, "pm25": 47, "pm100": 57, "timestamp": 1681429329}	2023-04-13 23:42:09+00
249396	{"pm10": 31, "pm25": 47, "pm100": 57, "timestamp": 1681429335}	2023-04-13 23:42:15+00
249396	{"pm10": 32, "pm25": 46, "pm100": 57, "timestamp": 1681429341}	2023-04-13 23:42:21+00
249396	{"pm10": 32, "pm25": 48, "pm100": 59, "timestamp": 1681429348}	2023-04-13 23:42:28+00
249396	{"pm10": 32, "pm25": 48, "pm100": 58, "timestamp": 1681429354}	2023-04-13 23:42:34+00
249396	{"pm10": 31, "pm25": 48, "pm100": 59, "timestamp": 1681429360}	2023-04-13 23:42:40+00
249396	{"pm10": 31, "pm25": 48, "pm100": 57, "timestamp": 1681429366}	2023-04-13 23:42:46+00
249396	{"pm10": 31, "pm25": 47, "pm100": 57, "timestamp": 1681429372}	2023-04-13 23:42:52+00
249396	{"pm10": 31, "pm25": 47, "pm100": 56, "timestamp": 1681429378}	2023-04-13 23:42:58+00
249396	{"pm10": 31, "pm25": 47, "pm100": 56, "timestamp": 1681429384}	2023-04-13 23:43:04+00
249396	{"pm10": 31, "pm25": 48, "pm100": 57, "timestamp": 1681429390}	2023-04-13 23:43:10+00
249396	{"pm10": 31, "pm25": 48, "pm100": 57, "timestamp": 1681429397}	2023-04-13 23:43:17+00
249396	{"pm10": 31, "pm25": 47, "pm100": 56, "timestamp": 1681429403}	2023-04-13 23:43:23+00
249396	{"pm10": 30, "pm25": 46, "pm100": 55, "timestamp": 1681429409}	2023-04-13 23:43:29+00
249396	{"pm10": 30, "pm25": 46, "pm100": 55, "timestamp": 1681429415}	2023-04-13 23:43:35+00
249396	{"pm10": 31, "pm25": 46, "pm100": 56, "timestamp": 1681429421}	2023-04-13 23:43:41+00
249396	{"pm10": 31, "pm25": 46, "pm100": 55, "timestamp": 1681429427}	2023-04-13 23:43:47+00
249396	{"pm10": 31, "pm25": 47, "pm100": 56, "timestamp": 1681429433}	2023-04-13 23:43:53+00
249396	{"pm10": 31, "pm25": 46, "pm100": 56, "timestamp": 1681429439}	2023-04-13 23:43:59+00
249396	{"pm10": 31, "pm25": 46, "pm100": 56, "timestamp": 1681429446}	2023-04-13 23:44:06+00
249396	{"pm10": 31, "pm25": 46, "pm100": 56, "timestamp": 1681429452}	2023-04-13 23:44:12+00
249396	{"pm10": 31, "pm25": 47, "pm100": 56, "timestamp": 1681429458}	2023-04-13 23:44:18+00
249396	{"pm10": 31, "pm25": 47, "pm100": 56, "timestamp": 1681429464}	2023-04-13 23:44:24+00
249396	{"pm10": 31, "pm25": 46, "pm100": 56, "timestamp": 1681429470}	2023-04-13 23:44:30+00
249396	{"pm10": 31, "pm25": 46, "pm100": 56, "timestamp": 1681429476}	2023-04-13 23:44:36+00
249396	{"pm10": 32, "pm25": 47, "pm100": 58, "timestamp": 1681429482}	2023-04-13 23:44:42+00
249396	{"pm10": 32, "pm25": 47, "pm100": 58, "timestamp": 1681429488}	2023-04-13 23:44:48+00
249396	{"pm10": 31, "pm25": 45, "pm100": 54, "timestamp": 1681429495}	2023-04-13 23:44:55+00
249396	{"pm10": 30, "pm25": 45, "pm100": 53, "timestamp": 1681429501}	2023-04-13 23:45:01+00
249396	{"pm10": 30, "pm25": 45, "pm100": 53, "timestamp": 1681429507}	2023-04-13 23:45:07+00
249396	{"pm10": 31, "pm25": 47, "pm100": 57, "timestamp": 1681429513}	2023-04-13 23:45:13+00
249396	{"pm10": 31, "pm25": 47, "pm100": 57, "timestamp": 1681429519}	2023-04-13 23:45:19+00
249396	{"pm10": 32, "pm25": 47, "pm100": 57, "timestamp": 1681429525}	2023-04-13 23:45:25+00
249396	{"pm10": 32, "pm25": 47, "pm100": 57, "timestamp": 1681429531}	2023-04-13 23:45:31+00
249396	{"pm10": 32, "pm25": 48, "pm100": 58, "timestamp": 1681429537}	2023-04-13 23:45:37+00
249396	{"pm10": 32, "pm25": 48, "pm100": 58, "timestamp": 1681429544}	2023-04-13 23:45:44+00
249396	{"pm10": 32, "pm25": 48, "pm100": 57, "timestamp": 1681429550}	2023-04-13 23:45:50+00
249396	{"pm10": 32, "pm25": 48, "pm100": 57, "timestamp": 1681429556}	2023-04-13 23:45:56+00
249396	{"pm10": 32, "pm25": 48, "pm100": 57, "timestamp": 1681429562}	2023-04-13 23:46:02+00
249396	{"pm10": 31, "pm25": 48, "pm100": 58, "timestamp": 1681429568}	2023-04-13 23:46:08+00
249396	{"pm10": 31, "pm25": 48, "pm100": 57, "timestamp": 1681429574}	2023-04-13 23:46:14+00
249396	{"pm10": 31, "pm25": 48, "pm100": 57, "timestamp": 1681429580}	2023-04-13 23:46:20+00
249396	{"pm10": 31, "pm25": 48, "pm100": 57, "timestamp": 1681429586}	2023-04-13 23:46:26+00
249396	{"pm10": 31, "pm25": 47, "pm100": 57, "timestamp": 1681429593}	2023-04-13 23:46:33+00
249396	{"pm10": 31, "pm25": 47, "pm100": 57, "timestamp": 1681429599}	2023-04-13 23:46:39+00
249396	{"pm10": 32, "pm25": 46, "pm100": 56, "timestamp": 1681429605}	2023-04-13 23:46:45+00
249396	{"pm10": 32, "pm25": 46, "pm100": 55, "timestamp": 1681429611}	2023-04-13 23:46:51+00
249396	{"pm10": 32, "pm25": 46, "pm100": 55, "timestamp": 1681429617}	2023-04-13 23:46:57+00
249396	{"pm10": 31, "pm25": 45, "pm100": 55, "timestamp": 1681429623}	2023-04-13 23:47:03+00
249396	{"pm10": 31, "pm25": 46, "pm100": 56, "timestamp": 1681429629}	2023-04-13 23:47:09+00
249396	{"pm10": 31, "pm25": 46, "pm100": 57, "timestamp": 1681429635}	2023-04-13 23:47:15+00
249396	{"pm10": 31, "pm25": 46, "pm100": 56, "timestamp": 1681429642}	2023-04-13 23:47:22+00
249396	{"pm10": 31, "pm25": 47, "pm100": 56, "timestamp": 1681429648}	2023-04-13 23:47:28+00
249396	{"pm10": 30, "pm25": 47, "pm100": 56, "timestamp": 1681429654}	2023-04-13 23:47:34+00
249396	{"pm10": 30, "pm25": 46, "pm100": 56, "timestamp": 1681429660}	2023-04-13 23:47:40+00
249396	{"pm10": 30, "pm25": 46, "pm100": 55, "timestamp": 1681429666}	2023-04-13 23:47:46+00
249396	{"pm10": 32, "pm25": 47, "pm100": 57, "timestamp": 1681429672}	2023-04-13 23:47:52+00
249396	{"pm10": 32, "pm25": 48, "pm100": 58, "timestamp": 1681429678}	2023-04-13 23:47:58+00
249396	{"pm10": 31, "pm25": 48, "pm100": 58, "timestamp": 1681429684}	2023-04-13 23:48:04+00
249396	{"pm10": 32, "pm25": 49, "pm100": 59, "timestamp": 1681429691}	2023-04-13 23:48:11+00
249396	{"pm10": 32, "pm25": 48, "pm100": 58, "timestamp": 1681429697}	2023-04-13 23:48:17+00
249396	{"pm10": 32, "pm25": 48, "pm100": 58, "timestamp": 1681429703}	2023-04-13 23:48:23+00
249396	{"pm10": 31, "pm25": 47, "pm100": 58, "timestamp": 1681429709}	2023-04-13 23:48:29+00
249396	{"pm10": 31, "pm25": 46, "pm100": 56, "timestamp": 1681429715}	2023-04-13 23:48:35+00
249396	{"pm10": 31, "pm25": 46, "pm100": 56, "timestamp": 1681429721}	2023-04-13 23:48:41+00
249396	{"pm10": 31, "pm25": 46, "pm100": 58, "timestamp": 1681429727}	2023-04-13 23:48:47+00
249396	{"pm10": 31, "pm25": 48, "pm100": 58, "timestamp": 1681429733}	2023-04-13 23:48:53+00
249396	{"pm10": 31, "pm25": 49, "pm100": 60, "timestamp": 1681429740}	2023-04-13 23:49:00+00
249396	{"pm10": 30, "pm25": 45, "pm100": 56, "timestamp": 1681429746}	2023-04-13 23:49:06+00
249396	{"pm10": 31, "pm25": 46, "pm100": 59, "timestamp": 1681429752}	2023-04-13 23:49:12+00
249396	{"pm10": 31, "pm25": 46, "pm100": 59, "timestamp": 1681429758}	2023-04-13 23:49:18+00
249396	{"pm10": 30, "pm25": 45, "pm100": 55, "timestamp": 1681429764}	2023-04-13 23:49:24+00
249396	{"pm10": 32, "pm25": 47, "pm100": 58, "timestamp": 1681429770}	2023-04-13 23:49:30+00
249396	{"pm10": 32, "pm25": 47, "pm100": 57, "timestamp": 1681429776}	2023-04-13 23:49:36+00
249396	{"pm10": 32, "pm25": 47, "pm100": 56, "timestamp": 1681429782}	2023-04-13 23:49:42+00
249396	{"pm10": 31, "pm25": 46, "pm100": 57, "timestamp": 1681429789}	2023-04-13 23:49:49+00
249396	{"pm10": 30, "pm25": 49, "pm100": 60, "timestamp": 1681429795}	2023-04-13 23:49:55+00
249396	{"pm10": 30, "pm25": 49, "pm100": 60, "timestamp": 1681429801}	2023-04-13 23:50:01+00
249396	{"pm10": 30, "pm25": 47, "pm100": 59, "timestamp": 1681429807}	2023-04-13 23:50:07+00
249396	{"pm10": 30, "pm25": 47, "pm100": 59, "timestamp": 1681429813}	2023-04-13 23:50:13+00
249396	{"pm10": 30, "pm25": 47, "pm100": 58, "timestamp": 1681429819}	2023-04-13 23:50:19+00
249396	{"pm10": 30, "pm25": 46, "pm100": 58, "timestamp": 1681429825}	2023-04-13 23:50:25+00
249396	{"pm10": 31, "pm25": 50, "pm100": 60, "timestamp": 1681429832}	2023-04-13 23:50:32+00
249396	{"pm10": 31, "pm25": 49, "pm100": 60, "timestamp": 1681429838}	2023-04-13 23:50:38+00
249396	{"pm10": 32, "pm25": 49, "pm100": 59, "timestamp": 1681429844}	2023-04-13 23:50:44+00
249396	{"pm10": 32, "pm25": 49, "pm100": 60, "timestamp": 1681429850}	2023-04-13 23:50:50+00
249396	{"pm10": 32, "pm25": 49, "pm100": 60, "timestamp": 1681429856}	2023-04-13 23:50:56+00
249396	{"pm10": 32, "pm25": 48, "pm100": 58, "timestamp": 1681429862}	2023-04-13 23:51:02+00
249396	{"pm10": 32, "pm25": 48, "pm100": 58, "timestamp": 1681429868}	2023-04-13 23:51:08+00
249396	{"pm10": 32, "pm25": 48, "pm100": 58, "timestamp": 1681429874}	2023-04-13 23:51:14+00
249396	{"pm10": 32, "pm25": 48, "pm100": 58, "timestamp": 1681429881}	2023-04-13 23:51:21+00
249396	{"pm10": 31, "pm25": 47, "pm100": 57, "timestamp": 1681429887}	2023-04-13 23:51:27+00
249396	{"pm10": 31, "pm25": 47, "pm100": 57, "timestamp": 1681429893}	2023-04-13 23:51:33+00
249396	{"pm10": 31, "pm25": 47, "pm100": 57, "timestamp": 1681429899}	2023-04-13 23:51:39+00
249396	{"pm10": 31, "pm25": 47, "pm100": 56, "timestamp": 1681429905}	2023-04-13 23:51:45+00
249396	{"pm10": 31, "pm25": 45, "pm100": 56, "timestamp": 1681429911}	2023-04-13 23:51:51+00
249396	{"pm10": 30, "pm25": 45, "pm100": 57, "timestamp": 1681429917}	2023-04-13 23:51:57+00
249396	{"pm10": 30, "pm25": 45, "pm100": 57, "timestamp": 1681429923}	2023-04-13 23:52:03+00
249396	{"pm10": 30, "pm25": 45, "pm100": 56, "timestamp": 1681429930}	2023-04-13 23:52:10+00
249396	{"pm10": 30, "pm25": 46, "pm100": 56, "timestamp": 1681429936}	2023-04-13 23:52:16+00
249396	{"pm10": 30, "pm25": 46, "pm100": 56, "timestamp": 1681429942}	2023-04-13 23:52:22+00
249396	{"pm10": 30, "pm25": 46, "pm100": 55, "timestamp": 1681429948}	2023-04-13 23:52:28+00
249396	{"pm10": 30, "pm25": 46, "pm100": 55, "timestamp": 1681429954}	2023-04-13 23:52:34+00
249396	{"pm10": 30, "pm25": 46, "pm100": 55, "timestamp": 1681429960}	2023-04-13 23:52:40+00
249396	{"pm10": 30, "pm25": 46, "pm100": 55, "timestamp": 1681429966}	2023-04-13 23:52:46+00
249396	{"pm10": 31, "pm25": 47, "pm100": 56, "timestamp": 1681429973}	2023-04-13 23:52:53+00
249396	{"pm10": 32, "pm25": 47, "pm100": 56, "timestamp": 1681429979}	2023-04-13 23:52:59+00
249396	{"pm10": 32, "pm25": 48, "pm100": 57, "timestamp": 1681429985}	2023-04-13 23:53:05+00
249396	{"pm10": 31, "pm25": 49, "pm100": 59, "timestamp": 1681429991}	2023-04-13 23:53:11+00
249396	{"pm10": 31, "pm25": 47, "pm100": 56, "timestamp": 1681429997}	2023-04-13 23:53:17+00
249396	{"pm10": 31, "pm25": 47, "pm100": 56, "timestamp": 1681430003}	2023-04-13 23:53:23+00
249396	{"pm10": 31, "pm25": 47, "pm100": 56, "timestamp": 1681430009}	2023-04-13 23:53:29+00
249396	{"pm10": 32, "pm25": 48, "pm100": 60, "timestamp": 1681430015}	2023-04-13 23:53:35+00
249396	{"pm10": 31, "pm25": 46, "pm100": 57, "timestamp": 1681430328}	2023-04-13 23:58:48+00
249396	{"pm10": 31, "pm25": 47, "pm100": 57, "timestamp": 1681430334}	2023-04-13 23:58:54+00
249396	{"pm10": 31, "pm25": 48, "pm100": 59, "timestamp": 1681430340}	2023-04-13 23:59:00+00
249396	{"pm10": 33, "pm25": 49, "pm100": 60, "timestamp": 1681430346}	2023-04-13 23:59:06+00
249396	{"pm10": 33, "pm25": 48, "pm100": 58, "timestamp": 1681430352}	2023-04-13 23:59:12+00
249396	{"pm10": 32, "pm25": 48, "pm100": 58, "timestamp": 1681430359}	2023-04-13 23:59:19+00
249396	{"pm10": 32, "pm25": 48, "pm100": 58, "timestamp": 1681430365}	2023-04-13 23:59:25+00
249396	{"pm10": 33, "pm25": 48, "pm100": 58, "timestamp": 1681430371}	2023-04-13 23:59:31+00
249396	{"pm10": 32, "pm25": 47, "pm100": 58, "timestamp": 1681430377}	2023-04-13 23:59:37+00
249396	{"pm10": 32, "pm25": 47, "pm100": 58, "timestamp": 1681430383}	2023-04-13 23:59:43+00
249396	{"pm10": 32, "pm25": 47, "pm100": 59, "timestamp": 1681430389}	2023-04-13 23:59:49+00
249396	{"pm10": 32, "pm25": 47, "pm100": 59, "timestamp": 1681430395}	2023-04-13 23:59:55+00
249396	{"pm10": 31, "pm25": 46, "pm100": 55, "timestamp": 1681430402}	2023-04-14 00:00:02+00
249396	{"pm10": 31, "pm25": 46, "pm100": 55, "timestamp": 1681430408}	2023-04-14 00:00:08+00
249396	{"pm10": 31, "pm25": 46, "pm100": 55, "timestamp": 1681430414}	2023-04-14 00:00:14+00
249396	{"pm10": 32, "pm25": 46, "pm100": 56, "timestamp": 1681430420}	2023-04-14 00:00:20+00
249396	{"pm10": 32, "pm25": 47, "pm100": 56, "timestamp": 1681430427}	2023-04-14 00:00:27+00
249396	{"pm10": 32, "pm25": 48, "pm100": 57, "timestamp": 1681430433}	2023-04-14 00:00:33+00
249396	{"pm10": 32, "pm25": 47, "pm100": 56, "timestamp": 1681430439}	2023-04-14 00:00:39+00
249396	{"pm10": 32, "pm25": 47, "pm100": 56, "timestamp": 1681430445}	2023-04-14 00:00:45+00
249396	{"pm10": 33, "pm25": 47, "pm100": 57, "timestamp": 1681430451}	2023-04-14 00:00:51+00
249396	{"pm10": 31, "pm25": 47, "pm100": 57, "timestamp": 1681430457}	2023-04-14 00:00:57+00
249396	{"pm10": 31, "pm25": 47, "pm100": 57, "timestamp": 1681430463}	2023-04-14 00:01:03+00
249396	{"pm10": 31, "pm25": 47, "pm100": 58, "timestamp": 1681430469}	2023-04-14 00:01:09+00
249396	{"pm10": 31, "pm25": 47, "pm100": 58, "timestamp": 1681430476}	2023-04-14 00:01:16+00
249396	{"pm10": 31, "pm25": 47, "pm100": 57, "timestamp": 1681430482}	2023-04-14 00:01:22+00
249396	{"pm10": 32, "pm25": 48, "pm100": 61, "timestamp": 1681430488}	2023-04-14 00:01:28+00
249396	{"pm10": 32, "pm25": 48, "pm100": 61, "timestamp": 1681430494}	2023-04-14 00:01:34+00
249396	{"pm10": 32, "pm25": 48, "pm100": 57, "timestamp": 1681430500}	2023-04-14 00:01:40+00
249396	{"pm10": 32, "pm25": 48, "pm100": 57, "timestamp": 1681430506}	2023-04-14 00:01:46+00
249396	{"pm10": 32, "pm25": 48, "pm100": 57, "timestamp": 1681430512}	2023-04-14 00:01:52+00
249396	{"pm10": 33, "pm25": 48, "pm100": 58, "timestamp": 1681430518}	2023-04-14 00:01:58+00
249396	{"pm10": 33, "pm25": 48, "pm100": 58, "timestamp": 1681430525}	2023-04-14 00:02:05+00
249396	{"pm10": 33, "pm25": 48, "pm100": 58, "timestamp": 1681430531}	2023-04-14 00:02:11+00
249396	{"pm10": 33, "pm25": 48, "pm100": 58, "timestamp": 1681430537}	2023-04-14 00:02:17+00
249396	{"pm10": 33, "pm25": 47, "pm100": 58, "timestamp": 1681430543}	2023-04-14 00:02:23+00
249396	{"pm10": 33, "pm25": 47, "pm100": 58, "timestamp": 1681430549}	2023-04-14 00:02:29+00
249396	{"pm10": 31, "pm25": 47, "pm100": 57, "timestamp": 1681430555}	2023-04-14 00:02:35+00
249396	{"pm10": 31, "pm25": 46, "pm100": 56, "timestamp": 1681430561}	2023-04-14 00:02:41+00
249396	{"pm10": 31, "pm25": 46, "pm100": 56, "timestamp": 1681430567}	2023-04-14 00:02:47+00
249396	{"pm10": 31, "pm25": 46, "pm100": 56, "timestamp": 1681430574}	2023-04-14 00:02:54+00
249396	{"pm10": 32, "pm25": 48, "pm100": 59, "timestamp": 1681430580}	2023-04-14 00:03:00+00
249396	{"pm10": 32, "pm25": 48, "pm100": 59, "timestamp": 1681430586}	2023-04-14 00:03:06+00
249396	{"pm10": 32, "pm25": 49, "pm100": 59, "timestamp": 1681430592}	2023-04-14 00:03:12+00
249396	{"pm10": 31, "pm25": 48, "pm100": 58, "timestamp": 1681430598}	2023-04-14 00:03:18+00
249396	{"pm10": 31, "pm25": 49, "pm100": 59, "timestamp": 1681430604}	2023-04-14 00:03:24+00
249396	{"pm10": 31, "pm25": 47, "pm100": 58, "timestamp": 1681430610}	2023-04-14 00:03:30+00
249396	{"pm10": 31, "pm25": 47, "pm100": 57, "timestamp": 1681430616}	2023-04-14 00:03:36+00
249396	{"pm10": 31, "pm25": 48, "pm100": 59, "timestamp": 1681430623}	2023-04-14 00:03:43+00
249396	{"pm10": 31, "pm25": 48, "pm100": 59, "timestamp": 1681430629}	2023-04-14 00:03:49+00
249396	{"pm10": 32, "pm25": 46, "pm100": 57, "timestamp": 1681430635}	2023-04-14 00:03:55+00
249396	{"pm10": 32, "pm25": 47, "pm100": 58, "timestamp": 1681430641}	2023-04-14 00:04:01+00
249396	{"pm10": 32, "pm25": 47, "pm100": 58, "timestamp": 1681430647}	2023-04-14 00:04:07+00
249396	{"pm10": 31, "pm25": 46, "pm100": 56, "timestamp": 1681430653}	2023-04-14 00:04:13+00
249396	{"pm10": 31, "pm25": 46, "pm100": 56, "timestamp": 1681430659}	2023-04-14 00:04:19+00
249396	{"pm10": 31, "pm25": 49, "pm100": 60, "timestamp": 1681430665}	2023-04-14 00:04:25+00
249396	{"pm10": 31, "pm25": 49, "pm100": 59, "timestamp": 1681430672}	2023-04-14 00:04:32+00
249396	{"pm10": 31, "pm25": 48, "pm100": 58, "timestamp": 1681430678}	2023-04-14 00:04:38+00
249396	{"pm10": 31, "pm25": 48, "pm100": 58, "timestamp": 1681430684}	2023-04-14 00:04:44+00
249396	{"pm10": 31, "pm25": 48, "pm100": 58, "timestamp": 1681430690}	2023-04-14 00:04:50+00
249396	{"pm10": 32, "pm25": 49, "pm100": 59, "timestamp": 1681430696}	2023-04-14 00:04:56+00
249396	{"pm10": 32, "pm25": 48, "pm100": 58, "timestamp": 1681430702}	2023-04-14 00:05:02+00
249396	{"pm10": 31, "pm25": 48, "pm100": 58, "timestamp": 1681430708}	2023-04-14 00:05:08+00
249396	{"pm10": 31, "pm25": 47, "pm100": 57, "timestamp": 1681430714}	2023-04-14 00:05:14+00
249396	{"pm10": 30, "pm25": 46, "pm100": 56, "timestamp": 1681430721}	2023-04-14 00:05:21+00
249396	{"pm10": 31, "pm25": 46, "pm100": 57, "timestamp": 1681430727}	2023-04-14 00:05:27+00
249396	{"pm10": 31, "pm25": 46, "pm100": 57, "timestamp": 1681430733}	2023-04-14 00:05:33+00
249396	{"pm10": 31, "pm25": 46, "pm100": 57, "timestamp": 1681430739}	2023-04-14 00:05:39+00
249396	{"pm10": 32, "pm25": 47, "pm100": 58, "timestamp": 1681430745}	2023-04-14 00:05:45+00
249396	{"pm10": 32, "pm25": 47, "pm100": 57, "timestamp": 1681430751}	2023-04-14 00:05:51+00
249396	{"pm10": 32, "pm25": 46, "pm100": 56, "timestamp": 1681430794}	2023-04-14 00:06:34+00
249396	{"pm10": 32, "pm25": 46, "pm100": 56, "timestamp": 1681430800}	2023-04-14 00:06:40+00
249396	{"pm10": 31, "pm25": 46, "pm100": 56, "timestamp": 1681430813}	2023-04-14 00:06:53+00
249396	{"pm10": 31, "pm25": 47, "pm100": 57, "timestamp": 1681430831}	2023-04-14 00:07:11+00
249396	{"pm10": 30, "pm25": 45, "pm100": 55, "timestamp": 1681430843}	2023-04-14 00:07:23+00
249396	{"pm10": 31, "pm25": 46, "pm100": 58, "timestamp": 1681430855}	2023-04-14 00:07:35+00
249396	{"pm10": 32, "pm25": 47, "pm100": 59, "timestamp": 1681430868}	2023-04-14 00:07:48+00
249396	{"pm10": 31, "pm25": 46, "pm100": 57, "timestamp": 1681430874}	2023-04-14 00:07:54+00
249396	{"pm10": 32, "pm25": 48, "pm100": 57, "timestamp": 1681430886}	2023-04-14 00:08:06+00
249396	{"pm10": 32, "pm25": 46, "pm100": 56, "timestamp": 1681431180}	2023-04-14 00:13:00+00
249396	{"pm10": 33, "pm25": 47, "pm100": 56, "timestamp": 1681431459}	2023-04-14 00:17:39+00
249396	{"pm10": 32, "pm25": 47, "pm100": 57, "timestamp": 1681430757}	2023-04-14 00:05:57+00
249396	{"pm10": 32, "pm25": 46, "pm100": 56, "timestamp": 1681430764}	2023-04-14 00:06:04+00
249396	{"pm10": 31, "pm25": 46, "pm100": 56, "timestamp": 1681430770}	2023-04-14 00:06:10+00
249396	{"pm10": 31, "pm25": 46, "pm100": 56, "timestamp": 1681430776}	2023-04-14 00:06:16+00
249396	{"pm10": 31, "pm25": 46, "pm100": 55, "timestamp": 1681430782}	2023-04-14 00:06:22+00
249396	{"pm10": 31, "pm25": 46, "pm100": 55, "timestamp": 1681430788}	2023-04-14 00:06:28+00
249396	{"pm10": 31, "pm25": 46, "pm100": 55, "timestamp": 1681430806}	2023-04-14 00:06:46+00
249396	{"pm10": 31, "pm25": 47, "pm100": 57, "timestamp": 1681430819}	2023-04-14 00:06:59+00
249396	{"pm10": 31, "pm25": 47, "pm100": 57, "timestamp": 1681430825}	2023-04-14 00:07:05+00
249396	{"pm10": 30, "pm25": 45, "pm100": 55, "timestamp": 1681430837}	2023-04-14 00:07:17+00
249396	{"pm10": 31, "pm25": 46, "pm100": 58, "timestamp": 1681430849}	2023-04-14 00:07:29+00
249396	{"pm10": 32, "pm25": 47, "pm100": 59, "timestamp": 1681430862}	2023-04-14 00:07:42+00
249396	{"pm10": 31, "pm25": 47, "pm100": 57, "timestamp": 1681430880}	2023-04-14 00:08:00+00
249396	{"pm10": 31, "pm25": 47, "pm100": 57, "timestamp": 1681430892}	2023-04-14 00:08:12+00
249396	{"pm10": 31, "pm25": 48, "pm100": 57, "timestamp": 1681430898}	2023-04-14 00:08:18+00
249396	{"pm10": 31, "pm25": 46, "pm100": 55, "timestamp": 1681430904}	2023-04-14 00:08:24+00
249396	{"pm10": 30, "pm25": 46, "pm100": 55, "timestamp": 1681430911}	2023-04-14 00:08:31+00
249396	{"pm10": 33, "pm25": 50, "pm100": 61, "timestamp": 1681430917}	2023-04-14 00:08:37+00
249396	{"pm10": 33, "pm25": 50, "pm100": 61, "timestamp": 1681430923}	2023-04-14 00:08:43+00
249396	{"pm10": 33, "pm25": 49, "pm100": 60, "timestamp": 1681430929}	2023-04-14 00:08:49+00
249396	{"pm10": 33, "pm25": 49, "pm100": 60, "timestamp": 1681430935}	2023-04-14 00:08:55+00
249396	{"pm10": 32, "pm25": 47, "pm100": 56, "timestamp": 1681430941}	2023-04-14 00:09:01+00
249396	{"pm10": 32, "pm25": 47, "pm100": 56, "timestamp": 1681430994}	2023-04-14 00:09:54+00
249396	{"pm10": 32, "pm25": 46, "pm100": 56, "timestamp": 1681431087}	2023-04-14 00:11:27+00
249396	{"pm10": 32, "pm25": 46, "pm100": 56, "timestamp": 1681431273}	2023-04-14 00:14:33+00
249396	{"pm10": 32, "pm25": 46, "pm100": 56, "timestamp": 1681431366}	2023-04-14 00:16:06+00
249396	{"pm10": 33, "pm25": 47, "pm100": 56, "timestamp": 1681431553}	2023-04-14 00:19:13+00
249396	{"pm10": 32, "pm25": 46, "pm100": 56, "timestamp": 1681431646}	2023-04-14 00:20:46+00
249396	{"pm10": 31, "pm25": 48, "pm100": 57, "timestamp": 1681431739}	2023-04-14 00:22:19+00
249396	{"pm10": 31, "pm25": 48, "pm100": 57, "timestamp": 1681431832}	2023-04-14 00:23:52+00
249396	{"pm10": 31, "pm25": 48, "pm100": 57, "timestamp": 1681431925}	2023-04-14 00:25:25+00
249396	{"pm10": 32, "pm25": 47, "pm100": 57, "timestamp": 1681432018}	2023-04-14 00:26:58+00
249396	{"pm10": 32, "pm25": 47, "pm100": 57, "timestamp": 1681432111}	2023-04-14 00:28:31+00
249396	{"pm10": 32, "pm25": 48, "pm100": 57, "timestamp": 1681432205}	2023-04-14 00:30:05+00
249396	{"pm10": 32, "pm25": 47, "pm100": 57, "timestamp": 1681432298}	2023-04-14 00:31:38+00
249396	{"pm10": 35, "pm25": 52, "pm100": 65, "timestamp": 1681432391}	2023-04-14 00:33:11+00
249396	{"pm10": 35, "pm25": 52, "pm100": 64, "timestamp": 1681432484}	2023-04-14 00:34:44+00
249396	{"pm10": 35, "pm25": 52, "pm100": 64, "timestamp": 1681432577}	2023-04-14 00:36:17+00
249396	{"pm10": 33, "pm25": 51, "pm100": 63, "timestamp": 1681457837}	2023-04-14 07:37:17+00
249396	{"pm10": 33, "pm25": 52, "pm100": 63, "timestamp": 1681457930}	2023-04-14 07:38:50+00
249396	{"pm10": 33, "pm25": 52, "pm100": 63, "timestamp": 1681458023}	2023-04-14 07:40:23+00
249396	{"pm10": 34, "pm25": 52, "pm100": 63, "timestamp": 1681458116}	2023-04-14 07:41:56+00
249396	{"pm10": 34, "pm25": 52, "pm100": 63, "timestamp": 1681458209}	2023-04-14 07:43:29+00
249396	{"pm10": 34, "pm25": 52, "pm100": 63, "timestamp": 1681458302}	2023-04-14 07:45:02+00
249396	{"pm10": 34, "pm25": 52, "pm100": 63, "timestamp": 1681458395}	2023-04-14 07:46:35+00
249396	{"pm10": 34, "pm25": 51, "pm100": 62, "timestamp": 1681458489}	2023-04-14 07:48:09+00
249396	{"pm10": 33, "pm25": 49, "pm100": 60, "timestamp": 1681458582}	2023-04-14 07:49:42+00
249396	{"pm10": 33, "pm25": 49, "pm100": 61, "timestamp": 1681458675}	2023-04-14 07:51:15+00
249396	{"pm10": 33, "pm25": 49, "pm100": 61, "timestamp": 1681458768}	2023-04-14 07:52:48+00
249396	{"pm10": 33, "pm25": 50, "pm100": 61, "timestamp": 1681458861}	2023-04-14 07:54:21+00
249396	{"pm10": 33, "pm25": 50, "pm100": 61, "timestamp": 1681458954}	2023-04-14 07:55:54+00
249396	{"pm10": 33, "pm25": 50, "pm100": 61, "timestamp": 1681459047}	2023-04-14 07:57:27+00
249396	{"pm10": 33, "pm25": 50, "pm100": 61, "timestamp": 1681459141}	2023-04-14 07:59:01+00
249396	{"pm10": 33, "pm25": 50, "pm100": 61, "timestamp": 1681459234}	2023-04-14 08:00:34+00
249396	{"pm10": 33, "pm25": 50, "pm100": 61, "timestamp": 1681459327}	2023-04-14 08:02:07+00
249396	{"pm10": 33, "pm25": 49, "pm100": 60, "timestamp": 1681459420}	2023-04-14 08:03:40+00
249396	{"pm10": 33, "pm25": 50, "pm100": 60, "timestamp": 1681459513}	2023-04-14 08:05:13+00
249396	{"pm10": 32, "pm25": 50, "pm100": 61, "timestamp": 1681459606}	2023-04-14 08:06:46+00
249396	{"pm10": 33, "pm25": 50, "pm100": 60, "timestamp": 1681459699}	2023-04-14 08:08:19+00
249396	{"pm10": 31, "pm25": 47, "pm100": 57, "timestamp": 1681459886}	2023-04-14 08:11:26+00
249396	{"pm10": 31, "pm25": 47, "pm100": 57, "timestamp": 1681459979}	2023-04-14 08:12:59+00
249396	{"pm10": 31, "pm25": 48, "pm100": 57, "timestamp": 1681460072}	2023-04-14 08:14:32+00
249396	{"pm10": 31, "pm25": 49, "pm100": 58, "timestamp": 1681460351}	2023-04-14 08:19:11+00
249396	{"pm10": 33, "pm25": 48, "pm100": 59, "timestamp": 1681460631}	2023-04-14 08:23:51+00
249396	{"pm10": 30, "pm25": 45, "pm100": 56, "timestamp": 1681460910}	2023-04-14 08:28:30+00
249396	{"pm10": 30, "pm25": 45, "pm100": 56, "timestamp": 1681461004}	2023-04-14 08:30:04+00
249396	{"pm10": 32, "pm25": 48, "pm100": 57, "timestamp": 1681461097}	2023-04-14 08:31:37+00
249396	{"pm10": 31, "pm25": 45, "pm100": 54, "timestamp": 1681461562}	2023-04-14 08:39:22+00
249396	{"pm10": 33, "pm25": 50, "pm100": 61, "timestamp": 1681459793}	2023-04-14 08:09:53+00
249396	{"pm10": 32, "pm25": 49, "pm100": 58, "timestamp": 1681460258}	2023-04-14 08:17:38+00
249396	{"pm10": 33, "pm25": 48, "pm100": 58, "timestamp": 1681460538}	2023-04-14 08:22:18+00
249396	{"pm10": 31, "pm25": 46, "pm100": 56, "timestamp": 1681461190}	2023-04-14 08:33:10+00
249396	{"pm10": 31, "pm25": 45, "pm100": 53, "timestamp": 1681461376}	2023-04-14 08:36:16+00
249396	{"pm10": 32, "pm25": 48, "pm100": 58, "timestamp": 1681460165}	2023-04-14 08:16:05+00
249396	{"pm10": 31, "pm25": 49, "pm100": 58, "timestamp": 1681460445}	2023-04-14 08:20:45+00
249396	{"pm10": 33, "pm25": 48, "pm100": 59, "timestamp": 1681460724}	2023-04-14 08:25:24+00
249396	{"pm10": 31, "pm25": 46, "pm100": 57, "timestamp": 1681460817}	2023-04-14 08:26:57+00
249396	{"pm10": 31, "pm25": 46, "pm100": 56, "timestamp": 1681461283}	2023-04-14 08:34:43+00
249396	{"pm10": 31, "pm25": 45, "pm100": 53, "timestamp": 1681461469}	2023-04-14 08:37:49+00
249396	{"pm10": 39, "pm25": 61, "pm100": 77, "timestamp": 1681475592}	2023-04-14 12:33:12+00
249396	{"pm10": 27, "pm25": 44, "pm100": 52, "timestamp": 1681475792}	2023-04-14 12:36:32+00
249396	{"pm10": 39, "pm25": 64, "pm100": 75, "timestamp": 1681475885}	2023-04-14 12:38:05+00
249396	{"pm10": 39, "pm25": 62, "pm100": 74, "timestamp": 1681475978}	2023-04-14 12:39:38+00
249396	{"pm10": 36, "pm25": 59, "pm100": 73, "timestamp": 1681476061}	2023-04-14 12:41:01+00
249396	{"pm10": 36, "pm25": 55, "pm100": 67, "timestamp": 1681476228}	2023-04-14 12:43:48+00
249396	{"pm10": 39, "pm25": 59, "pm100": 72, "timestamp": 1681476321}	2023-04-14 12:45:21+00
249396	{"pm10": 40, "pm25": 60, "pm100": 74, "timestamp": 1681476414}	2023-04-14 12:46:54+00
249396	{"pm10": 38, "pm25": 59, "pm100": 72, "timestamp": 1681476507}	2023-04-14 12:48:27+00
249396	{"pm10": 38, "pm25": 59, "pm100": 72, "timestamp": 1681476600}	2023-04-14 12:50:00+00
249396	{"pm10": 38, "pm25": 57, "pm100": 71, "timestamp": 1681476693}	2023-04-14 12:51:33+00
249396	{"pm10": 38, "pm25": 57, "pm100": 71, "timestamp": 1681476786}	2023-04-14 12:53:06+00
249396	{"pm10": 36, "pm25": 55, "pm100": 69, "timestamp": 1681476880}	2023-04-14 12:54:40+00
249396	{"pm10": 39, "pm25": 59, "pm100": 70, "timestamp": 1681476973}	2023-04-14 12:56:13+00
249396	{"pm10": 38, "pm25": 59, "pm100": 70, "timestamp": 1681477066}	2023-04-14 12:57:46+00
249396	{"pm10": 38, "pm25": 58, "pm100": 69, "timestamp": 1681477159}	2023-04-14 12:59:19+00
249396	{"pm10": 37, "pm25": 57, "pm100": 69, "timestamp": 1681477252}	2023-04-14 13:00:52+00
249396	{"pm10": 37, "pm25": 57, "pm100": 69, "timestamp": 1681477345}	2023-04-14 13:02:25+00
249396	{"pm10": 36, "pm25": 55, "pm100": 67, "timestamp": 1681477438}	2023-04-14 13:03:58+00
249396	{"pm10": 36, "pm25": 55, "pm100": 67, "timestamp": 1681477532}	2023-04-14 13:05:32+00
249396	{"pm10": 39, "pm25": 55, "pm100": 68, "timestamp": 1681477625}	2023-04-14 13:07:05+00
249396	{"pm10": 37, "pm25": 55, "pm100": 68, "timestamp": 1681477718}	2023-04-14 13:08:38+00
249396	{"pm10": 38, "pm25": 57, "pm100": 68, "timestamp": 1681477811}	2023-04-14 13:10:11+00
249396	{"pm10": 38, "pm25": 55, "pm100": 67, "timestamp": 1681477904}	2023-04-14 13:11:44+00
249396	{"pm10": 39, "pm25": 57, "pm100": 68, "timestamp": 1681477997}	2023-04-14 13:13:17+00
249396	{"pm10": 40, "pm25": 57, "pm100": 68, "timestamp": 1681478090}	2023-04-14 13:14:50+00
249396	{"pm10": 40, "pm25": 57, "pm100": 68, "timestamp": 1681478184}	2023-04-14 13:16:24+00
249396	{"pm10": 40, "pm25": 57, "pm100": 68, "timestamp": 1681478277}	2023-04-14 13:17:57+00
249396	{"pm10": 41, "pm25": 58, "pm100": 69, "timestamp": 1681478370}	2023-04-14 13:19:30+00
249396	{"pm10": 38, "pm25": 58, "pm100": 69, "timestamp": 1681478463}	2023-04-14 13:21:03+00
249396	{"pm10": 39, "pm25": 59, "pm100": 70, "timestamp": 1681478556}	2023-04-14 13:22:36+00
249396	{"pm10": 39, "pm25": 60, "pm100": 70, "timestamp": 1681478649}	2023-04-14 13:24:09+00
249396	{"pm10": 39, "pm25": 59, "pm100": 70, "timestamp": 1681478742}	2023-04-14 13:25:42+00
249396	{"pm10": 39, "pm25": 59, "pm100": 70, "timestamp": 1681478836}	2023-04-14 13:27:16+00
249396	{"pm10": 36, "pm25": 55, "pm100": 66, "timestamp": 1681478929}	2023-04-14 13:28:49+00
249396	{"pm10": 36, "pm25": 53, "pm100": 65, "timestamp": 1681479022}	2023-04-14 13:30:22+00
249396	{"pm10": 38, "pm25": 55, "pm100": 66, "timestamp": 1681479115}	2023-04-14 13:31:55+00
249396	{"pm10": 38, "pm25": 56, "pm100": 67, "timestamp": 1681479208}	2023-04-14 13:33:28+00
249396	{"pm10": 40, "pm25": 58, "pm100": 70, "timestamp": 1681479301}	2023-04-14 13:35:01+00
249396	{"pm10": 40, "pm25": 59, "pm100": 71, "timestamp": 1681479395}	2023-04-14 13:36:35+00
249396	{"pm10": 40, "pm25": 59, "pm100": 71, "timestamp": 1681479488}	2023-04-14 13:38:08+00
249396	{"pm10": 37, "pm25": 52, "pm100": 65, "timestamp": 1681479581}	2023-04-14 13:39:41+00
249396	{"pm10": 37, "pm25": 52, "pm100": 65, "timestamp": 1681479674}	2023-04-14 13:41:14+00
249396	{"pm10": 36, "pm25": 52, "pm100": 66, "timestamp": 1681479767}	2023-04-14 13:42:47+00
249396	{"pm10": 36, "pm25": 52, "pm100": 66, "timestamp": 1681479860}	2023-04-14 13:44:20+00
249396	{"pm10": 36, "pm25": 52, "pm100": 66, "timestamp": 1681479953}	2023-04-14 13:45:53+00
249396	{"pm10": 36, "pm25": 52, "pm100": 66, "timestamp": 1681480047}	2023-04-14 13:47:27+00
249396	{"pm10": 37, "pm25": 53, "pm100": 66, "timestamp": 1681480140}	2023-04-14 13:49:00+00
249396	{"pm10": 37, "pm25": 53, "pm100": 66, "timestamp": 1681480233}	2023-04-14 13:50:33+00
249396	{"pm10": 37, "pm25": 53, "pm100": 66, "timestamp": 1681480326}	2023-04-14 13:52:06+00
249396	{"pm10": 37, "pm25": 53, "pm100": 66, "timestamp": 1681480419}	2023-04-14 13:53:39+00
249396	{"pm10": 37, "pm25": 53, "pm100": 66, "timestamp": 1681480512}	2023-04-14 13:55:12+00
249396	{"pm10": 37, "pm25": 53, "pm100": 65, "timestamp": 1681480605}	2023-04-14 13:56:45+00
249396	{"pm10": 37, "pm25": 53, "pm100": 65, "timestamp": 1681480699}	2023-04-14 13:58:19+00
249396	{"pm10": 35, "pm25": 51, "pm100": 63, "timestamp": 1681480792}	2023-04-14 13:59:52+00
249396	{"pm10": 35, "pm25": 52, "pm100": 63, "timestamp": 1681480885}	2023-04-14 14:01:25+00
249396	{"pm10": 35, "pm25": 51, "pm100": 63, "timestamp": 1681480978}	2023-04-14 14:02:58+00
249396	{"pm10": 35, "pm25": 51, "pm100": 63, "timestamp": 1681481071}	2023-04-14 14:04:31+00
249396	{"pm10": 35, "pm25": 50, "pm100": 62, "timestamp": 1681481164}	2023-04-14 14:06:04+00
249396	{"pm10": 35, "pm25": 50, "pm100": 62, "timestamp": 1681481257}	2023-04-14 14:07:37+00
249396	{"pm10": 35, "pm25": 52, "pm100": 63, "timestamp": 1681481351}	2023-04-14 14:09:11+00
249396	{"pm10": 35, "pm25": 52, "pm100": 64, "timestamp": 1681481444}	2023-04-14 14:10:44+00
249396	{"pm10": 34, "pm25": 51, "pm100": 63, "timestamp": 1681481537}	2023-04-14 14:12:17+00
249396	{"pm10": 38, "pm25": 55, "pm100": 67, "timestamp": 1681481630}	2023-04-14 14:13:50+00
249396	{"pm10": 39, "pm25": 57, "pm100": 69, "timestamp": 1681481723}	2023-04-14 14:15:23+00
249396	{"pm10": 34, "pm25": 51, "pm100": 63, "timestamp": 1681481816}	2023-04-14 14:16:56+00
249396	{"pm10": 34, "pm25": 51, "pm100": 63, "timestamp": 1681481909}	2023-04-14 14:18:29+00
249396	{"pm10": 34, "pm25": 51, "pm100": 64, "timestamp": 1681482003}	2023-04-14 14:20:03+00
249396	{"pm10": 34, "pm25": 52, "pm100": 66, "timestamp": 1681482096}	2023-04-14 14:21:36+00
249396	{"pm10": 34, "pm25": 51, "pm100": 64, "timestamp": 1681482189}	2023-04-14 14:23:09+00
249396	{"pm10": 33, "pm25": 51, "pm100": 64, "timestamp": 1681482282}	2023-04-14 14:24:42+00
249396	{"pm10": 38, "pm25": 59, "pm100": 70, "timestamp": 1681482375}	2023-04-14 14:26:15+00
249396	{"pm10": 38, "pm25": 58, "pm100": 70, "timestamp": 1681482468}	2023-04-14 14:27:48+00
249396	{"pm10": 39, "pm25": 59, "pm100": 70, "timestamp": 1681482561}	2023-04-14 14:29:21+00
249396	{"pm10": 39, "pm25": 59, "pm100": 70, "timestamp": 1681482655}	2023-04-14 14:30:55+00
249396	{"pm10": 39, "pm25": 55, "pm100": 66, "timestamp": 1681482748}	2023-04-14 14:32:28+00
249396	{"pm10": 39, "pm25": 56, "pm100": 67, "timestamp": 1681482841}	2023-04-14 14:34:01+00
249396	{"pm10": 38, "pm25": 56, "pm100": 68, "timestamp": 1681482934}	2023-04-14 14:35:34+00
249396	{"pm10": 38, "pm25": 56, "pm100": 68, "timestamp": 1681483027}	2023-04-14 14:37:07+00
249396	{"pm10": 39, "pm25": 55, "pm100": 67, "timestamp": 1681483120}	2023-04-14 14:38:40+00
249396	{"pm10": 39, "pm25": 55, "pm100": 67, "timestamp": 1681483213}	2023-04-14 14:40:13+00
249396	{"pm10": 41, "pm25": 59, "pm100": 71, "timestamp": 1681483307}	2023-04-14 14:41:47+00
249396	{"pm10": 41, "pm25": 59, "pm100": 71, "timestamp": 1681483400}	2023-04-14 14:43:20+00
249396	{"pm10": 41, "pm25": 59, "pm100": 71, "timestamp": 1681483493}	2023-04-14 14:44:53+00
249396	{"pm10": 41, "pm25": 59, "pm100": 71, "timestamp": 1681483586}	2023-04-14 14:46:26+00
249396	{"pm10": 40, "pm25": 59, "pm100": 70, "timestamp": 1681483679}	2023-04-14 14:47:59+00
249396	{"pm10": 40, "pm25": 59, "pm100": 70, "timestamp": 1681483772}	2023-04-14 14:49:32+00
249396	{"pm10": 41, "pm25": 59, "pm100": 71, "timestamp": 1681483865}	2023-04-14 14:51:05+00
249396	{"pm10": 40, "pm25": 57, "pm100": 68, "timestamp": 1681483959}	2023-04-14 14:52:39+00
249396	{"pm10": 39, "pm25": 59, "pm100": 69, "timestamp": 1681484052}	2023-04-14 14:54:12+00
249396	{"pm10": 39, "pm25": 59, "pm100": 69, "timestamp": 1681484145}	2023-04-14 14:55:45+00
249396	{"pm10": 39, "pm25": 61, "pm100": 70, "timestamp": 1681484238}	2023-04-14 14:57:18+00
249396	{"pm10": 39, "pm25": 61, "pm100": 70, "timestamp": 1681484331}	2023-04-14 14:58:51+00
249396	{"pm10": 38, "pm25": 56, "pm100": 68, "timestamp": 1681484424}	2023-04-14 15:00:24+00
249396	{"pm10": 37, "pm25": 55, "pm100": 68, "timestamp": 1681484517}	2023-04-14 15:01:57+00
249396	{"pm10": 37, "pm25": 55, "pm100": 67, "timestamp": 1681484611}	2023-04-14 15:03:31+00
249396	{"pm10": 37, "pm25": 54, "pm100": 67, "timestamp": 1681484704}	2023-04-14 15:05:04+00
249396	{"pm10": 36, "pm25": 54, "pm100": 67, "timestamp": 1681484797}	2023-04-14 15:06:37+00
249396	{"pm10": 37, "pm25": 57, "pm100": 69, "timestamp": 1681484890}	2023-04-14 15:08:10+00
249396	{"pm10": 37, "pm25": 59, "pm100": 70, "timestamp": 1681484983}	2023-04-14 15:09:43+00
249396	{"pm10": 38, "pm25": 57, "pm100": 70, "timestamp": 1681485076}	2023-04-14 15:11:16+00
249396	{"pm10": 37, "pm25": 57, "pm100": 69, "timestamp": 1681485170}	2023-04-14 15:12:50+00
249396	{"pm10": 37, "pm25": 57, "pm100": 70, "timestamp": 1681485263}	2023-04-14 15:14:23+00
249396	{"pm10": 34, "pm25": 51, "pm100": 63, "timestamp": 1681485356}	2023-04-14 15:15:56+00
249396	{"pm10": 34, "pm25": 50, "pm100": 62, "timestamp": 1681485449}	2023-04-14 15:17:29+00
249396	{"pm10": 34, "pm25": 50, "pm100": 62, "timestamp": 1681485542}	2023-04-14 15:19:02+00
249396	{"pm10": 33, "pm25": 50, "pm100": 63, "timestamp": 1681485635}	2023-04-14 15:20:35+00
249396	{"pm10": 33, "pm25": 50, "pm100": 63, "timestamp": 1681485728}	2023-04-14 15:22:08+00
249396	{"pm10": 35, "pm25": 52, "pm100": 66, "timestamp": 1681485822}	2023-04-14 15:23:42+00
249396	{"pm10": 35, "pm25": 52, "pm100": 66, "timestamp": 1681485915}	2023-04-14 15:25:15+00
249396	{"pm10": 35, "pm25": 52, "pm100": 67, "timestamp": 1681486008}	2023-04-14 15:26:48+00
249396	{"pm10": 35, "pm25": 52, "pm100": 67, "timestamp": 1681486101}	2023-04-14 15:28:21+00
249396	{"pm10": 37, "pm25": 58, "pm100": 71, "timestamp": 1681486194}	2023-04-14 15:29:54+00
249396	{"pm10": 36, "pm25": 57, "pm100": 71, "timestamp": 1681486287}	2023-04-14 15:31:27+00
249396	{"pm10": 35, "pm25": 57, "pm100": 70, "timestamp": 1681486380}	2023-04-14 15:33:00+00
249396	{"pm10": 35, "pm25": 57, "pm100": 70, "timestamp": 1681486474}	2023-04-14 15:34:34+00
249396	{"pm10": 35, "pm25": 57, "pm100": 70, "timestamp": 1681486567}	2023-04-14 15:36:07+00
249396	{"pm10": 35, "pm25": 57, "pm100": 70, "timestamp": 1681486660}	2023-04-14 15:37:40+00
249396	{"pm10": 39, "pm25": 55, "pm100": 67, "timestamp": 1681486753}	2023-04-14 15:39:13+00
249396	{"pm10": 40, "pm25": 56, "pm100": 68, "timestamp": 1681486846}	2023-04-14 15:40:46+00
249396	{"pm10": 36, "pm25": 54, "pm100": 66, "timestamp": 1681486939}	2023-04-14 15:42:19+00
249396	{"pm10": 37, "pm25": 55, "pm100": 66, "timestamp": 1681487032}	2023-04-14 15:43:52+00
249396	{"pm10": 37, "pm25": 55, "pm100": 66, "timestamp": 1681487126}	2023-04-14 15:45:26+00
249396	{"pm10": 36, "pm25": 52, "pm100": 65, "timestamp": 1681487219}	2023-04-14 15:46:59+00
249396	{"pm10": 37, "pm25": 53, "pm100": 65, "timestamp": 1681487312}	2023-04-14 15:48:32+00
249396	{"pm10": 37, "pm25": 53, "pm100": 65, "timestamp": 1681487405}	2023-04-14 15:50:05+00
249396	{"pm10": 37, "pm25": 53, "pm100": 65, "timestamp": 1681487498}	2023-04-14 15:51:38+00
249396	{"pm10": 36, "pm25": 52, "pm100": 64, "timestamp": 1681487591}	2023-04-14 15:53:11+00
249396	{"pm10": 39, "pm25": 59, "pm100": 70, "timestamp": 1681487684}	2023-04-14 15:54:44+00
249396	{"pm10": 40, "pm25": 59, "pm100": 70, "timestamp": 1681487778}	2023-04-14 15:56:18+00
249396	{"pm10": 40, "pm25": 59, "pm100": 70, "timestamp": 1681487871}	2023-04-14 15:57:51+00
249396	{"pm10": 40, "pm25": 59, "pm100": 70, "timestamp": 1681487964}	2023-04-14 15:59:24+00
249396	{"pm10": 40, "pm25": 59, "pm100": 70, "timestamp": 1681488057}	2023-04-14 16:00:57+00
249396	{"pm10": 40, "pm25": 59, "pm100": 70, "timestamp": 1681488150}	2023-04-14 16:02:30+00
249396	{"pm10": 40, "pm25": 59, "pm100": 70, "timestamp": 1681488243}	2023-04-14 16:04:03+00
249396	{"pm10": 40, "pm25": 59, "pm100": 69, "timestamp": 1681488336}	2023-04-14 16:05:36+00
249396	{"pm10": 40, "pm25": 59, "pm100": 70, "timestamp": 1681488430}	2023-04-14 16:07:10+00
249396	{"pm10": 39, "pm25": 58, "pm100": 69, "timestamp": 1681488523}	2023-04-14 16:08:43+00
249396	{"pm10": 39, "pm25": 58, "pm100": 69, "timestamp": 1681488616}	2023-04-14 16:10:16+00
249396	{"pm10": 39, "pm25": 59, "pm100": 69, "timestamp": 1681488709}	2023-04-14 16:11:49+00
249396	{"pm10": 41, "pm25": 59, "pm100": 69, "timestamp": 1681488802}	2023-04-14 16:13:22+00
249396	{"pm10": 41, "pm25": 58, "pm100": 68, "timestamp": 1681488895}	2023-04-14 16:14:55+00
249396	{"pm10": 40, "pm25": 57, "pm100": 68, "timestamp": 1681488988}	2023-04-14 16:16:28+00
249396	{"pm10": 38, "pm25": 55, "pm100": 68, "timestamp": 1681489082}	2023-04-14 16:18:02+00
249396	{"pm10": 43, "pm25": 64, "pm100": 72, "timestamp": 1681489175}	2023-04-14 16:19:35+00
249396	{"pm10": 42, "pm25": 64, "pm100": 72, "timestamp": 1681489268}	2023-04-14 16:21:08+00
249396	{"pm10": 42, "pm25": 63, "pm100": 72, "timestamp": 1681489361}	2023-04-14 16:22:41+00
249396	{"pm10": 42, "pm25": 63, "pm100": 72, "timestamp": 1681489454}	2023-04-14 16:24:14+00
249396	{"pm10": 42, "pm25": 63, "pm100": 72, "timestamp": 1681489547}	2023-04-14 16:25:47+00
249396	{"pm10": 39, "pm25": 60, "pm100": 71, "timestamp": 1681489640}	2023-04-14 16:27:20+00
249396	{"pm10": 39, "pm25": 61, "pm100": 71, "timestamp": 1681489734}	2023-04-14 16:28:54+00
249396	{"pm10": 40, "pm25": 60, "pm100": 70, "timestamp": 1681489827}	2023-04-14 16:30:27+00
249396	{"pm10": 40, "pm25": 59, "pm100": 70, "timestamp": 1681489920}	2023-04-14 16:32:00+00
249396	{"pm10": 40, "pm25": 60, "pm100": 70, "timestamp": 1681490013}	2023-04-14 16:33:33+00
249396	{"pm10": 39, "pm25": 59, "pm100": 70, "timestamp": 1681490106}	2023-04-14 16:35:06+00
249396	{"pm10": 39, "pm25": 57, "pm100": 69, "timestamp": 1681490199}	2023-04-14 16:36:39+00
249396	{"pm10": 39, "pm25": 57, "pm100": 69, "timestamp": 1681490292}	2023-04-14 16:38:12+00
249396	{"pm10": 39, "pm25": 57, "pm100": 69, "timestamp": 1681490386}	2023-04-14 16:39:46+00
249396	{"pm10": 39, "pm25": 57, "pm100": 69, "timestamp": 1681490479}	2023-04-14 16:41:19+00
249396	{"pm10": 39, "pm25": 58, "pm100": 69, "timestamp": 1681490572}	2023-04-14 16:42:52+00
249396	{"pm10": 38, "pm25": 54, "pm100": 67, "timestamp": 1681490665}	2023-04-14 16:44:25+00
249396	{"pm10": 38, "pm25": 54, "pm100": 67, "timestamp": 1681490758}	2023-04-14 16:45:58+00
249396	{"pm10": 39, "pm25": 55, "pm100": 67, "timestamp": 1681490851}	2023-04-14 16:47:31+00
249396	{"pm10": 39, "pm25": 55, "pm100": 67, "timestamp": 1681490944}	2023-04-14 16:49:04+00
249396	{"pm10": 39, "pm25": 55, "pm100": 68, "timestamp": 1681491038}	2023-04-14 16:50:38+00
249396	{"pm10": 39, "pm25": 55, "pm100": 68, "timestamp": 1681491131}	2023-04-14 16:52:11+00
249396	{"pm10": 39, "pm25": 56, "pm100": 68, "timestamp": 1681491224}	2023-04-14 16:53:44+00
249396	{"pm10": 39, "pm25": 56, "pm100": 68, "timestamp": 1681491317}	2023-04-14 16:55:17+00
249396	{"pm10": 40, "pm25": 62, "pm100": 72, "timestamp": 1681491410}	2023-04-14 16:56:50+00
249396	{"pm10": 40, "pm25": 60, "pm100": 70, "timestamp": 1681491503}	2023-04-14 16:58:23+00
249396	{"pm10": 39, "pm25": 60, "pm100": 70, "timestamp": 1681491597}	2023-04-14 16:59:57+00
249396	{"pm10": 73, "pm25": 110, "pm100": 120, "timestamp": 25237}	1970-01-01 07:00:37+00
249396	{"pm10": 74, "pm25": 111, "pm100": 122, "timestamp": 25330}	1970-01-01 07:02:10+00
\.


--
-- TOC entry 3455 (class 0 OID 24589)
-- Dependencies: 222
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (id, username, password, role) FROM stdin;
1	demo@example.com	$2b$10$7OTfcuzl7cyZo7I6qQFRFOFtBmO5DuiC.SbbzV3ZJGQwKuEigZmry	user
2	demo2@example.com	$2b$10$SsCkWDSQtH0vqhtYBhBmMOhov65nX5ooCUOjE5MruIZO9g1HQ5SHS	user
\.


--
-- TOC entry 3463 (class 0 OID 0)
-- Dependencies: 221
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_id_seq', 2, true);


--
-- TOC entry 3280 (class 2606 OID 16453)
-- Name: hdb_action_log hdb_action_log_pkey; Type: CONSTRAINT; Schema: hdb_catalog; Owner: postgres
--

ALTER TABLE ONLY hdb_catalog.hdb_action_log
    ADD CONSTRAINT hdb_action_log_pkey PRIMARY KEY (id);


--
-- TOC entry 3287 (class 2606 OID 16476)
-- Name: hdb_cron_event_invocation_logs hdb_cron_event_invocation_logs_pkey; Type: CONSTRAINT; Schema: hdb_catalog; Owner: postgres
--

ALTER TABLE ONLY hdb_catalog.hdb_cron_event_invocation_logs
    ADD CONSTRAINT hdb_cron_event_invocation_logs_pkey PRIMARY KEY (id);


--
-- TOC entry 3283 (class 2606 OID 16465)
-- Name: hdb_cron_events hdb_cron_events_pkey; Type: CONSTRAINT; Schema: hdb_catalog; Owner: postgres
--

ALTER TABLE ONLY hdb_catalog.hdb_cron_events
    ADD CONSTRAINT hdb_cron_events_pkey PRIMARY KEY (id);


--
-- TOC entry 3276 (class 2606 OID 16441)
-- Name: hdb_metadata hdb_metadata_pkey; Type: CONSTRAINT; Schema: hdb_catalog; Owner: postgres
--

ALTER TABLE ONLY hdb_catalog.hdb_metadata
    ADD CONSTRAINT hdb_metadata_pkey PRIMARY KEY (id);


--
-- TOC entry 3278 (class 2606 OID 16443)
-- Name: hdb_metadata hdb_metadata_resource_version_key; Type: CONSTRAINT; Schema: hdb_catalog; Owner: postgres
--

ALTER TABLE ONLY hdb_catalog.hdb_metadata
    ADD CONSTRAINT hdb_metadata_resource_version_key UNIQUE (resource_version);


--
-- TOC entry 3292 (class 2606 OID 16504)
-- Name: hdb_scheduled_event_invocation_logs hdb_scheduled_event_invocation_logs_pkey; Type: CONSTRAINT; Schema: hdb_catalog; Owner: postgres
--

ALTER TABLE ONLY hdb_catalog.hdb_scheduled_event_invocation_logs
    ADD CONSTRAINT hdb_scheduled_event_invocation_logs_pkey PRIMARY KEY (id);


--
-- TOC entry 3290 (class 2606 OID 16494)
-- Name: hdb_scheduled_events hdb_scheduled_events_pkey; Type: CONSTRAINT; Schema: hdb_catalog; Owner: postgres
--

ALTER TABLE ONLY hdb_catalog.hdb_scheduled_events
    ADD CONSTRAINT hdb_scheduled_events_pkey PRIMARY KEY (id);


--
-- TOC entry 3294 (class 2606 OID 16519)
-- Name: hdb_schema_notifications hdb_schema_notifications_pkey; Type: CONSTRAINT; Schema: hdb_catalog; Owner: postgres
--

ALTER TABLE ONLY hdb_catalog.hdb_schema_notifications
    ADD CONSTRAINT hdb_schema_notifications_pkey PRIMARY KEY (id);


--
-- TOC entry 3274 (class 2606 OID 16432)
-- Name: hdb_version hdb_version_pkey; Type: CONSTRAINT; Schema: hdb_catalog; Owner: postgres
--

ALTER TABLE ONLY hdb_catalog.hdb_version
    ADD CONSTRAINT hdb_version_pkey PRIMARY KEY (hasura_uuid);


--
-- TOC entry 3298 (class 2606 OID 24582)
-- Name: devices devices_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.devices
    ADD CONSTRAINT devices_pkey PRIMARY KEY (id);


--
-- TOC entry 3296 (class 2606 OID 16526)
-- Name: logs logs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.logs
    ADD CONSTRAINT logs_pkey PRIMARY KEY (device_id, "timestamp");


--
-- TOC entry 3300 (class 2606 OID 24597)
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- TOC entry 3285 (class 1259 OID 16482)
-- Name: hdb_cron_event_invocation_event_id; Type: INDEX; Schema: hdb_catalog; Owner: postgres
--

CREATE INDEX hdb_cron_event_invocation_event_id ON hdb_catalog.hdb_cron_event_invocation_logs USING btree (event_id);


--
-- TOC entry 3281 (class 1259 OID 16466)
-- Name: hdb_cron_event_status; Type: INDEX; Schema: hdb_catalog; Owner: postgres
--

CREATE INDEX hdb_cron_event_status ON hdb_catalog.hdb_cron_events USING btree (status);


--
-- TOC entry 3284 (class 1259 OID 16467)
-- Name: hdb_cron_events_unique_scheduled; Type: INDEX; Schema: hdb_catalog; Owner: postgres
--

CREATE UNIQUE INDEX hdb_cron_events_unique_scheduled ON hdb_catalog.hdb_cron_events USING btree (trigger_name, scheduled_time) WHERE (status = 'scheduled'::text);


--
-- TOC entry 3288 (class 1259 OID 16495)
-- Name: hdb_scheduled_event_status; Type: INDEX; Schema: hdb_catalog; Owner: postgres
--

CREATE INDEX hdb_scheduled_event_status ON hdb_catalog.hdb_scheduled_events USING btree (status);


--
-- TOC entry 3272 (class 1259 OID 16433)
-- Name: hdb_version_one_row; Type: INDEX; Schema: hdb_catalog; Owner: postgres
--

CREATE UNIQUE INDEX hdb_version_one_row ON hdb_catalog.hdb_version USING btree (((version IS NOT NULL)));


--
-- TOC entry 3301 (class 2606 OID 16477)
-- Name: hdb_cron_event_invocation_logs hdb_cron_event_invocation_logs_event_id_fkey; Type: FK CONSTRAINT; Schema: hdb_catalog; Owner: postgres
--

ALTER TABLE ONLY hdb_catalog.hdb_cron_event_invocation_logs
    ADD CONSTRAINT hdb_cron_event_invocation_logs_event_id_fkey FOREIGN KEY (event_id) REFERENCES hdb_catalog.hdb_cron_events(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 3302 (class 2606 OID 16505)
-- Name: hdb_scheduled_event_invocation_logs hdb_scheduled_event_invocation_logs_event_id_fkey; Type: FK CONSTRAINT; Schema: hdb_catalog; Owner: postgres
--

ALTER TABLE ONLY hdb_catalog.hdb_scheduled_event_invocation_logs
    ADD CONSTRAINT hdb_scheduled_event_invocation_logs_event_id_fkey FOREIGN KEY (event_id) REFERENCES hdb_catalog.hdb_scheduled_events(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 3304 (class 2606 OID 24598)
-- Name: devices devices_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.devices
    ADD CONSTRAINT devices_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE SET NULL ON DELETE SET NULL;


--
-- TOC entry 3303 (class 2606 OID 24583)
-- Name: logs logs_device_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.logs
    ADD CONSTRAINT logs_device_id_fkey FOREIGN KEY (device_id) REFERENCES public.devices(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


-- Completed on 2023-04-16 13:24:28

--
-- PostgreSQL database dump complete
--

