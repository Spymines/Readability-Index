program Flesch

character(:), allocatable :: long_string, wordlist
character(:), allocatable :: currWord
integer :: filesize,j,k,wordsize,l
real :: wordCount, sentenceCount, syllableCount, difficultCount
real :: alpha, beta, dcAlpha, fleschVal, fleschKincaid, daleChall
character(len = 50) :: filename
integer :: counter, i
logical :: out


interface 
subroutine read_file(long_string, filesize, filename)
character(:), allocatable :: long_string
integer :: filesize
character(len = 50) :: filename
end subroutine read_file

logical function isWord(currWord, wordsize) result(out)
integer :: counter, i
character(*) :: currWord
integer :: wordsize
end function isWord

logical function isSentence(currWord, wordsize) result (out)
integer :: wordsize, i
character(*) :: currWord
character :: c
end function isSentence

logical function isVowel(c) result (out)
character :: c
end function isVowel

subroutine getWordList(wordList)
integer :: listsize, counter
character(:), allocatable :: wordlist
character(LEN = 1):: input
end subroutine getWordList

logical function isDifficult(currWord, wordlist) result(out)
character(*) :: currWord
character(*) :: wordlist
end function isDifficult

function formatWord(in) result(out)
character(*), intent(in)  :: in
character(:), allocatable :: out
integer                   :: i, j, counter, ascii, currPos

character(*), parameter   :: upp = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
character(*), parameter   :: low = 'abcdefghijklmnopqrstuvwxyz'
end function formatWord

end interface

call GET_COMMAND_ARGUMENT(1, filename)

call read_file(long_string, filesize, filename)
call getWordList(wordlist)
wordlist = formatWord(wordlist)
print*, wordlist
k = 1
j = 1


do while (k .le. filesize)
        
        if(long_string(k:k) .eq. ' ' .or. iachar(long_string(k:k)) .eq. 10) then
                wordsize = k-j
                if (wordsize .gt. 0) then
                        allocate(character(wordsize) :: currWord)
                        currWord = long_string(j:k)     
!                       print *, currWord 
                        k = k + 1
                        j = k
                
                        if(isWord(currWord, wordsize)) then
                                wordCount = wordCount + 1
                                !print*, currWord
                                if (isSentence(currWord, wordSize)) then
                                        sentenceCount = sentenceCount + 1
                                end if 
                        !end if
                        currCount = 0
                        l = 1
                        do while (l .le. wordsize)
                                if(isVowel(currWord(l:l)) .and. l == 1) then
                                        currCount = currCount + 1
                                else if(isVowel(currWord(l:l))) then
                                        if(.not. isVowel(currWord(l-1:l-1))) then
                                                currCount = currCount + 1
                                        end if
                                end if
                                       l = l + 1 
                        end do
                        currWord = formatWord(currWord)
                 !       print *, currWord
                        if(currWord(wordsize:wordsize) .eq. 'e') then
                                if(isVowel(currWord(wordsize-1:wordsize-1))) then
                                        currCount = currCount - 1
                                end if
                        end if
                        if(currCount .le. 0) then
                                currCount = 1
                        end if
                        syllableCount = syllableCount + currCount
                        
                        if(isDifficult(currWord, wordlist)) then 
                                difficultCount = difficultCount + 1
                        else 
                                print*, currWord
                        end if
                        end if
                        deallocate(currWord)

                else 
                        k = k+1
                        j = k
                end if
        else
                k = k + 1           
        end if 
end do

print *, "Word count: ", wordCount
print *, "Sentence count: ", sentenceCount
print *, "Syllable count: ", syllableCount
print *, "Difficult count: ", difficultCount


alpha = syllableCount/wordCount
beta = wordCount/sentenceCount
dcAlpha = difficultCount/wordCount 

fleschVal = 206.835 - (alpha*84.6) - (beta*1.015)
fleschKincaid = (alpha*11.8) + (beta*0.39) - 15.59
daleChall = (dcAplha*100)*(0.1579+(beta*0.0496))
if(dcAlpha .gt. 0.05) then 
        daleChall = daleChall + 3.6365
end if 

print *, "Flesch: ", fleschVal
print *, "Flesch-Kincaid: ", fleschKincaid
print *, "Dale Chall: ", daleChall


end program Flesch



function formatWord(in) result(out)
character(*), intent(in)  :: in
character(:), allocatable :: out, temp
integer                   :: i, j, counter, ascii, currPos

character(*), parameter   :: upp = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
character(*), parameter   :: low = 'abcdefghijklmnopqrstuvwxyz'
out = in                                            
do i = 1, LEN_TRIM(out)             
        j = INDEX(upp, out(i:i))        
        if (j > 0) out(i:i) = low(j:j)  
end do 
!print*, out
counter = 0
allocate(character(len(out)) :: temp)
temp = out
!print*, temp
do i = 1, len(out)
        ascii = iachar(out(i:i))
!        print *, ascii
        if(( ascii .le. 122 .and. ascii .ge. 97) .or. ascii .eq. 10) then
        !        print*, out(i:i)
                counter = counter + 1
        end if     
!print*,counter
end do
currPos = 1
deallocate(out)
allocate(character(counter) :: out)
do i = 1, len(temp)
        ascii = iachar(temp(i:i))
        if(( ascii .le. 122 .and. ascii .ge. 97) .or. ascii .eq. 10) then          
               out(currPos:currPos) = temp(i:i)
               currPos = currPos + 1
        end if 
end do
!print*, out
end function formatWord


logical function isDifficult(currWord, wordlist) result(out)
character(*) :: currWord
character(*) :: wordlist
out = .true.
if (index(trim(adjustl(wordlist)),trim(adjustl(currWord))) .ne. 0) then
        out = .false.
end if 

end function isDifficult

!Imports the dale chall word list into wordlist
subroutine getWordList(wordList)
integer :: listsize, counter
character(:), allocatable :: wordlist
character(LEN = 1):: input

inquire (file = "/pub/pounds/CSC330/dalechall/wordlist1995.txt", size = listsize)
open (unit=5,status="old",access="direct",form="unformatted",recl=1, file &
="/pub/pounds/CSC330/dalechall/wordlist1995.txt")
allocate(character(listsize) :: wordlist)

counter = 1
100 read(5,rec=counter,err=200) input
        wordlist(counter:counter) = input
        counter = counter + 1
        goto 100
200 continue
counter = counter -1
close(5)
end subroutine getWordList

!Returns true if the passed in char is a vowel
logical function isVowel(c) result (out)
character :: c 
if( c .eq. 'a' .or. c .eq. 'e' .or. c .eq. 'i' .or. c .eq. 'o' .or. c .eq. 'u' .or. c .eq. 'y') then
        out = .true.
else
        out = .false.
end if
end function isVowel

!function to determine if the passed in word ends a sentence
logical function isSentence(currWord, wordsize) result (out)
integer :: wordsize, i
character(*) :: currWord
character :: c
out = .false.

i = 1

do while(i .le. wordsize)
        c = currWord(i:i)
        if(c .eq. '?' .or. c .eq. '!' .or. c .eq. '.' .or. c .eq. ';' .or. c .eq. ':') then
                out = .true.
        end if
        i = i + 1 
end do
end function isSentence

!Function to determine if the word has numbers in it
logical function isWord(currWord, wordsize) result(out)
integer :: counter, i
character(*) :: currWord
integer :: wordsize

i = 1

counter = 0
do while(i .le. wordsize)
        if(iachar(currWord(i:i)) .gt. 57 .or. iachar(currWord(i:i)) .lt. 48)then
                counter = counter + 1
        end if
        i = i + 1
end do
if(counter .eq. wordsize) then 
        out = .true.
else
        !print*, currWord
        out = .false.
end if 
end function isWord


!Subroutine to place the contents of the file into long_string
subroutine read_file(long_string, filesize, filename)
character(:), allocatable :: long_string
integer :: filesize
integer :: counter
character(len = 50) :: filename
character(len = 1) :: input

inquire (file = "/pub/pounds/CSC330/translations/" // filename, size = filesize)
open (unit=5,status="old",access="direct",form="unformatted",recl=1, file ="/pub/pounds/CSC330/translations/" // filename)
allocate(character(filesize) :: long_string)

counter = 1
100 read(5,rec=counter,err=200) input
        long_string(counter:counter) = input
        counter = counter + 1
        goto 100
200 continue
counter = counter -1
close(5)

print *, filesize
print *, filename
print *, counter

end subroutine read_file
