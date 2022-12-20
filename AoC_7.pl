#!/usr/bin/perl
# https://adventofcode.com/2022/day/7
use strict;
use warnings FATAL => 'all';
use File::Basename ();
use lib File::Basename::dirname( $0 );
use AoC;

my $fh = AoC::GetInput('7ex.txt');

my %home = (
    next  => {},
    files => []
);

my @currDir = (['/']);
my @allDirs = (['/']);

my $matchCommand = {
    '^\$' => \&DoCommand,
    '^\d+\s.+$' => \&WriteFile,
    '^dir\s\w+$' => \&WriteDir,
};

sub main {
    my @lines = ();
    while (<$fh>) {
        chomp;
        push(@lines, $_);
    }

    for my $line (@lines) {
        for my $match (sort keys %{$matchCommand}) {
            if ($line =~ /$match/) {
                &{$matchCommand->{$match}}($line);
                last;
            }
        }
    }

    AoC::Dump(\%home);

    for my $dirs_aRef (@allDirs) {
        my $dir = GetDirectory($dirs_aRef);

    }
}

sub GetDirectory {
    my @dirs = defined($_[0])? @{$_[0]}: @currDir;
    shift(@dirs);
    my $temp = \%home;
    while (@dirs) {
        $temp = $temp->{next}{shift(@dirs)};
    }
    return $temp;
}

sub DoCommand {
    $_ = shift;
    DoCD($1) if /cd/ && m/(\S+$)/;
}

sub DoCD {
    my $dir = shift;
    if ($dir eq '/') {
        @currDir = ('/');
    }
    elsif ($dir eq '..') {
        pop(@currDir);
    }
    else {
        push(@currDir, $dir);
        push(@allDirs, [@currDir]);
    }
}

sub WriteFile {
    my $currDir = GetDirectory;
    my ($size, $name) = split /\s/, shift;
    push(@{$currDir->{files}}, {
        name  => $name,
        size => $size
    });
}

sub WriteDir {
    my (undef, $dir) = split /\s/, shift;
    my $currDir = GetDirectory;
    $currDir->{next}{$dir} = {
        next  => {},
        files => []
    };
}

sub CalcSize {
    my %dir = %{shift()};
    my $size = 0;
    for my $file (@{$dir{files}}) {
        $size += $file->{size};
    }


}

main;
