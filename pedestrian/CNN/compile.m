mex cc=gcc fconvn.cc CXXFLAGS="\$CXXFLAGS  -fopenmp" LDFLAGS="\$LDFLAGS -fopenmp" -lgomp 
mex cc=gcc dtAccS.cc CXXFLAGS="\$CXXFLAGS  -fopenmp" LDFLAGS="\$LDFLAGS -fopenmp" -lgomp
