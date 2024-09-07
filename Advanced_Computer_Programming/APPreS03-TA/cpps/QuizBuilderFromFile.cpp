#include "../hpps/QuizBuilderFromFile.hpp"
QuizBuilderFromFile::QuizBuilderFromFile(char *address) : file(address)
{
    if (!file.is_open())
        throw FILE_NOT_FOUND();
}
Quiz QuizBuilderFromFile::build_quiz()
{
    string type_of_question;
    vector<Problem *> problems = vector<Problem *>(1);
    while (getline(file, type_of_question))
    {
        try
        {
            if (type_of_question == SINGLE_ANSWER)
            {
                problems.push_back(make_single_ans_prob());
            }
            else if (type_of_question == MULTIPLE_ANSWER)
            {
                problems.push_back(make_multiple_ans_prob());
            }
            else if (type_of_question == SHORT_ANSWER)
            {
                problems.push_back(make_short_ans_prob());
            }
            else
            {
                throw INVALID_QUESTION_TYPE();
            }
        }
        catch (INVALID_QUESTION_TYPE &e)
        {
            cerr << e.error() << '\n';
        }
    }
    if (problems.size() == 1)
        throw EMPTY_FILE();
    return Quiz(problems);
}

QuizBuilderFromFile::~QuizBuilderFromFile()
{
    file.close();
}

SingleAnswerProblem *QuizBuilderFromFile::make_single_ans_prob()
{
    string question;
    getline(file, question);
    int choices_count;
    file >> choices_count;
    vector<string> choices;
    string temp;
    for (int i = 0; i < choices_count; i++)
    {
        getline(file >> ws, temp);
        choices.push_back(temp);
    }
    string answer;
    getline(file, answer);
    SingleAnswerProblem *problem = new SingleAnswerProblem(question, choices, answer);
    return problem;
}

MultipleAnswerProblem *QuizBuilderFromFile::make_multiple_ans_prob()
{
    string question;
    getline(file, question);
    int choices_count;
    file >> choices_count;
    vector<string> choices;
    string temp;
    for (int i = 0; i < choices_count; i++)
    {
        getline(file >> ws, temp);
        choices.push_back(temp);
    }
    vector<int> answers;
    string ans, str_ans;
    getline(file, temp);
    stringstream ss(temp);
    while (ss >> ans)
    {
        answers.push_back(stoi(ans));
        str_ans += ans + ' ';
    }
    str_ans.pop_back();
    MultipleAnswerProblem *problem = new MultipleAnswerProblem(question, choices, answers, str_ans);
    return problem;
}

ShortAnswerProblem *QuizBuilderFromFile::make_short_ans_prob()
{
    string question;
    getline(file, question);
    string answer;
    getline(file, answer);
    ShortAnswerProblem *problem = new ShortAnswerProblem(question, answer);
    return problem;
}