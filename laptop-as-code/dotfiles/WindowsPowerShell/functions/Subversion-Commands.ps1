
function Run-Svn-In-Directory ($directory, $command, $depth = 1) {
    Run-In-Directory $directory $depth ".svn" "svn $command"
}

New-Alias svn-all Run-Svn-In-Directory
