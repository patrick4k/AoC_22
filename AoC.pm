package AoC;
use strict;
use warnings FATAL => 'all';

sub GetInput {
    my $filename = shift;
    open my $fh, 'C:\Users\Patrick\Documents\Code\AoC\22\INPUT\\'.$filename or die 'Could not locate input file';
    return $fh;
}

1;