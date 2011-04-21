require 'grit'
require 'sinatra'
require 'kramdown'

repo = Grit::Repo.new('/Users/eungju/sisyphus-ng/wikidata')

get %r{/([^;]*)(?:;(\w+))?} do |path, view|
  puts "path: #{path}, view: #{view}"
  if path == ""
    @content = repo.tree
    @path = ""
  else
    @content = repo.tree / path.force_encoding("ASCII-8BIT")
    @path = path
  end
  if @content.is_a?(Grit::Tree)
    erb :tree
  elsif @content.is_a?(Grit::Blob)
    if view == "edit"
      erb :blob_edit
    elsif view == ""
      erb :blob_history
    else
      erb :blob
    end
  end
end

post %r{/([^;]*)(?:;(\w+))?} do |path, view|
  redirect path
end

helpers do
  include Rack::Utils
  alias_method :h, :escape_html
end
