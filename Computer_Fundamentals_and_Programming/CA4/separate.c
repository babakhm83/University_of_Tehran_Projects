#include <stdio.h>
void separate(int arr[], int sizeArr)
{
    int arrOdd[100];
    int arrOddNum = 0;
    int arrEven[100];
    int arrEvenNum = 0;
    int swap = 0;
    for (int i = 0; i < sizeArr - 1; i++) /*Comparing the elements of the array and
    making a new array with the same elements but in order from smallest to greates*/
    {
        for (int j = 0; j < sizeArr - i - 1; j++)
        {
            if (arr[j] > arr[j + 1])
            {
                swap = arr[j + 1];
                arr[j + 1] = arr[j];
                arr[j] = swap;
            }
        }
    }
    for (int i = 0; i < sizeArr; i++)/*Separating the odd and even elements of the array to two new arrays*/
    {
        if (arr[i] % 2 == 1)
        {
            arrOdd[arrOddNum] = arr[i];
            arrOddNum++;
        }
        else
        {
            arrEven[arrEvenNum] = arr[i];
            arrEvenNum++;
        }
    }
    /*Printing the elements of the two arrays*/
    printf("%d", arrOdd[0]);
    for (int i = 1; i < arrOddNum; i++)
    {
        printf(",%d", arrOdd[i]);
    }
    printf("\n%d", arrEven[0]);
    for (int i = 1; i < arrEvenNum; i++)
    {
        printf(",%d", arrEven[i]);
    }
}
/*void main()
{
    int arr[7] = {6, 9, 3, 8, 7, 10, 1};
    separate(arr, 7);
}*/