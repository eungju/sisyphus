require 'rubygems'
require 'bundler/setup'
require 'grit'
require 'sinatra'
require 'kramdown'

REPO = Grit::Repo.new('/Users/eungju/sisyphus-ng/wikidata')

def get_content(path)
  if path == ""
    REPO.tree
  else
    REPO.tree / path.clone.force_encoding("ASCII-8BIT")
  end
end

get %r{^/(index)?$} do
  @path = ""
  @content = get_content @path
  erb :tree
end

get %r{^/view/(.*)$} do |path|
  @path = path
  @content = get_content @path
  if @content.is_a?(Grit::Tree)
    erb :tree
  elsif @content.is_a?(Grit::Blob)
    erb :blob
  end
end

get %r{^/edit/(.*)$} do |path|
  @path = path
  @content = get_content path
  erb :blob_edit
end

post %r{^/edit/(.*)$} do |path|
  @path = path
  @content = get_content path
  redirect "/view/" + @path
end

helpers do
  include Rack::Utils
  alias_method :h, :escape_html
end
