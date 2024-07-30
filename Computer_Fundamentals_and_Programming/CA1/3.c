#include <stdio.h>
#include <math.h>
float QuadraticRoot(float b, float c, int Sign)/*Here the because of the exception explained in line 70*/
{/*the roots of the derivative of the expression are found.*/
    float Result;
    float Delta;
    Delta = b * b - 4 * 3 * c;
    if (Delta >= 0)
    {
        Delta = sqrtf(Delta);
        Result = (-b + Sign * Delta) / 6;
        return Result;
    }
}
int main()
{
    float a = 4;
    float b = 0;
    float c = 8;
    float Greatest = 8;
    float Error = 1;
    float TempRoot = 0;
    float PreTempRoot = 0;
    float TempY = 0;
    float PreTempY = 0;
    float QuadraticError = 0;
    int NumberOfRoots = 0;
    int Sign = 1;
    scanf("%f", &a);
    scanf("%f", &b);
    scanf("%f", &c);
    scanf("%f", &Error);
    Error *= 2;
    if (a * a < 1 && b < 1 && c < 1) /*Finding the greatest multiplier of x*/
    {
        Greatest = 1;
    }
    else if (a * a >= b * b && a * a >= c * c)
    {
        Greatest = a;
    }
    else if (b * b >= a * a && b * b >= c * c)
    {
        Greatest = b;
    }
    else if (c * c >= a * a && c * c >= b * b)
    {
        Greatest = c;
    }
    for (int i = 0; i * Error <= 2 * Greatest * Greatest; i++) /*Finding the roots by testing different values for x*/
    {
        TempRoot = i * Error - Greatest * Greatest;
        TempY = (TempRoot * TempRoot * TempRoot) + (a * TempRoot * TempRoot) + (b * TempRoot) + c;
        PreTempRoot = (i - 1) * Error - Greatest * Greatest;
        PreTempY = (PreTempRoot * PreTempRoot * PreTempRoot) + (a * PreTempRoot * PreTempRoot) + (b * PreTempRoot) + c;
        if (Sign * TempY >= 0) /*If the sign of function changes for a value then we can know that there is a root less than the value*/
        {
            if (Sign * (TempY) > -Sign * (PreTempY)) /*The root is either closer to this value or the previous value*/
            {
                printf("%f\n", PreTempRoot);
            }
            else if (Sign * (TempY) < -Sign * (PreTempY))
            {
                printf("%f\n", TempRoot);
            }
            NumberOfRoots++;
            Sign *= -1;
        }
    }
    if (NumberOfRoots == 1 && a != 0 && b != 0)/*If the root is also is also the point that the derivative is 0*/
    {/*then the root cannot be calulated using the above method so in that case the root is calculated precisely here.*/
        QuadraticError = QuadraticRoot(2 * a, b, 1);
        if ((QuadraticError * QuadraticError * QuadraticError) + (a * QuadraticError * QuadraticError) + (b * QuadraticError) + c == 0)
        {
            printf("%f\n", QuadraticError);
            NumberOfRoots++;
        }
        QuadraticError = QuadraticRoot(2 * a, b, -1);
        if ((QuadraticError * QuadraticError * QuadraticError) + (a * QuadraticError * QuadraticError) + (b * QuadraticError) + c == 0)
        {
            printf("%f\n", QuadraticError);
            NumberOfRoots++;
        }
    }
    for (int j = 0; j < (3 - NumberOfRoots); j++) /*The expression has at most 3 roots and we already know how many roots has been found*/
    {                                             /*So we know how many roots the expression is missing*/
        printf("bedoon rishe\n");
    }
}