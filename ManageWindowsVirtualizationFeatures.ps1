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
    "Windows-Defender-ApplicationGuard",
    "Containers-DisposableClientVM"  # Windows Sandbox
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
Write-Output "7. Enable Windows Sandbox"
Write-Output ""
Write-Output "-= DEACTIVATION =-"
Write-Output "8. Disable Hyper-V"
Write-Output "9. Disable Virtual Machine Platform"
Write-Output "10. Disable Windows Hypervisor Platform"
Write-Output "11. Disable Containers"
Write-Output "12. Disable Windows Subsystem for Linux (WSL2)"
Write-Output "13. Disable Microsoft Defender Application Guard"
Write-Output "14. Disable Windows Sandbox"
Write-Output ""
Write-Output "A. Enable all features"
Write-Output "D. Disable all features"
Write-Output ""
$choice = Read-Host "Enter your choice (1-14, A, or D)"

# Enable or disable selected features based on user input
switch ($choice) {
    "1" { Enable-Feature "Microsoft-Hyper-V-All" }
    "2" { Enable-Feature "VirtualMachinePlatform" }
    "3" { Enable-Feature "HypervisorPlatform" }
    "4" { Enable-Feature "Containers" }
    "5" { wsl --install }
    "6" { Enable-Feature "Windows-Defender-ApplicationGuard" }
    "7" { Enable-Feature "Containers-DisposableClientVM" }  # Windows Sandbox
    "8" { Disable-Feature "Microsoft-Hyper-V-All" }
    "9" { Disable-Feature "VirtualMachinePlatform" }
    "10" { Disable-Feature "HypervisorPlatform" }
    "11" { Disable-Feature "Containers" }
    "12" { Disable-Feature "Microsoft-Windows-Subsystem-Linux" }
    "13" { Disable-Feature "Windows-Defender-ApplicationGuard" }
    "14" { Disable-Feature "Containers-DisposableClientVM" }  # Windows Sandbox
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

# Prompt for reboot
Write-Output ""
$rebootChoice = Read-Host "Do you want to reboot now (Y), in 5 minutes (5), or not at all (N)?"

switch ($rebootChoice.ToUpper()) {
    "Y" { Restart-Computer }
    "5" { Shutdown.exe /r /t 300 }
    "N" { Write-Output "Please remember to reboot your computer later to apply the changes." }
    default { Write-Output "Invalid choice. No reboot scheduled." }
}
