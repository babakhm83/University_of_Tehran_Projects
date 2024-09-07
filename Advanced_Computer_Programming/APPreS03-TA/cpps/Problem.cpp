#include "../hpps/Problem.hpp"

Problem::Problem(string _question, string _answer)
    : question(_question), correct_answer(_answer)
{
}

void Problem::print_result()
{
    if (is_answered)
    {
        if (is_answered_correctly)
        {
            cout << CORRECT;
        }
        else
        {
            cout << WRONG << CORRECT_ANSWER_IS << correct_answer << YOU_ANSWER_IS << user_answer;
        }
    }
    else
    {
        cout << NO_ANSWER << CORRECT_ANSWER_IS << correct_answer;
    }
}

bool Problem::get_is_answered_correctly()
{
    return is_answered_correctly;
}