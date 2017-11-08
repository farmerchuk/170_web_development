require "sinatra"
require "sinatra/reloader"
require "tilt/erubis"

get "/" do
  @title = "Jason's Book Reader"
  @toc = File.readlines('data/toc.txt')

  erb :home
end

get "/chapters/:number" do
  @chapter_num = params[:number]
  @toc = File.readlines('data/toc.txt')
  chapter_name = @toc[@chapter_num.to_i - 1]
  @title = "Chapter #{@chapter_num}: #{chapter_name}"
  @chapter = File.read("data/chp#{@chapter_num}.txt")

  erb :chapter
end
