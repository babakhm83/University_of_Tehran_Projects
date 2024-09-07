#include "../hpps/MultipleAnswerProblem.hpp"
MultipleAnswerProblem::MultipleAnswerProblem(string _question, vector<string> _choices, vector<int> _answers, string _str_answer)
    : Problem(_question, _str_answer), choices(_choices)
{
    is_correct = vector<bool>(_answers.size() + 1, false);
    for (int ans : _answers)
    {
        is_correct[ans] = true;
    }
}

void MultipleAnswerProblem::submit_answer()
{
    if (is_answered)
        throw ALREADY_ASSIGNED();
    string ans;
    is_answered_correctly = true;
    getline(cin, ans);
    stringstream ss(ans);
    while (ss >> ans)
    {
        try
        {
            user_answer += ans + ' ';
            if (stoi(ans) >= is_correct.size() || stoi(ans) <= 0)
            {
                throw INVALID_ANSWER();
            }
            if (!is_correct[stoi(ans)])
            {
                is_answered_correctly = false;
            }
        }
        catch (INVALID_ANSWER &e)
        {
            is_answered_correctly = false;
        }
        catch (const std::invalid_argument &e)
        {
            is_answered_correctly = false;
        }
        catch (const std::out_of_range &e)
        {
            is_answered_correctly = false;
        }
    }
    user_answer.pop_back();
    is_answered = true;
}