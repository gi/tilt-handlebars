# frozen_string_literal: true

require "tilt/handlebars"

RSpec.describe Tilt::HandlebarsTemplate do
  let(:render) { template.render(render_scope, render_locals, &render_block) }
  let(:render_block) { nil }
  let(:render_locals) { nil }
  let(:render_scope) { nil }
  let(:rendered) { "" }
  let(:template) {
    described_class.new(template_file, **template_options, &template_block)
  }
  let(:template_block) { nil }
  let(:template_file) { nil }
  let(:template_options) { {} }

  describe "#initialize" do
    subject { template }

    let(:template_data) { fixture_data("views/hello.hbs") }
    let(:rendered) { "Hello, .\n" }

    context "with a block" do
      let(:template_block) { ->(_template = nil) { template_data } }

      it "reads from the block" do
        expect(template.data).to eq(template_data)
      end

      describe "rendering" do
        it "renders correctly" do
          expect(render).to eq(rendered)
        end
      end
    end

    context "with a file" do
      let(:template_file) { fixture_file("views/hello.hbs") }

      it "reads from the file" do
        expect(template.data).to eq(template_data)
      end

      describe "rendering" do
        it "renders correctly" do
          expect(render).to eq(rendered)
        end
      end
    end

    context "with a path" do
      let(:template_file) { fixture_path("views/hello.hbs") }

      it "reads from the file" do
        expect(template.data).to eq(template_data)
      end

      describe "rendering" do
        it "renders correctly" do
          expect(render).to eq(rendered)
        end
      end
    end

    context "with nothing" do
      it "raises an error" do
        expect { render }.to raise_error(ArgumentError)
      end
    end
  end

  describe "#allows_script?" do
    subject { template.allows_script? }

    let(:template_file) { fixture_path("views/hello.hbs") }

    it { is_expected.to eq(false) }
  end

  if Tilt::VERSION[/\d+/].to_i > 1
    describe "#metadata" do
      subject { template.metadata }

      let(:template_file) { fixture_path("views/hello.hbs") }

      it { is_expected.to include(allows_script: false) }
    end
  end

  describe "#render" do
    subject { render }

    let(:render_scope) { { name: "World", type: "planet" } }
    let(:rendered) { "Hello, World (a 'planet')." }
    let(:template_block) { ->(_template = nil) { template_data } }
    let(:template_data) { "Hello, {{name}} (a '{{type}}')." }

    it "can be called multiple times" do
      3.times do
        expect(render).to eq(rendered)
      end
    end

    describe "parameters" do
      describe "scope" do
        let(:render_scope) { { name: "World", type: "planet" } }

        it "is accessible in the context" do
          expect(render).to eq(rendered)
        end

        shared_examples "with locals" do
          context "with locals" do
            let(:rendered) { "Hello, Mars (a 'planet')." }
            let(:render_locals) { { name: "Mars", type: "planet" } }

            it "is merged with the locals" do
              expect(render).to eq(rendered)
            end
          end
        end

        include_examples "with locals"

        context "with a nested value" do
          let(:render_scope) { { person: { name: "World" } } }
          let(:rendered) { "Hello, World." }
          let(:template_data) { "Hello, {{person.name}}." }

          it "is accessible in the context" do
            expect(render).to eq(rendered)
          end
        end

        context "with an object" do
          let(:object_class) {
            Class.new do
              attr_accessor :name, :type

              def initialize(name, type)
                @name = name
                @type = type
              end
            end
          }
          let(:render_scope) { object_class.new("World", "planet") }

          context "when it responds to #to_h" do
            let(:rendered) { "Hello, World (a '')." }

            before do
              def render_scope.to_h
                { name: name }
              end
            end

            it "merges the result into the context" do
              expect(render).to eq(rendered)
            end

            include_examples "with locals"
          end

          context "when it does not respond to #to_h" do
            let(:rendered) { "Hello, World (a 'planet')." }

            it "merges the instance variables into the context" do
              expect(render).to eq(rendered)
            end

            include_examples "with locals"
          end
        end
      end

      describe "locals" do
        let(:render_scope) { nil }
        let(:render_locals) { { name: "World", type: "planet" } }

        it "is accessible in the render context" do
          expect(render).to eq(rendered)
        end

        describe "a nested value" do
          let(:render_locals) { { person: { name: "World" } } }
          let(:rendered) { "Hello, World." }
          let(:template_data) { "Hello, {{person.name}}." }

          it "is accessible in the render context" do
            expect(render).to eq(rendered)
          end
        end
      end

      describe "block" do
        let(:render_block) { -> { "World (a '{{type}}')" } }
        let(:rendered) { "Hello, World (a '{{type}}')." }
        let(:template_data) { "Hello, {{{yield}}}." }

        it "is accessible in the render context" do
          expect(render).to eq(rendered)
        end
      end
    end

    describe "comments" do
      context "when {{!...}}" do
        let(:template_data) { "Hello, World (a 'planet').{{! Comment }}" }

        it "is not rendered" do
          expect(render).to eq(rendered)
        end
      end

      context "when {{!--...--}}" do
        let(:template_data) { "Hello, World (a 'planet').{{!-- Comment --}}" }

        it "is not rendered" do
          expect(render).to eq(rendered)
        end
      end
    end

    describe "helpers" do
      describe "each" do
        let(:template_data) {
          <<~TEMPLATE.chomp
            Hello, {{#each items~}}
            {{~this}}{{#unless @last}}/{{/unless~}}
            {{~else}}no one
            {{~/each}}.
          TEMPLATE
        }

        context "with items" do
          let(:render_scope) { { items: ["Mars", "World"] } }
          let(:rendered) { "Hello, Mars/World." }

          it "renders correctly" do
            expect(render).to eq(rendered)
          end
        end

        context "when empty" do
          let(:render_scope) { { items: [] } }
          let(:rendered) { "Hello, no one." }

          it "renders correctly" do
            expect(render).to eq(rendered)
          end
        end
      end

      describe "if" do
        let(:template_data) {
          "Hello, {{#if test}}Then{{else}}Else{{/if}}."
        }

        context "when true" do
          let(:render_scope) { { test: true } }
          let(:rendered) { "Hello, Then." }

          it "renders correctly" do
            expect(render).to eq(rendered)
          end
        end

        context "when false" do
          let(:render_scope) { { test: false } }
          let(:rendered) { "Hello, Else." }

          it "renders correctly" do
            expect(render).to eq(rendered)
          end
        end

        context "when undefined" do
          let(:render_scope) { {} }
          let(:rendered) { "Hello, Else." }

          it "renders correctly" do
            expect(render).to eq(rendered)
          end
        end
      end

      describe "unless" do
        let(:template_data) {
          "Hello, {{#unless test}}Then{{else}}Else{{/unless}}."
        }

        context "when true" do
          let(:render_scope) { { test: true } }
          let(:rendered) { "Hello, Else." }

          it "renders correctly" do
            expect(render).to eq(rendered)
          end
        end

        context "when false" do
          let(:render_scope) { { test: false } }
          let(:rendered) { "Hello, Then." }

          it "renders correctly" do
            expect(render).to eq(rendered)
          end
        end

        context "when undefined" do
          let(:render_scope) { {} }
          let(:rendered) { "Hello, Then." }

          it "renders correctly" do
            expect(render).to eq(rendered)
          end
        end
      end

      describe "with" do
        let(:render_scope) { { person: { name: "World" } } }
        let(:rendered) { "Hello, World." }
        let(:template_data) { "Hello, {{#with person}}{{name}}{{/with}}." }

        it "renders correctly" do
          expect(render).to eq(rendered)
        end
      end

      describe "custom" do
        describe "simple" do
          let(:rendered) { "Hello, WORLD AND MARS." }

          before do
            template.register_helper(:upper) do |_ctx, arg|
              arg.upcase
            end
          end

          context "when variable" do
            let(:template_data) { "Hello, {{upper name}} AND MARS." }

            it "renders correctly" do
              expect(render).to eq(rendered)
            end
          end

          context "when quoted" do
            let(:template_data) { "Hello, {{upper 'world and mars'}}." }

            it "renders correctly" do
              expect(render).to eq(rendered)
            end
          end
        end

        describe "block" do
          let(:rendered) { "Hello, WORLD." }
          let(:template_data) { "Hello, {{#upper}}{{name}}{{/upper}}." }

          before do
            template.register_helper(:upper, <<~JS)
              function(options) {
                return options.fn(this).toUpperCase();
              }
            JS
          end

          it "renders correctly" do
            expect(render).to eq(rendered)
          end
        end
      end
    end

    describe "HTML" do
      context "when returned by {{...}}" do
        let(:rendered) { "Hello, &amp;&lt;&gt;&quot;&#x27;&#x60;&#x3D;." }
        let(:render_scope) { { name: "&<>\"'`=" } }
        let(:template_data) { "Hello, {{name}}." }

        it "escapes special characters" do
          expect(render).to eq(rendered)
        end
      end

      context "when returned by {{{...}}}" do
        let(:rendered) { "Hello, &<>\"'`=." }
        let(:render_scope) { { name: "&<>\"'`=" } }
        let(:template_data) { "Hello, {{{name}}}." }

        it "does not escape special characters" do
          expect(render).to eq(rendered)
        end
      end
    end

    describe "partials" do
      context "when data is from a file" do
        let(:rendered) { "Hello, World (a 'planet')\n.\n" }
        let(:template_block) { nil }

        context "when file is missing" do
          let(:template_file) { fixture_path("views/hello_missing.hbs") }

          it "raises an error" do
            expect { render }.to raise_error(Tilt::Handlebars::Error)
          end
        end

        context "when file exists" do
          let(:template_file) { fixture_path("views/hello_partial.hbs") }

          it "renders correctly" do
            expect(render).to eq(rendered)
          end
        end

        context "when partial has extension `handlebars`" do
          let(:template_file) { fixture_path("views/hello_partial2.hbs") }

          it "renders correctly" do
            expect(render).to eq(rendered)
          end
        end

        context "when partial is registered" do
          let(:rendered) { "Hello, World.\n" }
          let(:template_file) { fixture_path("views/hello_partial.hbs") }

          before do
            template.register_partial(:partial, "{{name}}")
          end

          it "renders correctly" do
            expect(render).to eq(rendered)
          end
        end
      end

      context "when data is from a string" do
        let(:template_data) { "Hello, {{> partial}}." }

        context "when partial is missing" do
          it "raises an error" do
            expect { render }.to raise_error(Tilt::Handlebars::Error)
          end
        end

        context "when partial is registered" do
          let(:rendered) { "Hello, World." }

          before do
            template.register_partial(:partial, "{{name}}")
          end

          it "renders correctly" do
            expect(render).to eq(rendered)
          end
        end
      end

      describe "#load_partial" do
        let(:rendered) { "Hello, World (a 'planet')\n.\n" }

        context "when path is absolute" do
          let(:rendered) { "Hello, World (a 'planet')\n." }
          let(:template_data) {
            "Hello, {{> '#{fixture_dir}/views/partial'}}."
          }

          it "renders correctly" do
            expect(render).to eq(rendered)
          end
        end

        context "when path is relative" do
          let(:template_block) { nil }
          let(:template_file) { fixture_path("views/hello_partial.hbs") }

          it "renders correctly" do
            expect(render).to eq(rendered)
          end
        end
      end

      describe "#partial_missing" do
        let(:rendered) { "Hello, World (from partial)." }
        let(:template_data) { "Hello, {{> partial}}." }

        before do
          template.partial_missing do |name|
            "{{name}} (from #{name})"
          end
        end

        it "renders correctly" do
          expect(render).to eq(rendered)
        end
      end
    end

    describe "variables" do
      describe "arrays" do
        let(:render_scope) { { items: ["Mars", "World"] } }

        describe "access" do
          let(:rendered) { "Hello, World." }
          let(:template_data) { "Hello, {{items.[1]}}." }

          it "renders correctly" do
            expect(render).to eq(rendered)
          end
        end
      end
    end
  end

  describe "#respond_to?" do
    subject { template.respond_to?(name) }

    let(:template_file) { fixture_path("views/hello.hbs") }

    context "when name is `register_helper`" do
      let(:name) { :register_helper }

      it { is_expected.to eq(true) }
    end

    context "when name is `register_partial`" do
      let(:name) { :register_partial }

      it { is_expected.to eq(true) }
    end

    context "when name is `undefined`" do
      let(:name) { :undefined }

      it { is_expected.to eq(false) }
    end
  end
end
