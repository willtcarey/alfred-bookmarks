require "fileutils"
require "open3"
require "json"

class DB
  def initialize(path:)
    @path = path
  end

  def setup!
    FileUtils.mkdir_p(File.dirname(@path))
    Dir["./migrations/*.sql"].sort.each do |sql|
      filename = File.basename(sql)
      check = sql("SELECT 1 as one FROM migrations WHERE name = '#{filename}'")
      next if check.any?
      _out, _status = Open3.capture2("sqlite3", @path, ".read #{sql}")
      sql("INSERT INTO migrations (name) VALUES ('#{filename}')")
    end
  end

  def sql(query)
    $stderr.puts(query)
    out, _status = Open3.capture2("sqlite3", @path, "-json", query)
    if out != ""
      JSON.parse(out)
    else
      []
    end
  end
end
