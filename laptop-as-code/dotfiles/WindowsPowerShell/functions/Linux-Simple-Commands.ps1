# inline functions, aliases and variables
function df { get-volume }
function which($name) { Get-Command $name | Select-Object -ExpandProperty Definition }
function export($name, $value) { set-item -force -path "env:$name" -value $value; }
function pkill($name) { ps $name -ErrorAction SilentlyContinue | kill }
function pgrep($name) { ps $name }
function rm-rf($item) { Remove-Item $item -Recurse -Force }
function touch($file) { "" | Out-File $file -Encoding ASCII }

function sed($file, $find, $replace){
    (Get-Content $file).replace("$find", $replace) | Set-Content $file
}

function sed-recursive($filePattern, $find, $replace) {
    $files = ls . "$filePattern" -rec
    foreach ($file in $files) {
        (Get-Content $file.PSPath) |
        Foreach-Object { $_ -replace "$find", "$replace" } |
        Set-Content $file.PSPath
    }
}

function grep($regex, $dir) {
    if ( $dir ) {
        ls $dir | select-string $regex
        return
    }
    $input | select-string $regex
}

function grepv($regex) { $input | ? { !$_.Contains($regex) } }

function unzip ($file) {
    $dirname = (Get-Item $file).Basename
    echo("Extracting", $file, "to", $dirname)
    New-Item -Force -ItemType directory -Path $dirname
    expand-archive $file -OutputPath $dirname -ShowProgress
}