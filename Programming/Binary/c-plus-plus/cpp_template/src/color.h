#ifndef __H_COLOR__
#define __H_COLOR__ 1
// Based on https://github.com/fengwang/colorize/blob/master/color.hpp

#include <map>
#include <string>

namespace color {
    const static std::map<std::string, std::string> colorForeground = {
        {"default", "39"},
        {"black", "30"},
        {"red", "31"},
        {"green", "32"},
        {"yellow", "33"},
        {"blue", "34"},
        {"magenta", "35"},
        {"cyan", "36"},
        {"light gray", "37"},
        {"dark gray", "90"},
        {"light red", "91"},
        {"light green", "92"},
        {"light yellow", "93"},
        {"light blue", "94"},
        {"light magenta", "95"},
        {"light cyan", "96"},
        {"white", "97"}
    };

    const static std::map<std::string, std::string> colorBackground = {
        {"default", "49"},
        {"black", "40"},
        {"red", "41"},
        {"green", "42"},
        {"yellow", "43"},
        {"blue", "44"},
        {"magenta", "45"},
        {"cyan", "46"},
        {"light gray", "47"},
        {"dark gray", "100"},
        {"light red", "101"},
        {"light green", "102"},
        {"light yellow", "103"},
        {"light blue", "104"},
        {"light magenta", "105"},
        {"light cyan", "106"},
        {"white", "107"}
    };

    const static std::map<std::string, std::string> formattingSet = {
        {"default", "0"},
        {"bold", "1"},
        {"dim", "2"},
        {"underlined", "4"},
        {"blink", "5"},
        {"reverse", "7"},
        {"hidden", "8"}
    };

    const static std::map<std::string, std::string> formattingReset = {
        {"all", "0"},
        {"bold", "21"},
        {"dim", "22"},
        {"underlined", "24"},
        {"blink", "25"},
        {"reverse", "27"},
        {"hidden", "28"}
    };

    std::string const colorControl = "\033";

    /*
     * std::cout << color::rize("I am a banana!", "green", "light yellow", "blink") << std::endl;
     *
     * auto message = color::rize("I am a banana!", "green", "light yellow", "blink");
     * std::cout << message << std::endl;
     */
    inline std::string rize(
        std::string const& message,
        std::string foreground = "default",
        std::string background = "default",
        std::string format = "default",
        std::string reset = "all"
    ) {
        if (colorForeground.find(foreground) == colorForeground.end()) {
            foreground = "default";
        }

        if (colorBackground.find(background) == colorBackground.end()) {
            background = "default";
        }

        if (formattingSet.find(format) == formattingSet.end()) {
            format = "default";
        }

        if (formattingReset.find(reset) == formattingReset.end()) {
            reset = "all";
        }

        std::string ans = colorControl + std::string{"["} +
            formattingSet.at(format) + std::string{";"} +
            colorBackground.at(background) + std::string{";"} +
            colorForeground.at(foreground) + std::string{"m"} +
            message +
            colorControl + std::string{"["} +
            formattingReset.at(reset) + std::string{"m"};
        return ans;
    }
}

#endif
