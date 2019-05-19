function showServerCert($server, $port = 443) {
  openssl s_client -showcerts -status -servername $server -connect ${server}:${port}
}

function showServerCertWithCLient($server, $name, $port = 443 ) {
  openssl s_client -showcerts -status -servername $server -connect ${server}:${port}  -cert "${name}-publickey.pem" -key "${name}-unencrypted-privatekey.pem" -CAfile "${name}-cachain.pem"
}

function showPfx($cert) {
  openssl pkcs12 -info -in $cert
}

function showP12($cert) {
  openssl pkcs12 -info -in $cert
}

function showCert($cert) {
  openssl x509 -noout -text -in $cert
}

function showCsr($csr) {
  openssl req -noout -text -in $csr
}

function showCrl($crl) {
  openssl crl -noout  -text -in $crl
}

function showCrlDer($crl) {
  openssl crl -inform DER -noout  -text -in $crl
}

function showKey($key) {
  openssl rsa -in $key -check
}

function verifySSLServer($name) {
  openssl verify -verbose -purpose sslserver -CAfile "${name}-cachain.pem" "${name}-publickey.pem"
}

function PfxPrivateKey($name) {
  openssl pkcs12 -in "${name}.pfx" -nocerts -out "${name}-encrypted-privatekey.pem"
}

function PfxUnencryptedPrivateKey($name) {
  openssl pkcs12 -in "${name}.pfx" -nocerts -nodes -out "${name}-unencrypted-privatekey.pem"
}

function PfxCertificate($name) {
  openssl pkcs12 -in "${name}.pfx" -clcerts -nokeys -out "${name}-publickey.pem"
}

function PfxCAChain($name) {
  openssl pkcs12 -in "${name}.pfx" -cacerts -nokeys -chain -out "${name}-cachain.pem"
}

function PemToP12($name) {
  openssl pkcs12 -export -in "${name}-publickey.pem" -inkey "${name}-unencrypted-privatekey.pem" -name "${name}" -out "${name}-keystore.p12"
}

function PemToPfx($name) {
  openssl pkcs12 -export -in "${name}-publickey.pem" -inkey "${name}-unencrypted-privatekey.pem" -out "${name}-keystore.pfx"
}

function PemToDer($name) {
  openssl x509 -in "${name}.pem" -inform pem -out "${name}.cer" -outform der
}

function DerToPem($name) {
  openssl x509 -in "${name}.cer" -inform der -out "${name}.pem" -outform pem
}

function PfxToP12($name) {
  PfxPrivateKey($name)
  PfxUnencryptedPrivateKey($name)
  PfxCertificate($name)
  PfxCAChain($name)
  PemToP12($name)
}

function P12ToJKS($name) {
  keytool -importkeystore -srckeystore "${name}-keystore.p12" -srcstoretype pkcs12 -destkeystore "${name}-keystore.jks" -destkeystore JKS
}

function selfSignedJks($name, $keystore = "keystore.jks", $password = "changeit", $alias = "tomcat") {
  keytool -genkey -keystore $keystore -storetype JKS -storepass $password -keypass $password -alias $alias -keyalg RSA -keysize 2048 -validity 99999 -dname "CN=${name}, OU=Unknown, O=Unknown, L=Unknown, ST=Unknown, C=NL" -ext san=dns:example.com,dns:localhost,ip:127.0.0.1
}

function selfSignedP12($name, $keystore = "keystore.p12", $password = "changeit", $alias = "tomcat") {
  keytool -genkeypair -keystore "$keystore" -storetype PKCS12 -storepass $password -keypass $password -alias $alias -keyalg RSA -keysize 2048 -validity 99999 -dname "CN=${name}, OU=Unknown, O=Unknown, L=Unknown, ST=Unknown, C=NL" -ext san=dns:example.com,dns:localhost,ip:127.0.0.1
}

function keyImportJKS($cert, $keystore = "keystore.p12", $alias = "tomcat", $password = "changeit") {
    Write-Host $keystore

  keytool -import -alias $alias -file "$cert" -keystore "$keystore" -storetype JKS -storepass $password
}

function keyImportP12($cert, $keystore = "keystore.p12", $alias = "tomcat", $password = "changeit") {
  keytool -import -alias $alias -file "$cert" -keystore "$keystore" -storetype PKCS12 -storepass $password
}

function keyListJKS($keystore = "keystore.p12", $password = "changeit") {
  keytool -list -keystore "$keystore" -storetype JKS -storepass $password
}

function keyListP12($keystore = "keystore.p12", $password = "changeit") {
  keytool -list -keystore $keystore -storetype PKCS12 -storepass $password
}

function keyDownloadServerKey($server, $port = 443) {
  keytool "-J-Djava.net.useSystemProxies=true" -printcert -rfc -sslserver "${server}:${port}" > "${server}.pem"
}

function keyImportJava($cert, $alias, $keystore = "$Env:JAVA_HOME\jre\lib\security\cacerts", $password = "changeit") {
  keyImportJKS $cert  $keystore  $password  $alias
}

function keyImportAllJava($cert, $alias) {
  Get-ChildItem -Directory "C:\Program Files\Java" | % {
    Write-Host $_.FullName
    if (Test-Path "$_.FullName\jre\lib\security\cacerts"){
      keyImportJava $cert $alias "$_.FullName\jre\lib\security\cacerts"
    }
    else {
      keyImportJava $cert $alias "$_.FullName\lib\security\cacerts"
    }
  }
}
