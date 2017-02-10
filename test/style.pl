#!/usr/bin/env perl

use strict;
use warnings;

die "usage: $0 <file>\n" if (not @ARGV);

my $rc = 0;
my $file = shift;

open(my $fh, '<', $file) or die "Cannot open \`$file' for read: $!\n";
while (<$fh>) {
  next if (/^\s*#/);

  my $errors = 0;

  # remove everything between single quotes
  # this will remove too much in case of: echo "var='$var'"
  # and thus miss an opportunity to complain later on
  # also it mangles the input line irreversible
  s/'[^']+'/'___'/g;

  # highlight unbraced variables--
  # unless properly backslash'ed
  $errors += s/((?:^|[^\\]))(((\\\\)+)?\$\w)/$1\033[31m$2\033[0m/g;

  # highlight single square brackets
  $errors += s/((?:^|\s+))\[([^\[].+[^\]])\](\s*(;|&&|\|\|))/$1\033[31m\[\033[0m$2\033[31m\]\033[0m$3/g;

  # highlight double equal sign
  $errors += s/(\[\[.*)(==)(.*\]\])/$1\033[31m$2\033[0m$3/g;

  # highlight tabs mixed with whitespace at beginning of lines
  $errors += s/^( *)(\t+ *)/\033[31m\[$2\]\033[0m/;

  # highlight trailing whitespace
  $errors += s/([ \t]+)$/\033[31m\[$1\]\033[0m/;

  next if (not $errors);
  print "${file}[$.]: $_";
  $rc = 1;
}
close($fh);

exit $rc;
