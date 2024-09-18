# Check if the script is running with administrative privileges
function Test-Admin {
    $currentUser = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
    $currentUser.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

# Relaunch the script with elevated privileges if not already running as admin
if (-not (Test-Admin)) {
    Start-Process powershell -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    exit
}

# Function to check the status of a feature
function Check-FeatureStatus {
    param (
        [string]$FeatureName
    )
    $feature = Get-WindowsOptionalFeature -Online -FeatureName $FeatureName
    Write-Output "$($feature.DisplayName): $($feature.State)"
    return $feature.State
}

# Function to enable a feature
function Enable-Feature {
    param (
        [string]$FeatureName
    )
    $status = Check-FeatureStatus $FeatureName
    if ($status -ne "Enabled") {
        Enable-WindowsOptionalFeature -Online -FeatureName $FeatureName -All
        Write-Output "$FeatureName has been enabled."
    } else {
        Write-Output "$FeatureName is already enabled."
    }
}

# Function to disable a feature
function Disable-Feature {
    param (
        [string]$FeatureName
    )
    $status = Check-FeatureStatus $FeatureName
    if ($status -eq "Enabled") {
        Disable-WindowsOptionalFeature -Online -FeatureName $FeatureName
        Write-Output "$FeatureName has been disabled."
    } else {
        Write-Output "$FeatureName is already disabled."
    }
}

# Check the status of each feature
$features = @(
    "Microsoft-Hyper-V-All",
    "VirtualMachinePlatform",
    "HypervisorPlatform",
    "Containers",
    "Microsoft-Windows-Subsystem-Linux",
    "Windows-Defender-ApplicationGuard"
)

foreach ($feature in $features) {
    Check-FeatureStatus $feature
}

# Present the user with a multiple-choice question
Write-Output ""
Write-Output "-= ACTIVATION =-"
Write-Output "1. Enable Hyper-V"
Write-Output "2. Enable Virtual Machine Platform"
Write-Output "3. Enable Windows Hypervisor Platform"
Write-Output "4. Enable Containers"
Write-Output "5. Enable Windows Subsystem for Linux (WSL2)"
Write-Output "6. Enable Microsoft Defender Application Guard"
Write-Output ""
Write-Output "-= DEACTIVATION =-"
Write-Output "7. Disable Hyper-V"
Write-Output "8. Disable Virtual Machine Platform"
Write-Output "9. Disable Windows Hypervisor Platform"
Write-Output "10. Disable Containers"
Write-Output "11. Disable Windows Subsystem for Linux (WSL2)"
Write-Output "12. Disable Microsoft Defender Application Guard"
Write-Output ""
Write-Output "A. Enable all features"
Write-Output "D. Disable all features"
Write-Output ""
$choice = Read-Host "Enter your choice (1-12, A, or D)"

# Enable or disable selected features based on user input
switch ($choice) {
    "1" { Enable-Feature "Microsoft-Hyper-V-All" }
    "2" { Enable-Feature "VirtualMachinePlatform" }
    "3" { Enable-Feature "HypervisorPlatform" }
    "4" { Enable-Feature "Containers" }
    "5" { wsl --install }
    "6" { Enable-Feature "Windows-Defender-ApplicationGuard" }
    "7" { Disable-Feature "Microsoft-Hyper-V-All" }
    "8" { Disable-Feature "VirtualMachinePlatform" }
    "9" { Disable-Feature "HypervisorPlatform" }
    "10" { Disable-Feature "Containers" }
    "11" { Disable-Feature "Microsoft-Windows-Subsystem-Linux" }
    "12" { Disable-Feature "Windows-Defender-ApplicationGuard" }
    "A" {
        foreach ($feature in $features) {
            if ($feature -ne "Microsoft-Windows-Subsystem-Linux") {
                Enable-Feature $feature
            } else {
                wsl --install
            }
        }
    }
    "D" {
        foreach ($feature in $features) {
            Disable-Feature $feature
        }
    }
    default { Write-Output "Invalid choice. No features were enabled or disabled." }
}

# Restart the computer to apply changes
Restart-Computer
