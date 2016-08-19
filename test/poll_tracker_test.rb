ENV["RACK_ENV"] = "test"

require "minitest/autorun"
require "rack/test"
require "pry"

require_relative "../poll_tracker.rb"

class CMSTest < Minitest::Test
  include Rack::Test::Methods

  def App
    Sinatra::Application
  end

  def session
    last_request.env["rack.session"]
  end

  def setup
  end

  def teardown
  end

  def admin_session
    { "rack.session" => { user_name: "admin" } }
  end

  def test_index
    get "/"

    assert_equal 200, last_response.status
    assert_includes last_response.body, "Poll Tracker"
  end
end
