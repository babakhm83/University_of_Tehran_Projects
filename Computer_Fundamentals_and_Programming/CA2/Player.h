#include <stdio.h>
int Player(int cards[4][11], int first_card_symbol)
{
    int card_played = -1;
    int a = 0;
    int i = 0;
    int j = 0;
    int check = 0;
    int number_cards = 0;
    for (int m = 0; m < 11 && first_card_symbol >= 0; m++) /*Checking wether there are any cards on board if there is at least one then,*/
    {                                                      /*Checking wether the player has a card with the same symbol as the first card on board*/
        if (cards[first_card_symbol][m] == 1)
        {
            check = 1;
            break;
        }
    }
    for (i = 0; i < 4 && number_cards < 11; i++)
    {
        for (j = 0; j < 11 && number_cards < 11; j++)
        {
            if (cards[i][j] == 1)
            {
                number_cards++;
            }
        }
    }
    do /*The player chooses the card they want to play*/
    {
        printf("\nPlease enter an integer number between 0 to %d: ", number_cards - 1);
        a = scanf("%d", &card_played);
        fflush(stdin);
        if (card_played <= number_cards - 1 && card_played >= 0 && a == 1) /*Finding the symbol and value of the card the player chose*/
        {
            for (i = 0; i < 4 && card_played > -1; i++)
            {
                for (j = 0; j < 11 && card_played > -1; j++)
                {
                    if (cards[i][j] == 1)
                    {
                        card_played--;
                    }
                }
            }
            if (check == 1 && (i - 1) != first_card_symbol) /*If the player has any cards with the same symbOl as the first card on board,*/
            {                                               /*They must choose a card with that symbol*/
                printf("You must choose a with has this symbol: %c", 65 + first_card_symbol);
            }
            else
            {
                break;
            }
        }
    } while (1);
    cards[i - 1][j - 1] = 0; /*The card the player chose will be removed*/
    return (100 * (i - 1) + j);
}