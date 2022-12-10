package AoC;
use strict;
use warnings FATAL => 'all';
use Cwd;

sub GetInput {
    my $filename = shift;
    open my $fh, getcwd().'\INPUT\\'.$filename or die 'Could not locate input file';
    return $fh;
}

1;