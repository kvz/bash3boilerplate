When hacking up BASH scripts, I often find there are some
higherlevel things like logging, configuration, commandline argument
parsing that:

 - I need everytime
 - Take quite some effort to get right
 - Keep you from your actual work

Here's an attempt to bundle those things in a generalized way so that
they are reusable as-is in most of my (and hopefully your, if not ping
me) programs.

## Goals

I'm going to be pragmatic and violate good practices like DRY
and the things I know about sourcing files, git submodules,
package management, etc.

I feel that when a program consists of multiple files, BASH
may very well not be the right tool for the job.

Copy-pasting, and removing what you don't need may not seem
very rocket-scientific, or 2013, but in fact neither is BASH.

Keeping things simple, small and lightweight should be key
here.

Aiming for portability I'm targetting BASH 3 (OSX still ships
with v3 for instance). If you're going to ask people to install
BASH 4 first, you might as well pick a better language as a
dependency and code up your script in that.

The main template shoud only have features that are needed
80% of the time you write BASH.

Other cool functions can be adopted into this repository,
but should not be referenced by the `main.sh` template and function
purely as a resource.

## Features

- Structure
- Configuration by environment variables
- Configuration by commandline arguments (definitions parsed from help info,
so no duplication needed)
- Magic variables like __FILE__ and __DIR__
- Logging that supports colors and is compatible with [Syslog Severity levels](http://en.wikipedia.org/wiki/Syslog#Severity_levels)

## Conventions

It's the task of the script's **caller** to:
 - Redirect the output to appropriate locations
 - Correctly set the PATH variable (think [cronjobs](http://kvz.io/blog/2007/07/29/schedule-tasks-on-linux-using-crontab/))

## Recommendations

- Use spaces vs tabs so you can copy-paste parts directly into
the console, without BASH's automcomplete firing on every tab
character
- Use `set -eu`, so it will break on every error
and undefined variable. if you're expecting an error, add `||true`
to your command.
Using `set -eu` over the interpreter `#!/bin/bash -eu` makes
sure the flags are respected even when your script is called like `bash main.sh`.
- Checkout [The 10 Commandments of Logging](http://www.masterzen.fr/2013/01/13/the-10-commandments-of-logging/)

## Notes

- Use `emergency` to exit with 1

## Compile

For those who want the template to get out of there way, I'm also
shipping a compiled version that removes some comments, puts
more things on one line, etc. For readability and boilerplate development, use the
bigger version.

## Fork

I'm looking forward to your comments and pull requests!

On [github](http://github.com/kvz/bash3boilerplate)

