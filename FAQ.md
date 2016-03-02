[This document is formatted with GitHub-Flavored Markdown.   ]:#
[For better viewing, including hyperlinks, read it online at ]:#
[https://github.com/kvz/bash3boilerplate/blob/master/FAQ.md  ]:#

# Frequently Asked Questions

## Contents
* [What is a cli](#what-is-a-cli)?
* [How do I add a command-line flag](#how-do-i-add-a-command-line-flag)?
* [How do I access the value of a command-line argument](#how-do-i-access-the-value-of-a-command-line-argument)?
* [How do I incorporate bash3boilerplate into my own project](#how-do-i-incorporate-bash3boilerplate-into-my-own-project)?
* [What is a magic variable](#what-is-a-magic-variable)?
* [How do I incorporate bash3boilerplate into my own project](how-do-i-incorporate-bash3boilerplate-into-my-own-project)?
* [How can I contribute to this project](how-can-i-contribute-to-this-project)?

### What is a cli?

A 'cli' is a [command-line interface](https://en.wikipedia.org/wiki/Command-line_interface).

### How do I incorporate bash3boilerplate into my own project?

You can incorporate bash3boilerplate into your project one of three ways:
1. Copy the desired portions of [main.sh](./main.sh) into your own script.
2. Copy [main.sh](./main.sh) into the same directory as your script and then edit and embed it into your script using bash's dot (".") include feature, e.g.
    #!/bin/bash
    . main.sh
3. Source [main.sh](./main.sh) in your script or at the command line
    source main.sh
4. ... (add additional use cases here and descriptions of how to use other files in bash3boilerplate)

### How do I add a command-line flag?

1. Copy the line the main.sh [read block](https://github.com/kvz/bash3boilerplate/blob/master/main.sh#L53) that most resembles the desired behavior and paste the line into the same block.
2. Edit the single-character (e.g., -d) and, if present, the multi-character (e.g., --debug) versions of the flag in the copied line.  
3. Omit the "[arg]" text in the copied line if the desired flag takes no arguments.
4. Omit or edit the text after "Default:" to set or not set default values, respectively. 
5. Omit the "Required." text if the flag is optional.

### How do I access the value of a command-line argument?

To evaluate the value of an argument, append the corresponding single-character flag to the text "$arg_".  For example, if the [read block]
contains the line
```bash
   -t --temp  [arg] Location of tempfile. Default="/tmp/bar"
```
then you can evalute the correspondign argument and assign it to a variable as follows:
```bash
   temp_file_name=$arg_t
```

### What is a magic variable?

The [magic variables](https://github.com/kvz/bash3boilerplate/blob/master/main.sh#L63) in main.sh are special in that...

### How do I submit an issue report?

Please visit our [Issues](https://github.com/kvz/bash3boilerplate/issues) page.

### How can I contribute to this project?

Please fork this repository.  Then create a branch containing your suggested changes and submit a pull request based on the master branch
of https://github.com/kvz/bash3boilerplate/.


