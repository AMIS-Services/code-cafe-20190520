#
# set path to include my usual directories
# and configure dev environment
#
function script:append-path([string] $path ) {
   if ( -not [string]::IsNullOrEmpty($path) ) {
      if ( (test-path $path) -and (-not $env:PATH.contains($path)) ) {
         $env:PATH += ';' + $path
      }
   }
}
