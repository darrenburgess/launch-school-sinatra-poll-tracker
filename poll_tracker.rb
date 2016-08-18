require "sinatra"
require "sinatra/contrib"
require "sinatra/reloader"
require "yaml"
require "bcrypt"
require "pry"

configure do
  enable :sessions
  set :session_secret, "super secret"
end

get "/" do
  erb :index
end
