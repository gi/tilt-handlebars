# frozen_string_literal: true

require "rack/test"
require "sinatra/base"
require "sinatra/handlebars"

RSpec.describe Sinatra::Handlebars do
  let(:app) {
    Sinatra.new(Sinatra::Base) do
      extend Fixtures::Helpers

      set :environment, :test
      set :root, fixture_dir
      helpers Sinatra::Handlebars # rubocop:disable RSpec/DescribedClass

      get "/:name" do
        template = params["name"].to_sym
        handlebars template, locals: { name: "World", type: "planet" }
      end
    end
  }
  let(:client) {
    Rack::Test::Session.new(Rack::MockSession.new(app))
  }

  describe "#handlebars" do
    context "with a simple template" do
      let(:rendered) { "Hello, World." }
      let(:response) { client.get("/hello") }
      let(:response_data) { response.body.strip }

      it "renders correctly" do
        expect(response_data).to eq(rendered)
      end
    end

    context "with a partial template" do
      let(:rendered) { "Hello, World (a 'planet')\n." }
      let(:response) { client.get("/hello_partial") }
      let(:response_data) { response.body.strip }

      it "renders correctly" do
        expect(response_data).to eq(rendered)
      end
    end
  end
end
