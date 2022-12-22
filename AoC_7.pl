#!/usr/bin/perl
# https://adventofcode.com/2022/day/7
use strict;
use warnings FATAL => 'all';
use File::Basename ();
use lib File::Basename::dirname( $0 );
use AoC;

my $fh = GetInput('7.txt');

my %home = (
    next  => {},
    files => []
);

my ($totalSize, $reqFree) = (70000000, 30000000);

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

    CalcSize(['/']);
    my $minReqDir = DeepClone(\%home);
    my $currFree = $totalSize - $home{size};
    for my $dirs_aRef (@allDirs) {
        my $size = CalcSize($dirs_aRef);
        if ($size + $currFree > $reqFree && $size < $minReqDir->{size}) {
            $minReqDir = GetDirectory($dirs_aRef);
        }
    }

    Dump($minReqDir);
    print "SIZE: $minReqDir->{size}";
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
    my @parent = @{shift()};
    my $parent = join '/', @parent;
    my $parentDir = GetDirectory(\@parent);
    my @dirs = grep {join('/', @{$_}) =~ /^$parent/} @allDirs;
    my $size = 0;
    for (@dirs) {
        my $dir = GetDirectory($_);
        for (@{$dir->{files}}) {
            $size += $_->{size};
        }
    }
    $parentDir->{size} = $size;
    return $size;
}

main;
