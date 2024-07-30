#include <iostream>
#include <vector>
using namespace std;
vector<int> extract_Ns(string board)
{
    vector<int> Ns_positions;
    for (int i = 0; i < 49; i++)
    {
        if (board[i] == 'N')
        {
            Ns_positions.push_back(i);
        }
    }
    return Ns_positions;
}
string move_to_string(int i, int j)
{
    string move = "a1 ";
    move[0] = 65 + (i / 7);
    move[1] = 49 + (i % 7);
    move[2] = ' ';
    switch (j)
    {
    case 0:
        move += "RIGHT";
        break;
    case 1:
        move += "LEFT";
        break;
    case 2:
        move += "DOWN";
        break;
    case 3:
        move += "UP";
        break;
    default:
        break;
    }
    return move;
}
bool solve(string board, vector<string> &result)
{
    int moves[4] = {2, -2, 14, -14}, lol;
    vector<int> N_position = extract_Ns(board);
    string temp;
    if (N_position.size() == 1)
    {
        if (N_position[0] == 24)
        {
            return true;
        }
        return false;
    }
    for (int i = 0; i < N_position.size(); i++)
    {
        for (int j = 0; j < 4; j++)
        {
            if (moves[j] + N_position[i] > 48 || moves[j] + N_position[i] < 0)
            {
                continue;
            }
            if (board[N_position[i] + moves[j]] == 'O' && board[N_position[i] + moves[j] / 2] == 'N')
            {
                board[N_position[i]] = 'O';
                board[N_position[i] + moves[j]] = 'N';
                board[N_position[i] + moves[j] / 2] = 'O';
                if (solve(board, result))
                {
                    result.push_back(move_to_string(N_position[i], j));
                    return true;
                }
                board[N_position[i]] = 'N';
                board[N_position[i] + moves[j]] = 'O';
                board[N_position[i] + moves[j] / 2] = 'N';
            }
        }
    }
    return false;
}
int main()
{
    string board, temp;
    vector<string> result;
    for (int i = 0; i < 7; i++)
    {
        cin >> temp;
        board += temp;
    }
    solve(board, result);
    for (int i = result.size() - 1; i >= 0; i--)
    {
        cout << result[i] << endl;
    }
    if (result.size()==0)
    {
        cout<<"Loser";
    }
    return 0;
}