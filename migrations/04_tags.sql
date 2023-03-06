CREATE TABLE "tags" (
  "id" integer PRIMARY KEY,
  "name" text NOT NULL
);

CREATE INDEX idx_name ON tags (name);