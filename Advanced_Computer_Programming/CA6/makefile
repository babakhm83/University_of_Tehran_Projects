all: main

GV=g++ -g -std=c++11 -c

main: CountMission.o DistanceMission.o TimeMission.o Mission.o Driver.o DMS.o
	g++ -g -std=c++11 CountMission.o DistanceMission.o TimeMission.o Mission.o Driver.o DMS.o -o main

DMS.o: DMS.cpp CountMission.o DistanceMission.hpp TimeMission.hpp Driver.hpp DMS.hpp
	$(GV) DMS.cpp

Driver.o: Driver.cpp CountMission.o DistanceMission.hpp TimeMission.hpp Driver.hpp
	$(GV) Driver.cpp

Mission.o: Mission.cpp Mission.hpp
	$(GV) Mission.cpp

TimeMission.o: TimeMission.cpp Mission.hpp TimeMission.hpp
	$(GV) TimeMission.cpp

DistanceMission.o: DistanceMission.cpp Mission.hpp DistanceMission.hpp
	$(GV) DistanceMission.cpp

CountMission.o: CountMission.cpp Mission.hpp CountMission.hpp
	$(GV) CountMission.cpp

clean :
	rm *.o main
