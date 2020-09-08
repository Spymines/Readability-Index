//C++ Flesch file, currently working on file read in
//File read in works
//Getting seg faule and more difficult words than actual words


#include <iostream>
#include <fstream>
#include <string>
#include <cmath>
#include <vector>
#include <algorithm>

using namespace std;

void checkInput(int argc);
bool isWord(string word);
bool endsSentence(string word);
int countSyllables(string word); 
void computeLevels(double wordCount, double sentenceCount, double syllableCount, double difficultCount);
void importDifficultWords(vector<string> &difficultWords);
bool isDifficult(vector<string> &difficultWords, string word);


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
			syllableCount += countSyllables(word);
			if (isDifficult(difficultWords, word))
				difficultCount++;
		}
		cout << wordCount << "   " << difficultCount << endl;
	}

	computeLevels(wordCount, sentenceCount, syllableCount, difficultCount);

	cout << wordCount << endl; 
	cout << sentenceCount << endl; 
	cout << syllableCount << endl; 
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

bool endsSentence(string word){
	bool end = false; 
	for(int i = 0; i < word.size(); i++){
		char curr = word[i];
		if(curr == '.' || curr == '!' || curr == ':' || curr == '?' || curr == ';')
			end = true;
	}
	return end; 
}

int countSyllables(string word){
	int currCount = 0; 
	for (int i = 0; i < word.size(); i++){
		char c = tolower(word[i]);
		if(c == 'a' || c == 'e' || c == 'i' || c == 'o' || c == 'u' || c == 'y'){
			if(i == 0){
				currCount++; 		
			}
			else{
				char t = tolower(word[i-1]);
				if(t == 'a' || t == 'e' || t == 'i' || t == 'o' || t == 'u' || t == 'y'){
					break; 
				}
				else{
					currCount++;
				}
			}
		}
		if(tolower(word[word.size()-1]) == 'e'){
			char r = tolower(word[word.size()-2]);
			if(r == 'a' || r == 'e' || r == 'i' || r == 'o' || r == 'u' || r == 'y'){
				break;
			}
			else{
				currCount--;
			}
		}
	}	
	if(currCount <= 0)
		currCount = 1;
	return currCount; 
}

void computeLevels(double wordCount, double sentenceCount, double syllableCount, double difficultCount){
	double alpha = syllableCount/wordCount;
	double beta = wordCount/sentenceCount; 	
	double flesch = 206.835 - (alpha*84.6) - (beta*1.015);


	cout << "Flesch = " << round(flesch) << endl; 

	double fleschKincaid = (alpha*11.8) + (beta*.39) - 15.59;

	cout << "Flesch-Kincaid = " << fleschKincaid << endl; 
	
}

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

bool isDifficult(vector<string> &difficultWords, string word){ 
	for(int i = 0; i < word.size(); i++){
		word[i] = tolower(word[i]);
	}	
	int low = 0; 
	int high = difficultWords.size();

	while(low <= high){
		int mid = (low+high)/2;
 
		if (word.compare(difficultWords[mid]) > 0)
			low = mid+1;
		else if (word.compare(difficultWords[mid]) < 0)
			high = mid-1;
		else{
			cout << mid << endl;  
			return false; 
		}
	}
	return true; 
}










