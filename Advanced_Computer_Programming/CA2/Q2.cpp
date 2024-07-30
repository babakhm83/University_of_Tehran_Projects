#include <iostream>
#include <vector>
using namespace std;
void simon(vector<int> lines, int &number, int i)
{
    if (i == 0)
    {
        return;
    }
    if (lines[i] == i + 1)
    {
        simon(lines, number, i - 1);
        return;
    }
    lines[i]++;
    if (i == lines.size() - 1)
    {
        number++;
    }
    else
    {
        lines[i + 1] = lines[i]-1;
        i++;
    }
    simon(lines, number, i);
    return;
}
int main()
{
    int n = 0, number = 1;
    cin >> n;
    vector<int> lines(n, 1);
    simon(lines, number, n - 1);
    cout << number;
    return 0;
}