#include <stdio.h>
#define Macaroni 329 /*Defining kilocalories of each food*/
#define Ghorme 127
#define Havij 61
#define Khoresht 83
#define Sabzi 156
#define Chelo 296
#define Kale 496
#define Kotlet 73
#define Ash 34
#define Salad 16
#define CaloriBurnt 100
int main()
{
    int n = 0;
    int Food = 0;
    int Sum = 0;
    scanf("%d", &n);
    for (int i = 0; i < n; i++) /*Calculating the total kilocalories consumed*/
    {
        scanf("%d", &Food);
        if (Food == 1)
        {
            Sum += Macaroni;
        }
        else if (Food == 2)
        {
            Sum += Ghorme;
        }
        else if (Food == 3)
        {
            Sum += Havij;
        }
        else if (Food == 4)
        {
            Sum += Khoresht;
        }
        else if (Food == 5)
        {
            Sum += Sabzi;
        }
        else if (Food == 6)
        {
            Sum += Chelo;
        }
        else if (Food == 7)
        {
            Sum += Kale;
        }
        else if (Food == 8)
        {
            Sum += Kotlet;
        }
        else if (Food == 9)
        {
            Sum += Ash;
        }
        else if (Food == 10)
        {
            Sum += Salad;
        }
    }
    /*Checking the change in calorie based and printing the result*/
    if (Sum > (CaloriBurnt * n))
    {
        printf("chagh");
    }
    else if (Sum < (CaloriBurnt * n))
    {
        printf("laghar");
    }
    else if (Sum == CaloriBurnt * n)
    {
        printf("bedoon taghir");
    }
}