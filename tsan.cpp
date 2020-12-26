#include <pthread.h>
#include <iostream>

int Global = 1;
void *Thread1(void *x)
{
    Global = 42;
    for (size_t i = 0; i < 1000; i++)
    {
        Global++;
    }

    return x;
}
int main()
{
    std::cout << "Initial value of count is " << Global << std::endl;
    pthread_t t;
    pthread_create(&t, NULL, Thread1, NULL);
    Global = 43;
    pthread_join(t, NULL);
    return Global;
}