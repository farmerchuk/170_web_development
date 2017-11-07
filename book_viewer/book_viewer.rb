require "sinatra"
require "sinatra/reloader"
require "tilt/erubis"

get "/" do
  @title = "Jason's Book Reader"
  @toc = File.readlines('data/toc.txt')

  erb :home
end

get "/chapters/1" do
  @title = "Chapter 1"
  @toc = File.readlines('data/toc.txt')
  @text = File.read('data/chp1.txt')

  erb :chapter
end
