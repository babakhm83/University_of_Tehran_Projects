#include "DMS.hpp"
using namespace std;

// Drivers Mission System program
// A system where drivers take missions and by hitt
// Written by Babak Hosseini Mohtasham(810101408) on 1402/2/26

DMS::~DMS()
{
    for (auto mission : missions)
    {
        delete mission;
    }
    for (auto driver : drivers)
    {
        delete driver;
    }
}

void DMS::run()
{
    string input;
    while (getline(cin, input))
    {
        vector<string> words = separate_words(input);
        try
        {
            if (words[0] == COMMANDS[0])
            {
                add_mission_command<TimeMission>(words);
            }
            else if (words[0] == COMMANDS[1])
            {
                add_mission_command<DistanceMission>(words);
            }
            else if (words[0] == COMMANDS[2])
            {
                add_mission_command<CountMission>(words);
            }
            else if (words[0] == COMMANDS[3])
            {
                assign_mission(words);
            }
            else if (words[0] == COMMANDS[4])
            {
                record_ride(words);
            }
            else if (words[0] == COMMANDS[5])
            {
                show_missions_status(words);
            }
        }
        catch (const INVALID_ARGUMENTS)
        {
            cout << "INVALID_ARGUMENTS" << endl;
        }
        catch (const std::logic_error) // for wrong input type and for null input
        {
            cout << "INVALID_ARGUMENTS" << endl;
        }
    }
}

Mission *DMS::find_mission_by_id(int _id)
{
    for (auto mission : missions)
    {
        if (mission->is_your_id(_id))
        {
            return mission;
        }
    }
    throw MISSION_NOT_FOUND();
}

Driver *DMS::find_driver_by_id(int _id)
{
    for (auto driver : drivers)
    {
        if (driver->is_your_id(_id))
        {
            return driver;
        }
    }
    drivers.push_back(new Driver(_id));
    return drivers[drivers.size() - 1];
}

// input commands

vector<string> DMS::separate_words(string input)
{
    vector<string> words;
    int i = 0, j = 0;
    while (1)
    {
        if (input[i] == ' ' || input[i] == '\t' || input[i] == '\r' || input[i] == '\0' || input[i] == '\n' || i == input.size())
        {
            words.push_back(input.substr(j, i - j));
            j = i + 1;
            if (i == input.size() || input[i] == '\t' || input[i] == '\r' || input[i] == '\0' || input[i] == '\n')
            {
                return words;
            }
        }
        i++;
    }
}

void DMS::assign_mission(vector<string> words)
{
    if (words.size() < 3)
    {
        throw INVALID_ARGUMENTS();
    }
    string mission_id = words[1], driver_id = words[2];
    try
    {
        Mission *mission = find_mission_by_id(stoi(mission_id));
        find_driver_by_id(stoi(driver_id))->assign_new_mission(mission);
        cout << OK << endl;
    }
    catch (const MISSION_NOT_FOUND)
    {
        cout << "MISSION_NOT_FOUND" << endl;
    }
    catch (const DUPLICATE_DRIVER_MISSION)
    {
        cout << "DUPLICATE_DRIVER_MISSION" << endl;
    }
}

void DMS::record_ride(vector<string> words)
{
    if (words.size() < 5)
    {
        throw INVALID_ARGUMENTS();
    }
    string start = words[1], end = words[2], id = words[3], distance = words[4];
    if (stoi(end) < stoi(start))
    {
        throw INVALID_ARGUMENTS();
    }
    find_driver_by_id(stoi(id))->print_completed_missions(stoi(start), stoi(end), stoi(distance));
}

void DMS::show_missions_status(vector<string> words)
{
    if (words.size() < 2)
    {
        throw INVALID_ARGUMENTS();
    }
    string id = words[1];
    try
    {
        find_driver_by_id(stoi(id))->print_missions_status();
    }
    catch (const DRIVER_MISSION_NOT_FOUND)
    {
        cout << "DRIVER_MISSION_NOT_FOUND" << endl;
    }
}

template <typename mission_type>
void DMS::add_mission_command(vector<string> words)
{
    if (words.size() < 6)
    {
        throw INVALID_ARGUMENTS();
    }
    string id = words[1],
           start_time = words[2],
           end_time = words[3],
           target = words[4],
           reward = words[5];
    try
    {
        for (auto _mission : missions)
        {
            if (_mission->is_your_id(stoi(id)))
            {
                throw DUPLICATE_MISSION_ID();
            }
        }
        missions.push_back(new mission_type(stoi(id), stoi(start_time),
                                            stoi(end_time), stoi(target), stoi(reward)));
        cout << OK << endl;
    }
    catch (const DUPLICATE_MISSION_ID)
    {
        cout << "DUPLICATE_MISSION_ID" << endl;
    }
}

int main()
{
    DMS dms;
    dms.run();
    return 0;
}