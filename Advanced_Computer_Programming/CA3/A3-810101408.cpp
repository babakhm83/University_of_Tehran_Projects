#include <iostream>
#include <vector>
#include <algorithm>
using namespace std;

/*
School weekly schedule program
writing a weekly schedule based on an algorithm for a school
written by Babak Hosseini Mohtasham (810101408) on 27/12/1401
*/

#define NUMBER_OF_CLASSES 2
#define NUMBER_OF_PERIODS 3
#define SCHOOL_START_HOUR 7
#define SCHOOL_START_MINUTE 30
#define NUMBER_OF_DAYS_SCHOOL_IS_OPEN 5
#define NUMBER_OF_DAYS_EACH_COURSE_IS_TAUGHT 2

struct Teacher_struct
{
    string teacher_name;
    int number_of_free_days;
    vector<string> free_days;
    bool free_days_bool[NUMBER_OF_DAYS_SCHOOL_IS_OPEN];
    vector<vector<int>> teaching_periods;
    int number_of_courses;
    vector<string> courses_names;
};

struct Course_struct
{
    string course_name;
    string day_str[NUMBER_OF_DAYS_EACH_COURSE_IS_TAUGHT];
    int day_int[NUMBER_OF_DAYS_EACH_COURSE_IS_TAUGHT];
    string start_time;
    string end_time;
    int start_hour;
    int start_minute;
    int end_hour;
    int end_minute;
    int class_period[NUMBER_OF_CLASSES] = {0};
    vector<Teacher_struct *> teachers_of_this_course;
    Teacher_struct *chosen_teacher_class[NUMBER_OF_CLASSES];
};

int convert_string_day_to_int(string day_string)
{
    if (day_string == "Saturday")
    {
        return 0;
    }
    else if (day_string == "Sunday")
    {
        return 1;
    }
    else if (day_string == "Monday")
    {
        return 2;
    }
    else if (day_string == "Tuesday")
    {
        return 3;
    }
    else if (day_string == "Wednesday")
    {
        return 4;
    }
    return -1;
}

void input_info_for_teacher(int &number_of_info, vector<string> &info)
{
    string temp_info;
    cin >> number_of_info;
    for (int i = 0; i < number_of_info; i++)
    {
        cin >> temp_info;
        info.push_back(temp_info);
    }
}

vector<Teacher_struct> input_teachers(vector<Teacher_struct> teachers)
{
    int number_of_teachers = 0;
    cin >> number_of_teachers;
    for (int i = 0; i < number_of_teachers; i++)
    {
        teachers.resize(teachers.size() + 1);
        cin >> teachers[i].teacher_name;
        input_info_for_teacher(teachers[i].number_of_free_days, teachers[i].free_days);
        input_info_for_teacher(teachers[i].number_of_courses, teachers[i].courses_names);
        for (int j = 0; j < teachers[i].number_of_free_days; j++)
        {
            teachers[i].free_days_bool[j] = false;
        }
        for (int j = 0; j < teachers[i].number_of_free_days; j++)
        {
            teachers[i].free_days_bool[convert_string_day_to_int(teachers[i].free_days[j])] = true;
        }
    }
    return teachers;
}

Course_struct convert_time_to_hour_minute(Course_struct course)
{
    course.start_hour = stoi(course.start_time.substr(0, 2));
    course.start_minute = stoi(course.start_time.substr(3, 2));
    course.end_hour = stoi(course.end_time.substr(0, 2));
    course.end_minute = stoi(course.end_time.substr(3, 2));
    return course;
}

vector<Course_struct> input_courses(vector<Course_struct> courses)
{
    int number_of_courses = 0;
    cin >> number_of_courses;
    for (int i = 0; i < number_of_courses; i++)
    {
        courses.resize(courses.size() + 1);
        cin >> courses[i].course_name;
        for (int j = 0; j < NUMBER_OF_DAYS_EACH_COURSE_IS_TAUGHT; j++)
        {
            cin >> courses[i].day_str[j];
            courses[i].day_int[j] = convert_string_day_to_int(courses[i].day_str[j]);
            courses[i].class_period[j] = -1;
        }
        cin >> courses[i].start_time;
        cin >> courses[i].end_time;
        courses[i] = convert_time_to_hour_minute(courses[i]);
    }
    return courses;
}

void input(vector<Teacher_struct> &teachers,
           vector<Course_struct> &courses)
{
    teachers = input_teachers(teachers);
    courses = input_courses(courses);
}

void output_teacher(Course_struct course, int i)
{
    cout << course.chosen_teacher_class[i]->teacher_name << ": ";
    if ((course.class_period[i]) * 2 + SCHOOL_START_HOUR < 10)
    {
        cout << 0;
    }
    cout << (course.class_period[i]) * 2 + SCHOOL_START_HOUR << ":30 ";
    if ((course.class_period[i]) * 2 + SCHOOL_START_HOUR + 2 < 10)
    {
        cout << 0;
    }
    cout << (course.class_period[i]) * 2 + SCHOOL_START_HOUR + 2 << ":00" << endl;
}

void sort_courses_by_name(vector<Course_struct> &courses)
{
    Course_struct temp_course_for_sorting;
    bool is_sorting_done = false;
    while (!is_sorting_done)
    {
        is_sorting_done = true;
        for (int i = 1; i < courses.size(); i++)
        {
            if (courses[i].course_name < courses[i - 1].course_name)
            {
                temp_course_for_sorting = courses[i - 1];
                courses[i - 1] = courses[i];
                courses[i] = temp_course_for_sorting;
                is_sorting_done = false;
            }
        }
    }
    return;
}

vector<Teacher_struct *> sort_teachers_by_name(vector<Teacher_struct *> teachers)
{
    Teacher_struct *temp_teacher_for_sorting;
    bool is_sorting_done = false;
    while (!is_sorting_done)
    {
        is_sorting_done = true;
        for (int i = 1; i < teachers.size(); i++)
        {
            if (teachers[i]->teacher_name < teachers[i - 1]->teacher_name)
            {
                temp_teacher_for_sorting = teachers[i - 1];
                teachers[i - 1] = teachers[i];
                teachers[i] = temp_teacher_for_sorting;
                is_sorting_done = false;
            }
        }
    }
    return teachers;
}

void output(vector<Course_struct> courses)
{
    for (int i = 0; i < courses.size(); i++)
    {
        cout << courses[i].course_name << endl;
        for (int j = 0; j < NUMBER_OF_CLASSES; j++)
        {
            if (courses[i].class_period[j] + 1)
            {
                output_teacher(courses[i], j);
            }
            else
            {
                cout << "Not Found" << endl;
            }
        }
    }
}

bool are_days_of_course_and_teacher_same(Teacher_struct teacher, Course_struct course)
{
    for (int i = 0; i < NUMBER_OF_DAYS_EACH_COURSE_IS_TAUGHT; i++)
    {
        if (!teacher.free_days_bool[course.day_int[i]])
        {
            return false;
        }
    }
    return true;
}

void find_teachers_for_courses(vector<Teacher_struct> &teachers,
                               vector<Course_struct> &courses)
{
    for (int i = 0; i < courses.size(); i++)
    {
        for (int j = 0; j < teachers.size(); j++)
        {
            for (int k = 0; k < teachers[j].courses_names.size(); k++)
            {
                if (teachers[j].courses_names[k] == courses[i].course_name &&
                    are_days_of_course_and_teacher_same(teachers[j], courses[i]))
                {
                    courses[i].teachers_of_this_course.push_back(&teachers[j]);
                }
            }
        }
    }
}

bool is_this_teacher_free_in_given_period(Teacher_struct teacher,
                                          int days[NUMBER_OF_DAYS_EACH_COURSE_IS_TAUGHT],
                                          int period)
{
    for (auto teaching_period : teacher.teaching_periods)
    {
        for (int i = 0; i < NUMBER_OF_DAYS_EACH_COURSE_IS_TAUGHT; i++)
        {
            if (teaching_period[0] == days[i] && teaching_period[1] == period)
            {
                return false;
            }
        }
    }
    return true;
}

int find_min_number_of_free_days(Course_struct course, int period)
{
    int min_free_days = NUMBER_OF_DAYS_SCHOOL_IS_OPEN;
    bool is_any_teacher_free = false;
    for (auto teacher : course.teachers_of_this_course)
    {
        if (min_free_days >= teacher->number_of_free_days &&
            is_this_teacher_free_in_given_period(*teacher, course.day_int, period) &&
            teacher->number_of_free_days >= NUMBER_OF_DAYS_EACH_COURSE_IS_TAUGHT)
        {

            min_free_days = teacher->number_of_free_days;
            is_any_teacher_free = true;
        }
    }
    if (is_any_teacher_free)
    {
        return min_free_days;
    }
    return -1;
}

Teacher_struct *find_teacher_with_given_free_days(vector<Teacher_struct *> teachers,
                                                  int min_free_days,
                                                  int day_int[NUMBER_OF_DAYS_EACH_COURSE_IS_TAUGHT],
                                                  int period)
{
    if (min_free_days == -1)
    {
        return NULL;
    }
    for (int i = 0; i < teachers.size(); i++)
    {
        if (min_free_days == teachers[i]->number_of_free_days &&
            is_this_teacher_free_in_given_period(*teachers[i],
                                                 day_int, period))
        {
            return teachers[i];
        }
    }
    return NULL;
}

Teacher_struct *choose_teacher_for_given_course(Course_struct &course, int period)
{
    return find_teacher_with_given_free_days(sort_teachers_by_name(course.teachers_of_this_course),
                                             find_min_number_of_free_days(course, period),
                                             course.day_int,
                                             period);
}

bool is_hour_eligible(Course_struct course, int i)
{
    return (course.start_hour < 2 * i + SCHOOL_START_HOUR ||
            (course.start_hour == 2 * i + SCHOOL_START_HOUR &&
             course.start_minute <= SCHOOL_START_MINUTE)) &&
           (course.end_hour > 2 * i + SCHOOL_START_HOUR + 2 ||
            (course.end_hour == 2 * i + SCHOOL_START_HOUR + 2 &&
             course.end_minute >= 0));
}

bool is_any_day_for_this_course_full(Course_struct *courses_in_week_for_this_class
                                         [NUMBER_OF_DAYS_SCHOOL_IS_OPEN]
                                         [NUMBER_OF_PERIODS],
                                     int day_int
                                         [NUMBER_OF_DAYS_EACH_COURSE_IS_TAUGHT],
                                     int period)
{
    for (int i = 0; i < NUMBER_OF_DAYS_EACH_COURSE_IS_TAUGHT; i++)
    {
        if (courses_in_week_for_this_class[day_int[i]][period]->start_hour != -1)
        {
            return true;
        }
    }
    return false;
}

vector<Course_struct *> find_courses_eligible_for_this_time(vector<Course_struct> &courses,
                                                            Course_struct *courses_in_week
                                                                [NUMBER_OF_DAYS_SCHOOL_IS_OPEN]
                                                                [NUMBER_OF_PERIODS],
                                                            int school_class, int day, int period)
{
    vector<Course_struct *> courses_in_this_time;
    for (int m = 0; m < courses.size(); m++)
    {
        for (int day_index1 = 0; day_index1 < NUMBER_OF_DAYS_EACH_COURSE_IS_TAUGHT; day_index1++)
        {
            if ((courses[m].day_int[day_index1] == day) &&
                courses[m].class_period[school_class] == -1 &&
                is_hour_eligible(courses[m], period))
            {
                if (!is_any_day_for_this_course_full(courses_in_week,
                                                     courses[m].day_int,
                                                     period))
                {
                    courses_in_this_time.push_back(&courses[m]);
                }
            }
        }
    }
    return courses_in_this_time;
}

int find_the_eligible_course(vector<Course_struct *> &courses_in_this_time,
                             int period, int school_class)
{
    Teacher_struct *temp_chosen_teacher;
    for (int i = 0; i < courses_in_this_time.size(); i++)
    {
        temp_chosen_teacher = choose_teacher_for_given_course(*courses_in_this_time[i], period);
        if (temp_chosen_teacher != NULL)
        {
            courses_in_this_time[i]->chosen_teacher_class[school_class] = temp_chosen_teacher;
            return i;
        }
    }
    return -1;
}

void choose_the_eligible_course(vector<Course_struct *> &courses_in_this_time,
                                Course_struct *courses_in_week
                                    [NUMBER_OF_CLASSES]
                                    [NUMBER_OF_DAYS_SCHOOL_IS_OPEN]
                                    [NUMBER_OF_PERIODS],
                                int course_index, int period, int school_class)
{
    vector<int> temp_periods(NUMBER_OF_DAYS_EACH_COURSE_IS_TAUGHT);
    if (course_index + 1)
    {
        for (int num = 0; num < NUMBER_OF_DAYS_EACH_COURSE_IS_TAUGHT; num++)
        {
            temp_periods[0] = courses_in_this_time[course_index]->day_int[num];
            temp_periods[1] = period;
            courses_in_this_time[course_index]
                ->chosen_teacher_class[school_class]
                ->teaching_periods.push_back(temp_periods);
            courses_in_week[school_class][courses_in_this_time[course_index]->day_int[num]][period] =
                courses_in_this_time[course_index];
        }
        courses_in_this_time[course_index]->class_period[school_class] = period;
    }
    courses_in_this_time.clear();
}

void find_plan_for_week(vector<Course_struct> &courses,
                        Course_struct *courses_in_week
                            [NUMBER_OF_CLASSES]
                            [NUMBER_OF_DAYS_SCHOOL_IS_OPEN]
                            [NUMBER_OF_PERIODS])
{
    vector<Course_struct *> courses_in_this_time;
    sort_courses_by_name(courses);
    for (int school_class = 0; school_class < NUMBER_OF_CLASSES; school_class++)
    {
        for (int day = 0; day < NUMBER_OF_DAYS_SCHOOL_IS_OPEN; day++)
        {
            for (int period = 0; period < NUMBER_OF_PERIODS; period++)
            {
                if (courses_in_week[school_class][day][period]->start_hour != -1)
                {
                    continue;
                }
                courses_in_this_time = find_courses_eligible_for_this_time(courses,
                                                                           courses_in_week
                                                                               [school_class],
                                                                           school_class, day, period);
                if (courses_in_this_time.size() == 0)
                {
                    continue;
                }
                choose_the_eligible_course(courses_in_this_time, courses_in_week,
                                           find_the_eligible_course(courses_in_this_time,
                                                                    period, school_class),
                                           period, school_class);
            }
        }
    }
}

void solve(vector<Teacher_struct> &teachers,
           vector<Course_struct> &courses,
           Course_struct *courses_in_week[NUMBER_OF_CLASSES]
                                         [NUMBER_OF_DAYS_SCHOOL_IS_OPEN]
                                         [NUMBER_OF_PERIODS])
{
    find_teachers_for_courses(teachers, courses);
    find_plan_for_week(courses, courses_in_week);
}

int main()
{
    vector<Teacher_struct> teachers;
    vector<Course_struct> courses;
    Course_struct null_course;
    null_course.start_hour = -1;
    Course_struct *courses_in_week
        [NUMBER_OF_CLASSES]
        [NUMBER_OF_DAYS_SCHOOL_IS_OPEN]
        [NUMBER_OF_PERIODS];
    for (int i = 0; i < NUMBER_OF_CLASSES; i++)
    {
        for (int j = 0; j < NUMBER_OF_DAYS_SCHOOL_IS_OPEN; j++)
        {
            for (int k = 0; k < NUMBER_OF_PERIODS; k++)
            {
                courses_in_week[i][j][k] = &null_course;
            }
        }
    }
    input(teachers, courses);
    solve(teachers, courses, courses_in_week);
    output(courses);
    return 0;
}