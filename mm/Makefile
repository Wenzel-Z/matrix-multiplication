CXX = g++
CXXFLAGS = -std=c++11 -g -O2 -fopenmp


all: mm
	@echo The mm program has been compiled 

# implicit rule: create x from x.cpp
.cpp:
	$(CXX) $(CXXFLAGS) $? -o $@

.PHONY: clean
clean:
	$(RM) -r mm *.dSYM

