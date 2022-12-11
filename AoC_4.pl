#!/usr/bin/perl
use strict;
use warnings FATAL => 'all';
use File::Basename ();
use lib File::Basename::dirname( $0 );
use AoC;

my $fh = AoC::GetInput('4.txt');

sub main {
    my @pairs = ();
    while (<$fh>) {
        chomp;
        my @pair;
        my @room_assignments = split /\,/;
        for (@room_assignments) {
            my @rooms = split /-/;
            my %assignment = (
                MIN => $rooms[0],
                MAX => $rooms[1]
            );
            push(@pair, \%assignment);
        }
        my @sortedPair = sort {($b->{MAX} - $b->{MIN}) <=> ($a->{MAX} - $a->{MIN})} @pair;
        push(@pairs, [@sortedPair]);
    }
    print 'Total Overlap = '.CountTotalOverlap(@pairs)."\n";
    print 'All Overlap = '.CountAllOverlap(@pairs)."\n";
}

sub CountTotalOverlap {
    my @pairs = @_;
    my $count = 0;
    for my $pair (@pairs) {
        my ($rooms1, $rooms2) = @{$pair};
        if ($rooms1->{MIN} <= $rooms2->{MIN} &&
            $rooms1->{MAX} >= $rooms2->{MAX}) {
            $count++;
        }
    }
    return $count;
}

sub CountAllOverlap {
    my @pairs = @_;
    my $count = 0;
    for my $pair (@pairs) {
        my $foundOverlap = 0;
        for my $mod (\&DoNothing, \&Reverse) { # funny solution hehe
            my ($room1, $room2) = &$mod(@{$pair});
            for my $end ('MIN', 'MAX') {
                if ($room1->{$end} >= $room2->{MIN} &&
                    $room1->{$end} <= $room2->{MAX}) {
                    $foundOverlap = 1;
                    last;
                }
            }
            last if $foundOverlap;
        }
        $count += 1 if $foundOverlap;
    }
    return $count;
}

sub DoNothing {
    return @_;
}

sub Reverse {
    return reverse(@_);
}

main;
