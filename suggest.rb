require_relative "./db"
require_relative "./repository"

class Command
  def self.run(input, db:)
    repo = Repository.new(db)

    result = {
      items: []
    }

    if input&.start_with?(">")
      result[:items] << {
        title: "> add",
        subtitle: "> add <url> <tag1> <tag2>",
        autocomplete: "> add ",
        arg: input
      }
      result[:items] << {
        title: "> configure",
        subtitle: "Set up the bookmarks configuration",
        arg: "> configure"
      }

      result[:items] << {
        title: "> reset",
        subtitle: "Erase your bookmarks",
        arg: "> reset"
      }
    else
      tag_query, query = input.split(" ")
      if input.end_with?(" ") && query.nil? # Make searches like "tag " work and list out the bookmarks under that tag
        query = ""
      end
      if query # We have a search with a tag
        repo.list_bookmarks(query, tagged_with: tag_query).map do |bookmark|
          result[:items] << {
            title: bookmark,
            # subtitle: "",
            arg: bookmark
          }
        end
      else
        repo.list_tags(tag_query).map do |tag|
          result[:items] << {
            title: tag,
            subtitle: "Search in #{tag}...",
            valid: "false",
            autocomplete: "#{tag} "
          }
        end
      end
    end

    puts result.to_json
  end
end

data_path = ENV["alfred_workflow_data"]
db = DB.new(path: "#{data_path}/bookmarks.db")

Command.run(ARGV[0], db: db)
