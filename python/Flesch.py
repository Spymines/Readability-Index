#Word Count Works
#Need to fix importing difficult words


import sys

def importDifficult(difficultWords):
	f = open("/pub/pounds/CSC330/dalechall/wordlist1995.txt","r")
	for word in f:
		difficultWords.append(word.rstrip())
#		print(word)

#Binary Search to look through difficult word list, based off Rosetta Code
def isDifficult(word, difficultWords):
	low = 0
	high = len(difficultWords)-1
	while low <= high:
		mid = (low + high)//2
		print(mid, " ", word, " ", difficultWords[mid])
		if(difficultWords[mid] > word):
			 high = mid -1
		elif(difficultWords[mid] < word):
			low = mid + 1
		else:
			print("found")
			return False
	print("not found")
	return True

def isWord(word):
	if(word.isnumeric()):
		return False
	else: 
		return True

def endsSentence(word):
	if(len(word) == 1):
		return False
	punctuation = ['.', '?', '!', ':', ';']
	if any(c in word for c in punctuation):
		return True
	else:
		return False 

def cleanUp(word):
	return word.translate({ord(i): None for i in '",.:;?![]{}/'})

def countSyllables(word):
	syllables = 0
	if(len(word) == 1):
		return 1
	for x in range(0, len(word)):
		if((x == 0) and (isVowel(word[x]))):
#			print("first Vowel", word)
			syllables += 1
		elif(isVowel(word[x])):
			if(not isVowel(word[x-1])):
#				print(word[x], " " , word[x-1], " add one")
				syllables += 1
	if((word[len(word)-1] == 'e') and (not isVowel(word[len(word)-2]))):
		syllables -= 1
#	print(word, " ", syllables)
	if(syllables <= 0):
		syllables = 1
	return syllables		

def isVowel(char):
	if(char == 'a' or char == 'e' or char == 'i' or char == 'o' or char == 'u' or char == 'y'):
		return True
	else: 
		return False	


def computeScores(sentenceCount, wordCount, syllableCount, difficultCount):
	alpha = syllableCount/wordCount
	beta = wordCount/sentenceCount
	


	flesch = (206.865 - (alpha*84.6) - (beta*1.015))
	fleschKincaid = ((alpha*11.8) + (beta*0.39) -15.59)	

	alphaDC = difficultCount/wordCount
	daleChall = (alphaDC *100 * 0.1579 + (beta * 0.0496))
	if(alphaDC > 0.05):
		daleChall += 3.6365

	print("Flesch: ", round(flesch))
	print("Flesch Kincaid: ", round(fleschKincaid, 1))
	print("Dale Chall: ", round(daleChall, 1))

#Main body of the program starts

filename = "test.txt"

#Commented out for testing 
#filename = "/pub/pounds/CSC330/translations/" + sys.argv[1]
f= open(filename, "r")

difficultWords = []
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
			syllableCount = syllableCount + countSyllables(currWord)
			if(isDifficult(currWord, difficultWords)):
				difficultCount += 1

print("Word count: ", wordCount)
print("Sentence count: ", sentenceCount)
print("Syllable count: ", syllableCount)
print("Difficult count: ", difficultCount)
computeScores(sentenceCount, wordCount, syllableCount, difficultCount)
f.close()
