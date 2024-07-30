#include "CountMission.hpp"
using namespace std;

CountMission::CountMission(int _id, int _start, int _end, int _target, int _reward)
    : Mission(_id, _start, _end, _target, _reward)
{
}

int CountMission::travel(int path_start, int path_end,
               int path_distance, vector<pair<int, int>> &time_periods)
{
    return Mission::travel(path_start, path_end, 1, time_periods);
}