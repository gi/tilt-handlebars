require 'sinatra'
require 'sinatra/handlebars'

class MyApp < Sinatra::Base
  helpers Sinatra::Handlebars

  get "/hello" do
    handlebars :index, locals: {name: 'Joe', emotion: 'happy'}
  end

  run! if app_file == $0
end
