extern int lib_func1();

int local_func1()
{
    int k = 0x7fffffff;
    k += 10;
    return 0;
}

int local_func2()
{
    int k = 0x7fffffff;
    k += 10;
    return 0;
}

int local_func3()
{
    int *array = new int[100];
    delete[] array;
    return array[1]; // BOOM
}

int main(int argc, char **argv)
{
    local_func1();
    local_func2();
    lib_func1();

    local_func3();
    return 0;
}