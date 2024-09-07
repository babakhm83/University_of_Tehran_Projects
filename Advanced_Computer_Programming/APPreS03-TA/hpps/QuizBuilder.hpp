#ifndef _QUIZ_BUILDER_HPP
#define _QUIZ_BUILDER_HPP
#include "Quiz.hpp"
#include "MultipleAnswerProblem.hpp"
#include "ShortAnswerProblem.hpp"
#include "SingleAnswerProblem.hpp"
class QuizBuilder
{
protected:
    virtual SingleAnswerProblem *make_single_ans_prob() = 0;
    virtual MultipleAnswerProblem *make_multiple_ans_prob() = 0;
    virtual ShortAnswerProblem *make_short_ans_prob() = 0;
    const string SINGLE_ANSWER = "single_answer";
    const string MULTIPLE_ANSWER = "multiple_answer";
    const string SHORT_ANSWER = "short_answer";
};
#endif