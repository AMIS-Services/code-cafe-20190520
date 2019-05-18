function Create-SymLink([string]$name, [string]$target) {
  if ((Test-Path $name) -And !(Test-ReparsePoint $name)) {
    if ((Test-Path $name) -And !(Test-Path $target)) {
      Write-Host "Move-Item: " $name " to " $target
      Move-Item $name $target
    }
    else {
      $file = Get-Item $name
      Write-Host "Rename-Item: " $name " to " $name ".old"
      Rename-Item $name -NewName ($file.Name + ".old")
    }
  }
  if (Test-Path $target) {
    if (!(Test-ReparsePoint $name)) {
      $symLink = New-Item -ItemType SymbolicLink -Path $name -Value $target
      If(Test-ReparsePoint $name) {
        Write-Host "Created SymbolicLink: " $name " to " $target
      }
      else {
        Write-Host "SymbolicLink NOT created: " $name " to " $target
      }
    }
  }
  else {
    Write-Host "Target does NOT exist: " $target
  }
}

function Test-ReparsePoint([string]$path) {
  $file = Get-Item $path -Force -ea SilentlyContinue
  return [bool]($file.Attributes -band [IO.FileAttributes]::ReparsePoint)
}

function Create-HardLink([string]$name, [string]$target) {
  if (!(Test-Path $name) -And (Test-Path $target)) {
      $hardLink = New-Item -ItemType HardLink -Path $name -Value $target
      If(Test-Path $name) {
        Write-Host "Created HardLink: " $name " to " $target
      }
      else {
        Write-Host "HardLink NOT created: " $name " to " $target
      }
  }
  else {
    if ((Test-Path $name) -And !(Test-Path $target)) {
      $hardLink = New-Item -ItemType HardLink -Path $target -Value $name
      If(Test-Path $target) {
        Write-Host "Created HardLink: " $name " to " $target
      }
      else {
        Write-Host "HardLink NOT created: " $name " to " $target
      }
    }
    else {
      if (!(Test-Path $name) -And !(Test-Path $target)) {
        Write-Host "Both ends of the Hardlink do NOT exist: " $name " to " $target
      }
    }
  }
}

function Create-Directory([string]$path) {
  If(!(test-path $path)) {
        New-Item -ItemType Directory -Force -Path $path
  }
}
