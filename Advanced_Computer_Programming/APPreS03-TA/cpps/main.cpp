#include "../hpps/QuizBuilderFromFile.hpp"
#include "../hpps/Quiz.hpp"
#include "../hpps/Errors.hpp"

// Project for becoming TA of AP
// A system that can read questions from file and give a quiz to user
// Written by Babak Hosseini Mohtasham(810101408) on 1402/11/27

int main(int argc, char **argv)
{
    try
    {
        QuizBuilderFromFile builder(argv[1]);
        Quiz quiz = builder.build_quiz();
        quiz.give_quiz();
    }
    catch (EMPTY_FILE &e)
    {
        cerr << e.error() << '\n';
    }
    catch (FILE_NOT_FOUND &e)
    {
        cerr << e.error() << '\n';
    }
}