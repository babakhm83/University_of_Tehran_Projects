#ifndef _Quiz_HPP
#define _Quiz_HPP
#include <fstream>
#include <iostream>
#include <iomanip>
#include <vector>
using namespace std;
#include "Errors.hpp"
#include "Problem.hpp"
class Quiz
{
public:
    Quiz(vector<Problem *> _problems) : problems(_problems){};
    ~Quiz();          // no need for copy constructor or copy assignment constructor because I assumed
    void give_quiz(); // there can be just one Quiz object we can use the singleton design pattern for Quiz

private:
    void submit_answer(int question_number, string answer);
    void print_result_for(int question_number);
    void print_all_results();

private:
    vector<Problem *> problems;
    const string SUBMIT_ANSWER = "submit_answer";
    const string FINISH_EXAM = "finish_exam";
    const string CORRECT_ANSWER = "correct answer.";
    const string WRONG_ANSWER = "wrong answer.";
};
#endif