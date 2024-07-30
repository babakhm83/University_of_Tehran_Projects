#include "Driver.hpp"
using namespace std;

Driver::Driver(int _id)
{
    id = _id;
}

void Driver::assign_new_mission(Mission *new_mission)
{
    for (auto mission : missions)
    {
        if (mission.mission->are_you(new_mission))
        {
            throw DUPLICATE_DRIVER_MISSION();
        }
    }
    missions.push_back({new_mission, new_mission->get_target(), -1, {}});
}

// print functions

bool Driver::is_target_hit(driver_mission _mission)
{
    return _mission.amount_till_target <= 0;
}

void Driver::sort_missions_by_start_time()
{
    for (int i = 0; i < missions.size() - 1; i++)
    {
        for (int j = 0; j < missions.size() - i - 1; j++)
        {
            if (*missions[j].mission > missions[j + 1].mission)
            {
                driver_mission temp = missions[j];
                missions[j] = missions[j + 1];
                missions[j + 1] = temp;
            }
        }
    }
}

bool Driver::is_your_id(int _id)
{
    return id == _id;
}

void Driver::print_completed_missions(int path_start, int path_end, int path_distance)
{ // for record_ride command
    cout << "completed missions for driver " << id << ":";
    sort_missions_by_start_time();
    bool no_mission = true;
    for (int i = 0; i < missions.size(); i++)
    {
        if (!is_target_hit(missions[i]))
        {
            missions[i].amount_till_target -=
                missions[i].mission->travel(path_start, path_end,
                                            path_distance, missions[i].time_periods);
            if (is_target_hit(missions[i]))
            {
                missions[i].last_path_end_time = path_end;
                no_mission = false;
                cout << endl;
                missions[i].mission->print_id_for_record();
                missions[i].mission->print_start();
                cout << "end timestamp: " << missions[i].last_path_end_time << endl;
                missions[i].mission->print_reward();
            }
        }
    }
    if (no_mission)
    {
        cout << endl;
        if (missions.size() == 0)
        {
            throw DRIVER_MISSION_NOT_FOUND();
        }
    }
}

void Driver::print_missions_status()
{ // for show_status command
    cout << "missions status for driver " << id << ":";
    sort_missions_by_start_time();
    for (auto mission : missions)
    {
        cout << endl;
        mission.mission->print_id_for_show();
        mission.mission->print_start();
        cout << "end timestamp: " << mission.last_path_end_time << endl;
        mission.mission->print_reward();
        if (is_target_hit(mission))
        {
            cout << "status: completed" << endl;
        }
        else if (!is_target_hit(mission))
        {
            cout << "status: ongoing" << endl;
        }
    }
    if (missions.size() == 0)
    {
        cout << endl;
        throw DRIVER_MISSION_NOT_FOUND();
    }
}
