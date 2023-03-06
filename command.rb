require_relative "./db"

class Command
  def self.run(input)
    data_path = ENV["alfred_workflow_data"] || raise("Data path required")
    db = DB.new(path: "#{data_path}/bookmarks.db")

    case input
    when "> configure"
      db.setup!
      puts "Bookmarks configured"
    when "> reset"
      File.delete("#{data_path}/bookmarks.db") if File.exist?("#{data_path}/bookmarks.db")
      puts "Bookmarks DB deleted"
    when /^> add/ # Match the beginning of the command being "add"
      $stderr.puts(input)
      url, *tags = input.gsub("> add ", "").split(" ")
      return if url.nil? || url == ""
      tag_ids = tags.map do |tag|
        tag_row = db.sql("SELECT id FROM tags WHERE name = '#{tag}'")[0]
        tag_id = if tag_row.nil?
          db.sql("INSERT INTO tags (name) VALUES ('#{tag}') RETURNING id")[0]["id"]
        else
          tag_row["id"]
        end
        tag_id
      end

      bookmark_id = db.sql("INSERT INTO bookmarks (url) VALUES ('#{url}') RETURNING id")[0]["id"]
      tag_ids.each do |tag_id|
        db.sql("INSERT INTO taggings (tag_id, bookmark_id) VALUES (#{tag_id}, #{bookmark_id})")
      end
      puts "Inserted bookmark"
    end
  end
end

Command.run(ARGV[0])
