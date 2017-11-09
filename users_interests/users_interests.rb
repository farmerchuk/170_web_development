# users_interests.rb

require "sinatra"
require "sinatra/reloader"
require "tilt/erubis"
require "yaml"

before do
  @users = YAML.load_file('data/users.yml')
  @num_of_users = @users.size
end

helpers do
  def format_name(name)
    name.to_s.capitalize
  end

  def count_interests(users)
    users.map { |_, details| details[:interests] }.flatten.size
  end
end

get '/' do
  redirect '/index'
end

get '/index' do
  erb :index
end

get '/user/:name' do
  @user_name = params[:name]
  @user_email = @users[@user_name.to_sym][:email]
  @user_interests = @users[@user_name.to_sym][:interests].join(', ')

  erb :user
end
