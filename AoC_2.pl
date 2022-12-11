#!/usr/bin/perl
# https://adventofcode.com/2022/day/2
use strict;
use warnings FATAL => 'all';
use File::Basename ();
use lib File::Basename::dirname( $0 );
use AoC;

my $fh = AoC::GetInput('2.txt');

my %points_per_move = (
    X => 1, # rock
    Y => 2, # paper
    Z => 3 # scissors
);

my %foe_to_me = (
    A => 'X', # rock
    B => 'Y', # paper
    C => 'Z' # scissor
);

my %strengths = (
    A => 'Z', # rock > scissor
    B => 'X', # paper > rock
    C => 'Y' # scissors > paper
);

my %weaknesses = (
    A => 'Y',
    B => 'Z',
    C => 'X'
);

sub main {
    my @rounds = ();
    my $totalScore = 0;

    # Get rounds
    push @rounds, [split /\W/] while (<$fh>);

    # Part 2
    my @rounds2 = ();
    for (@rounds) {
        push @rounds2, [StratToRound(@{$_})]
    }

    # Populate Score
    # $totalScore += GetScore(@{$_}) for (@rounds); # Part 1
    $totalScore += GetScore(@{$_}) for (@rounds2); # Part 2
    print "Total Score = $totalScore";
}


sub GetScore {
    my ($foe, $me) = @_;
    my $score = $points_per_move{$me};
    if ($strengths{$foe} eq $me) {
        $score += 0; # loss
    }
    elsif ($foe_to_me{$foe} eq $me) {
        $score += 3; # draw
    }
    else {
        $score += 6; # win
    }
    print "@_ -> $score\n";
    return $score;
}

sub StratToRound {
    my ($foe, $strat) = @_;
    if ($strat eq 'X') {
        return ($foe, $strengths{$foe});
    }
    elsif ($strat eq 'Y') {
        return ($foe, $foe_to_me{$foe});
    }
    else {
        return( ($foe, $weaknesses{$foe}));
    }
}

main;
