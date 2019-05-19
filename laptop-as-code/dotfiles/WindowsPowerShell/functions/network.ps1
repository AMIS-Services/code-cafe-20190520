function Find-Port { netstat -aon|findstr `"$args`"}
Set-Alias port Find-Port
