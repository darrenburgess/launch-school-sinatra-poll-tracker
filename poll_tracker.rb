require "sinatra"
require "sinatra/contrib"
require "sinatra/reloader"
require "yaml"
require "bcrypt"
require "data_mapper"
require "pry"

DataMapper.setup(:default, "sqlite3::memory")

configure do
  enable :sessions
  set :session_secret, "super secret"
end

class Poll
  include DataMapper::Resource

  property :id, Serial
  property :clinton, Float
  property :trump, Float
end

def test_database
  Poll.auto_migrate!

  first_poll = Poll.new
  first_poll.clinton = 54.3
  first_poll.trump = 48.1
  first_poll.save
end

get "/" do
  clinton = Poll.get(1).clinton
  trump = Poll.get(1).trump
  @poll = "Clinton: #{clinton}  Trump: #{trump}"
  erb :index
end
