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
  property :dates, String
  property :date_start, Date
  property :date_end, Date
  property :pollster, String
  property :clinton, Float
  property :trump, Float
  property :johnson, Float
end


def test_database
  Poll.auto_migrate!

  first_poll = Poll.new
  first_poll.dates = "Aug 14-18"
  first_poll.clinton = 54.3
  first_poll.trump = 48.1
  first_poll.save

  second_poll = Poll.new
  second_poll.clinton = 54.0
  second_poll.save
end

test_database

get "/" do
  @polls = Poll.all(:order => [:date_end.asc])
  @poll = Poll.get(1)
  erb :index do
    erb :poll_table
  end
end
