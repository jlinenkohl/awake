Add-Type @"
using System;
using System.Runtime.InteropServices;

public class PowerState {
    [Flags]
    public enum EXECUTION_STATE : uint {
        ES_CONTINUOUS      = 0x80000000,
        ES_SYSTEM_REQUIRED = 0x00000001,
        ES_DISPLAY_REQUIRED= 0x00000002
    }

    [DllImport("kernel32.dll")]
    public static extern EXECUTION_STATE SetThreadExecutionState(EXECUTION_STATE esFlags);
}
"@

# Prevent sleep and display turning off
$esFlags = [PowerState+EXECUTION_STATE]::ES_CONTINUOUS -bor `
    [PowerState+EXECUTION_STATE]::ES_SYSTEM_REQUIRED -bor `
    [PowerState+EXECUTION_STATE]::ES_DISPLAY_REQUIRED

$result = [PowerState]::SetThreadExecutionState($esFlags)
if ($result -eq 0) {
    Write-Error "Failed to set execution state."
    exit 1
}

Write-Host "System will stay awake. Press Enter to exit..."
[void][System.Console]::ReadLine()

# Clear the execution state override
[PowerState]::SetThreadExecutionState([PowerState+EXECUTION_STATE]::ES_CONTINUOUS)
