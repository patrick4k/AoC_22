#!/usr/bin/perl
# https://adventofcode.com/2022/day/9
use strict;
use warnings FATAL => 'all';
use File::Basename ();
use lib File::Basename::dirname( $0 );
use AoC;

my $fh = GetInput('9.txt');

my %unitVec = (
    R => {i => 1, j => 0},
    L => {i => -1, j => 0},
    U => {i => 0, j => 1},
    D => {i => 0, j => -1}
);

my %head = (
    i    => 0,
    j    => 0
);

my %tailVisited = (0 => {0 => 1});

sub main {
    AddKnots(9);
    MoveH(split /\s/) while <$fh>;
    print 'Total Visited by T: '.GetVisited();
}

sub AddKnots {
    my $n = shift;
    my $temp = \%head;
    while (defined $temp->{tail}) {
        $temp = $temp->{tail};
    }

    $temp = $temp->{tail} = { # why is this even allowed
        i    => $temp->{i},
        j    => $temp->{j}
    } for (1..$n);
}

sub MoveH {
    my ($dir, $n) = @_;
    for (1..$n) {
        $head{$_} += $unitVec{$dir}{$_} for qw(i j);
        MoveT(\%head, $head{tail});
    }
}

sub MoveT {
    my ($H, $T) = @_;
    my $shouldMove = 0;
    for (qw(i j)) {
        $shouldMove = 1 if abs($H->{$_} - $T->{$_}) > 1;
    }
    return unless $shouldMove;

    for (qw(i j)) {
        my $delta = $H->{$_} - $T->{$_};
        $T->{$_} += $delta/abs($delta) unless $delta == 0;
    }

    if (defined $T->{tail}) {
        MoveT($T, $T->{tail});
    }
    else {
        $tailVisited{$T->{i}}{$T->{j}} = 1;
    }
}

sub GetVisited {
    my $count = 0;
    $count += keys %{$tailVisited{$_}} for keys %tailVisited;
    return $count;
}

main;
