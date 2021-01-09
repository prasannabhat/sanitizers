#include "gtest/gtest.h"
#include <string>

TEST(FooTest, Foo)
{
    std::string foo("foo");
    EXPECT_STREQ("foo", foo.c_str());
}

TEST(FooTest, MemsanError1)
{
    int *a = new int[10];
    // a[5] = 0;
    ASSERT_TRUE(a[0]);
}

TEST(FooTest, MemsanError2)
{
    int uninitialized;
    EXPECT_GT(uninitialized, 5);
}

int main(int argc, char **argv)
{
    ::testing::InitGoogleTest(&argc, argv);
    return RUN_ALL_TESTS();
}
