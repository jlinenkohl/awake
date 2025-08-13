#include <windows.h>
#include <iostream>

int main()
{
    // Prevent sleep and display turning off
    EXECUTION_STATE esFlags = ES_CONTINUOUS | ES_SYSTEM_REQUIRED | ES_DISPLAY_REQUIRED;
    if (SetThreadExecutionState(esFlags) == 0)
    {
        std::cerr << "Failed to set execution state." << std::endl;
        return 1;
    }

    std::cout << "System will stay awake. Press Enter to exit..." << std::endl;
    std::cin.get();

    // Clear the execution state override
    SetThreadExecutionState(ES_CONTINUOUS);

    return 0;
}
