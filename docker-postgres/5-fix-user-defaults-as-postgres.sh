#!/bin/bash
set -e
export PGPASSWORD=$POSTGRES_PASSWORD;
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER"  --dbname "$DB_NAME" <<-EOSQL
  BEGIN;
    ALTER ROLE $API_USER SET search_path = opensociocracy_api,public;
    ALTER ROLE $SUPERTOKENS_USER SET search_path = supertokens,public;
    
  COMMIT;

EOSQL