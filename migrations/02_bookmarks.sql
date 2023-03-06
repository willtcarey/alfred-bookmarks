CREATE TABLE "bookmarks" (
  "id" integer PRIMARY KEY,
  "url" text NOT NULL
);

CREATE INDEX idx_url ON bookmarks (url);