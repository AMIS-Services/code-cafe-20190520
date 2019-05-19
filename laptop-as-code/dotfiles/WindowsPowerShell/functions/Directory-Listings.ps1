# LS.MSH
# Colorized LS function replacement
# /\/\o\/\/ 2006
# http://mow001.blogspot.com
function LL
{
    param ($dir = ".", $all = $false)

    $origFg = $host.ui.rawui.foregroundColor
    if ( $all ) { $toList = ls -force $dir }
    else { $toList = ls $dir }

    foreach ($Item in $toList)
    {
        Switch ($Item.Extension)
        {
            ".Exe" {$host.ui.rawui.foregroundColor = "Yellow"}
            ".cmd" {$host.ui.rawui.foregroundColor = "Red"}
            ".msh" {$host.ui.rawui.foregroundColor = "Red"}
            ".vbs" {$host.ui.rawui.foregroundColor = "Red"}
            Default {$host.ui.rawui.foregroundColor = $origFg}
        }
        if ($item.Mode.StartsWith("d")) {$host.ui.rawui.foregroundColor = "Green"}
        $item
    }
    $host.ui.rawui.foregroundColor = $origFg
}

function lla
{
    param ( $dir=".")
    ll $dir $true
}

function la { ls -force }

function Run-In-Directory ($directory, $depth, $merkerFilename, $command) {
    Get-ChildItem -recurse -Depth $depth -force $directory -Filter $merkerFilename |
    foreach {
        if ($_.PSIsContainer) {
            Run-Command $_.parent.FullName $command
        }
        else {
            Run-Command $_.Directory.FullName $command
        }
    }
}

function Run-Command ($directory, $command) {
    echo "Running in '$directory' the command '$command'"
    pushd $directory; Invoke-Expression -Command $command ; popd;
}
