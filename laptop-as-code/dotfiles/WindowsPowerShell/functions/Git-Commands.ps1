function Git-Status { git status -s }

function Git-Squash($number) { git rebase -i HEAD~$number }
function Git-Prune { git remote prune origin }
function Git-Permissions($perm, $file) { git update-index --chmod=$perm $file }
function Git-Edit-Comment { git commit --amend }

function Git-Clone {
    param([string]$repository = "", [string]$folder ="")

    git clone $repository

    cd $folder

    git submodule update --init

}

function Git-Checkout-Remote {
    param([string]$branch = "")

    git checkout -b $branch --track origin/$branch
}

function Run-Git-In-Directory ($directory, $command, $depth = 1) {
    Run-In-Directory $directory $depth ".git" "git $command"
}

set-alias gits Git-Status
set-alias gitc Git-Clone
set-alias gitbranch Git-Checkout-Remote
New-Alias git-all Run-Git-In-Directory

function Git-Checkout-PullRequest{
    param
    (
        [Parameter(Position=0, Mandatory=$true, HelpMessage='The pull request number')]
        [int]$PR,
        [Parameter(Mandatory=$false, HelpMessage='The branch to check the PR out into')]
        [string]$B
    )
    $branch = if([string]::IsNullOrEmpty($B)) {"PR-$PR"} else {$B}
    Invoke-Expression "git fetch origin pull/$PR/head:$branch"
    Invoke-Expression "git checkout $branch"
}

function Git-Rebase-PullRequest{
    Invoke-Expression 'git fetch origin; git rebase -i origin/master'
}

function Git-Merge-PullRequest{
    param
    (
        [Parameter(Position=0, Mandatory=$true, HelpMessage='The pull request number')]
        [int]$PR
    )
    $branch = {"PR-$PR"}
    Invoke-Expression "git checkout master"
    Invoke-Expression "git merge $branch"
}

function Git-Push-PullRequest{
    Invoke-Expression 'git push origin master'
    Invoke-Expression 'git push'
}
