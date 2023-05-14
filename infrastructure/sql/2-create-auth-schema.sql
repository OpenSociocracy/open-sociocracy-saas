 CREATE SCHEMA IF NOT EXISTS supertokens;

 SET SEARCH_PATH = supertokens;

 CREATE TABLE IF NOT EXISTS key_value (
    name VARCHAR(128),
    value TEXT,
    created_at_time BIGINT,
    CONSTRAINT key_value_pkey PRIMARY KEY(name)
);

CREATE TABLE IF NOT EXISTS all_auth_recipe_users(
    user_id CHAR(36) NOT NULL,
    recipe_id VARCHAR(128) NOT NULL,
    time_joined BIGINT NOT NULL,
    CONSTRAINT all_auth_recipe_users_pkey PRIMARY KEY (user_id)
);
CREATE INDEX all_auth_recipe_users_pagination_index ON all_auth_recipe_users (time_joined DESC, user_id DESC);

CREATE TABLE IF NOT EXISTS userid_mapping(
    supertokens_user_id CHAR(36) NOT NULL CONSTRAINT userid_mapping_supertokens_user_id_key UNIQUE,
    external_user_id VARCHAR(128) NOT NULL CONSTRAINT userid_mapping_external_user_id_key UNIQUE,
    external_user_id_info TEXT,
    CONSTRAINT userid_mapping_pkey PRIMARY KEY (supertokens_user_id, external_user_id),
    CONSTRAINT userid_mapping_supertokens_user_id_fkey FOREIGN KEY (supertokens_user_id) REFERENCES all_auth_recipe_users(user_id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS dashboard_users(
    user_id CHAR(36) NOT NULL,
    email VARCHAR(256) NOT NULL CONSTRAINT dashboard_users_email_key UNIQUE,
    password_hash VARCHAR(256) NOT NULL,
    time_joined BIGINT NOT NULL,
    CONSTRAINT dashboard_users_pkey PRIMARY KEY (user_id) 
);

CREATE TABLE IF NOT EXISTS dashboard_user_sessions(
    session_id CHAR(36) NOT NULL,
    user_id CHAR(36) NOT NULL,
    time_created BIGINT NOT NULL,
    expiry BIGINT NOT NULL,
    CONSTRAINT dashboard_user_sessions_pkey PRIMARY KEY(session_id),
    CONSTRAINT dashboard_user_sessions_user_id_fkey FOREIGN KEY (user_id) REFERENCES dashboard_users(user_id) ON DELETE CASCADE
);

CREATE INDEX dashboard_user_sessions_expiry_index ON dashboard_user_sessions(expiry);

CREATE TABLE session_access_token_signing_keys (
    created_at_time BIGINT NOT NULL,
    value TEXT,
    CONSTRAINT session_access_token_signing_keys_pkey PRIMARY KEY (created_at_time)
);

CREATE TABLE IF NOT EXISTS session_info (
    session_handle VARCHAR(255) NOT NULL,
    user_id VARCHAR(128) NOT NULL,
    refresh_token_hash_2 VARCHAR(128) NOT NULL,
    session_data TEXT,
    expires_at BIGINT NOT NULL,
    created_at_time BIGINT NOT NULL,
    jwt_user_payload TEXT,
    use_static_key BOOLEAN NOT NULL,
    CONSTRAINT session_info_pkey PRIMARY KEY(session_handle)
);

CREATE TABLE IF NOT EXISTS user_last_active (
    user_id VARCHAR(128),
    last_active_time BIGINT,
    PRIMARY KEY(user_id)
);

CREATE TABLE IF NOT EXISTS emailpassword_users (
    user_id CHAR(36) NOT NULL,
    email VARCHAR(256) NOT NULL CONSTRAINT emailpassword_users_email_key UNIQUE,
    password_hash VARCHAR(256) NOT NULL,
    time_joined BIGINT NOT NULL,
    CONSTRAINT emailpassword_users_pkey PRIMARY KEY (user_id)
);

CREATE TABLE IF NOT EXISTS emailpassword_pswd_reset_tokens (
    user_id CHAR(36) NOT NULL,
    token VARCHAR(128) NOT NULL CONSTRAINT emailpassword_pswd_reset_tokens_token_key UNIQUE,
    token_expiry BIGINT NOT NULL,
    CONSTRAINT emailpassword_pswd_reset_tokens_pkey PRIMARY KEY (user_id, token),
    CONSTRAINT emailpassword_pswd_reset_tokens_user_id_fkey FOREIGN KEY (user_id) REFERENCES emailpassword_users (user_id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE INDEX emailpassword_password_reset_token_expiry_index ON emailpassword_pswd_reset_tokens(token_expiry);

CREATE TABLE IF NOT EXISTS emailverification_verified_emails (
    user_id VARCHAR(128) NOT NULL,
    email VARCHAR(256),
    CONSTRAINT emailverification_verified_emails_pkey PRIMARY KEY (user_id, email)
);

CREATE TABLE IF NOT EXISTS emailverification_tokens (
    user_id VARCHAR(128) NOT NULL,
    email VARCHAR(256),
    token VARCHAR(128) NOT NULL CONSTRAINT emailverification_tokens_token_key UNIQUE,
    token_expiry BIGINT NOT NULL,
    CONSTRAINT emailverification_tokens_pkey PRIMARY KEY (user_id, email, token)
);

CREATE INDEX emailverification_tokens_index ON emailverification_tokens(token_expiry);

CREATE TABLE IF NOT EXISTS thirdparty_users (
    third_party_id VARCHAR(28) NOT NULL,
    third_party_user_id VARCHAR(256) NOT NULL,
    user_id CHAR(36) NOT NULL CONSTRAINT thirdparty_users_user_id_key UNIQUE,
    email VARCHAR(256) NOT NULL,
    time_joined BIGINT NOT NULL,
    CONSTRAINT thirdparty_users_pkey PRIMARY KEY (third_party_id, third_party_user_id)
);

CREATE TABLE IF NOT EXISTS passwordless_users (
    user_id CHAR(36) NOT NULL,
    email VARCHAR(256) CONSTRAINT passwordless_users_email_key UNIQUE,
    phone_number VARCHAR(256) CONSTRAINT passwordless_users_phone_number_key UNIQUE,
    time_joined BIGINT NOT NULL,
    CONSTRAINT passwordless_users_pkey PRIMARY KEY (user_id)
);

CREATE TABLE IF NOT EXISTS passwordless_devices (
    device_id_hash CHAR(44) NOT NULL,
    email VARCHAR(256),
    phone_number VARCHAR(256),
    link_code_salt CHAR(44) NOT NULL,
    failed_attempts INT NOT NULL,
    CONSTRAINT passwordless_devices_pkey PRIMARY KEY (device_id_hash)
);
CREATE INDEX passwordless_devices_email_index ON passwordless_devices USING HASH (email);
CREATE INDEX passwordless_devices_phone_number_index ON passwordless_devices USING HASH (phone_number);

CREATE TABLE IF NOT EXISTS passwordless_codes (
    code_id CHAR(36) NOT NULL,
    device_id_hash CHAR(44) NOT NULL,
    link_code_hash CHAR(44) NOT NULL CONSTRAINT passwordless_link_code_hash_key UNIQUE,
    created_at BIGINT NOT NULL,
    CONSTRAINT passwordless_codes_pkey PRIMARY KEY (code_id),
        CONSTRAINT passwordless_codes_device_id_hash_fkey FOREIGN KEY (device_id_hash)
          REFERENCES passwordless_devices(device_id_hash) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE INDEX passwordless_codes_created_at_index ON passwordless_codes(created_at);
CREATE INDEX IF NOT EXISTS passwordless_codes_device_id_hash_index ON passwordless_codes(device_id_hash);

CREATE TABLE IF NOT EXISTS jwt_signing_keys (
    key_id VARCHAR(255) NOT NULL,
    key_string TEXT NOT NULL,
    algorithm VARCHAR(10) NOT NULL,
    created_at BIGINT,
    CONSTRAINT jwt_signing_keys_pkey PRIMARY KEY(key_id)
);

CREATE TABLE IF NOT EXISTS user_metadata (
    user_id VARCHAR(128) NOT NULL,
    user_metadata TEXT NOT NULL,
    CONSTRAINT user_metadata_pkey PRIMARY KEY(user_id)
);

CREATE TABLE IF NOT EXISTS roles (
  role VARCHAR(255) NOT NULL,
  CONSTRAINT roles_pkey PRIMARY KEY (role)
);

CREATE TABLE IF NOT EXISTS role_permissions (
  role VARCHAR(255) NOT NULL,
  permission VARCHAR(255) NOT NULL,
  CONSTRAINT role_permissions_pkey PRIMARY KEY (role, permission),
  CONSTRAINT role_permissions_role_fkey FOREIGN KEY (role) REFERENCES roles(role) ON DELETE CASCADE
);

CREATE INDEX role_permissions_permission_index ON role_permissions(permission);

CREATE TABLE IF NOT EXISTS user_roles (
  user_id VARCHAR(128) NOT NULL,
  role VARCHAR(255) NOT NULL,
  CONSTRAINT user_roles_pkey PRIMARY KEY (user_id, role),
  CONSTRAINT user_roles_role_fkey FOREIGN KEY (role) REFERENCES roles (role) ON DELETE CASCADE
);

CREATE INDEX user_roles_role_index ON user_roles(role);

CREATE TABLE IF NOT EXISTS totp_users (
    user_id VARCHAR(128) NOT NULL,
    PRIMARY KEY (user_id)
);

CREATE TABLE IF NOT EXISTS totp_user_devices (
    user_id VARCHAR(128) NOT NULL,
    device_name VARCHAR(256) NOT NULL,
    secret_key VARCHAR(256) NOT NULL,
    period INTEGER NOT NULL,
    skew INTEGER NOT NULL,
    verified BOOLEAN NOT NULL,
    PRIMARY KEY (user_id, device_name),
    FOREIGN KEY (user_id) REFERENCES totp_users(user_id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS totp_used_codes (
    user_id VARCHAR(128) NOT NULL,
    code VARCHAR(8) NOT NULL,
    is_valid BOOLEAN NOT NULL,
    expiry_time_ms BIGINT NOT NULL,
    created_time_ms BIGINT NOT NULL,
    PRIMARY KEY (user_id, created_time_ms),
    FOREIGN KEY (user_id) REFERENCES totp_users(user_id) ON DELETE CASCADE
);

CREATE INDEX totp_used_codes_expiry_time_ms_index ON totp_used_codes(expiry_time_ms);

CREATE USER opensociocracy_supertokens WITH PASSWORD '$SUPERTOKENS_PASS';
GRANT CONNECT ON DATABASE opensociocracy TO opensociocracy_supertokens;

GRANT USAGE ON SCHEMA supertokens TO opensociocracy_supertokens;
GRANT ALL ON ALL SEQUENCES IN SCHEMA supertokens TO opensociocracy_supertokens;
GRANT ALL ON ALL TABLES IN SCHEMA supertokens TO opensociocracy_supertokens;
GRANT ALL ON ALL FUNCTIONS IN SCHEMA supertokens TO opensociocracy_supertokens;
ALTER ROLE opensociocracy_supertokens SET search_path = supertokens,public;
ALTER SCHEMA supertokens OWNER TO opensociocracy_supertokens;