# Get Firewall rules for Network Discovery
function List-Network-Discovery {
  Get-NetFirewallRule -DisplayGroup 'Network Discovery'|select Name,DisplayName,Enabled,Profile|ft -a
}

# Enable Network Discovery for Private and Domain network profiles
function Enable-Network-Discovery {
  Get-NetFirewallRule -DisplayGroup 'Network Discovery'|Set-NetFirewallRule -Profile 'Private, Domain' -Enabled true -PassThru|select Name,DisplayName,Enabled,Profile|ft -a
}

# Disable Network Discovery for all network profiles
function Disable-Network-Discovery {
  Get-NetFirewallRule -DisplayGroup 'Network Discovery'|Set-NetFirewallRule -Enabled false -PassThru|select Name,DisplayName,Enabled,Profile|ft -a
}
