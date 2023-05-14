 CREATE SCHEMA IF NOT EXISTS api;

 SET SEARCH_PATH = api;

CREATE USER opensociocracy_api WITH PASSWORD '$SUPERTOKENS_PASS';
GRANT CONNECT ON DATABASE opensociocracy TO opensociocracy_api;

GRANT USAGE ON SCHEMA api TO opensociocracy_api;
GRANT ALL ON ALL SEQUENCES IN SCHEMA api TO opensociocracy_api;
GRANT ALL ON ALL TABLES IN SCHEMA api TO opensociocracy_api;
GRANT ALL ON ALL FUNCTIONS IN SCHEMA api TO opensociocracy_api;
ALTER ROLE opensociocracy_api SET search_path = api,public;