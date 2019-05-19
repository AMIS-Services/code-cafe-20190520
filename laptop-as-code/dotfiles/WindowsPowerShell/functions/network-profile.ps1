function List-Network-Connection-Profiles() {
  Get-NetIPInterface -AddressFamily IPv4 -ConnectionState Connected -Verbose
}

#Set Network Connection Profile to Private.
function Set-Network-Connection-Profile-To-Private() {
  #this works for me to automatically identify my nic - mtu 1500 may vary
  $InterfaceAlias = (Get-NetIPInterface -AddressFamily IPv4 -ConnectionState Connected -NlMtuBytes 1500 -Verbose)

  #change network connection profile to private
  Set-NetConnectionProfile -InterfaceIndex $InterfaceAlias.ifIndex -NetworkCategory Private -PassThru
}
