ManageWindowsVirtualizationFeatures.ps1
Description
ManageWindowsVirtualizationFeatures.ps1 is a PowerShell script designed to simplify the management of virtualization features on Windows 11. This script allows users to enable or disable various virtualization features, such as Hyper-V, Virtual Machine Platform, Windows Hypervisor Platform, Containers, Windows Subsystem for Linux (WSL2), Microsoft Defender Application Guard, and Windows Sandbox. The script includes auto-elevation, ensuring it runs with administrative privileges, and provides an interactive menu for easy feature management.

Features
Enable or disable individual virtualization features
Enable or disable all virtualization features at once
Check the current status of each virtualization feature
Auto-elevation to run with administrative privileges
Optional reboot prompt
Download and Installation
Download the script:
Click on the Code button at the top of the repository.
Select Download ZIP to download the repository as a ZIP file.
Extract the ZIP file to a desired location on your computer.
Save the script:
Alternatively, you can copy the script content and save it as ManageWindowsVirtualizationFeatures.ps1 using a text editor like Notepad or Visual Studio Code.
Usage
Run the script:
Double-click the ManageWindowsVirtualizationFeatures.ps1 file or run it from a non-admin PowerShell window:
.\ManageWindowsVirtualizationFeatures.ps1

Follow the prompts:
The script will check the status of each virtualization feature and present a multiple-choice question.
Select the feature you want to enable or disable by entering the corresponding number or letter.
Examples
Example 1: Enable Hyper-V
Run the script:
.\ManageWindowsVirtualizationFeatures.ps1

Select option 1 to enable Hyper-V.
Example 2: Disable Virtual Machine Platform
Run the script:
.\ManageWindowsVirtualizationFeatures.ps1

Select option 9 to disable Virtual Machine Platform.
Example 3: Enable all features
Run the script:
.\ManageWindowsVirtualizationFeatures.ps1

Select option A to enable all virtualization features.
Example 4: Disable all features
Run the script:
.\ManageWindowsVirtualizationFeatures.ps1

Select option D to disable all virtualization features.
Example 5: Reboot options
After making changes, the script will prompt you to choose whether to reboot immediately, in 5 minutes, or not at all:
Do you want to reboot now (Y), in 5 minutes (5), or not at all (N)?

Contributing
Contributions are welcome! If you have any suggestions or improvements, please create a pull request or open an issue.

License
This project is licensed under the MIT License - see the LICENSE file for details.
