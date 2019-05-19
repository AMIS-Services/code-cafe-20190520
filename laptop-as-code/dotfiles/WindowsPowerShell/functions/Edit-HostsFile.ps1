function Edit-HostsFile {
    Start-Process  -Verb RunAs -FilePath notepad -ArgumentList "$env:windir\system32\drivers\etc\hosts"
}
