#include <iostream>
#include <vector>
using namespace std;
int print_vector(vector<int> numbers, vector<int> &results, bool max = 1, int j = 0, int previous_number = 0)
{
    if (numbers[0] == 0)
    {
        results.push_back(0);
        return 0;
    }
    if (j >= numbers.size())
    {
        return 1;
    }
    results.push_back(numbers[j]);
    int this_number = numbers[j];
    if (max)
    {
        if (numbers[j] > previous_number)
        {
            j += numbers[j];
            /* if (numbers[j] == 0)
            {
                return 0;
            } */
        }
        else
        {
            j += previous_number;
            if (previous_number == 0)
            {
                return 0;
            }
        }
    }
    else
    {
        if (numbers[j] < previous_number)
        {
            j += numbers[j];
        }
        else
        {
            j += previous_number;
        }
    }
    print_vector(numbers, results, !max, j, this_number);
    return 1;
}
int main()
{
    int number_of_terms = 0, temp = 0;
    vector<int> numbers, results;
    cin >> number_of_terms;
    for (int i = 0; i < number_of_terms; i++)
    {
        cin >> temp;
        numbers.push_back(temp);
    }
    print_vector(numbers, results, 1, 0, 0);
    for (int i = 0; i < results.size(); i++)
    {
        cout << results[i] << " ";
    }
    return 0;
}