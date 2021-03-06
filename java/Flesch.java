//Trevor Mines
//CSC 330 
//FLesch Project
//10/5/2020

import java.io.*;
import java.util.*;
import java.lang.*;

public class Flesch{

public static void main(String args[]){
	
	try{

		double wordCount = 0; 
		double sentenceCount = 0;
		double syllableCount = 0; 
		double difficultCount = 0;

		ArrayList<String> wordList = new ArrayList<String>();
		importWordList(wordList);
	
		//Setup for bash command line argument
		boolean bash = false;
		if(args.length == 2){	
			if(args[1].equals("bash")){
				bash = true;
			}
		}
		String name = args[0]; 
		name = name.substring(0, name.indexOf('.'));

		//Reads in file word by word
		String filename = "/pub/pounds/CSC330/translations/" + args[0];
		BufferedReader inFile = new BufferedReader(new FileReader(filename));
		while(inFile.ready()){
			String line = inFile.readLine();
			String words[] = line.split(" ");
			
			for(String word:words){			

				if(isWord(word)){
					wordCount++;
					if(endsSentence(word))
						sentenceCount++;
					word = formatWord(word);
					syllableCount += countSyllables(word);
					if(isDifficult(word, wordList))
						difficultCount++;			
				}
			}
		}
//		System.out.print("Word Count: ");	
//		System.out.println(wordCount);
//		System.out.print("Sentence Count: ");		
//		System.out.println(sentenceCount);
//		System.out.print("Syllable Count: ");
//		System.out.println(syllableCount);
//		System.out.print("Difficult Count: ");
//		System.out.println(difficultCount);	

		computeScores(wordCount, sentenceCount, syllableCount, difficultCount, bash, name);
	}
	catch(IOException e){
		System.out.println("File not found.");
		System.exit(0);
	}
}

//Puts word list into an array list
static void importWordList(ArrayList<String> wordList){
	try{
		String tempWord;
		File wordFile = new File("/pub/pounds/CSC330/dalechall/wordlist1995.txt");
		Scanner inFile = new Scanner(wordFile);
		while(inFile.hasNext()){
			tempWord = inFile.next();
			wordList.add((String)formatWord(tempWord));		
		}
		Collections.sort(wordList);
		wordList.trimToSize();
	}
	catch(FileNotFoundException e){
		System.out.println("Word list not found");
		System.exit(0);
	}

}

//Returns a boolean based on if the passed in string contains numbers
static boolean isWord(String word){
	boolean temp = true; 
	for(int i = 0; i < word.length(); i++){
		if(Character.isDigit(word.charAt(i))){
			temp = false;
			break;
		}
	}
	return temp;
}

//Determines if the passed in string ends a sentence
static boolean endsSentence(String word){
	if(word.length() != 0){
		char c = word.charAt(word.length()-1);
		char d = 'a';
		if(word.length() >= 2){
			d = word.charAt(word.length()-2);
		}
		if(c == '.' || c == ';' || c == ':' || c == '?' || c == '!' || d == '.' || d == ';' || d == ':' || d == '?' || d == '!')
			return true;
	}
	return false;
}

//Removes everythng from a string except alphabetic characters
static String formatWord(String word){
	StringBuilder tempWord = new StringBuilder(word);
	for(int i = tempWord.length()-1; i >= 0 ; i--){
		if(! Character.isLetter(word.charAt(i)))
			tempWord.deleteCharAt(i);
	}
	word = tempWord.toString();
	return word.toLowerCase();
}

//Returns a syllable count for the passed in word
static int countSyllables(String word){
	int syllableCount = 0; 
	for(int i = 0; i < word.length(); i++){
		if( i == 0 && isVowel(word.charAt(i))){
			syllableCount++; 
		}
		else if(isVowel(word.charAt(i)) && !isVowel(word.charAt(i-1))){
			syllableCount++; 
		}
	}
	if((word.length() >= 2) && (word.charAt(word.length()-1) == 'e') && isVowel(word.charAt(word.length()-1)))
		syllableCount --;
	if(syllableCount <= 0)
		syllableCount = 1; 
	return syllableCount; 
}

//Returns a bool to say if the passed in char is a vowel
static boolean isVowel(char c){
	if(c == 'a' || c == 'e' || c == 'i' || c == 'o' || c == 'u' || c == 'y')
		return true; 
	return false;
}

//Determines if the passed in bool is in the wordList
static boolean isDifficult(String word, ArrayList<String> wordList){	
	int low = 0; 
	int high = wordList.size()-1;
	int mid;  
	while(high >= low){
		mid = (high + low)/2;
		if(word.compareTo(wordList.get(mid)) > 0){
			low = mid + 1; 	
		}
		else if(word.compareTo(wordList.get(mid)) < 0){
			high = mid - 1; 
		}
		else{
			return false; 
		}
	}	
	return true;

}

//Computes and prints final scores
static void computeScores(double wordCount, double sentenceCount, double syllableCount, double difficultCount, boolean bash, String name){
	double alpha = syllableCount/wordCount;
	double beta = wordCount/sentenceCount; 

	double flesch = 206.835 - (alpha * 84.6) - (beta *1.015);
	double fleschKincaid = (alpha * 11.8) + (beta * 0.39) - 15.59;

	double dcAlpha = difficultCount/wordCount;

	double daleChall = (dcAlpha * 100 * 0.1579) + (beta * 0.0496); 
	if(dcAlpha > 0.05)
		daleChall += 3.636;		

	if(bash){
		System.out.printf("Java\t\t%s\t\t%.0f\t%.1f\t\t%.1f\n", name, flesch, fleschKincaid, daleChall);
	}
	else{
		System.out.printf("Flesch = %.0f\n", flesch); 
		System.out.printf("Flesch-Kincaid = %.1f\n", fleschKincaid);
		System.out.printf("Dale-Chall = %.1f\n", daleChall);
	}

}

}

























