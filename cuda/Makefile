CXX = nvcc
CXXFLAGS = -std=c++11 -g -O2


all: mm
	@echo The mm program has been compiled 

# implicit rule: create x from x.cu
.cu:
	module load gcc; \
	module load cudall.2/toolkit;\
	$(CXX) $(CXXFLAGS) $? -o $@

.PHONY: clean
clean:
	$(RM) -r mm *.dSYM
