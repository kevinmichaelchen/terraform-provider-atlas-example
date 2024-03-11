CREATE SCHEMA "identity";
CREATE TABLE IF NOT EXISTS "identity"."credentials" (
  id VARCHAR(36) PRIMARY KEY DEFAULT uuid_generate_v4 (),
  password VARCHAR(128) NOT NULL
);
