# School Weekly Schedule Program

This repository contains a solution for generating a school weekly schedule. The program allows users to input information about teachers, their available days, and the courses they teach, and then generates a weekly schedule accordingly.

## Directory Structure

The project follows this directory structure:

- **A3-810101408.cpp**: Implements the logic for creating and managing the weekly schedule for teachers and courses.

## Problem Description

This program generates a school weekly schedule based on the teachers' availability and the courses they are teaching. The main task is to match teachers to courses and ensure that the schedule is correctly filled based on teachers' free days and course timing.

### Key Features:

- **Input information about teachers**: Includes the teacher's name, free days, and the courses they teach.
- **Input course details**: For each course, include the name, days, and time range.
- **Automatic schedule generation**: The program automatically matches teachers to courses based on their availability.
- **Output the schedule**: The program outputs the weekly schedule with assigned teachers.

## Functions

The program contains several key functions:

- **`input_info_for_teacher`**: Collects teacher-related data, including the teacher's name, free days, and the courses they teach.
- **`convert_time_to_hour_minute`**: Converts time from a string format (e.g., "07:30") into hours and minutes.
- **`find_teachers_for_courses`**: Finds available teachers for each course.
- **`choose_teacher_for_given_course`**: Chooses the best teacher for each course considering their free days and times.
- **`find_plan_for_week`**: Generates the weekly schedule and assigns teachers to courses.

## Example

### Input:

#### Teacher Information:

        ```plaintext
        2
        Hamid 3 Saturday Monday Wednesday 2 Math Physics
        Amin 3 Saturday Sunday Monday 2 Math Science
        3
        Math Saturday Monday 07:30 10:00
        Physics Saturday Wednesday 08:00 11:00
        Science Monday Sunday 07:30 13:00

### Output:
        ```plaintext
        Math
        Hamid: 07:30 09:00
        Amin: 07:30 09:00
        Physics
        Hamid: 09:30 11:00
        Not Found
        Science
        Amin: 11:30 13:00
        Amin: 09:30 11:00

## Compilation:
To compile the program, run the following command:
        ```bash
        g++ -o schedule A3-810101408.cpp
## Running the Program:
After compilation, you can run the program using:
        ```bash
        ./schedule
