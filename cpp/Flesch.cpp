//Trevor Mines
//CSC 330
//Flesch Project
//10/5/2020


#include <iostream>
#include <fstream>
#include <string>
#include <cmath>
#include <vector>
#include <algorithm>
#include <cstddef>

using namespace std;

void checkInput(int argc);
bool isWord(string word);
bool endsSentence(string word);
int countSyllables(string word); 
void computeLevels(double wordCount, double sentenceCount, double syllableCount, double difficultCount, bool bash, string name);
void importDifficultWords(vector<string> &difficultWords);
bool isDifficult(vector<string> &difficultWords, string word);
void formatWord(string &word);
bool isVowel(char c);

int main(int argc, char* argv[]){
	
	checkInput(argc);  
	
	//Checks for bash command line argument
	bool bash = false;
	if(argc == 3){
		string arg2 = argv[2];
		if(arg2 == "bash"){
			bash = true;
		}
	}


	string providedFile = argv[1];
	//Isolate file name for bash
	string name = providedFile.substr(0, providedFile.find_first_of('.')); 

	string textFile = "/pub/pounds/CSC330/translations/" + providedFile; 
	
	ifstream infile; 
	infile.open(textFile);
	if(infile.fail()){
		cout << "File not found." << endl; 
		exit(0);
	}
	string word;
 
	vector<string> difficultWords; 
	importDifficultWords(difficultWords);

	double wordCount = 0; 
	double sentenceCount = 0; 
	double syllableCount = 0; 
	double difficultCount = 0;

	while(infile >> word){ 
		if (isWord(word)){
			wordCount++; 
			if (endsSentence(word))
				sentenceCount++; 
			formatWord(word);
			if (isDifficult(difficultWords,word))
				difficultCount++;
			syllableCount += countSyllables(word);
		}
	}

//Test print statements
//	cout << "Sentences: " << sentenceCount << endl; 
//	cout << "Words: " << wordCount << endl; 
//	cout << "Syllables: " << syllableCount << endl; 
//	cout << "Difficult: " << difficultCount << endl; 

	computeLevels(wordCount, sentenceCount, syllableCount, difficultCount,bash, name);
}

//Checks for the correct number of command line arguments, ends program upon incorrect number
void checkInput(int argc){
	if(argc == 1){
		cout << "Please provide a file name from the command line." << endl; 
		exit(0); 
	}
	if(argc > 3){
		cout << "Too many command line arguments" << endl;
		exit(0); 
	}
}

//Checks to see if a input string is numeric(and therefore not a word)
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

//Checks a word for end punctuation to denote the end of a sentence
bool endsSentence(string word){
	bool end = false; 
	for(int i = 0; i < word.size(); i++){
		char curr = word[i];
		if(curr == '.' || curr == '!' || curr == ':' || curr == '?' || curr == ';')
			end = true;
	}
	return end; 
}

//Counts and returns the syllables in the input word
int countSyllables(string word){
	int currCount = 0; 
	for (int i = 0; i < word.size(); i++){
		char c = tolower(word[i]);
		if(isVowel(tolower(word[i]))){
			if(i == 0){
				currCount++; 		
			}
			else if(! isVowel(tolower(word[i-1]))){
				currCount++;
			}
		}
	}
	if(tolower(word[word.size()-1]) == 'e'){
		if(!isVowel(tolower(word[word.size()-2]))){
			currCount--;		
		}
	}	
	if(currCount <= 0)
		currCount = 1;
	return currCount; 
}

//Does the computations to calculate and print the reading levels
void computeLevels(double wordCount, double sentenceCount, double syllableCount, double difficultCount, bool bash, string name){
	double alpha = syllableCount/wordCount;
	double beta = wordCount/sentenceCount; 	
	double flesch = 206.835 - (alpha*84.6) - (beta*1.015);

	double fleschKincaid = (alpha*11.8) + (beta*.39) - 15.59;

	double dcAlpha = difficultCount/wordCount;

	double daleChall = (dcAlpha *100 *.1579 + (beta * 0.0496));

	if(dcAlpha > 0.05)
		daleChall += 3.6365;
 
	//Printing in and out of bash
	if(bash){
		cout << "C++\t\t" << name << "\t\t";
		printf("%.0f\t%.1f\t\t%.1f\n", flesch, fleschKincaid, daleChall);
	}
	else{
		printf("Flesch:  %.0f \n", flesch);
		printf("Flesch-Kincaid: %.1f \n", fleschKincaid);
		printf("Dale-Chall: %.1f \n", daleChall);
	}
}

//Brings in the list of difficult words from the file provided
//Makes all words lowercase for later comparisons
void importDifficultWords(vector<string> &difficultWords){

	string wordFile = "/pub/pounds/CSC330/dalechall/wordlist1995.txt";

        ifstream infile;
        infile.open(wordFile);
        if(infile.fail()){
                cout << "File not found." << endl;
                exit(0);
        }

	string currWord = "";

	while(infile >> currWord){
		for(int i = 0; i < currWord.size(); i++){
			currWord[i] = tolower(currWord[i]);
		}
		difficultWords.push_back(currWord);
	}
	sort(difficultWords.begin(), difficultWords.end());
}

//Checks to see if the string sent in is on the difficult word list
bool isDifficult(vector<string> &difficultWords, string word){
	if (word.compare("") == 0 || word.compare(" ") == 0)
		return false;
	for(int i = 0; i < word.size(); i++){
		word[i] = tolower(word[i]);
	}	
	int low = 0; 
	int high = difficultWords.size();

	//Search for word
	while(low <= high){
		int mid = (low+high)/2;
 
		if (word.compare(difficultWords[mid]) > 0)
			low = mid+1;
		else if (word.compare(difficultWords[mid]) < 0)
			high = mid-1;
		else{ 
			return false; 
		}
	} 
	return true; 
}

//Formats words to lowercase and removes unwanted characters
void formatWord(string &word){
	for(int i = 0; i < word.size(); i++){
		word[i] = tolower(word[i]);
	}
	bool done = false;
	while(!done){
		int location = -1; 
		location = word.find_first_of("[].,;:!?/1234567890()#\"'");
		if(location == -1)
			done = true; 
		else 
			word.erase(word.begin()+location);
	}
}

//Checks to see if the sent in char is a vowel
bool isVowel(char c){
	if(c == 'a' || c == 'e' || c == 'i' || c == 'o' || c == 'u' || c == 'y'){
        	return true;
        }
        else{
                return false;
        }

}



