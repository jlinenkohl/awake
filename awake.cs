using System;
using System.Runtime.InteropServices;

class Program
{
    [Flags]
    enum EXECUTION_STATE : uint
    {
        ES_CONTINUOUS        = 0x80000000,
        ES_SYSTEM_REQUIRED   = 0x00000001,
        ES_DISPLAY_REQUIRED  = 0x00000002
    }

    [DllImport("kernel32.dll")]
    static extern EXECUTION_STATE SetThreadExecutionState(EXECUTION_STATE esFlags);

    static void Main()
    {
        // Prevent sleep and display turning off
        var esFlags = EXECUTION_STATE.ES_CONTINUOUS | EXECUTION_STATE.ES_SYSTEM_REQUIRED | EXECUTION_STATE.ES_DISPLAY_REQUIRED;
        if (SetThreadExecutionState(esFlags) == 0)
        {
            Console.Error.WriteLine("Failed to set execution state.");
            Environment.Exit(1);
        }

        Console.WriteLine("System will stay awake. Press Enter to exit...");
        Console.ReadLine();

        // Clear the execution state override
        SetThreadExecutionState(EXECUTION_STATE.ES_CONTINUOUS);
    }
}

