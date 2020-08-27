//C++ Flesch file, currently working on file read in
//File read in works (file name input from command line) with exception of repeating the last word

#include <iostream>
#include <fstream>
#include <string>

using namespace std;

void checkInput(int argc);

int main(int argc, char* argv[]){
	
	checkInput(argc); 

	string providedFile = argv[1];
	string textFile = "/pub/pounds/CSC330/translations/" + providedFile; 
	
	ifstream infile; 
	infile.open(textFile);
	if(infile.fail()){
		cout << "File not found." << endl; 
		exit(0);
	}
	string word; 
	while(infile.good()){
		infile >> word; 
		cout << word; 
	}
}

//Checks for the correct number of command line arguments, ends program upon incorrect number
void checkInput(int argc){
	if(argc == 1){
		cout << "Please provide a file name from the command line." << endl; 
		exit(0); 
	}
	if(argc > 2){
		cout << "Too many command line arguments" << endl;
		exit(0); 
	}
}
