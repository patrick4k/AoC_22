#!/usr/bin/perl
use strict;
use warnings FATAL => 'all';
use File::Basename ();
use lib File::Basename::dirname( $0 );
use AoC;

my $fh = AoC::GetInput('5.txt');

sub main {

    my @initCrateLines = ();
    my @moves = ();
    while (<$fh>) {
        chomp;
        if (/move\s\d+\sfrom\s\d+\sto\s\d+/) {
            push(@moves, $_);
        }
        else {
            push(@initCrateLines, $_);
        }
    }

    my %initCrates = InitCratesFormat(@initCrateLines);

    for my $crateMover (\&CrateMover9000, \&CrateMover9001) {
        my $crates = AoC::Clone(\%initCrates);
        &$crateMover($crates, @moves);
        for my $i (sort {$a <=> $b} keys %{$crates}) {
            my @stack = @{$crates->{$i}};
            print "$stack[$#stack]";
        }
        print "\n";
    }
}

sub InitCratesFormat {
    my %crates = ();
    my %indexToCrate = ();
    for (reverse(@_)) {
        if (/\d/) {
            my @line = split //;
            for my $i (0..$#line) {
                if ($line[$i] =~ /\d/) {
                    $indexToCrate{$i} = $line[$i];
                    $crates{$line[$i]} = ();
                }
            }
        }
        elsif (/\w/) {
            my @line = split //;
            for my $i (0..$#line) {
                push(@{$crates{$indexToCrate{$i}}}, $line[$i]) if ($line[$i] =~ /[A-Z]/);
            }
        }
    }
    return %crates;
}

sub CrateMover9000 {
    my ($crates, @moves) = @_;
    for my $move (@moves) {
        my ($numBoxes, $from, $to) = grep {/\d+/} split /\s+/, $move;
        for (1..$numBoxes) {
            my $box = pop(@{$crates->{$from}});
            push(@{$crates->{$to}}, $box);
        }
    }
}

sub CrateMover9001 {
    my ($crates, @moves) = @_;
    for my $move (@moves) {
        my ($numBoxes, $from, $to) = grep {/\d+/} split /\s+/, $move;
        my $last = @{$crates->{$from}};
        my @boxes = splice(@{$crates->{$from}}, $last - $numBoxes, $last);
        push(@{$crates->{$to}}, @boxes);
    }
}

main;
