function Test-IsAdmin {
    ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")
}

$Host.UI.RawUI.WindowTitle = "Private Projects"
if ( Test-IsAdmin ) {
    $title = "Administrator Shell - {0}" -f $host.UI.RawUI.WindowTitle
    $host.UI.RawUI.WindowTitle = $title;
}

function Get-Time { return $(get-date | foreach { $_.ToLongTimeString() } ) }



## Posh-Git 0.7.X
# $GitPromptSettings.DefaultPromptAbbreviateHomeDirectory = $true
# $GitPromptSettings.DefaultPromptPrefix = '$(Get-Date -f "MM-dd HH:mm:ss") '

## Posh-Git 1.0.0
# $GitPromptSettings.DefaultPromptAbbreviateHomeDirectory = $true
# $GitPromptSettings.DefaultPromptPrefix.Text = '$(Get-Date -f "MM-dd HH:mm:ss") '
# $GitPromptSettings.DefaultPromptPrefix.ForegroundColor = [ConsoleColor]::Yellow
# $GitPromptSettings.DefaultPromptPath.ForegroundColor = 'Green'
# $GitPromptSettings.DefaultPromptBeforeSuffix.Text = '`n'

function prompt {
    # $lastResult = Invoke-Expression '$?'
    # if (!$lastResult) {
    #         Write-Host "Last command exited with error status." -ForegroundColor Red
    # }

    if ( Test-IsAdmin ) {
        write-host -NoNewLine -f red "Admin "
    }
    # Write the time
    write-host "[" -noNewLine
    write-host $(Get-Time) -foreground yellow -noNewLine
    write-host "] " -noNewLine
    # Write the path
    write-host $($(Get-Location).Path.replace($home,"~").replace("\","/")) -foreground green -noNewLine
    # & $GitPromptScriptBlock
    Write-VcsStatus
    write-host ''
    write-host $(if ($nestedpromptlevel -ge 1) { '>>' }) -noNewLine
    return "> "
}
