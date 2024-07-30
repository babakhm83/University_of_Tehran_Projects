#ifndef _MISSION_HPP
#define _MISSION_HPP
#include "Errors.hpp"
#include <iostream>
#include <vector>

class Mission
{
private:
    int id;
    int target;
    int reward;
    int start_stamp;
    int end_stamp;

public:
    Mission(int _id, int _start, int _end, int _target, int _reward);
    Mission() {}
    bool operator>(Mission *_mission);
    bool operator<(Mission *_mission);
    bool is_your_id(int _id);
    bool are_you(Mission *_mission);
    bool do_you_start_earlier_than(int _start);
    virtual int travel(int path_start, int path_end,
                       int path_distance, std::vector<std::pair<int, int>> &time_periods);
    // accessors
    int get_target() { return target; }
    // print functions
    void print_id_for_show();
    void print_id_for_record();
    void print_start();
    void print_reward();
};
#endif