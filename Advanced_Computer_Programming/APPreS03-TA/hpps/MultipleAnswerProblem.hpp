#ifndef _MULTIPLE_ANSWER_Problem_HPP
#define _MULTIPLE_ANSWER_Problem_HPP
#include <vector>
#include <sstream>
using namespace std;
#include "Problem.hpp"

class MultipleAnswerProblem : public Problem
{
public:
    MultipleAnswerProblem(string _question, vector<string> _choices, vector<int> _answers, string _str_answer);
    virtual void submit_answer();

private:
    const vector<string> choices;
    vector<bool> is_correct;
};
#endif