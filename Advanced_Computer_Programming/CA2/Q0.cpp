#include <iostream>
using namespace std;
string to_upper(string line)
{
    if (line.size() != 1)
    {
        line.replace(1,line.size()-1,to_upper(line.substr(1, line.size())));
    }
    if (line[0] > 96 && line[0] < 123)
    {
        line[0] -= 32;
    }
    return line;
}
int main()
{
    string line;
    while (getline(cin, line))
    {
        cout << to_upper(line) << endl;
    }
    return 0;
}