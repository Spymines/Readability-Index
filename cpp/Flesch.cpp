//C++ Flesch file, currently working on file read in
//File read in works

#include <iostream>
#include <fstream>
#include <string>

using namespace std;

void checkInput(int argc);
bool isWord(string word);
bool endsSentence(string word);


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
 
	int wordCount = 0; 
	int sentenceCount = 0; 

	while(infile >> word){ 
		if (isWord(word))
			wordCount++; 
		if (endsSentence(word))
			sentenceCount++; 
		
	}
	cout << wordCount << endl; 
	cout << sentenceCount << endl; 
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

bool isWord(string input){
	bool word = true; 
	for(int i = 0; i < input.size(); i++){
		if(isdigit(input[i])){
			word = false; 
			break; 
		}
	}
	return word; 
}

bool endsSentence(string input){
	bool end = false; 
	for(int i = 0; i < input.size(); i++){
		char curr = input[i];
		if(curr == '.' || curr == '!' || curr == ':' || curr == '?' || curr == ';')
			end = true;
	}
	return end; 
}
