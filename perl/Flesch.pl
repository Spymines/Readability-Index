#!/usr/bin/perl
use strict;
use warnings;

use Scalar::Util qw(looks_like_number);

my $filename = $ARGV[0] or die "Need to get file name on the command line\n";

open(DATA, "<$filename") or die "Couldn't open file $filename,$!";

my @all_lines = <DATA>;

my $wordCount = 0;
my $syllableCount = 0;
my $sentenceCount = 0; 
my $difficultCount = 0;

#Reads in one line and splits it into words
foreach my $line (@all_lines){
	my @tokens  = split(' ', $line);
	
	#Loop that will count words, sentences, syllables, etc. for each word
	foreach my $token (@tokens){
		if(not looks_like_number($token)){
			$wordCount++;
			my $s = 'a';
			my $c = substr($token, length($token)-1, 1);
			if(length($token) >1){
				$s = substr($token, length($token)-2, 1);
				print "s  = $s   c = $c\n";
			}
			if(($c or $s) eq ('.' or '!' or ':' or ';' or '?')){
				print "$token";
				$sentenceCount++;
			}
		}
	}		
}

print "Word Count: $wordCount\n";
print "Sentence Count: $sentenceCount\n";
print "Syllable Count: $syllableCount\n"; 
print "Difficult Count: $difficultCount\n";

