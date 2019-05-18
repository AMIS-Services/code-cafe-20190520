## http://www.boxstarter.org/
## http://boxstarter.org/WhyBoxstarter
## https://chocolatey.org/

# Installing from the web
# Run in powershell v3 or higher:
#
# Set-ExecutionPolicy Unrestricted -Force
# . { iwr -useb http://boxstarter.org/bootstrapper.ps1 } | iex; get-boxstarter -Force
#
## Run in Boxstarter Shell
## Install-BoxstarterPackage -force -PackageName << fullpath to dotfiles\boxstarter\boxstarter-setup.psm1>>
##

Update-ExecutionPolicy Unrestricted
# Set-ExecutionPolicy Unrestricted -Scope CurrentUser

# enable reboot
$Boxstarter.RebootOk=$true
$Boxstarter.NoPassword=$false
$Boxstarter.AutoLogin=$true

# https://github.com/mwrock/boxstarter/blob/master/Boxstarter.WinConfig/Set-WindowsExplorerOptions.ps1
Set-WindowsExplorerOptions -EnableShowHiddenFilesFoldersDrives -EnableShowProtectedOSFiles -EnableShowFileExtensions -EnableShowFullPathInTitleBar -EnableExpandToOpenFolder

Disable-GameBarTips
Disable-BingSearch

# Enable-RemoteDesktop

# Windows 10 comes with OneGet, a universal package manager that can use Chocolatey
Get-PackageProvider -name chocolatey

# cinst Microsoft-Hyper-V-All -source windowsFeatures
cinst TelnetClient -source windowsFeatures
# cinst Net-Framework-Core -source windowsFeatures

# cinst Microsoft-Windows-Subsystem-Linux -source windowsFeatures
# Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux

if (Test-PendingReboot) { Invoke-Reboot }


cinst chocolateygui

## Git
cinst git.install
cinst git-credential-winstore
cinst poshgit
## Java
cinst gradle
cinst jdk8
cinst maven

# cinst microsoft-build-tools
# cinst microsoft-visual-cpp-build-tools

## Node / Npm
cinst nodejs.install
cinst yarn
cinst phantomjs
## Go
# cinst -y golang
## Python
# cinst python
# cinst pip
# cinst easy.install
## Ruby
# cinst ruby
#cinst ruby.devkit

cinst 7zip.install
# cinst adobereader
cinst notepadplusplus
cinst putty
cinst sysinternals

cinst googlechrome
cinst firefox

# cinst docker-for-windows
# cinst docker-desktop
# cinst kubernetes-cli
# cinst minikube

# cinst packer
# cinst virtualbox
# cinst virtualbox.extensionpack
# cinst vagrant

# cinst console-devel
# cinst fiddler4
# cinst awscli
# cinst awstools.powershell
# cinst mariadb
# cinst memcached
# cinst mongodb
# cinst mysql
# cinst rabbitmq
# cinst redis-64
# cinst soapui
# cinst sqlite
# cinst postman

# cinst sourcetree
# cinst visualstudiocode

# cinst filezilla
# cinst google-backup-and-sync
# cinst keepass.install
# cinst keepass-keepasshttp
# cinst office365proplus
# cinst skype
# cinst skypeforbusiness
# cinst slack
# cinst vlc
# cinst winmerge
# cinst wireshark

# Import-Module "$env:ChocolateyInstall\helpers\chocolateyInstaller.psm1"

# Add Exlusion to Microsoft Defender
Add-MpPreference -ExclusionPath "C:\projects"

function Node-Global-Install() {
  npm install -`g $args
}
New-Alias npmig Node-Global-Install

npmig @angular/cli
# npmig @oracle/ojet-cli
# npmig @feathersjs/cli
# npmig babel-eslint
# npmig cordova
npmig create-react-app
# npmig create-react-native-app
# npmig eslint
# npmig eslint-plugin-flowtype
# npmig eslint-plugin-import
# npmig eslint-plugin-jsx-a11y
# npmig eslint-plugin-react
# npmig exp
# npmig flow-bin
# npmig generator-typescript-library
# npmig grunt-cli
# npmig http-server
# npmig jest
# npmig jshint
# npmig lerna
# npmig nodemon
# npmig pm2
# npmig pnpm
# npmig protractor
# npmig react-devtools
# npmig serve
# npmig tslint
# npmig typescript
# npmig vue-cli
# npmig webpack
# npmig yo

# Let's get Updates, too
Install-WindowsUpdate -acceptEula

# Privacy: Let apps use my advertising ID: Disable
If (-Not (Test-Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo")) {
    New-Item -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo | Out-Null
}
Set-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo -Name Enabled -Type DWord -Value 0

# WiFi Sense: HotSpot Sharing: Disable
If (-Not (Test-Path "HKLM:\Software\Microsoft\PolicyManager\default\WiFi\AllowWiFiHotSpotReporting")) {
    New-Item -Path HKLM:\Software\Microsoft\PolicyManager\default\WiFi\AllowWiFiHotSpotReporting | Out-Null
}
Set-ItemProperty -Path HKLM:\Software\Microsoft\PolicyManager\default\WiFi\AllowWiFiHotSpotReporting -Name value -Type DWord -Value 0

# WiFi Sense: Shared HotSpot Auto-Connect: Disable
Set-ItemProperty -Path HKLM:\Software\Microsoft\PolicyManager\default\WiFi\AllowAutoConnectToWiFiSenseHotspots -Name value -Type DWord -Value 0

# Start Menu: Disable Bing Search Results
Set-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search -Name BingSearchEnabled -Type DWord -Value 0
# To Restore (Enabled):
# Set-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search -Name BingSearchEnabled -Type DWord -Value 1

# Change Explorer home screen back to "This PC"
Set-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name LaunchTo -Type DWord -Value 1
# Change it back to "Quick Access" (Windows 10 default)
# Set-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name LaunchTo -Type DWord -Value 2

# Better File Explorer
Set-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name NavPaneExpandToCurrentFolder -Value 1
Set-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name NavPaneShowAllFolders -Value 1
Set-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name MMTaskbarMode -Value 2

# These make "Quick Access" behave much closer to the old "Favorites"
# Disable Quick Access: Recent Files
Set-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer -Name ShowRecent -Type DWord -Value 0
# Disable Quick Access: Frequent Folders
Set-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer -Name ShowFrequent -Type DWord -Value 0
# To Restore:
# Set-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer -Name ShowRecent -Type DWord -Value 1
# Set-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer -Name ShowFrequent -Type DWord -Value 1

# Turn off People in Taskbar
If (-Not (Test-Path "HKCU:SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\People")) {
    New-Item -Path HKCU:SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\People | Out-Null
}
Set-ItemProperty -Path "HKCU:SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\People" -Name PeopleBand -Type DWord -Value 0
