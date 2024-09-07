#include "../hpps/ShortAnswerProblem.hpp"

ShortAnswerProblem::ShortAnswerProblem(string _question, string _answer)
    : Problem(_question, _answer)
{
}

void ShortAnswerProblem::submit_answer()
{
    if (is_answered)
        throw ALREADY_ASSIGNED();
    getline(cin >> ws, user_answer);
    is_answered_correctly = (user_answer == correct_answer);
    is_answered = true;
}