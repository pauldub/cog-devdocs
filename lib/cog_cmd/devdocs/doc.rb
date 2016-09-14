require 'cog/command'
require 'unirest'
require 'json'

class CogCmd::Devdocs::Doc < Cog::Command
  def run_command
    args = request.args

    subject = request.args.shift
    query   = request.args.join(" ")
    slug    = find_slug(subject)

    fail("could not find subject: #{subject}") unless slug

    res = Unirest.get("https://docs.devdocs.io/#{slug}/index.json")
    path = nil

    res.body['entries'].each do |entry|
      if entry['name'].gsub(query).any?
        path = entry['path']
        break
      end
    end

    fail("no results for query: #{query}") unless path

    response.write "https://devdocs.io/#{slug}/#{path}"
  end

  def find_slug(subject)
    res = Unirest.get('https://devdocs.io/docs.json')
    res.body.each do |doc|
      if doc['slug'].gsub(subject).any?
        return doc['slug']
      end
    end

    nil
  end
end
