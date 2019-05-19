###########################################################
#
# PowerShell custom profile
#
###########################################################

# ahh yes... this would be so nice if it was a built in variable
$here = Split-Path -Parent $MyInvocation.MyCommand.Path

. $PSScriptRoot\Microsoft.PowerShell_settings.ps1

# Chocolatey profile
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
  Import-Module "$ChocolateyProfile"
}

# load all script modules available to us
#Get-Module -ListAvailable | ? { $_.ModuleType -eq "Script" } | Import-Module


$poshModules = Get-Childitem –Path "C:\tools\poshgit" -Include "posh-git.psd1" -File -Recurse -ErrorAction SilentlyContinue
foreach($poshModule in $poshModules){
    Import-Module $poshModules.FullName
}

# function loader
#
# if you want to add functions you can added scripts to your
# powershell profile functions directory or you can inline them
# in this file. Ignoring the dot source of any tests
Resolve-Path $PSScriptRoot\functions\*.ps1 |
? { -not ($_.ProviderPath.Contains(".Tests.")) } |
% { . $_.ProviderPath }

$domain=([System.Security.Principal.WindowsIdentity]::GetCurrent().Name -split '\\')[0]
If($domain -eq 'GROUP') {
    Resolve-Path $PSScriptRoot\amis\*.ps1 |
    ? { -not ($_.ProviderPath.Contains(".Tests.")) } |
    % { . $_.ProviderPath }
}

Set-Alias e "C:\Windows\explorer.exe"
Set-Alias google-chrome "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe"

Set-PSReadlineKeyHandler -Chord Ctrl+B -ScriptBlock { google-chrome }
Set-PSReadlineKeyHandler -Chord Ctrl+D -ScriptBlock { code . }
