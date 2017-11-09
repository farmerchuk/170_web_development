require "sinatra"
require "sinatra/reloader"
require "tilt/erubis"

before do
  @toc = File.readlines('data/toc.txt')
end

helpers do
  def in_paragraphs(text)
    paragraphs = text.split("\n\n")
    paragraphs.map.with_index { |para, idx| "<p id='#{idx}'>#{para}</p>" }.join('')
  end

  def highlight(text, query)
    text.split(query).join("<strong>#{query}</strong>")
  end
end

get "/" do
  @title = "The Adventures of Sherlock Holmes"

  erb :home
end

get "/chapters/:number" do
  @chapter_num = params[:number].to_i

  redirect "/" unless (1..@toc.size).cover?(@chapter_num)

  chapter_name = @toc[@chapter_num - 1]
  @title = "Chapter #{@chapter_num}: #{chapter_name}"
  @chapter = File.read("data/chp#{@chapter_num}.txt")

  erb :chapter
end

get "/search" do
  @query = params[:query]

  @matches = {}
  @toc.each_with_index do |title, index|
    paragraphs = {}
    chapter = File.read("data/chp#{index + 1}.txt")
    paras = chapter.split("\n\n")

    paras.each_with_index do |para, idx|
      if @query && para.include?(@query)
        paragraphs[para] = idx
      end
    end
    @matches[[title, index + 1]] = paragraphs unless paragraphs.empty?
  end

  erb :search
end

not_found do
  redirect "/"
end
