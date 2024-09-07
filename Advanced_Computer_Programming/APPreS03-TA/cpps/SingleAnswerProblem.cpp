#include "../hpps/SingleAnswerProblem.hpp"

SingleAnswerProblem::SingleAnswerProblem(string _question, vector<string> _choices, string _answer)
    : Problem(_question, _answer), choices(_choices)
{
}

void SingleAnswerProblem::submit_answer()
{
    if (is_answered)
        throw ALREADY_ASSIGNED();
    getline(cin >> ws, user_answer);
    is_answered_correctly = (user_answer == correct_answer);
    is_answered = true;
}