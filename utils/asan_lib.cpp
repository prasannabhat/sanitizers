int func2()
{
    int *array = new int[100];
    delete[] array;
    return array[1]; // BOOM
}