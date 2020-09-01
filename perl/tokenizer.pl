#!/usr/bin/perl
use strict;
use warnings;

my $filename = $ARGV[0] or die "Need to get file name on the command line\n";

open(DATA, "<$filename") or die "Couldn't open file $filename,$!";

my @all_lines = <DATA>;

foreach my $line (@all_lines){
	my @tokens  = split(' ', $line);
	foreach my $token (@tokens){
		print "$token\n";
	}
}
