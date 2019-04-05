CC = g++

#92
#CC = /usr/local/gcc-4.9.0/bin/g++-4.9.0
#93
#CC = /usr/local/gcc-4.9.0/bin/g++

SUFFIX  = cpp
OBJPATH = ./obj

#92
#BOOSTROOT = /opt/boost_1_56
#86
BOOSTROOT = /opt/boost_1_57_0
#93
#BOOSTROOT = /home/yaohl/Prog/boost
BOOSTINCDIR = $(BOOSTROOT)/include
BOOSTLIBS = $(BOOSTROOT)/lib/libboost_graph.a

SOURCES = $(wildcard *.$(SUFFIX))
SOURCES1 = $(wildcard mymst/*.$(SUFFIX))
SOURCES2 = $(wildcard mymst/voronoi/*.$(SUFFIX))
SOURCES3 = $(wildcard BBDME/*.$(SUFFIX))

OBJECTS = $(SOURCES:%.$(SUFFIX)=$(OBJPATH)/%.o)
OBJECTS1 = $(SOURCES1:%.$(SUFFIX)=$(OBJPATH)/%.o)
OBJECTS2 = $(SOURCES2:%.$(SUFFIX)=$(OBJPATH)/%.o)
OBJECTS3 = $(SOURCES3:%.$(SUFFIX)=$(OBJPATH)/%.o)

HEADERS = $(wildcard ./*.h)

#92
#GLPKINC = -I/usr/local/glpk/include 
#GLPKLIB = -L/usr/local/glpk/lib -lglpk
#93
GLPKINC = -I/opt/glpk454/include 
GLPKLIB = -L/opt/glpk454/lib -lglpk
#GUROBIINC = -I/home/yaohl/Prog/gurobi600/linux64/include
#GUROBILIB = -L/home/yaohl/Prog/gurobi600/linux64/lib -lgurobi_c++ -lgurobi60
#GUROBIINC = -I/home/yaohl/Prog/gurobi563/linux64/include
#GUROBILIB = -L/home/yaohl/Prog/gurobi563/linux64/lib -lgurobi_c++ -lgurobi56
#86
GUROBIINC = -I/opt/gurobi600/linux64/include
GUROBILIB = -L/opt/gurobi600/linux64/lib -lgurobi_c++ -lgurobi60

STD=--std=c++11
#93
M64=-m64

IFLAG = -I. -I$(BOOSTINCDIR) $(GLPKINC) $(GUROBIINC)
LFLAG = -ldl -lm $(BOOSTLIBS) $(STD) $(GLPKLIB) $(GUROBILIB) $(M64)
CFLAGS = -c -Wno-deprecated $(IFLAG) $(DBG) $(STD) $(M64)

TARGET = ./FlowCSR

$(TARGET):$(OBJECTS) $(OBJECTS1) $(OBJECTS2) $(OBJECTS3)
	@echo "Now Generating $(TARGET)"
	$(CC) -o $(TARGET) $(OBJECTS) $(OBJECTS1) $(OBJECTS2) $(OBJECTS3) $(LFLAG)
	@echo "Done!"

# Compile the application code
$(OBJPATH)/%.o: %.$(SUFFIX) $(HEADERS)
	@echo "Now Compile $< ..."
	$(CC) -o $@ $(CFLAGS) $<
	@echo "Done!"
.KEEP_STATE:
clean:
	@echo "Now Removing ..."
	@-rm -rf $(TARGET)
	@-rm -rf $(OBJECTS)
	@-rm -rf $(OBJECTS1)
	@-rm -rf $(OBJECTS2)
	@-rm -rf $(OBJECTS3)
	@echo "Done!"
debug:
	@$(MAKE) -f makefile DBG="-DDEBUG -g"
opt:
	@$(MAKE) -f makefile DBG="-O2"

explain:
	@echo "The following information represents your program:"
	@echo "Final executable name: $(TARGET)"
	@echo "Source files: $(SOURCES)"
	@echo "Source1 files: $(SOURCES1)"
	@echo "Source2 files: $(SOURCES2)"
	@echo "Source2 files: $(SOURCES3)"
	@echo "Object files: $(OBJECTS)"
	@echo "Object1 files: $(OBJECTS1)"
	@echo "Object2 files: $(OBJECTS2)"
	@echo "Object3 files: $(OBJECTS3)"

