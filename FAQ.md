[This document is formatted with GitHub-Flavored Markdown.   ]:#
[For better viewing, including hyperlinks, read it online at ]:#
[https://github.com/kvz/bash3boilerplate/blob/master/FAQ.md  ]:#

## Contents

* [What is a cli](#what-is-a-cli)?
* [How do I add a command-line flag](#how-do-i-add-a-command-line-flag)?
* [How do I access the value of a command-line argument](#how-do-i-access-the-value-of-a-command-line-argument)?
* [How do I incorporate BASH3 Boilerplate into my own project](#how-do-i-incorporate-bash3boilerplate-into-my-own-project)?
* [What is a magic variable](#what-is-a-magic-variable)?
* [How do I incorporate BASH3 Boilerplate into my own project](#how-do-i-incorporate-bash3boilerplate-into-my-own-project)?
* [How can I contribute to this project](#how-can-i-contribute-to-this-project)?

<!--more-->

# Frequently Asked Questions

## What is a cli?

A 'cli' is a [command-line interface](https://en.wikipedia.org/wiki/Command-line_interface).

## How do I incorporate BASH3 Boilerplate into my own project?

You can incorporate BASH3 Boilerplate into your project one of three ways:
1. Copy the desired portions of [main.sh](./main.sh) into your own script.
1. Download [main.sh](./main.sh) and start pressing the delete-key for unwanted things

Once the `main.sh` has been tailor-made for your project you could either append your own script in the same file, or source it:

1. Copy [main.sh](./main.sh) into the same directory as your script and then edit and embed it into your script using bash's dot (`.`) include feature, e.g.
```bash
#!/usr/bin/env bash
. main.sh
```
1. Source [main.sh](./main.sh) in your script or at the command line
```bash
#!/usr/bin/env bash
. main.sh
```

## How do I add a command-line flag?

1. Copy the line the main.sh [read block](https://github.com/kvz/bash3boilerplate/blob/master/main.sh#L53) that most resembles the desired behavior and paste the line into the same block.
1. Edit the single-character (e.g., -d) and, if present, the multi-character (e.g., --debug) versions of the flag in the copied line.  
1. Omit the "[arg]" text in the copied line if the desired flag takes no arguments.
1. Omit or edit the text after "Default:" to set or not set default values, respectively. 
1. Omit the "Required." text if the flag is optional.

## How do I access the value of a command-line argument?

To evaluate the value of an argument, append the corresponding single-character flag to the text `$arg_`.  For example, if the [read block]
contains the line
```bash
   -t --temp  [arg] Location of tempfile. Default="/tmp/bar"
```

then you can evaluate the corresponding argument and assign it to a variable as follows:

```bash
__temp_file_name="${arg_t}"
```

## What is a magic variable?

The [magic variables](https://github.com/kvz/bash3boilerplate/blob/master/main.sh#L63) in `main.sh` are special in that they have a different value, depending on your environment. You can use `${__file}` to get a reference to your current script, `${__dir}` to get a reference to the directory it lives in. This is not to be confused with the location of the calling script that might be sourcing the `${__file}`, which is accessible via `${0}`, and the current directory of the administrator running the script, accessible via `$(pwd)`. Other magic variables are for instance `${__os}` which currently is limited to telling you wether you are on `OSX` and otherwise defaults to `Linux`.

## How do I submit an issue report?

Please visit our [Issues](https://github.com/kvz/bash3boilerplate/issues) page.

## How can I contribute to this project?

Please fork this repository.  Then create a branch containing your suggested changes and submit a pull request based on the master branch
of <https://github.com/kvz/bash3boilerplate/>. We're a welcoming bunch, happy to accept your contributions!
