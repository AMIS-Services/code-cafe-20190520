# Get Firewall rules for File and Printer Sharing
function List-Network-File-Sharing {
  Get-NetFirewallRule -DisplayGroup 'File and Printer Sharing'|select Name,DisplayName,Enabled,Profile|ft -a
}

# Enable File and Printer Sharing for Private and Domain network profiles
function Enable-Network-File-Sharing {
  Get-NetFirewallRule -DisplayGroup 'File and Printer Sharing'|Set-NetFirewallRule -Profile 'Private, Domain' -Enabled true -PassThru|select Name,DisplayName,Enabled,Profile|ft -a
}

# Disable File and Printer Sharing for all network profiles
function Disable-Network-File-Sharing {
  Get-NetFirewallRule -DisplayGroup 'File and Printer Sharing'|Set-NetFirewallRule -Enabled false -PassThru|select Name,DisplayName,Enabled,Profile|ft -a
}
