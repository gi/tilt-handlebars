# Tilt::Handlebars

[![Gem Version](https://badge.fury.io/rb/tilt-handlebars.svg)](https://rubygems.org/gems/tilt-handlebars)
[![Build Status](https://github.com/gi/tilt-handlebars/actions/workflows/ruby-ci.yml/badge.svg)](https://github.com/gi/tilt-handlebars/actions/workflows/ruby-ci.yml)
[![Test Coverage](https://api.codeclimate.com/v1/badges/19d544fcb843a50db1a2/test_coverage)](https://codeclimate.com/github/gi/tilt-handlebars/test_coverage)
[![Maintainability](https://api.codeclimate.com/v1/badges/19d544fcb843a50db1a2/maintainability)](https://codeclimate.com/github/gi/tilt-handlebars/maintainability)
[![MIT License](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE.txt)

Adds support for [Handlebars.rb](https://github.com/cowboyd/handlebars.rb) template 
engine to [Tilt](https://github.com/rtomayko/tilt).

See the [Handlebars.js](http://handlebarsjs.com) site for syntax.

## Installation

Add this line to your application's Gemfile:

    gem 'tilt-handlebars'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install tilt-handlebars

## Usage

Create a Handlebars template file with either a `.hbs` or `.handlebars` extension. 

Example, in `hello.hbs`:

```
Hello, {{name}}. I'm {{emotion}} to meet you.
```

Then, render the template with Ruby:

```ruby
require 'tilt/handlebars'

template = Tilt.new('hello.hbs')
puts template.render(nil, name: "Joe", emotion: "happy")
```

Output:

	Hello, Joe. I'm happy to meet you.

### Partials

Partials are a file that can be loaded into another. For example, you may define a web page with 
a master layout (`layout.hbs`), which includes a header (`header.hbs`) and footer (`footer.hbs`).
In this case, `header.hbs` and `footer.hbs` would be partials; `layout.hbs` includes these partials.

`layout.hbs`:

```html
<html>
	<head>...</head>
	<body>
		{{> header }}

		{{ content }}

		{{> footer }}
	</body>
</html>
```

Notice that you do not include the `.hbs` file extension in the partial name. Tilt Handlebars 
will look for the partial relative to the enclosing file (`layout.hbs` in this example) with
either a `.hbs` or `.handlebars` extension.

#### Sinatra

Handlebars can be used with Sintra:

```ruby
require 'sinatra/handlebars'

class MyApp < Sinatra::Base
  helpers Sinatra::Handlebars

  get "/hello" do
    handlebars :hello, locals: {name: 'Joe'}
  end
end
```

This will use the template file named `views/hello.hbs`.

Partials can also be used with Sinatra. As described previously, partials will be loaded
relative to the enclosing template (e.g., in the `views` directory).

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Add tests, preferrably using Minitest::Spec for consistency.
4. Run tests with `bundle exec rake test`.
5. Commit your changes (`git commit -am 'Add some feature'`)
6. Push to the branch (`git push origin my-new-feature`)
7. Create new Pull Request
