#include <iostream>
#include "src/color.h"
#include "src/tools.h"
#include "src/crash.h"

int main() {
    Tools tools;
    std::cout << color::rize("C++ Template", "red") << std::endl;

    Crash crash(false); // Segmentation fault if true
    char message[] = "This is a test message."; crash.message(message);
    // crash.message("This is a error!");

    char messageTools[] = "Message in C-String."; tools.message(messageTools);
    tools.message("Message in String.");
    return 0;
}
