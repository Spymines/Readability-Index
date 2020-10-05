import sys

#Puts the word list into a set called difficult words
def importDifficult(difficultWords):
	f = open("/pub/pounds/CSC330/dalechall/wordlist1995.txt","r")
	for word in f:
		difficultWords.add(cleanUp(word.rstrip()))

#Binary Search to look through difficult word list, based off Rosetta Code
def isDifficult(word, difficultWords):
	low = 0
	high = len(difficultWords)-1
	while low <= high:
		mid = (low + high)//2
		if(difficultWords[mid] > word):
			 high = mid -1
		elif(difficultWords[mid] < word):
			low = mid + 1
		else:
			return False
	return True

#Returns a bool based on if the passed in word is fully alphabetic
def isWord(word):
	if(word.isnumeric()):
		return False
	else: 
		return True

#Returns a bool based on if the passed end word ends a sentence
def endsSentence(word):
	if(len(word) == 1):
		return False
	punctuation = ['.', '?', '!', ':', ';']
	if any(c in word for c in punctuation):
		return True
	else:
		return False 

#Formats the input word and returns it
def cleanUp(word):
	temp = ""
	for char in word:
		if(char.isalpha()):
			temp += char
	return temp

#Returns a syllable count for the passed in word
def countSyllables(word):
	syllables = 0
	if(len(word) == 1):
		return 1
	for x in range(0, len(word)):
		if((x == 0) and (isVowel(word[x]))):
			syllables += 1
		elif(isVowel(word[x])):
			if(not isVowel(word[x-1])):
				syllables += 1
	if((word[len(word)-1] == 'e') and (not isVowel(word[len(word)-2]))):
		syllables -= 1
	if(syllables <= 0):
		syllables = 1
	return syllables		

#Returns a bool to tell if the passed in char is a vowel
def isVowel(char):
	if(char == 'a' or char == 'e' or char == 'i' or char == 'o' or char == 'u' or char == 'y'):
		return True
	else: 
		return False	

#Computes and prints scores
def computeScores(sentenceCount, wordCount, syllableCount, difficultCount, bash,name):
	alpha = syllableCount/wordCount
	beta = wordCount/sentenceCount
	


	flesch = (206.865 - (alpha*84.6) - (beta*1.015))
	fleschKincaid = ((alpha*11.8) + (beta*0.39) -15.59)	

	alphaDC = difficultCount/wordCount
	daleChall = (alphaDC *100 * 0.1579 + (beta * 0.0496))
	if(alphaDC > 0.05):
		daleChall += 3.6365

	if(bash):
		print("Python\t       ", name.strip(), "\t\t", round(flesch), "\t", round(fleschKincaid,1), "\t\t", round(daleChall,1))
	else:
		print("Flesch: ", round(flesch))
		print("Flesch Kincaid: ", round(fleschKincaid, 1))
		print("Dale Chall: ", round(daleChall, 1))



#Main body of the program starts


filename = "/pub/pounds/CSC330/translations/" + sys.argv[1]
f= open(filename, encoding="utf8", errors = 'ignore')


bash = False
if(len(sys.argv) == 3):
	if(sys.argv[2] == "bash"):
		bash = True

name = sys.argv[1]
name = name[0:name.index('.')]

difficultWords = set()
importDifficult(difficultWords)
wordCount = 0
sentenceCount = 0
syllableCount = 0
difficultCount = 0

for x in f:
	words = x.split()
	for y in words:
		currWord = y.lower()
		if(isWord(currWord)):
			wordCount += 1
			if(endsSentence(currWord)):
				sentenceCount += 1
			currWord = cleanUp(currWord)
			if(len(currWord) > 0):
				syllableCount = syllableCount + countSyllables(currWord)
				if(currWord not in difficultWords):
					difficultCount += 1

#print("Word count: ", wordCount)
#print("Sentence count: ", sentenceCount)
#print("Syllable count: ", syllableCount)
#print("Difficult count: ", difficultCount)
computeScores(sentenceCount, wordCount, syllableCount, difficultCount, bash, name)
f.close()
