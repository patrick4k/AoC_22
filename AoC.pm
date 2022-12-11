package AoC;
use strict;
use warnings FATAL => 'all';
use Cwd;
use Data::Dumper;
use Storable;

sub GetInput {
    my $filename = shift;
    open my $fh, getcwd().'\INPUT\\'.$filename or die 'Could not locate input file';
    return $fh;
}

sub CheckPattern {
    my $pattern = shift;
    while (<STDIN>) {
        chomp;
        if (/$pattern/) {
            print "MATCHED\n";
        }
        else {
            print "NO MATCHED\n"
        }
    }
}

sub Dump {
    for (@_) {
        print Dumper($_)."\n";
    }
}

sub Pause {
    print "Paused Program...\n\tEnter to continue";
    <STDIN>;
}

sub Clone {
    return(Storable::dclone(shift()));
}

1;