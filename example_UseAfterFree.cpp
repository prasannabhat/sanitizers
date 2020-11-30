int func1()
{
    int *array = new int[100];
    delete[] array;
    return array[1]; // BOOM
}

int func2()
{
    int *array = new int[100];
    delete[] array;
    return array[1]; // BOOM
}

int main(int argc, char **argv)
{
    (void)func1();
    (void)func2();
    return 1;
}