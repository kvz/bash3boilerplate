When hacking up BASH scripts, I often find there are some
higherlevel things like logging, configuration, commandline argument
parsing that:

 - I need everytime
 - Take quite some effort to get right
 - Keep you from your actual work

Here's an attempt to bundle those things in a generalized way so that
they are reusable as-is in most of my (and hopefully your, if not ping
me) programs.

An up to date [intro is found on my blog](http://kvz.io/blog/2013/02/26/introducing-bash3boilerplate/).

## Versioning

This project implements the Semantic Versioning guidelines.

Releases will be numbered with the following format:

`<major>.<minor>.<patch>`

And constructed with the following guidelines:

* Breaking backward compatibility bumps the major (and resets the minor and patch)
* New additions without breaking backward compatibility bumps the minor (and resets the patch)
* Bug fixes and misc changes bumps the patch

For more information on SemVer, please visit [http://semver.org/]().

## License

Copyright (c) 2013 Kevin van Zonneveld, [http://kvz.io]()  
Licensed under MIT: [http://kvz.mit-license.org]()
