CREATE TABLE "taggings" (
  "id" integer PRIMARY KEY,
  "tag_id" integer NOT NULL,
  "bookmark_id" integer NOT NULL,
  FOREIGN KEY(tag_id) REFERENCES tags(id),
  FOREIGN KEY (bookmark_id) REFERENCES bookmarks(id)
);

CREATE INDEX idx_tag_id_bookmark_id ON taggings (tag_id, bookmark_id);