EXE = md5_test
ADA_VERSION = -gnat05
SRC = Conversion.adb MD5.adb MD5_Test.adb
FLAGS = -gnato -gnatwa -fstack-check

all: 
	gnatmake $(ADA_VERSION) $(FLAGS) $(SRC)

ada83: 
	gnatmake -gnat83  $(FLAGS) $(SRC)

ada95: 
	gnatmake -gnat95  $(FLAGS) $(SRC)

ada2005: 
	gnatmake -gnat05  $(FLAGS) $(SRC)

ada2012: 
	gnatmake -gnat12  $(FLAGS) $(SRC)

clean:
	rm *.ali *~ *.o $(EXE)