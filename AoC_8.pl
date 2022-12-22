#!/usr/bin/perl
# https://adventofcode.com/2022/day/8
use strict;
use warnings FATAL => 'all';
use File::Basename ();
use lib File::Basename::dirname( $0 );
use AoC;

use List::Util qw(all max);

my $fh = GetInput('8.txt');

# $trees['top->down']['left->right'];
my @trees = ();
my ($width, $height);

sub main {
    push(@trees, [map {{height => $_}} grep {/\d/} split //]) while <$fh>;

    ($width, $height) = ($#{$trees[0]}, $#trees);

    for my $i (0..$width) {
        for my $j (0..$height) {
            SetVis($i, $j);
            SetViewScore($i, $j);
        }
    }

    my $numVis = Sum(map {scalar grep {$_->{vis}} @{$_}} @trees);
    print "Number Vis: $numVis\n";

    my $viewMax = max map {max map {$_->{view}} @{$_}} @trees;
    print "Max View Score: $viewMax";
}

sub SetVis {
    my ($i, $j) = @_;
    my $tree = $trees[$j][$i];
    if ($i == 0 || $i == $width ||
            $j == 0 || $j == $width) {
        $tree->{vis} = 1;
        return;
    }

    my @row = @{$trees[$j]};
    my @column = map {@{$_}[$i]} @trees;

    for ([$i, @row], [$j, @column]) {
        my ($x, @list) = @{$_};

        my @list1 = @list[0..$x-1];
        my @list2 = @list[$x+1..$#list];

        for ([@list1], [@list2]) {
            if (all {$_->{height} < $tree->{height}} @{$_}) {
                $tree->{vis} = 1;
                return;
            }
        }
    }

    $tree->{vis} = 0;
}

sub SetViewScore {
    my ($i, $j) = @_;
    my $tree = $trees[$j][$i];

    my @row = @{$trees[$j]};
    my @column = map {@{$_}[$i]} @trees;

    my $viewScore = 1;

    for ([$i, @row], [$j, @column]) {
        my ($x, @list) = @{$_};

        my @list1 = $x >= 0 ? reverse @list[0..$x-1] : ();
        my @list2 = $x+1 <= $#list ? @list[$x+1..$#list] : ();

        for ([@list1], [@list2]) {
            my $distance = 0;
            for (@{$_}) {
                $distance++;
                last if $_->{height} >= $tree->{height};
            }
            $viewScore *= $distance;
        }
    }

    $tree->{view} = $viewScore;

}

main;
