#!usr/bin/perl
BEGIN {
  binmode STDIN, ":utf8";
}

while (<>) {
  s/(.)/ord($1) < 128 ? $1 : sprintf("\\U%08x", ord($1))/ge
}
continue {
  print or die "-p destination: $!\n";
}
