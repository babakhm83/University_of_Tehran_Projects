#include <stdio.h>
void recognize(char s[], int sizeString)
{
    char Alphabet[26] = {'\0'};
    int Num = 0;
    int j = 0;
    for (int i = 0; i < sizeString; i++)/*Finding the number of types of character used in the username*/
    {
        for (j = 0; j < 26; j++)
        {
            if (s[i] == Alphabet[j])
            {
                break;
            }
        }
        if (j == 26)
        {
            Alphabet[Num] = s[i];
            Num++;
        }
    }
    if (Num % 2 == 1)/*Checking wether or not the username is fake*/
    {
        printf("BLOCK THIS USER");
    }
    else
    {
        printf("CHAT WITH THIS USER");
    }
}
/*int main()
{
    char s[6] = "Hello";
    recognize(s, 5);
}*/