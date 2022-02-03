# frozen_string_literal: true

RSpec.describe Tilt do
  let(:template_class) { Tilt::HandlebarsTemplate }

  describe "[]" do
    subject { described_class[path] }

    let(:path) { "test.#{extension}" }

    context "when the file extension is `handlebars`" do
      let(:extension) { :handlebars }

      it { is_expected.to eq(template_class) }
    end

    context "when the file extension is `hbs`" do
      let(:extension) { :hbs }

      it { is_expected.to eq(template_class) }
    end
  end

  describe "new" do
    subject(:template) { described_class.new(template_file, **template_opts) }

    let(:template_file) { fixture_path("views/hello.hbs") }
    let(:template_opts) { { lazy: false, path: nil } }

    it { is_expected.to be_a(template_class) }

    it "sets the file" do
      expect(template.file).to eq(template_file)
    end

    it "sets the options" do
      expect(template.options).to eq(template_opts)
    end
  end
end
