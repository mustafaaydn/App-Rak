#!/usr/bin/env raku

# This script reads the lib/App/Rak.rakumod file, and generates the information
# about supported options, and writes it back to the file.

# always use highest version of Raku
use v6.*;

use String::Utils <between>;

my $generator = $*PROGRAM-NAME;
my $generated = DateTime.now.gist.subst(/\.\d+/,'');
my $start     = '#- start of available options';
my $end       = '#- end of available options';

# slurp the whole file and set up writing to it
my $filename = $?FILE.IO.parent.sibling("lib").add("App").add("Rak.rakumod");
my @lines = $filename.IO.lines;
$*OUT = $filename.IO.open(:w);

# for all the lines in the source that don't need special handling
my @options;
while @lines {
    my $line := @lines.shift;

    # nothing to do yet
    unless $line.starts-with($start) {
        @options.push: .Str with $line.match(/ 'my sub option-' <( <-[(]>+ /);
        say $line;
        next;
    }

    # found header, check validity and set up mapper
    say "$start --------------------------------------------------";
    say "#- Generated on $generated by $generator";
    say "#- PLEASE DON'T CHANGE ANYTHING BELOW THIS LINE";

    # skip the old version of the code
    while @lines {
        last if @lines.shift.starts-with($end);
    }

    # spurt the options
    say "my str @options = <@options[]>;";

    # we're done for this role
    say "#- PLEASE DON'T CHANGE ANYTHING ABOVE THIS LINE";
    say "$end ----------------------------------------------------";
}

# close the file properly
$*OUT.close;

note "Found @options.elems() options";

# vim: expandtab sw=4
