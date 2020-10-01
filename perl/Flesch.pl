#!/usr/bin/perl
use strict;
use warnings;

use Scalar::Util qw(looks_like_number);

sub isVowel{
	my $c = $_[0];
	if ($c eq 'a' or $c eq 'e' or $c eq 'i' or $c eq 'o' or $c  eq 'u' or $c eq 'y'){
		return 1;
	}else{
		return 0;
	}
}

sub countSyllables{
	my $currWord = $_[0];
	my $i = 0;
	my $count = 0;
	while($i < length($currWord)){
		my $c = substr($currWord, $i, 1);
		if(isVowel($c) and $i eq 1){
			$count++;
		}elsif(isVowel($c) and not isVowel(substr($currWord, $i-1, 1))){
			$count++;
		}
		$i++;
	}
	if(length($currWord) > 1){	
		if(substr($currWord, length($currWord)-1, 1) eq 'e'){
			if(not isVowel(substr($currWord, length($currWord)-2),1)){
				$count--;
			}
		}
	}
	if($count < 1){
		$count = 1;
	}
	return $count;
} 
#substr(word,n,1)


my $filename = $ARGV[0] or die "Need to get file name on the command line\n";

open(DATA, "</pub/pounds/CSC330/translations/$filename") or die "Couldn't open file $filename,$!";

my @all_lines = <DATA>;

my $wordCount = 0;
my $syllableCount = 0;
my $sentenceCount = 0; 
my $difficultCount = 0;

#Imports the difficult word list into an array and makes each word lowercase
my $diffFile = "/pub/pounds/CSC330/dalechall/wordlist1995.txt";
open(LIST, $diffFile) or die "Couldn't open wordlist";
my @difficultWords = <LIST>;
my $counter = 0;
foreach my $word (@difficultWords){
	$difficultWords[$counter] = lc($word);
	chomp($difficultWords[$counter]);
	$counter++;
}


#Reads in one line and splits it into words
foreach my $line (@all_lines){
	my @tokens  = split(' ', $line);
	
	#Loop that will count words, sentences, syllables, etc. for each word
	foreach my $token (@tokens){
		if(not looks_like_number($token)){
			$wordCount++;
			$token = lc($token);			

			#Variables to hold the last two char of each word for punctuation
			my $s = 'a';
			my $c = substr($token, length($token)-1, 1);
			if(length($token) >1){
				$s = substr($token, length($token)-2, 1);
			}
			#Sentence Counter
			if($c eq '.' or $s eq '.' or $c eq '?' or $s eq '?' or $c eq '!' or $s eq '!' or $c eq ';' or $s eq ';' or $c eq ':' or $s eq ':'){
				$sentenceCount++;
			}
			#Deletes listed chars from string
			$token =~ tr/[]{}.,;:\"!?//d;

			my $high = @difficultWords -1;
			my $mid = -2;
              		my $low = 0;
			my $diff = 1;
              		while ($low <= $high and $diff){
				$mid = int(($low+$high)/2);
                      		if($token lt $difficultWords[$mid]){
                             		 $high = $mid -1;
                      		}elsif($token gt $difficultWords[$mid]){
                              		$low = $mid + 1;
                      		}else{ 
                              		$diff = 0;
                      		}
         		}       
         	        if($diff){
				$difficultCount++;
			}       
			$syllableCount = $syllableCount + countSyllables($token);
			




#			#Count Syllables
#			my $currCount = 0;
#			my $last = '';
#			my $first = 1;
#			foreach my $char(split //, $token){
#				if($first){
#					if($char eq 'a' or $char eq 'e' or $char eq 'i' or $char eq 'o' or $char eq 'u' or $char eq 'y') 
#						$currCount++;
#					}
#					$first = 0;
#				}elsif($char eq 'a' or $char eq 'e' or $char eq 'i' or $char eq 'o' or $char eq 'u' or $char eq 'y'){
#					if($last ne 'a' and $last ne 'e' and $last ne 'i' and $last ne 'o' and $last ne 'u' and $last ne 'y'){
#						$currCount++;
#					}
#				}
#				$last = $char;				
#			}
#			#How to check for ending e
#			if($last eq 'e'){
#				my $t = substr($token, $token.length()-1,1);
#				if($t eq 'a' or $t eq 'e' or $t eq 'i' or $t eq 'o' or $t eq 'u' or $t eq 'y'){
#					$currCount--;
#				}
#			}	
#			if($currCount <= 0){
#				$currCount = 1; 
#			}
#			$syllableCount += $currCount;				
		}
	}		
}

print "Word Count: $wordCount\n";
print "Sentence Count: $sentenceCount\n";
print "Syllable Count: $syllableCount\n"; 
print "Difficult Count: $difficultCount\n";


