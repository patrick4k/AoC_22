#!/usr/bin/perl
# https://adventofcode.com/2022/day/3
use strict;
use warnings FATAL => 'all';
use File::Basename ();
use lib File::Basename::dirname( $0 );
use AoC;

my $fh = AoC::GetInput('3.txt');

my @priority = (('a'..'z'),('A'..'Z'));

sub main {
    my @rucksacks = ();

    push(@rucksacks, $_) while (<$fh>);

    print 'Priority Sum = '.GetPrioritySum(@rucksacks)."\n";

    print 'Badge Sum = '.GetBadgeSum(@rucksacks);
}

sub GetPriority {
    # Will break if $item is not in priority list
    my $item = shift;
    my $i = 0;
    $i++ until $item eq $priority[$i];
    return $i+1;
}

sub GetPrioritySum {
    my @rucksacks = @_;
    my $prioritySum = 0;
    for (@rucksacks) {
        my @sack = split //;
        my @sack1 = @sack[0..@sack/2-1];
        my @sack2 = @sack[@sack/2..$#sack];
        for my $item (@sack1) {
            if (grep {$item eq $_} @sack2) {
                $prioritySum += GetPriority($item);
                last;
            }
        }
    }
    return $prioritySum;
}

sub GetLikeItem {
    my @sack1 = split //, shift();
    my @sack2 = split //, shift();
    my @sack3 = split //, shift();
    for my $item (@sack1) {
        if ((grep {$_ eq $item} @sack2) &&
            (grep {$_ eq $item} @sack3)) {
            return $item;
        }
    }
    return 0;
}

sub GetBadgeSum {
    my @ruchsacks = @_;
    my $badgeSum = 0;
    for(my $i = 2; $i < @ruchsacks; $i+=3) {
        my @sacks = @ruchsacks[$i-2..$i];
        $badgeSum += GetPriority(GetLikeItem(@sacks));
    }
    return $badgeSum;
}

main;
