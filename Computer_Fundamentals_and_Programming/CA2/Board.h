#include <stdio.h>
#define width 49
#define height 7
void Board(int P1[4][11], int Score[2], int cards[4][2], int first_player, char main_symbol, int winner)
{
    int num = 0;
    char enter[100];
    system("cls");
    if (main_symbol != -1)
    {
        printf("\nLast winner: P%d\t\t\t\t\t\tMain symbol: %c\n", first_player + 1, main_symbol);
    }
    printf("Team1: %d\t\t\t\t\t\tTeam2: %d\n", Score[0], Score[1]); /*Printing the score of each team*/
    printf("\t");
    if (cards[2][1] == 0) /*Printing the card played by the third player*/
    {
        printf("\t\t    P3    \n\t");
    }
    else
    {
        printf("\t\t    P3: %c%d\n\t", cards[2][0] + 65, cards[2][1]);
    }
    for (int i = 0; i < width; i++) /*Drawing the border*/
    {
        printf("-");
    }
    for (int i = 0; i < height; i++)
    {
        if (i == height / 2)
        {
            if (cards[1][1] == 0) /*Printing the card played by the second player*/
            {
                printf("\n\tP2    ");
            }
            else
            {
                printf("\n\tP2: %c%d", cards[1][0] + 65, cards[1][1]);
            }
            if (cards[3][1] == 0) /*Printing the card played by the fourth player*/
            {
                printf("\t\t\t\t\t\tP4");
            }
            else
            {
                printf("\t\t\t\t\t      P4: %c%d", cards[3][0] + 65, cards[3][1]);
            }
        }
        else
        {
            printf("\n\t|\t\t\t\t\t\t|");
        }
    }
    printf("\n\t");
    for (int i = 0; i < width; i++)
    {
        printf("-");
    }
    if (cards[0][1] == 0) /*Printing the card played by the first player*/
    {
        printf("\n\t\t\t    P1    \n");
    }
    else
    {
        printf("\n\t\t\t    P1: %c%d\n", cards[0][0] + 65, cards[0][1]);
    }
    printf("\nSymbol:");
    for (int i = 0; i < 4; i++) /*Printing the symbol of the first player's cards*/
    {
        for (int j = 0; j < 11; j++)
        {
            if (P1[i][j] == 1)
            {
                num++;
                switch (i)
                {
                case 0:
                    printf(" A |");
                    break;
                case 1:
                    printf(" B |");
                    break;
                case 2:
                    printf(" C |");
                    break;
                case 3:
                    printf(" D |");
                    break;
                default:
                    break;
                }
            }
        }
    }
    printf("\nValue: "); /*Printing the values of the first player's cards*/
    for (int i = 0; i < 4; i++)
    {
        for (int j = 0; j < 11; j++)
        {
            if (P1[i][j] == 1)
            {
                printf(" %d |", j + 1);
            }
        }
    }
    printf("\n\t"); /*Printing the number under every one of the first player's cards*/
    for (int j = 0; j < num; j++)
    {
        printf(" %d |", j);
    }
    if (winner == 1)
    {
        printf("\nTeam%d has just got a point!", first_player % 2+1);
    }
    printf("\nPlease enter any key to continue");
    scanf("%s", &enter);
}
