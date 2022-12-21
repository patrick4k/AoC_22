# https://adventofcode.com/2022
package AoC;
use strict;
use warnings FATAL => 'all';
use Cwd;
use Data::Dumper;
use Storable;
use File::Spec::Functions;
use JSON;
use Exporter;
our @ISA = qw(Exporter);
our @EXPORT = qw(GetInput OutFile CloseFH CheckPattern Dump Pause DeepClone ToJSON);

sub GetInput {
    my $filepath = catfile(catdir(getcwd(),'INPUT'), shift);
    open my $fh, $filepath or die 'Could not locate file: '.$filepath."\n";
    return $fh;
}

sub OutFile {
    my $filepath = catfile(catdir(getcwd(),'OUT'), shift);
    open my $fh, '>', $filepath or die $!."\nCould not open dir: $filepath\n";
    return $fh;
}

sub CloseFH {
    close shift;
}

sub CheckPattern {
    my $pattern = shift;
    while (<STDIN>) {
        chomp;
        if (/$pattern/) {
            print "MATCHED\n";
        }
        else {
            print "NO MATCHED\n"
        }
    }
}

sub Dump {
    for (@_) {
        print Dumper($_)."\n";
    }
}

sub Pause {
    print "Paused Program...\n\tEnter to continue";
    <STDIN>;
}

sub DeepClone {
    return(Storable::dclone(shift()));
}

sub ToJSON {
    my ($ref, $filename) = @_;
    my $fh = OutFile($filename);
    print $fh to_json($ref);
    CloseFH($fh);
}

1;
