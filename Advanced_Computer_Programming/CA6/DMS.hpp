#ifndef _DMS_HPP
#define _DMS_HPP
#include "Driver.hpp"
#include "TimeMission.hpp"
#include "DistanceMission.hpp"
#include "CountMission.hpp"
#include <iostream>
#include <vector>
const std::string COMMANDS[6] = {"add_time_mission", "add_distance_mission",
                                 "add_count_mission", "assign_mission",
                                 "record_ride", "show_missions_status"};
const std::string OK = "OK";

class DMS
{
public:
    ~DMS();
    void run();

private:
    // variables
    std::vector<Mission *> missions;
    std::vector<Driver *> drivers;
    // functions
    Mission *find_mission_by_id(int _id);
    Driver *find_driver_by_id(int _id);
    // input commands
    std::vector<std::string> separate_words(std::string input);
    template <typename mission_type>
    void add_mission_command(std::vector<std::string> words);
    void assign_mission(std::vector<std::string> words);
    void record_ride(std::vector<std::string> words);
    void show_missions_status(std::vector<std::string> words);
};
#endif