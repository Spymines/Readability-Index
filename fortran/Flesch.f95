program Flesch

character, dimension(:), allocatable :: long_string
integer :: filesize
character(len = 50) :: filename

interface 
subroutine read_file(long_string, filesize, filename)
character, dimension(:), allocatable :: long_string
integer :: filesize
character(len = 50) :: filename
end subroutine read_file
end interface

call GET_COMMAND_ARGUMENT(1, filename)

call read_file(long_string, filesize, filename)

print *, long_string


end program Flesch








subroutine read_file(long_string, filesize, filename)
character, dimension(:), allocatable :: long_string
integer :: filesize
integer :: counter
character(len = 50) :: filename
character(len = 1) :: input

inquire (file = "/pub/pounds/CSC330/translations/" // filename, size = filesize)
open (unit=5,status="old",access="direct",form="unformatted",recl=1, file ="/pub/pounds/CSC330/translations/" // filename)
allocate(long_string(filesize))

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
