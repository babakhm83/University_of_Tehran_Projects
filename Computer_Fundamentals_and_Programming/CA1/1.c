#include <stdio.h>
int main()
{
    int Info = 0;
    int Part = 0;
    int Height = 0;
    int Number = 1;
    int Floor = 0;
    float Jump = 0;
    float Temp = 0;
    ;
    scanf("%d", &Info);
    scanf("%f", &Jump);
    Part = (((Info % 100) - 1) / 4) + 1; /*Finding the part that the trampoline should be placed*/
    printf("%d\n", Part);
    Floor = Info / 100;                       /*The third digit of info is the Floor that we want to jump to*/
    Height = (2 * Floor) + 1;                 /*Calculating the Height of the Floor we want to jump to*/
    for (Number = 1; Temp < Height; Number++) /*Finding the number of times we need to jump*/
    {
        Temp = (Number * (Jump / 2)) + Jump;
    }
    printf("%d", Number - 1);
}