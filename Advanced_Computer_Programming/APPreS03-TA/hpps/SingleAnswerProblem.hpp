#ifndef _SINGLE_ANSWER_Problem_HPP
#define _SINGLE_ANSWER_Problem_HPP
#include <vector>
using namespace std;
#include "Problem.hpp"
class SingleAnswerProblem : public Problem
{
public:
    SingleAnswerProblem(string _question, vector<string> _choices, string _answer);
    virtual void submit_answer();

private:
    vector<string> choices;
};
#endif