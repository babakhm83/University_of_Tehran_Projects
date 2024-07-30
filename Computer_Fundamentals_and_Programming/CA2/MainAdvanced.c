#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include "BoardAdvanced.h"
#include "Player.h"
#include "BotsAdvanced.h"
#include "Score.h"
#define P1 0
#define P2 1
#define P3 2
#define P4 3
#define SYMBOL 4
#define VALUE 11
void shuffle_card(int *card)
{
    int i, r, temp;
    for (temp = 0, i = 0; temp < 44; i++, temp++)
        card[temp] = i;
    srand(time(NULL));
    for (i = 43; i > 0; i--)
    {
        r = rand() % i;
        temp = card[i];
        card[i] = card[r];
        card[r] = temp;
    }
}
int main()
{
    int cards[SYMBOL][VALUE];
    int cards_player1[SYMBOL][VALUE] = {0};
    int cards_player2[SYMBOL][VALUE] = {0};
    int cards_player3[SYMBOL][VALUE] = {0};
    int cards_player4[SYMBOL][VALUE] = {0};
    char main_symbol = '\0';
    int main_symbol_num = -1;
    int score[2] = {0};
    int cards_played_player[4][2] = {};
    int first_card_symbol = -1;
    int first_player = 0;
    int last_card_played = -1;
    int j = 0;
    int m = 0;
    int text = 0;
    int round[2] = {0};
    int advance = 0;
    char enter[100];
    do
    {
        for (int i = 0; i < SYMBOL; i++) /*Initializing the cards*/
        {
            for (int j = 1; j <= VALUE; j++)
            {
                cards[i][j - 1] = j;
            }
        }
        shuffle_card(cards[0]);
        for (int j = 0; j < 5; j++) /*Distributing the cards among the players*/
        {
            cards_player1[cards[P1][j] / VALUE][cards[P1][j] % VALUE] = 1;
            cards_player2[cards[P2][j] / VALUE][cards[P2][j] % VALUE] = 1;
            cards_player3[cards[P3][j] / VALUE][cards[P3][j] % VALUE] = 1;
            cards_player4[cards[P4][j] / VALUE][cards[P4][j] % VALUE] = 1;
        }
        Board(cards_player1, score, cards_played_player, first_player, main_symbol, round, text);
        do
        {
            fflush(stdin);
            printf("\nPlease choose the main symbol: ");
            scanf("%c", &main_symbol);
        } while (main_symbol != 'A' && main_symbol != 'B' && main_symbol != 'C' && main_symbol != 'D');
        main_symbol_num = (int)main_symbol - 65;
        printf("The main symbol is: %c", main_symbol);
        for (int j = 5; j < 9; j++) /*Distributing the cards among the players*/
        {
            cards_player1[cards[P1][j] / VALUE][cards[P1][j] % VALUE] = 1;
            cards_player2[cards[P2][j] / VALUE][cards[P2][j] % VALUE] = 1;
            cards_player3[cards[P3][j] / VALUE][cards[P3][j] % VALUE] = 1;
            cards_player4[cards[P4][j] / VALUE][cards[P4][j] % VALUE] = 1;
        }
        Board(cards_player1, score, cards_played_player, first_player, main_symbol, round, text);
        for (int j = 9; j < 11; j++) /*Distributing the cards among the players*/
        {
            cards_player1[cards[P1][j] / VALUE][cards[P1][j] % VALUE] = 1;
            cards_player2[cards[P2][j] / VALUE][cards[P2][j] % VALUE] = 1;
            cards_player3[cards[P3][j] / VALUE][cards[P3][j] % VALUE] = 1;
            cards_player4[cards[P4][j] / VALUE][cards[P4][j] % VALUE] = 1;
        }
        Board(cards_player1, score, cards_played_player, first_player, main_symbol, round, text);
        do
        {
            m = first_player;
            first_card_symbol = -1;
            text = 0;
            for (m, j; m < 4 && j < 4; m++, j++) /*Player and bots choose their cards*/
            {
                switch (m)
                {
                case P1:
                {
                    last_card_played = Player(cards_player1, first_card_symbol);
                    cards_played_player[P1][0] = last_card_played / 100;
                    cards_played_player[P1][1] = last_card_played % 100;
                    break;
                }
                case P2:
                {
                    if (cards_played_player[3][1] != 0)
                    {
                        for (int i = 0; i < 4; i++)
                        {
                            if (cards_played_player[i][1] == 0)
                            {
                                cards_played_player[i][0] = first_card_symbol;
                                cards_played_player[i][1] = 0;
                            }
                        }
                        advance = Point(cards_played_player, main_symbol_num, first_card_symbol);
                    }
                    else
                    {
                        advance = 0;
                    }
                    last_card_played = Bot(cards_player2, first_card_symbol, main_symbol_num, advance);
                    cards_played_player[P2][0] = last_card_played / 100;
                    cards_played_player[P2][1] = last_card_played % 100;
                    break;
                }
                case P3:
                {
                    if (cards_played_player[0][1] != 0)
                    {
                        for (int i = 0; i < 4; i++)
                        {
                            if (cards_played_player[i][1] == 0)
                            {
                                cards_played_player[i][0] = first_card_symbol;
                                cards_played_player[i][1] = 0;
                            }
                        }
                        advance = Point(cards_played_player, main_symbol_num, first_card_symbol);
                        if (advance == 0)
                        {
                            advance = 1;
                        }
                        else
                        {
                            advance = 0;
                        }
                    }
                    else
                    {
                        advance = 0;
                    }
                    last_card_played = Bot(cards_player3, first_card_symbol, main_symbol_num, advance);
                    cards_played_player[P3][0] = last_card_played / 100;
                    cards_played_player[P3][1] = last_card_played % 100;
                    break;
                }
                case P4:
                {
                    if (cards_played_player[1][1] != 0)
                    {
                        for (int i = 0; i < 4; i++)
                        {
                            if (cards_played_player[i][1] == 0)
                            {
                                cards_played_player[i][0] = first_card_symbol;
                                cards_played_player[i][1] = 0;
                            }
                        }
                        advance = Point(cards_played_player, main_symbol_num, first_card_symbol);
                    }
                    else
                    {
                        advance = 0;
                    }
                    last_card_played = Bot(cards_player4, first_card_symbol, main_symbol_num, advance);
                    cards_played_player[P4][0] = last_card_played / 100;
                    cards_played_player[P4][1] = last_card_played % 100;
                    m = -1;
                    break;
                }
                default:
                    break;
                }
                Board(cards_player1, score, cards_played_player, first_player, main_symbol, round, text);
                if (j == 0)
                {
                    first_card_symbol = last_card_played / 100;
                }
            }
            j = 0;
            first_player = Point(cards_played_player, main_symbol_num, first_card_symbol); /*The winner is determined*/
            if (first_player % 2 == 0)                                                     /*The score is updated*/
            {
                score[0]++;
            }
            else
            {
                score[1]++;
            }
            text = 1;
            for (int i = 0; i < 4; i++) /*Resets the board*/
            {
                cards_played_player[i][1] = 0;
            }
            Board(cards_player1, score, cards_played_player, first_player, main_symbol, round, text);
        } while (score[0] < 6 && score[1] < 6); /*Checks wether the round has ended or not*/
        system("cls");
        if (score[0] == 6)
        {
            printf("The winner of this round is Team1!\nPlease enter any key to continue");
            scanf("%s", &enter);
            round[0]++;
            if (score[1] == 0)
            {
                round[0]++;
            }
        }
        else
        {
            printf("The winner of this round is Team2!\nPlease enter any key to continue");
            scanf("%s", &enter);
            round[1]++;
            if (score[0] == 0)
            {
                round[1]++;
            }
        }
        score[0] = 0; /*Resetting the initial values*/
        score[1] = 0;
        for (int i = 0; i < 4; i++)
        {
            for (int l = 0; l < 11; l++)
            {
                cards_player1[i][l] = 0;
                cards_player2[i][l] = 0;
                cards_player3[i][l] = 0;
                cards_player4[i][l] = 0;
            }
        }
        text = 0;
        main_symbol = '\0';
        main_symbol_num = -1;
        first_card_symbol = -1;
        int first_player = 0;
        int last_card_played = -1;
        int j = 0;
        int m = 0;
    } while (round[0] + round[1] <= 5);
    system("cls");
    if (round[0] > round[1])
    {
        printf("The winner of the whole game is Team1!");
    }
    else
    {
        printf("The winner of the whole game is Team2!");
    }
}