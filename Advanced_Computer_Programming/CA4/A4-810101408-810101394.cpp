#include <iostream>
#include <cmath>
#include <vector>
#include <fstream>
#include <iomanip>
#include <string>
using namespace std;

// Employees salary management program
// Managing employees salary easier
// Written by Babak Hosseini Mohtasham(810101408) and Mohammad Sina Parvizi(810101394) on 1401/1/28

enum levels
{
    JUNIOR,
    EXPERT,
    SENIOR,
    TEAM_LEAD
};

const int LAST_DAY_OF_MONTH = 30;
const int FIRST_DAY_OF_MONTH = 1;
const int NUMBER_OF_LEVELS = 4;
const int NO_LEVEL = -1;
const string LEVELS[NUMBER_OF_LEVELS] = {"junior", "expert", "senior", "team_lead"};
const string REPORT_COMMANDS[] = {"report_salaries", "report_employee_salary", "report_team_salary",
                                  "report_total_hours_per_day", "report_employee_per_hour"};
const string CONFIG_COMMANDS[] = {"show_salary_config", "update_salary_config", "add_working_hours",
                                  "delete_working_hours", "update_team_bonus"};
const string BONUS_COMMANDS[] = {"find_teams_for_bonus"};
const string OK = "OK";
const string INVALID_INTERVAL = "INVALID_INTERVAL";
const string INVALID_LEVEL = "INVALID_LEVEL";
const string INVALID_ARGUMENTS = "INVALID_ARGUMENTS";
const string TEAM_NOT_FOUND = "TEAM_NOT_FOUND";
const string EMPLOYEE_NOT_FOUND = "EMPLOYEE_NOT_FOUND";
const string NO_BONUS_TEAMS = "NO_BONUS_TEAMS";
const string ID = "ID: ";
const string NAME = "Name: ";
const string AGE = "Age: ";
const string LEVEL = "Level: ";
const string TEAM_ID = "Team ID: ";
const string NOT_AVAILABLE = "N/A";
const string TOTAL_WORKING_HOURS = "Total Working Hours: ";
const string ABSENT_dAYS = "Absent Days: ";
const string SALARY = "Salary: ";
const string BONUS = "Bonus: ";
const string TAX = "Tax: ";
const string REPORT = "report";
const string HEAD_ID = "Head ID: ";
const string HEAD_NAME = "Head Name: ";
const string TEAM_TOTAL_WORKING_HOURS = "Team Total Working Hours: ";
const string AVERAGE_MEMBER_WORKING_HOURS = "Average Member Working Hours: ";
const string MEMBER_ID = "Member ID: ";
const string BASE_SALARY = "Base Salary: ";
const string SALARY_PER_HOUR = "Salary Per Hour: ";
const string SALARY_PER_EXTRA_HOUR = "Salary Per Extra Hour: ";
const string OFFICIAL_WORKING_HOURS = "Official Working Hours: ";
const string PERIODS_WITH_MAX_WORKING_EMPLOYEES = "Period(s) with Max Working Employees:";
const string PERIODS_WITH_MIN_WORKING_EMPLOYEES = "Period(s) with Min Working Employees:";
const string DAYS_WITH_MAX_WORKING_HOURS = "Day(s) with Max Working Hours:";
const string DAYS_WITH_MIN_WORKING_HOURS = "Day(s) with Min Working Hours:";
const string DAY_NUMBER = "Day #";
const string END = "---";
const string COLON = ": ";
const char HYPHEN = '-';
const char SPACE = ' ';
const char COMMA = ',';
const char DOLLAR_SIGN = '$';
const string PERCENT = "%";
const string TOTAL_EARNING = "Total Earning: ";
const string EMPLOYEES_CSV = "/employees.csv";
const string WORKING_HOURS_CSV = "/working_hours.csv";
const string SALARY_CONFIGS_CSV = "/salary_configs.csv";
const string TEAMS_CSV = "/teams.csv";

struct salary_configs
{
    int base_salary[NUMBER_OF_LEVELS];
    int salary_per_hour[NUMBER_OF_LEVELS];
    int salary_per_extra_hour[NUMBER_OF_LEVELS];
    int official_working_hours[NUMBER_OF_LEVELS];
    double tax_percentage[NUMBER_OF_LEVELS];
};

struct working_interval
{
    int day;
    vector<pair<int, int>> start_and_end_hour;
};

void end_of_command()
{
    cout << END << endl;
}

class Working_hour
{
private:
    int employee_id;
    int absent_days;
    vector<working_interval> working_intervals;
    int total_working_hours;

    int find_interval_index_by_day(int day)
    {
        for (int i = 0; i < working_intervals.size(); i++)
        {
            if (working_intervals[i].day == day)
            {
                return i;
            }
        }
        working_intervals.resize(working_intervals.size() + 1);
        working_intervals[working_intervals.size() - 1].day = day;
        return working_intervals.size() - 1;
    }

    bool is_the_interval_valid(int period_start, int period_end, int i)
    {
        for (auto hour : working_intervals[i].start_and_end_hour)
        {
            if (hour.first < period_end && hour.second > period_start)
            {
                cout << INVALID_INTERVAL;
                return false;
            }
        }
        return true;
    }

    int get_working_hours_of_day(int day_index)
    {
        int working_hours = 0;
        for (auto hour : working_intervals[day_index].start_and_end_hour)
        {
            working_hours += hour.second - hour.first;
        }
        return working_hours;
    }

public:
    void set_values(int id, int input_day, int input_start_hour, int input_end_hour)
    {
        employee_id = id;
        absent_days = 0;
        total_working_hours = 0;
        int i = find_interval_index_by_day(input_day);
        working_intervals[i].day = input_day;
        working_intervals[i].start_and_end_hour.push_back({input_start_hour, input_end_hour});
    }

    int get_id()
    {
        return employee_id;
    }

    int get_absent_days()
    {
        absent_days = LAST_DAY_OF_MONTH - working_intervals.size();
        return absent_days;
    }

    int get_days_working_in_this_period(int start_hour, int end_hour)
    {
        int days_working_in_this_period = 0;
        for (auto interval : working_intervals)
        {
            for (auto period : interval.start_and_end_hour)
            {
                if (period.first <= start_hour && period.second >= end_hour)
                {
                    days_working_in_this_period++;
                }
            }
        }
        return days_working_in_this_period;
    }

    int get_working_hours_of_period(int start_day = FIRST_DAY_OF_MONTH, int end_day = LAST_DAY_OF_MONTH)
    {
        int duration = 0;
        for (int i = 0; i < working_intervals.size(); i++)
        {
            if (working_intervals[i].day >= start_day && working_intervals[i].day <= end_day)
            {
                duration += get_working_hours_of_day(i);
            }
        }
        if (start_day == FIRST_DAY_OF_MONTH && end_day == LAST_DAY_OF_MONTH)
        {
            total_working_hours = duration;
        }
        return duration;
    }

    void add_working_hours(int day, int period_start, int period_end)
    {
        int i = find_interval_index_by_day(day);
        if (is_the_interval_valid(period_start, period_end, i))
        {
            cout << OK << endl;
            working_intervals[i].start_and_end_hour.push_back({period_start, period_end});
            get_working_hours_of_period(FIRST_DAY_OF_MONTH, LAST_DAY_OF_MONTH);
        }
    }

    void delete_working_hours(int day)
    {
        int i = find_interval_index_by_day(day);
        working_intervals.erase(working_intervals.begin() + i);
        get_working_hours_of_period();
    }
};

class Salary
{
private:
    int level;
    salary_configs *configs;
    int salary;
    double total_earning;
    double taxed_earning;
    double bonused_earning;

public:
    void set_configs(salary_configs *global_configs)
    {
        configs = global_configs;
        string level = LEVELS[0];
        salary = 0;
        total_earning = 0;
        taxed_earning = 0;
        bonused_earning = 0;
    }

    int get_tax()
    {
        return configs->tax_percentage[level];
    }

    double get_taxed_earning()
    {
        return taxed_earning;
    }

    double get_bonused_earning()
    {
        return bonused_earning;
    }

    int get_base_salary()
    {
        return configs->base_salary[level];
    }

    int get_official_working_hours()
    {
        return configs->official_working_hours[level];
    }

    int get_salary_per_extra_hour()
    {
        return configs->salary_per_extra_hour[level];
    }

    int get_salary_per_hour()
    {
        return configs->salary_per_hour[level];
    }

    int get_salary()
    {
        return salary;
    }

    double get_total_earning()
    {
        return total_earning;
    }

    void set_salary(int new_salary)
    {
        salary = new_salary;
    }

    void set_earnings(double new_total_earning, double new_taxed_earning, double new_bonused_earning)
    {
        total_earning = new_total_earning;
        taxed_earning = new_taxed_earning;
        bonused_earning = new_bonused_earning;
    }

    void set_level(int input_level)
    {
        level = input_level;
    }

    int find_level_index(string input_level)
    {
        if (input_level == LEVELS[JUNIOR])
        {
            return JUNIOR;
        }
        else if (input_level == LEVELS[EXPERT])
        {
            return EXPERT;
        }
        else if (input_level == LEVELS[SENIOR])
        {
            return SENIOR;
        }
        else if (input_level == LEVELS[TEAM_LEAD])
        {
            return TEAM_LEAD;
        }
        cout << INVALID_LEVEL << endl;
        return NO_LEVEL;
    }

    void update_salary_config(string level, int base_salary,
                              int salary_per_hour,
                              int salary_per_extra_hour,
                              int official_working_hours,
                              int tax_percentage)
    {
        int level_index = find_level_index(level);
        if (base_salary != NO_LEVEL)
        {
            configs->base_salary[level_index] = base_salary;
        }
        if (official_working_hours != NO_LEVEL)
        {
            configs->official_working_hours[level_index] = official_working_hours;
        }
        if (salary_per_extra_hour != NO_LEVEL)
        {
            configs->salary_per_extra_hour[level_index] = salary_per_extra_hour;
        }
        if (salary_per_hour != NO_LEVEL)
        {
            configs->salary_per_hour[level_index] = salary_per_hour;
        }
        if (tax_percentage != NO_LEVEL)
        {
            configs->tax_percentage[level_index] = tax_percentage;
        }
    }
};

class Team
{
private:
    int team_id;
    int team_head_id;
    vector<int> member_ids;
    double bonus;
    int bonus_min_working_hours;
    double bonus_working_hours_max_variance;

public:
    void set_values(int input_team_id, int input_team_head_id, int input_bonus_min_working_hours,
                    double input_bonus_working_hours_max_variance, vector<int> input_member_ids)
    {
        team_id = input_team_id;
        team_head_id = input_team_head_id;
        bonus_min_working_hours = input_bonus_min_working_hours;
        bonus_working_hours_max_variance = input_bonus_working_hours_max_variance;
        bonus = 0;
        member_ids = input_member_ids;
    }

    vector<int> get_member_ids()
    {
        return member_ids;
    }

    int get_id()
    {
        return team_id;
    }

    int get_head_id()
    {
        return team_head_id;
    }

    double get_bonus()
    {
        return bonus;
    }

    double get_bonus_variance()
    {
        return bonus_working_hours_max_variance;
    }

    int get_bonus_min_working_hours()
    {
        return bonus_min_working_hours;
    }

    void update_team_bonus(double new_bonus)
    {
        bonus = new_bonus;
    }

    Team *find_team_by_id(int id, vector<Team *> teams)
    {
        Team *found_team;
        for (int i = 0; i < teams.size(); i++)
        {
            if (teams[i]->get_id() == id)
            {
                return teams[i];
            }
        }
        cout << TEAM_NOT_FOUND << endl;
        return NULL;
    }
};

class Employee
{
private:
    int id;
    string name;
    int age;
    string level;
    int level_index;
    Working_hour *working_hour;
    Salary salary;
    Team *team;

public:
    void set_values(int input_id, string input_name, int input_age, string input_level,
                    salary_configs *configs)
    {
        id = input_id;
        name = input_name;
        age = input_age;
        level = input_level;
        salary.set_configs(configs);
        level_index = salary.find_level_index(level);
        salary.set_level(level_index);
        team = NULL;
    }

    void set_working_hour(Working_hour *input_working_hour)
    {
        working_hour = input_working_hour;
    }

    void set_team(Team *input_team)
    {
        team = input_team;
    }

    int get_id()
    {
        return id;
    }

    Salary get_salary()
    {
        return salary;
    }

    string get_name()
    {
        return name;
    }

    int get_working_hours_of_period(int start_day = FIRST_DAY_OF_MONTH, int end_day = LAST_DAY_OF_MONTH)
    {
        return working_hour->get_working_hours_of_period(start_day, end_day);
    }

    double get_bonus()
    {
        return team->get_bonus();
    }

    int get_level()
    {
        return level_index;
    }

    double get_total_earning()
    {
        Calculate_total_earning();
        return salary.get_total_earning();
    }

    int get_absent_days()
    {
        return working_hour->get_absent_days();
    }

    int get_days_working_in_this_period(int start_hour, int end_hour)
    {
        return working_hour->get_days_working_in_this_period(start_hour, end_hour);
    }

    vector<Employee *> sort_employees_by_id(vector<Employee *> employees)
    {
        Employee *temp_employee;
        vector<Employee *> new_employees = employees;
        for (int i = 0; i < new_employees.size(); i++)
        {
            for (int j = i + 1; j < new_employees.size(); j++)
            {
                if (new_employees[j]->get_id() < new_employees[i]->get_id())
                {
                    temp_employee = new_employees[i];
                    new_employees[i] = new_employees[j];
                    new_employees[j] = temp_employee;
                }
            }
        }
        return new_employees;
    }

    void report_employee_salary()
    {
        cout << ID << id << endl;
        cout << NAME << name << endl;
        cout << AGE << age << endl;
        cout << LEVEL << level << endl;
        cout << TEAM_ID;
        if (team != NULL)
        {
            cout << team->get_id() << endl;
        }
        else
        {
            cout << NOT_AVAILABLE << endl;
        }
        cout << TOTAL_WORKING_HOURS << working_hour->get_working_hours_of_period() << endl;
        cout << ABSENT_dAYS << get_absent_days() << endl;
        cout << SALARY << get_total_salary() << endl;
        if (team != NULL)
        {
            cout << BONUS << round(get_bonused_earning()) << endl;
        }
        else
        {
            cout << BONUS << 0 << endl;
        }
        cout << TAX << round(get_taxed_earning()) << endl;
        cout << TOTAL_EARNING << round(get_total_earning()) << endl;
    }

    double get_taxed_earning()
    {
        Calculate_total_earning();
        return salary.get_taxed_earning();
    }

    double get_bonused_earning()
    {
        Calculate_total_earning();
        return salary.get_bonused_earning();
    }

    int get_total_salary()
    {
        Calculate_salary();
        return salary.get_salary();
    }

    void Calculate_salary()
    {
        int total_salary;
        total_salary = salary.get_base_salary();
        int working_duration = working_hour->get_working_hours_of_period();
        if (working_duration <= salary.get_official_working_hours())
        {
            total_salary += salary.get_salary_per_hour() * working_duration;
        }
        else
        {
            total_salary += salary.get_salary_per_hour() * salary.get_official_working_hours();
            total_salary += salary.get_salary_per_extra_hour() *
                            (working_duration - salary.get_official_working_hours());
        }
        salary.set_salary(total_salary);
    }

    void Calculate_total_earning()
    {
        Calculate_salary();
        double total_earning = salary.get_salary();
        double taxed_earning;
        double bonused_earning;
        if (team != NULL && team->get_bonus())
        {
            bonused_earning = total_earning * team->get_bonus() / 100;
            total_earning += bonused_earning;
        }
        taxed_earning = total_earning * salary.get_tax() / 100;
        total_earning -= taxed_earning;
        salary.set_earnings(total_earning, taxed_earning, bonused_earning);
    }

    void report_employee_per_hour(int start_period, int end_period, vector<Employee *> employees)
    {
        double max_average_working_employees = 0;
        vector<int> max_average_working_employees_periods;
        double min_average_working_employees = 0;
        vector<int> min_average_working_employees_periods;
        for (int i = start_period; i < end_period; i++)
        {
            double average_working_employees = 0;
            for (auto employee : employees)
            {
                average_working_employees +=
                    employee->get_days_working_in_this_period(i, i + 1);
            }
            cout << setprecision(1);
            average_working_employees = round((double)average_working_employees * 10 / LAST_DAY_OF_MONTH) / 10;
            find_extreme_periods(max_average_working_employees, max_average_working_employees_periods,
                                 min_average_working_employees, min_average_working_employees_periods,
                                 average_working_employees, i);
            cout << i << HYPHEN << i + 1 << COLON << average_working_employees << endl;
            cout << setprecision(0);
        }
        end_of_command();
        cout << PERIODS_WITH_MAX_WORKING_EMPLOYEES;
        for (auto max_working_day : max_average_working_employees_periods)
        {
            cout << SPACE << max_working_day << HYPHEN << max_working_day + 1;
        }
        cout << endl;
        cout << PERIODS_WITH_MIN_WORKING_EMPLOYEES;
        for (auto min_working_day : min_average_working_employees_periods)
        {
            cout << SPACE << min_working_day << HYPHEN << min_working_day + 1;
        }
        cout << endl;
    }

    void find_extreme_periods(double &max_value,
                              vector<int> &max_periods,
                              double &min_value,
                              vector<int> &min_periods,
                              double value,
                              int period)
    {
        if (value >= max_value || min_periods.size() == 0)
        {
            if (value != max_value)
            {
                max_periods.clear();
            }
            max_value = value;
            max_periods.push_back(period);
        }
        if (value <= min_value || min_periods.size() == 0)
        {
            if (value != min_value)
            {
                min_periods.clear();
            }
            min_value = value;
            min_periods.push_back(period);
        }
    }

    Employee *find_employee_by_id(int id, vector<Employee *> employees)
    {
        for (int i = 0; i < employees.size(); i++)
        {
            if (employees[i]->get_id() == id)
            {
                return employees[i];
            }
        }
        cout << EMPLOYEE_NOT_FOUND << endl;
        return NULL;
    }

    void add_working_hours(int day, int period_start, int period_end)
    {
        working_hour->add_working_hours(day, period_start, period_end);
    }

    void delete_working_hours(int day)
    {
        working_hour->delete_working_hours(day);
    }
};

class Command
{
private:
    vector<Employee *> employees;
    vector<Team *> teams;
    vector<Working_hour *> working_hours;
    salary_configs *configs;
    Salary salary;

    bool are_arguments_valid(double start, double end, double min, double max, bool can_start_be_end = true)
    {
        if (start >= min && start <= max && end >= min && end <= max && end >= start)
        {
            if (can_start_be_end || (!can_start_be_end && end > start))
            {
                return true;
            }
        }
        cout << INVALID_ARGUMENTS << endl;
        return false;
    }

    void run_report_commands(string command, string input)
    {
        if (command == REPORT_COMMANDS[0])
        {
            run_report_command0();
        }
        else if (command == REPORT_COMMANDS[1])
        {
            run_report_command1(input);
        }
        else if (command == REPORT_COMMANDS[2])
        {
            run_report_command2(input);
        }
        else if (command == REPORT_COMMANDS[3])
        {
            run_report_command3(input);
        }
        else if (command == REPORT_COMMANDS[4])
        {
            run_report_command4(input);
        }
    }

    void run_report_command0()
    {
        report_salaries(employees);
    }

    void run_report_command1(string input)
    {
        Employee temp_employee;
        int employee_id = stoi(input.substr(REPORT_COMMANDS[1].size() + 1));
        Employee *found_employee = temp_employee.find_employee_by_id(employee_id, employees);
        if (found_employee != NULL)
        {
            found_employee->report_employee_salary();
        }
    }

    void run_report_command2(string input)
    {
        Team temp_team;
        int team_id = stoi(input.substr(REPORT_COMMANDS[2].size() + 1));
        Team *found_team = temp_team.find_team_by_id(team_id, teams);
        if (found_team != NULL)
        {
            report_team_salary(found_team);
        }
    }

    void run_report_command3(string input)
    {
        int start_day = stoi(input.substr(REPORT_COMMANDS[3].size() + 1));
        int space_position = input.find(SPACE, REPORT_COMMANDS[3].size() + 1);
        int end_day = stoi(input.substr(space_position + 1));
        if (are_arguments_valid(start_day, end_day, FIRST_DAY_OF_MONTH, LAST_DAY_OF_MONTH))
        {
            report_total_hours_per_day(start_day, end_day);
        }
    }

    void run_report_command4(string input)
    {
        int second_space_pos = input.find_last_of(SPACE);
        int start_hour = stoi(input.substr(REPORT_COMMANDS[4].size() + 1));
        int end_hour = stoi(input.substr(second_space_pos + 1));
        if (are_arguments_valid(start_hour, end_hour, 0, 24, false))
        {
            Employee temp_employee;
            temp_employee.report_employee_per_hour(start_hour,
                                                   end_hour, employees);
        }
    }

    void run_non_report_commands(string command, string input)
    {
        if (command == CONFIG_COMMANDS[0])
        {
            run_non_report_command0(input);
        }
        else if (command == CONFIG_COMMANDS[1])
        {
            run_non_report_command1(input);
        }
        else if (command == CONFIG_COMMANDS[2])
        {
            run_non_report_command2(input);
        }
        else if (command == CONFIG_COMMANDS[3])
        {
            run_non_report_command3(input);
        }
        else if (command == CONFIG_COMMANDS[4])
        {
            run_non_report_command4(input);
        }
        else if (command == BONUS_COMMANDS[0])
        {
            run_non_report_command5();
        }
    }

    void run_non_report_command0(string input)
    {
        int level = salary.find_level_index(input.substr(CONFIG_COMMANDS[0].size() + 1));
        if (level != NO_LEVEL)
        {
            Show_salary_config(level);
        }
    }

    void run_non_report_command1(string input)
    {
        int first_space_position = CONFIG_COMMANDS[1].size() + 1;
        int space_position = first_space_position;
        space_position = input.find(SPACE, space_position + 1);
        string string_level = input.substr(first_space_position,
                                           space_position - first_space_position);
        int level = salary.find_level_index(string_level);
        if (level != NO_LEVEL)
        {
            cout << OK << endl;
            int data[5];
            for (int i = 0; i < 5; i++)
            {
                if (input[space_position + 1] != HYPHEN)
                {
                    data[i] = stoi(input.substr(space_position + 1));
                }
                else
                {
                    data[i] = NO_LEVEL;
                }
                space_position = input.find(SPACE, space_position + 1);
            }
            salary.update_salary_config(string_level, data[0], data[1], data[2], data[3], data[4]);
        }
    }

    void run_non_report_command2(string input)
    {
        Employee temp_employee;
        int space_position = CONFIG_COMMANDS[2].size() + 1;
        int employee_id = stoi(input.substr(space_position));
        Employee *found_employee = temp_employee.find_employee_by_id(employee_id, employees);
        if (found_employee != NULL)
        {
            space_position = input.find(SPACE, space_position + 1);
            int day = stoi(input.substr(space_position));
            if (are_arguments_valid(FIRST_DAY_OF_MONTH, day, FIRST_DAY_OF_MONTH, LAST_DAY_OF_MONTH))
            {
                space_position = input.find(SPACE, space_position + 1);
                int period_start = stoi(input.substr(space_position));
                space_position = input.find(SPACE, space_position + 1);
                int period_end = stoi(input.substr(space_position));
                if (are_arguments_valid(period_start, period_end, 0, 24, false))
                {
                    found_employee->add_working_hours(day, period_start, period_end);
                }
            }
        }
    }

    void run_non_report_command3(string input)
    {
        Employee temp_employee;
        int space_position = CONFIG_COMMANDS[3].size() + 1;
        int employee_id = stoi(input.substr(space_position));
        Employee *found_employee = temp_employee.find_employee_by_id(employee_id, employees);
        if (found_employee != NULL)
        {
            space_position = input.find(SPACE, space_position + 1);
            int day = stoi(input.substr(space_position));
            if (are_arguments_valid(FIRST_DAY_OF_MONTH, day, FIRST_DAY_OF_MONTH, LAST_DAY_OF_MONTH))
            {
                cout << OK << endl;
                found_employee->delete_working_hours(day);
            }
        }
    }

    void run_non_report_command4(string input)
    {
        Team temp_team;
        int team_id = stoi(input.substr(CONFIG_COMMANDS[4].size() + 1));
        Team *found_team = temp_team.find_team_by_id(team_id, teams);
        if (found_team != NULL)
        {
            int space_position = input.find(SPACE, CONFIG_COMMANDS[4].size() + 1);
            double bonus_percentage = stod(input.substr(space_position + 1));
            if (are_arguments_valid(0, bonus_percentage, 0, 100))
            {
                cout << OK << endl;
                found_team->update_team_bonus(bonus_percentage);
            }
        }
    }

    void run_non_report_command5()
    {
        find_teams_for_bonus();
    }

    void Show_salary_config(int level)
    {
        cout << BASE_SALARY << configs->base_salary[level] << endl;
        cout << SALARY_PER_HOUR << configs->salary_per_hour[level] << endl;
        cout << SALARY_PER_EXTRA_HOUR << configs->salary_per_extra_hour[level] << endl;
        cout << OFFICIAL_WORKING_HOURS << configs->official_working_hours[level] << endl;
        cout << TAX << configs->tax_percentage[level] << PERCENT << endl;
    }

    void report_team_salary(Team *team)
    {
        Employee temp_employee;
        vector<Employee *> team_employees;
        vector<int> member_ids = team->get_member_ids();
        for (auto id : member_ids)
        {
            team_employees.push_back(temp_employee.find_employee_by_id(id, employees));
        }
        cout << ID << team->get_id() << endl;
        cout << HEAD_ID << team->get_head_id() << endl;
        cout << HEAD_NAME
             << temp_employee.find_employee_by_id(team->get_head_id(), team_employees)->get_name() << endl;
        int team_total_working_hours =
            get_sum_of_working_duration_of_team(team);
        cout << TEAM_TOTAL_WORKING_HOURS << team_total_working_hours << endl;
        double average_member_working_hours =
            round((double)team_total_working_hours * 10 / team_employees.size()) / 10;
        cout << setprecision(1);
        cout << AVERAGE_MEMBER_WORKING_HOURS << average_member_working_hours << endl;
        cout << setprecision(0);
        cout << BONUS << team->get_bonus() << endl;
        end_of_command();
        vector<Employee *> sorted_employees = temp_employee.sort_employees_by_id(team_employees);
        for (int i = 0; i < sorted_employees.size(); i++)
        {
            cout << MEMBER_ID << sorted_employees[i]->get_id() << endl;
            cout << TOTAL_EARNING << round(sorted_employees[i]->get_total_earning()) << endl;
            end_of_command();
        }
    }

    void report_total_hours_per_day(int start_day, int end_day)
    {
        double max_working_hours = 0;
        vector<int> max_working_hours_days;
        double min_working_hours;
        vector<int> min_working_hours_days;
        for (int i = start_day; i <= end_day; i++)
        {
            int total_working_hours = 0;
            for (auto employee : employees)
            {
                total_working_hours += employee->get_working_hours_of_period(i, i);
            }
            cout << DAY_NUMBER << i << COLON << total_working_hours << endl;
            Employee *temp_employee;
            temp_employee->find_extreme_periods(max_working_hours, max_working_hours_days,
                                                min_working_hours, min_working_hours_days,
                                                total_working_hours, i);
        }
        end_of_command();
        cout << DAYS_WITH_MAX_WORKING_HOURS;
        for (auto max_working_day : max_working_hours_days)
        {
            cout << SPACE << max_working_day;
        }
        cout << endl
             << DAYS_WITH_MIN_WORKING_HOURS;
        for (auto min_working_day : min_working_hours_days)
        {
            cout << SPACE << min_working_day;
        }
        cout << endl;
    }

    void report_salaries(vector<Employee *> employees)
    {
        Employee temp_employee;
        vector<Employee *> sorted_employees =
            temp_employee.sort_employees_by_id(employees);
        for (int i = 0; i < sorted_employees.size(); i++)
        {
            cout << ID << sorted_employees[i]->get_id() << endl;
            cout << NAME << sorted_employees[i]->get_name() << endl;
            cout << TOTAL_WORKING_HOURS << sorted_employees[i]->get_working_hours_of_period() << endl;
            cout << TOTAL_EARNING << round(sorted_employees[i]->get_total_earning()) << endl;
            end_of_command();
        }
    }

    void find_teams_for_bonus()
    {
        vector<int> bonus_ids;
        vector<Team *> sorted_teams;
        sorted_teams = sort_teams_by_total_working_hours();
        for (int i = 0; i < sorted_teams.size(); i++)
        {
            vector<Employee *> team_employees = find_employees_of_team(sorted_teams[i]);
            if (get_employees_variance(team_employees) >= sorted_teams[i]->get_bonus_variance())
            {
                continue;
            }
            int sum_of_Working_duration =
                get_sum_of_working_duration_of_team(sorted_teams[i]);
            if (sum_of_Working_duration > sorted_teams[i]->get_bonus_min_working_hours())
            {
                bonus_ids.push_back(sorted_teams[i]->get_id());
            }
        }
        print_bonus_teams(bonus_ids);
    }

    vector<Team *> sort_teams_by_total_working_hours()
    {
        Team *temp_team;
        vector<Team *> new_teams = teams;
        for (int i = 0; i < new_teams.size(); i++)
        {
            for (int j = i + 1; j < new_teams.size(); j++)
            {
                int teamj_sum_of_working_duration =
                    get_sum_of_working_duration_of_team(new_teams[j]);
                int teami_sum_of_working_duration =
                    get_sum_of_working_duration_of_team(new_teams[i]);
                if (teamj_sum_of_working_duration < teami_sum_of_working_duration)
                {
                    temp_team = new_teams[i];
                    new_teams[i] = new_teams[j];
                    new_teams[j] = temp_team;
                }
                else if (teamj_sum_of_working_duration == teami_sum_of_working_duration)
                {
                    if (new_teams[i]->get_id() > new_teams[j]->get_id())
                    {
                        temp_team = new_teams[i];
                        new_teams[i] = new_teams[j];
                        new_teams[j] = temp_team;
                    }
                }
            }
        }
        return new_teams;
    }

    vector<Employee *> find_employees_of_team(Team *team)
    {
        Employee temp_employee;
        vector<Employee *> team_employees;
        vector<int> member_ids = team->get_member_ids();
        for (auto id : member_ids)
        {
            team_employees.push_back(temp_employee.find_employee_by_id(id, employees));
        }
        return team_employees;
    }

    double get_employees_variance(vector<Employee *> team_employees)
    {
        vector<int> employees_working_duration = get_list_employees_working_duration(team_employees);
        double average_working_duration = (double)get_sum_of_working_durations(employees_working_duration) /
                                          team_employees.size();
        double result;
        for (auto duration : employees_working_duration)
        {
            double temp_result = duration - average_working_duration;
            result += temp_result * temp_result;
        }
        return result / team_employees.size();
    }

    vector<int> get_list_employees_working_duration(vector<Employee *> team_employees)
    {
        vector<int> employees_working_duration;
        for (auto employee : team_employees)
        {
            employees_working_duration.push_back(employee->get_working_hours_of_period());
        }
        return employees_working_duration;
    }

    int get_sum_of_working_duration_of_team(Team *team)
    {
        return get_sum_of_working_durations(get_list_employees_working_duration(
            find_employees_of_team(team)));
    }

    int get_sum_of_working_durations(vector<int> employees_working_duration)
    {
        int sum = 0;
        for (auto duration : employees_working_duration)
        {
            sum += duration;
        }
        return sum;
    }

    void print_bonus_teams(vector<int> bonus_teams_ids)
    {
        if (bonus_teams_ids.size() == 0)
        {
            cout << NO_BONUS_TEAMS << endl;
            return;
        }
        for (auto id : bonus_teams_ids)
        {
            cout << TEAM_ID << id << endl;
        }
    }

public:
    void set_values(vector<Employee *> input_employees,
                    vector<Team *> input_teams,
                    vector<Working_hour *> input_working_hours,
                    salary_configs *input_confgis)
    {
        employees = input_employees;
        teams = input_teams;
        working_hours = input_working_hours;
        configs = input_confgis;
        salary.set_configs(configs);
    }

    void run()
    {
        string input;
        while (getline(cin, input))
        {
            string command = input.substr(0, input.find(SPACE));
            if (input.substr(0, 6) == REPORT)
            {
                run_report_commands(command, input);
            }
            else
            {
                run_non_report_commands(command, input);
            }
        }
    }
};

vector<string> split_line(string line)
{
    int i = 0;
    vector<string> words;
    while (i < line.size())
    {
        words.resize(words.size() + 1);
        while (line[i] != COMMA && line[i] != DOLLAR_SIGN && line[i] != HYPHEN &&
               i < line.size())
        {
            words[words.size() - 1] += line[i];
            i++;
        }
        i++;
    }
    return words;
}

vector<Employee *> input_employees(int argc, char const *argv[], salary_configs *configs)
{
    vector<Employee *> employees;
    string file_address = argv[1];
    file_address.append(EMPLOYEES_CSV);
    ifstream file_employees(file_address);
    string line;
    vector<string> words;
    getline(file_employees, line);
    while (getline(file_employees, line))
    {
        words = split_line(line);
        employees.resize(employees.size() + 1);
        employees[employees.size() - 1] = new Employee;
        employees[employees.size() - 1]->set_values(stoi(words[0]), words[1],
                                                    stoi(words[2]), words[3], configs);
    }
    file_employees.close();
    return employees;
}

vector<Working_hour *> input_working_hours(int argc, char const *argv[], vector<Employee *> employees)
{
    vector<Working_hour *> working_hour_input;
    string file_address = argv[1];
    file_address.append(WORKING_HOURS_CSV);
    ifstream file_working_hours(file_address);
    string line;
    vector<string> words;
    getline(file_working_hours, line);
    while (getline(file_working_hours, line))
    {
        words = split_line(line);
        int j;
        for (j = 0; j < working_hour_input.size(); j++)
        {
            if (working_hour_input[j]->get_id() == stoi(words[0]))
            {
                break;
            }
        }
        if (j == working_hour_input.size())
        {
            working_hour_input.resize(working_hour_input.size() + 1);
            working_hour_input[working_hour_input.size() - 1] = new Working_hour;
            Employee temp_employee;
            temp_employee.find_employee_by_id(stoi(words[0]), employees)
                ->set_working_hour(working_hour_input[j]);
        }
        working_hour_input[j]->set_values(stoi(words[0]), stoi(words[1]), stoi(words[2]), stoi(words[3]));
    }
    file_working_hours.close();
    return working_hour_input;
}

void input_salary_configs(int argc, char const *argv[], Salary salary)
{
    string file_address = argv[1];
    file_address.append(SALARY_CONFIGS_CSV);
    ifstream file_salary_configs(file_address);
    string line;
    vector<string> words;
    getline(file_salary_configs, line);
    while (getline(file_salary_configs, line))
    {
        words = split_line(line);
        salary.update_salary_config(
            words[0], stoi(words[1]), stoi(words[2]), stoi(words[3]), stoi(words[4]), stoi(words[5]));
    }
    file_salary_configs.close();
    return;
}

vector<Team *> input_team(int argc, char const *argv[], vector<Employee *> all_employees)
{
    vector<Team *> teams;
    vector<int> member_ids;
    Employee employee;
    vector<Employee *> team_employees;
    string file_address = argv[1];
    file_address.append(TEAMS_CSV);
    ifstream file_teams(file_address);
    string line;
    vector<string> words;
    getline(file_teams, line);
    while (getline(file_teams, line))
    {
        words = split_line(line);
        teams.resize(teams.size() + 1);
        teams[teams.size() - 1] = new Team;
        vector<int> member_ids;
        for (int i = 0; i < words.size() - 4; i++)
        {
            member_ids.push_back(stoi(words[i + 2]));
        }
        for (auto id : member_ids)
        {
            team_employees.push_back(employee.find_employee_by_id(id, all_employees));
            team_employees[team_employees.size() - 1]->set_team(teams[teams.size() - 1]);
        }
        teams[teams.size() - 1]->set_values(stoi(words[0]), stoi(words[1]), stoi(words[words.size() - 2]),
                                            stod(words[words.size() - 1]), member_ids);
    }
    file_teams.close();
    return teams;
}

void input(salary_configs *configs, vector<Employee *> &employees,
           vector<Working_hour *> &working_hours,
           vector<Team *> &teams, Command &command, int argc, char const *argv[])
{
    configs = new salary_configs;
    employees = input_employees(argc, argv, configs);
    working_hours = input_working_hours(argc, argv, employees);
    teams = input_team(argc, argv, employees);
    input_salary_configs(argc, argv, employees[0]->get_salary());
    command.set_values(employees, teams, working_hours, configs);
}

int main(int argc, char const *argv[])
{
    cout << fixed;
    cout << setprecision(0);
    salary_configs *configs;
    vector<Employee *> employees;
    vector<Working_hour *> working_hours;
    vector<Team *> teams;
    Command command;
    input(configs, employees, working_hours, teams, command, argc, argv);
    command.run();
    return 0;
}
