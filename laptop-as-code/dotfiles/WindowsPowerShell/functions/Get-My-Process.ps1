# get our own process information
function get-myprocess {
   [diagnostics.process]::GetCurrentProcess()
}