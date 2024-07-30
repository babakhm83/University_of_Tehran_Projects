int Point(int cards[4][2], int main_symbol, int first_symbol)
{
    int value = -1;
    int winner = 0;
    int i = 1;
    for (i = 0; i < 4; i++) /*Checks wether all the cards have the same symbol or not*/
    {
        if (cards[i][0] != first_symbol)
        {
            break;
        }
    }
    if (i == 4) /*If they all have the same symbol the owner of the card with greatest number will get a point*/
    {
        for (i = 0; i < 4; i++)
        {
            if (cards[i][1] > value)
            {
                value = cards[i][1];
                winner = i;
            }
        }
        return winner;
    }
    else /*If at least one card has a different symbol then:*/
    {
        for (i = 0; i < 4; i++) /*If there are any cards with main symbol the card with greatest number among those cards is the winner*/
        {
            if (cards[i][1] >= value && cards[i][0] == main_symbol)
            {
                value = cards[i][1];
                winner = i;
            }
        }
        if (value > -1)
        {
            return winner;
        }
        else /*If there aren't any cards with the main symbol, then the card with greatest numebr among the cards*/
        {
            for (i = 0; i < 4; i++)
            { /*with the same symbol as the first card's symbol is the winner*/
                if (cards[i][1] >= value && cards[i][0] == first_symbol)
                {
                    value = cards[i][1];
                    winner = i;
                }
            }
            return winner;
        }
    }
}