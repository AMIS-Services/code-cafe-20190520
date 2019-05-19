function Verify-Hash{
    param
    (
        [Parameter(Mandatory=$true, HelpMessage='The .MD5 file.')]
        [string]$File,
        [Parameter(Mandatory=$true, HelpMessage='The Algorithm to use')]
        [string]$Algorithm
    )
    foreach ($line in (Get-Content $File)) {
        $fields = $line -split '\s+'
        $hash = $fields[0].Trim().ToUpper()
        $filename = $fields[1].Trim()
        if($filename.StartsWith("*")){
            $filename = $filename.Substring(1).Trim()
        }
        $computedHash = (Get-FileHash -Algorithm $Algorithm $filename).Hash.ToUpper()
        if($hash.Equals($computedHash)){
            Write-Host $filename, ": Passed"
        }else{
            Write-Host $filename, ": Not Passed"
            Write-Host "Read from file: ", $hash
            Write-Host "Computed:       ", $computedHash
        }
    }
}
function Verify-MD5{
    param
    (
        [Parameter(Position=0, Mandatory=$true, HelpMessage='The .MD5 file.')]
        [string]$File
    )
    Verify-Hash -Algorithm MD5 -File $File
}
function Verify-SHA512{
    param
    (
        [Parameter(Position=0, Mandatory=$true, HelpMessage='The .SHA512 file.')]
        [string]$File
    )
    Verify-Hash -Algorithm SHA512 -File $File
}