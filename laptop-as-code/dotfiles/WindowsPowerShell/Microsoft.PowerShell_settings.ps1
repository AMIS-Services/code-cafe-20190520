# Increase history
$MaximumHistoryCount = 10000

# Produce UTF-8 by default
$PSDefaultParameterValues["Out-File:Encoding"]="utf8"

# Show selection menu for tab
Set-PSReadlineKeyHandler -Chord Tab -Function MenuComplete

# turn off annoying bell-type sound
Set-PSReadlineOption -BellStyle None

$shell = $Host.UI.RawUI
# $size = $shell.WindowSize
# $size.width=70
# $size.height=25
# $shell.WindowSize = $size

# $size = $Shell.BufferSize
# $size.width=70
# $size.height=5000
# $Shell.BufferSize = $size

# You can see all the available color options by typing
# [ConsoleColor].GetEnumNames()

$shell.BackgroundColor = "black"
$shell.ForegroundColor = "white"

$colors = $host.PrivateData
$colors.VerboseForegroundColor = "white"
$colors.VerboseBackgroundColor = "blue"
$colors.WarningForegroundColor = "yellow"
$colors.WarningBackgroundColor = "darkgreen"
$colors.ErrorForegroundColor = "white"
$colors.ErrorBackgroundColor = "red"

# $colorScheme = @{
#     None      = "White";
#     Comment   = "Magenta";
#     Keyword   = "Green";
#     String    = "Blue";
#     Operator  = "Yellow";
#     Variable  = "Green";
#     Command   = "Yellow";
#     Parameter = "Green";
#     Type      = "Gray";
#     Number    = "Gray";
#     Member    = "Gray";
# }

# $colorScheme.Keys | % { Set-PSReadlineOption -TokenKind $_ -ForegroundColor $colorScheme[$_] }

Clear-Host
