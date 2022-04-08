#ifndef __H_TEST__
#define __H_TEST__ 1

#include <iostream>
#include <cstring>

class Test {
public:
    Test()  {
        // char *segmentationFault;
        // strcpy(segmentationFault, "Segmentation fault!");

        std::cout << "Initialize class: Test..." << std::endl;
	}

    void message(char *message) {
        std::cout << "Test message: " << message << std::endl;
    }
};

#endif
