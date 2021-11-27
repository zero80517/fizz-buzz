#include <stdio.h>

int main()
{
    for (int i = 1, mul3, mul5; i < 101; i++)
    {
        mul3 = (i%3)==0;
        mul5 = (i%5)==0;
        if (mul3)
            printf("Fizz");
        if (mul5)
            printf("Buzz");
        if (!mul3 && !mul5)
            printf("%d", i);
        printf("\n");
    }
}