# dynamic.rb

require "sinatra"
require "sinatra/reloader"
require "tilt/erubis"

get '/' do
  @file_names = Dir.glob('public/*').map { |file| File.basename(file) }
  @file_names.sort! if params[:sort] == 'asc'
  @file_names.reverse! if params[:sort] == 'des'

  erb :list
end
