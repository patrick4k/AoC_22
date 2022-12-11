#!/usr/bin/perl
# https://adventofcode.com/2022/day/6
use strict;
use warnings FATAL => 'all';
use File::Basename ();
use lib File::Basename::dirname( $0 );
use AoC;

my $fh = AoC::GetInput('6.txt');

sub main {
    my @dsBuff = ();
    push(@dsBuff, split //, <$fh>);

    # Part 1
    FindFirstMarker(4, @dsBuff);

    # Part 2
    FindFirstMarker(14, @dsBuff);
}

sub FindFirstMarker {
    my ($n, @dsBuff) = @_;
    for (my $i = $n-1; $i <= $#dsBuff; $i++) {
        my @code = @dsBuff[1+$i-$n..$i];
        if (IsMarker(@code)) {
            print "First marker at -> ".($i+1)."\n";
            last;
        }
    }
}

sub IsMarker {
    my @code = @_;
    for my $char (@code) {
        return 0 if (1 < grep {$_ eq $char} @code);
    }
    return 1;
}

main;
