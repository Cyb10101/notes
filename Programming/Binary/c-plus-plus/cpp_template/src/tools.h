#ifndef __H_TOOLS__
#define __H_TOOLS__ 1

#include <iostream>
#include <cstring>

class Tools {
public:
    void message(const char *message) {
        std::cout << message << std::endl;
    }

    void message(const std::string &message) {
        std::cout << message << std::endl;
    }
};

#endif
