#ifndef _TIMEMISSION_HPP
#define _TIMEMISSION_HPP
#include "Mission.hpp"
#include <vector>

class TimeMission : public Mission
{
    public:
    TimeMission(int _id, int _start, int _end, int _target, int _reward);
    int travel(int path_start, int path_end,
    int path_distance, std::vector<std::pair<int, int>> &time_periods);
};
#endif