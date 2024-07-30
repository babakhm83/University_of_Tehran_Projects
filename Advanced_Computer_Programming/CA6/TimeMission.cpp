#include "TimeMission.hpp"
using namespace std;

TimeMission::TimeMission(int _id, int _start, int _end, int _target, int _reward)
    : Mission(_id, _start, _end, _target * 60, _reward)
{
}

int TimeMission::travel(int path_start, int path_end,
                        int path_distance, vector<pair<int, int>> &time_periods)
{
    return Mission::travel(path_start, path_end, path_end - path_start, time_periods);
}
