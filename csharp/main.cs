using System;

namespace main
{
    class Program
    {
        static void Main(string[] args)
        {
            int n = 101;
            for (int i = 1; i < n; i++)
            {
                if (i % 3 == 0)
                    Console.Write("Fizz");
                if (i % 5 == 0)
                    Console.Write("Buzz");
                if (!(i % 3 == 0 || i % 5 == 0))
                    Console.Write(i);
                Console.WriteLine();
            }
        }
    }
}
