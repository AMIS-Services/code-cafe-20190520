$dotFiles = $(Split-Path -Parent $PSScriptRoot)

. $dotFiles\WindowsPowerShell\functions\CreatetSymlink.ps1

Create-SymLink "$env:userprofile\.ssh" "$dotFiles\ssh"

Create-SymLink "$env:userprofile\.npmrc" "$dotFiles\npmrc"
# Create-SymLink "$env:userprofile\.npm-init.js" "$dotFiles\npm-init.js"
# Create-SymLink "$env:userprofile\.yarnrc" "$dotFiles\yarnrc"

Create-Directory "$env:userprofile\.config"
Create-SymLink "$env:userprofile\.config/git" "$dotFiles\git"
# Create-Directory "$env:APPDATA\Subversion"
# Create-SymLink "$env:APPDATA\Subversion\config" "$dotFiles\subversion.config"

Create-SymLink "$env:userprofile\Documents\WindowsPowerShell" "$dotFiles\WindowsPowerShell"

Create-SymLink "$env:userprofile\bin" "$dotFiles\bin"
Create-SymLink "$env:userprofile\.bashrc" "$dotFiles\bashrc"
Create-SymLink "$env:userprofile\.bash_profile" "$dotFiles\bash_profile"

Create-Directory "$dotFiles\Code"
Create-SymLink "$env:APPDATA\Code\User\settings.json" "$dotFiles\Code\settings.json"

# Create-Directory "$env:userprofile\.m2"
# Create-SymLink "$env:userprofile\.m2\settings.xml" "$dotFiles\m2\settings.xml"

# Create-SymLink "$env:userprofile\AppData\Local\Atlassian\SourceTree\bookmarks.xml" "$dotFiles\sourcetree\bookmarks.xml"
# Create-SymLink "$env:userprofile\AppData\Local\Atlassian\SourceTree\accounts.json" "$dotFiles\sourcetree\accounts.json"
