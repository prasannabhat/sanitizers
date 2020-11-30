int func1()
{
    int *array = new int[100];
    delete[] array;
    return array[1]; // BOOM
}

int func3()
{
    int *array = new int[100];
    delete[] array;
    return array[1]; // BOOM
}

extern int func2();

int main(int argc, char **argv)
{
    (void)func1();
    (void)func2();
    (void)func3();
    return 1;
}