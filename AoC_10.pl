#!/usr/bin/perl
# https://adventofcode.com/2022/day/10
use strict;
use warnings FATAL => 'all';
use File::Basename ();
use lib File::Basename::dirname( $0 );
use AoC;

use feature 'state';

use List::Util qw(any);

my $fh = GetInput('10.txt');

my $X = 1;
my $cycle = 0;
my @render = ();

my @cyclesToCount = (20, 60, 100, 140, 180, 220);

sub main {

    my $cycleSum = 0;

    while (<$fh>) {
        my $cmd = ToCommand($_);
        until ($cmd->{tick} == 0) {
            $cycle++;
            $cmd->{tick}--;
            if (any {$_ == $cycle} @cyclesToCount) {
                $cycleSum += $cycle*$X;
            }
            Draw();
        }
        &{$cmd->{cmd}}($cmd->{args}) if defined $cmd->{cmd};
    }

    print "Cycle Sum: $cycleSum\n";
    Render(); # out -> ZRARLFZU

}

sub Render {
    for (@render) {
        print "@{$_}\n";
    }
}

sub Draw {
    state $i = 0;
    state @line = ();

    push @line, (any {$_ == $i} ($X-1..$X+1)) ? '#' : '.';
    $i++;

    if ($i == 40) {
        push @render, [@line];
        ($i, @line) = (0);
    }
}

sub ToCommand {
    my $command = shift;
    if ($command =~ /^noop/) {
        return {tick => 1};
    }
    else {
        return {
            cmd  => \&{sub {
                $X += shift;
            }},
            tick => 2,
            args  => $command =~ /(-?\d+)/
        };
    }

}

main;
