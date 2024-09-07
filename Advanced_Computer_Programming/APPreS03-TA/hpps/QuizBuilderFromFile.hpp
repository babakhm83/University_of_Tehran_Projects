#ifndef _QUIZ_BUILDER_FROM_FILE_HPP
#define _QUIZ_BUILDER_FROM_FILE_HPP
#include <fstream>
#include <sstream>
using namespace std;
#include "Quiz.hpp"
#include "QuizBuilder.hpp"
#include "MultipleAnswerProblem.hpp"
#include "ShortAnswerProblem.hpp"
#include "SingleAnswerProblem.hpp"
class QuizBuilderFromFile : public QuizBuilder
{
public:
    QuizBuilderFromFile(char *address);
    ~QuizBuilderFromFile();
    Quiz build_quiz();

private:
    virtual SingleAnswerProblem *make_single_ans_prob();
    virtual MultipleAnswerProblem *make_multiple_ans_prob();
    virtual ShortAnswerProblem *make_short_ans_prob();
    ifstream file;
};
#endif