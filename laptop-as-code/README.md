# Laptop As Code

Your laptop is the most important production environment there is but it is often not treated like our infra-as-code environments. For Windows / OSX / Linux there are enough tools to do a new installation (including settings) with little interaction. 

Keywords: dotfiles, symlinks, boxstarter, chocolatey.

Setting up a new machine with applications, configurations and updates can be time-consuming. Boxstarter is an open source tool that uses Chocolatey packages and PowerShell to bring up a Windows machine and configure it.

Symbolic links (symlinks) are basically advanced shortcuts. Create a symbolic link to an individual file or folder, and that link will appear to be the same as the file or folder to Windows—even though it’s just a link pointing at the file or folder.

On linux and OSX, files and folders which start with a dot (.) are hidden by default. Many programs use this to store settings in the home folder. Examples are .profile, .vimrc, .ssh, .config
These setting files are referred to as dotfiles. These dotfiles can be kept in one folder and symlink them to home folder and other locations. Many Linux/OSX users store these files as git repositories to track changes and back them up. You can find many github repositories called dotfiles with these setting files.

On Windows you can do exactly the same as on Linux. Keep one folder and symlink them to the correct location in your userprofile.

## Dotfiles

The dotfiles folder in this repository contains several settings which can be used on Windows, Linux and OSX

* bin - scripts/binaries to run in a linux environment
* boxstarter - boxstarter package module
* Code - Visual Studio Code settings and powershell script to install plugins
* git - GIT configuration for personal and Amis usage
* ssh - Secure Shell configuration which is extensibale
* WindowsPowerShell - WindowsPowerShell Profile with many functions for personal and Amis usage
* bash_* - bash profile configuration
* npmrc - Node Module configuration

Have a look at these files and get inspired to setup your own.


## Windows preparations

There are several ways to try out boxstarter, chocolatey and these dotfiles.

1. Create a new local account when you have a windows laptop
2. Run a Windows VM in Hyper-V or Virtualbox
3. Run a Windows VM in Azure

### Create a new local account

Add the new account to the Administrators group, which gives the user full access to the device. Boxstarter requires this to perform all installation tasks.

Option 1:

* Open Start, Search for Windows PowerShell, right-click the top result, and select Run as administrator
* Type the following commands to temporarily store the password in a secure string in the $Password variable and create the new account:

```powershell
$Password = Read-Host -AsSecureString
New-LocalUser "codecafe" -Password $Password -FullName "Code Cafe" -Description "Code Cafe Account."
Add-LocalGroupMember -Group "Administrators" -Member "codecafe"
```

Option 2:

* Go to Windows Settings -> Accounts -> Other people
* Add someone else to this PC
* Click the link "I don't have this person's sign-in information"
* Click the link "Add a user without a Microsoft account"
* Then finish the questions
* Click the newly created account when on "Other people" screen
* Change account type to Administrator

### Login local account

Switch to the new local account. Windows 10 expects an email address as account name in the login screen. To use a local account you need to add ".\" in front of the account name. In our case the account name is ".\codecafe"


## Install boxstarter

There are two ways to proceed and install boxstarter. Both will RESTART your pc so be sure to have saved everything on all accounts.

### Use the Boxstarter WebLauncher

Open Edge or Internet Explorer. Do not use Chrome in this step, because it will fail

* Open url http://boxstarter.org/package/git
* Open the downloaded application and run it.
* This will ask for your local account password and Restart the PC.
* Depending how your windows is setup the autologon might fail. Just login with the local account
* Boxstarter will open some powershells and install GIT

### Use the Boxstarter powershell install

* Open powershell as administrator

```powershell
Set-ExecutionPolicy Unrestricted -Force
. { iwr -useb http://boxstarter.org/bootstrapper.ps1 } | iex; get-boxstarter -Force
```

* This will ask for your local account password and Restart the PC.
* Depending how your windows is setup the autologon might fail. Just login with the local account
* Boxstarter will open some powershells and install
* Open the Boxstarter Shell and run

```powershell
cinst git
````

## GIT Clone Code Cafe

Open powershell and run

```powershell
git clone https://github.com/AMIS-Services/code-cafe-20190520
```

## Let's install everything else

Run in Boxstarter Shell

```powershell
cd code-cafe-20190520\laptop-as-code
Install-BoxstarterPackage -force -PackageName dotfiles\boxstarter\boxstarter-setup.psm1
```

## Let's link the dotfiles configuration

Run in Boxstarter Shell

```powershell
cd code-cafe-20190520\laptop-as-code
dotfiles\boxstarter\symlinks.ps1
```

## Additional Resources

https://boxstarter.org/
https://chocolatey.org/packages
https://github.com/microsoft/windows-dev-box-setup-scripts
https://github.com/Disassembler0/Win10-Initial-Setup-Script.git
