# frozen_string_literal: true

require "test_helper"

require "rack/test"
require "sinatra/base"
require "sinatra/handlebars"

class HandlebarsApp < Sinatra::Base
  set :root, "#{__dir__}/fixtures"
  helpers Sinatra::Handlebars

  get "/hello" do
    handlebars :hello, locals: { name: "Joe", emotion: "happy" }
  end

  get "/partials" do
    handlebars :partial_test, locals: { author: "Stephanie Queen" }
  end
end

describe "Using handlebars in Sinatra" do
  include Rack::Test::Methods

  def app
    HandlebarsApp
  end

  it "renders simple template" do
    response = get "/hello"
    response.body.strip.must_equal "Hello, Joe. I'm happy to meet you."
  end

  it "renders template with partials" do
    response = get "/partials"
    response.body.strip.must_equal "My all time favorite book is It Came From the Partial Side by Stephanie Queen."
  end
end
