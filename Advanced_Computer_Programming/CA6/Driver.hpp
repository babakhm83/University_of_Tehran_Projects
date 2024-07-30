#ifndef _DRIVER_HPP
#define _DRIVER_HPP
#include "TimeMission.hpp"
#include "DistanceMission.hpp"
#include "CountMission.hpp"
#include <vector>
#include <iostream>

struct driver_mission
{
    Mission* mission;
    int amount_till_target;
    int last_path_end_time;
    std::vector<std::pair<int, int>> time_periods;
};


class Driver
{
private:
    int id;
    std::vector<driver_mission> missions;
    // functions
    bool is_target_hit(driver_mission _mission);
    void sort_missions_by_start_time();

public:
    Driver(int _id);
    bool is_your_id(int _id);
    void assign_new_mission(Mission *mission);
    //print functions
    void print_completed_missions(int path_start, int path_end, int path_distance);
    void print_missions_status();
};
#endif