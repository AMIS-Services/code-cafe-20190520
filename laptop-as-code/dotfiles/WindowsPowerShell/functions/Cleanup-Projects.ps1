function Cleanup-Projects ($directory = ".", $depth = 1) {
    Cleanup-Directory $directory $depth "build.gradle" "build" ".gradle"
    Cleanup-Directory $directory $depth "pom.xml" "target" "release.properties"
    Cleanup-Directory $directory $depth "package.json" "node_modules" "dist" "build" "npm-debug.log" "yarn-debug.log" "yarn-error.log"
}

function Cleanup-Directory () {
    Param(
        [string]$directory,
        [string]$depth,
        [string]$merkerFilename,
        [parameter(ValueFromRemainingArguments = $true)]
        [string[]]$items
    )

    Get-ChildItem -recurse -Depth $depth -force $directory -Filter $merkerFilename |
    foreach {
        if ($_.PSIsContainer) {
            Cleanup-Command $_.parent.FullName $items
        }
        else {
            Cleanup-Command $_.Directory.FullName $items
        }
    }
}

function Cleanup-Command ($directory, $items) {
  Foreach ($item in $items) {
    if (Test-Path "$directory/$item") {
      Write-Host "$directory : Removing $item"
      pushd $directory; Remove-Item -Path $item -Force -Recurse ; popd;
    }
    # else {
    #   Write-Host "$directory : not found: $item"
    # }
  }
}
