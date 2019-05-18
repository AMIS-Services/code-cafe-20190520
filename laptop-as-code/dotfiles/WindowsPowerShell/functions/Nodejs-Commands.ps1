function Run-Yarn-In-Directory ($directory, $command, $depth = 1) {
    Run-In-Directory $directory $depth "package.json" "yarn $command"
}
New-Alias yarn-all Run-Yarn-In-Directory

function Run-Npm-In-Directory ($directory, $command, $depth = 1) {
    Run-In-Directory $directory $depth "package.json" "npm $command"
}
New-Alias npm-all Run-Npm-In-Directory

function Node-Global-Install() {
  npm install -`g $args
}
New-Alias npmig Node-Global-Install

function Node-Install() {
  npm install -`-global $args
}
New-Alias npmi Node-Install


