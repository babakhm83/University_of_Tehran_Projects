#include "Mission.hpp"
using namespace std;

Mission::Mission(int _id, int _start, int _end, int _target, int _reward)
{
    id = _id;
    start_stamp = _start;
    end_stamp = _end;
    target = _target;
    reward = _reward;
    if (_end < _start)
    {
        throw INVALID_ARGUMENTS();
    }
    if (_target < 0 || _reward < 0)
    {
        throw INVALID_ARGUMENTS();
    }
}

bool Mission::operator>(Mission *_mission)
{
    return _mission->do_you_start_earlier_than(start_stamp);
}

bool Mission::operator<(Mission *_mission)
{
    return !_mission->do_you_start_earlier_than(start_stamp);
}

// print functions

void Mission::print_id_for_show()
{
    cout << "mission " << id << ":" << endl;
}

void Mission::print_id_for_record()
{
    cout << "mission: " << id << endl;
}

void Mission::print_start()
{
    cout << "start timestamp: " << start_stamp << endl;
}

void Mission::print_reward()
{
    cout << "reward: " << reward << endl;
}

bool Mission::is_your_id(int _id)
{
    return id == _id;
}

bool Mission::are_you(Mission *_mission)
{
    return _mission->is_your_id(id);
}

bool Mission::do_you_start_earlier_than(int _start)
{
    return start_stamp < _start;
}

int Mission::travel(int path_start, int path_end,
                    int amount, vector<pair<int, int>> &time_periods)
{
    if (path_end <= end_stamp && path_start >= start_stamp)
    {
        /*         for (auto time_period : time_periods)
                {
                    if (path_start < time_period.second &&
                        path_end > time_period.first)
                    {
                        return 0;
                    }
                }
                time_periods.push_back({path_start, path_end}); */
        return amount;
    }
    return 0;
}