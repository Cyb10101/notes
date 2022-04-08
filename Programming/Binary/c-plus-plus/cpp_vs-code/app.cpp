#include <iostream>
#include "src/test.h"

int main() {
    Test test;
    std::cout << "Hello World!" << std::endl;

    char message[] = "This is a test!";
    test.message(message);
    // test.message("This is a failture!");
    return 0;
}
