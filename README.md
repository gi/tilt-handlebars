# Tilt::Handlebars

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

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
