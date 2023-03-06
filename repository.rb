class Repository
  def initialize(db)
    @db = db
  end

  def list_tags(query)
    normalized_query = query.downcase
    sql = "SELECT * FROM tags"
    if normalized_query != ""
      sql += " WHERE name LIKE '%#{query}%'"
    end

    sql += " LIMIT 10"
    results = @db.sql(sql)
    results.map { |r| r["name"] }
  end

  def list_bookmarks(query, tagged_with: nil)
    @db.sql("SELECT * FROM bookmarks WHERE url LIKE '%#{query}%' LIMIT 10").map { |r| r["url"] }
  end
end
