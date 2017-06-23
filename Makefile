all:
	g++ -O2 -std=c++11 optimize.cpp -o optimize

debug:
	g++ -g3 -std=c++11 optimize.cpp -o optimize
