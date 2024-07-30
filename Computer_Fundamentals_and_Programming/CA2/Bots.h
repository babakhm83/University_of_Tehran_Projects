int Bot(int card[4][11], int first_card_symbol, int main_symbol)
{
    int greatest_card_value;
    if (first_card_symbol >= 0) /*There is at least one card on board*/
    {
        for (int i = 10; i >= 0; i--) /*If this bot has a card with the same symbol as the first card on board,*/
        {                             /*the card with greatest value among those cards will be removed*/
            if (card[first_card_symbol][i] == 1)
            {
                card[first_card_symbol][i] = 0;
                return (100 * first_card_symbol + i + 1);
            }
        }
        for (int i = 10; i >= 0; i--) /*Else if this bot has a card with the main symbol,*/
        {                             /*the card with greatest value among those cards will be removed*/
            if (card[main_symbol][i] == 1)
            {
                card[main_symbol][i] = 0;
                return (100 * main_symbol + i + 1);
            }
        }
        for (int i = 10; i >= 0; i--) /*Else the card with greatest value among the cards will be removed*/
        {
            for (int j = 0; j < 4; j++)
            {
                if (j == main_symbol || j == first_card_symbol)
                {
                    continue;
                }
                if (card[j][i] == 1)
                {
                    card[j][i] = 0;
                    return (100 * j + i + 1);
                }
            }
        }
    }
    else /*There aren't any cards on board*/
    {
        for (int i = 10; i >= 0; i--)
        {
            for (int j = 0; j < 4; j++)
            {
                if (card[j][i] == 1)
                {
                    if (j == main_symbol) /*Finds the greatest card with main symbol that this bot has*/
                    {
                        greatest_card_value = i;
                    }
                    else /*If this bot has any cards without the main symbol the card will be removed*/
                    {
                        card[j][i] = 0;
                        return (100 * j + i + 1);
                    }
                }
            }
        }
        card[main_symbol][greatest_card_value] = 0;           /*If all the cards of this bot are with the main symbol,*/
        return (100 * main_symbol + greatest_card_value + 1); /*the greatest card will be removed*/
    }
}