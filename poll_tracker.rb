require "sinatra"
require "sinatra/contrib"
require "sinatra/reloader"
require "yaml"
require "bcrypt"
require "data_mapper"
require "pry"

DataMapper.setup(:default, "sqlite3:///data/polls.db")

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

def initialize_database
  Poll.auto_upgrade!
end

initialize_database

get "/" do
  @polls = Poll.all(:order => [:date_end.asc])

  erb :index do
    erb :poll_table
  end
end

get "/new" do
  erb :new
end

post "/new" do
  dates = params["dates"]
  date_start = params["date_start"]
  date_end = params["date_end"]
  pollster = params["pollster"]
  clinton = params["clinton"]
  trump = params["trump"]
  johnson = params["johnson"]

  poll = Poll.new
  poll.dates = dates
  poll.date_start = date_start
  poll.date_end = date_end
  poll.pollster = pollster
  poll.clinton = clinton
  poll.trump = trump
  poll.johnson = johnson

  x = poll.save
  binding.pry

  redirect "/"
end

post "/:id/destroy" do
  id = params["id"]
  poll = Poll.all( :conditions => { :id => id })
  poll.destroy

  redirect "/"
end
