#ifndef _PROBLEM_HPP
#define _PROBLEM_HPP
#include <fstream>
#include <iostream>
using namespace std;
#include "Errors.hpp"
class Problem
{
public:
    Problem(string _question, string _answer);
    virtual void submit_answer() = 0;
    void print_result();
    bool get_is_answered_correctly();

protected:
    string question;
    bool is_answered_correctly;
    bool is_answered;
    string user_answer;
    string correct_answer;
    const string CORRECT = "correct";
    const string WRONG = "wrong";
    const string NO_ANSWER = "no_answer";
    const string CORRECT_ANSWER_IS = " | correct answer: ";
    const string YOU_ANSWER_IS = ", your answer : ";
};
#endif