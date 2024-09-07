#ifndef _SHORT_ANSWER_Problem_HPP
#define _SHORT_ANSWER_Problem_HPP
#include <vector>
using namespace std;
#include "Problem.hpp"

class ShortAnswerProblem : public Problem
{
public:
    ShortAnswerProblem(string _question, string _answer);
    virtual void submit_answer();
};
#endif