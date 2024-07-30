#include <stdio.h>
int main()
{
    int array[100], n, c = 0, d, swap; /*c needs an initial value be cause it gets compared in line 8*/
    printf("Enter number of elements\n");
    scanf("%d", &n);
    printf("Enter %d integers\n", n); /*There is no need for & in here because &n is the address of n not the value of n*/
    while (c < n)                     /*Array has n elements starting from 0 so the last element is the (n-1)th element so c should be less than n*/
    {
        scanf("%d", &array[c]);
        c++;
    }
    for (c = 0; c < n - 1; c++)
    {
        for (d = 0; d < n - c - 1; d++)
        {
            if (array[d] > array[d + 1])
            {
                swap = array[d]; /*swap must become equal to array[d] before its value is changed*/
                array[d] = array[d + 1];
                array[d + 1] = swap;
            }
        }
    }
    printf("Sorted list in ascending order:\n");
    for (c = 0; c < n; c++) /*Array has n elements starting from 0 so the last element is the (n-1)th element so c should be less than n*/
        printf("%d\n", array[c]);
    return 0;
}