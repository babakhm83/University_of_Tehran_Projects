#include "../hpps/Quiz.hpp"
void Quiz::give_quiz()
{
    string command;
    cin >> command;
    int number_of_answered_problems = problems.size() - 1;
    while (command != FINISH_EXAM)
    {
        try
        {
            if (command != SUBMIT_ANSWER)
                throw INVALID_COMMAND();
            int question_number;
            cin >> question_number;
            problems[question_number]->submit_answer();
            print_result_for(question_number);
            if (!(--number_of_answered_problems))
                break;
            cin >> command;
        }
        catch (INVALID_COMMAND &e)
        {
            cerr << e.error() << '\n';
            getline(cin, command);
            cin >> command;
        }
        catch (ALREADY_ASSIGNED &e)
        {
            cerr << e.error() << '\n';
            getline(cin, command);
            cin >> command;
        }
    }
    print_all_results();
}

Quiz::~Quiz()
{
    for (auto &i : problems)
    {
        delete i;
    }
}

void Quiz::print_result_for(int question_number)
{
    if (problems[question_number]->get_is_answered_correctly())
    {
        cout << CORRECT_ANSWER << "\n";
    }
    else
    {
        cout << WRONG_ANSWER << "\n";
    }
}

void Quiz::print_all_results()
{
    float result = 0;
    for (int i = 1; i <= problems.size() - 1; i++)
    {
        cout << i << ' ';
        problems[i]->print_result();
        cout << "\n";
        if (problems[i]->get_is_answered_correctly())
        {
            result += 1;
        }
    }
    result *= 100 / (problems.size() - 1);
    result = (int)(result * 10) / 10.0;
    cout << "final grade:" << fixed << setprecision(1) << result;
}