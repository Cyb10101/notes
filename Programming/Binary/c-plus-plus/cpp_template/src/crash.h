#ifndef __H_CRASH__
#define __H_CRASH__ 1

#include <iostream>
#include <cstring>
#include "color.h"

class Crash {
public:
    Crash(bool segmentationFault = false) {
        std::cout << color::rize("Initialize class: Crash...", "yellow") << std::endl;

        if (segmentationFault) {
            this->segmentationFault();
        }
    }

    /*
     * Working: char message[] = "This is a test message!"; crash.message(message);
     * Error: crash.message("This is a error!");
     */
    void message(char *message) {
        std::cout << "Test message: " << message << std::endl;
    }

private:
    void segmentationFault() {
        std::cout << "Segmentation fault: Start" << std::endl;
        char *segmentationFault;
        strcpy(segmentationFault, "Segmentation fault!");
        std::cout << "Segmentation fault: End" << std::endl;
    }
};

#endif
