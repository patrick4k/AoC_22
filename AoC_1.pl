#!/usr/bin/perl
use strict;
use warnings FATAL => 'all';
use File::Basename ();
use lib File::Basename::dirname( $0 );
use AoC;

my $fh = AoC::GetInput('1.txt');

my @elves = ();
my $i = 0;
while (<$fh>) {
    chomp;
    if (/^\d+$/) {
        $elves[$i] += $_;
    }
    else {
        $i++;
    }
}
my @sortedElves = sort {$b <=> $a} @elves;
print 'Max = '.$sortedElves[0]."\n";

my $top3Sum = 0;
for my $x (0..2) {
    print $sortedElves[$x]."\n";
    $top3Sum += $sortedElves[$x];
}

print "\n".'Top 3 Sum: '.$top3Sum;
