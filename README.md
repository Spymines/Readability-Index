# My Readability Index

This is the readability index project for CSC 330.

How to run each language from within it's respective folder:

Filename in each case is something like "KJV.txt". The path to reach the translation is coded in. 


C++:
	To compile type : c++ Flesch.cpp
	To run with standard printout: a.out FileName
	To run with bash style single line printout: a.out Filename bash

Python:
	To run with standard printout: python3 Flesch.py Filename
	To run with bash style single line printout: python3 Flesch.py Filename bash

Java:
	To compile: javac Flesch.java
	To run with standard printout: java Flesch Filename
	To run with bash style single line printout: java Flesch Filename bash

Perl:
	To run with standard printout: Flesch.pl Filename

Fortran:
	To compile: gfortran Flesch.f95
	To run with standard printout: a,out Filename




Bash Script:
	A bashscript named runall (in the top folder) will run a chart like format similar to the one found in the extra credit portion of the assignment. To run it type "runall".
	
	I have also made a bash script named "compare1" which will run all 5 languages on a translation specified on the command line and display the time it takes each to run. 
	To run type: compare1 Filename
