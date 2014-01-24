Tilt Handlebars Release Notes
=============================

Version 1.3.0
-------------
2014 January 24

* Uses Handlebars.js 1.3.0, and handlebars.rb 0.6.0.

Note: Tilt Handlebars currently uses Tilt 1.4.x, because Sinatra is not yet 
compatible with Tilt 2.0. Once Sinatra is updated for Tilt 2.0, I'll release a 
new version of tilt-handlebars. Alternatively, I could break out Sinatra support
into a separate gem. If you use Tilt and Tilt Handlebars without Sinatra, and
Tilt 2.0 support is important to you, please file an issue to let me know.


Version 1.2.0
-------------
2013 September 30

This version is recommend for all users, as it brings support for the release 
version of Handlebars.

* Updates to handlebars.rb 0.5.0, which brings with it the 1.0.0 release
  version version of the JavaScript Handlebars, and an updated Ruby Racer
  (Ruby-JavaScript bridge). Thanks to [Yehuda Katz](https://github.com/wycats)
  and [Charles Lowell](https://github.com/cowboyd) for their continued work on 
  Handlebars and Handlebars.rb, respectively.

* Backwards compatibility note: If you are using automatic partials loading with
 an absolute path, you must now quote the path. For example:

		{{> "/the/path/to/partial" }}

	This is due to changes in the Handlebars parser.


Version 1.1.0
-------------
2013 August 15

* Sinatra support
* Automatic loading of partials


Version 1.0.0
-------------
2013 July 5

* Initial release
