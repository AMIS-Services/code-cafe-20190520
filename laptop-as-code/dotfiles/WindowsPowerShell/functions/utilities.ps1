# calculate a hash from a string
function convert-tobinhex($array) {
   $str = new-object system.text.stringbuilder
   $array | %{
      [void]$str.Append($_.ToString('x2'));
   }
   return $str.ToString()
}
function convert-frombinhex([string]$binhex) {
   $arr = new-object byte[] ($binhex.Length/2)
   for ( $i=0; $i -lt $arr.Length; $i++ ) {
      $arr[$i] = [Convert]::ToByte($binhex.substring($i*2,2), 16)
   }
   return $arr
}
function get-hash($value, $hashalgo = 'MD5') {
   $tohash = $value
   if ( $value -is [string] ) {
      $tohash = [text.encoding]::UTF8.GetBytes($value)
   }
   $hash = [security.cryptography.hashalgorithm]::Create($hashalgo)
   return convert-tobinhex($hash.ComputeHash($tohash));
}
function escape-html($text) {
   $text = $text.Replace('&', '&amp;')
   $text = $text.Replace('"', '&quot;')
   $text = $text.Replace('<', '&lt;')
   $text.Replace('>', '&gt;')
}

# ugly, ugly, ugly
function to-binle([long]$val) {
   [Convert]::ToString($val, 2)
}

function byteToChar([byte]$b) {
   if ( $b -lt 32 -or $b  -gt 127 ) {
      '.'
   } else {
      [char]$b
   }
}
function format-bytes($bytes, $bytesPerLine = 8) {
   $buffer = new-object system.text.stringbuilder
   for ( $offset=0; $offset -lt $bytes.Length; $offset += $bytesPerLine ) {
      [void]$buffer.AppendFormat('{0:X8}   ', $offset)
      $numBytes = [math]::min($bytesPerLine, $bytes.Length - $offset)
      for ( $i=0; $i -lt $numBytes; $i++ ) {
         [void]$buffer.AppendFormat('{0:X2} ', $bytes[$offset+$i])
      }
      [void]$buffer.Append(' ' *((($bytesPerLine - $numBytes)*3)+3))
      for ( $i=0; $i -lt $numBytes; $i++ ) {
         [void]$buffer.Append( (byteToChar $bytes[$offset + $i]) )
      }
      [void]$buffer.Append("`n")
   }
   $buffer.ToString()
}
function convertfrom-b64([string] $str) {
   [convert]::FromBase64String($str)
}
function normalize-array($array, [int]$offset, [int]$len=$array.Length-$offset) {
   $dest = new-object $array.GetType() $len
   [array]::Copy($array, $offset, $dest, 0, $len)
   $dest
}
