$env:MAVEN_OPTS="-XX:+TieredCompilation -XX:TieredStopAtLevel=1"

function Maven-Clean { mvn $args clean }
function Maven-Install { mvn $args install }
function Maven-Clean-Install { mvn $args clean install }
function Maven-Release-Clean { mvn $args -B release:clean }
function Maven-Release-Prepare { mvn $args -B "-Dmaven.javadoc.skip=false" release:prepare }

function Maven-Release($releaseVersion, $developmentVersion) { mvn -DreleaseVersion=$releaseVersion -DdevelopmentVersion=$developmentVersion  release:prepare release:perform }
function Maven-Sources { mvn dependency:sources }
function Maven-Versions { mvn -U versions:display-dependency-updates }
function Maven-Versions-Plugins { mvn -U versions:display-plugin-updates }
function Maven-Cobertura { mvn clean cobertura:cobertura }

function Maven-Wrapper-Install { mvn -N io.takari:maven:wrapper }

function Maven-Clean-Install-With-Module($moduleName) {
    if ($moduleName) {
        Maven-Clean-Install -T 1C -pl $moduleName -am
    }
    else {
        Maven-Clean-Install -T 1C
    }
}

function Maven-Install-With-Module($moduleName) {
    if ($moduleName) {
        Maven-Install -T 1C -pl $moduleName -am
    }
    else {
        Maven-Install -T 1C
    }
}

function Maven-Clean-With-Module($moduleName) {
    if ($moduleName) {
        Maven-Clean -T 1C -pl $moduleName -am
    }
    else {
        Maven-Clean -T 1C
    }
}

function Run-Mvn-In-Directory ($directory, $command, $depth = 1) {
    Run-In-Directory $directory $depth "pom.xml" "mvn $command"
}

New-Alias mvnc Maven-Clean
New-Alias mvni Maven-Install
New-Alias mvnci Maven-Clean-Install
New-Alias mvnrc Maven-Release-Clean
New-Alias mvnrp Maven-Release-Prepare
New-Alias mvn-release Maven-Release
New-Alias mvn-sources Maven-Sources
New-Alias mvn-versions Maven-Versions
New-Alias mvn-versions-plugins Maven-Versions-Plugins
New-Alias mvn-cobertura Maven-Cobertura

New-Alias mvnwi Maven-Wrapper-Install

New-Alias mmvnc Maven-Clean-With-Module
New-Alias mmvni Maven-Install-With-Module
New-Alias mmvnci Maven-Clean-Install-With-Module

New-Alias mvn-all Run-Mvn-In-Directory
