function VisualStudioCode-Install-Extension($extension) {
  code --install-extension $extension
}
New-Alias vscext VisualStudioCode-Install-Extension

vscext "abusaidm.html-snippets"
vscext "christian-kohler.npm-intellisense"
vscext "CoenraadS.bracket-pair-colorizer"
vscext "cssho.vscode-svgviewer"
vscext "DavidAnson.vscode-markdownlint"
vscext "dbaeumer.jshint"
vscext "dbaeumer.vscode-eslint"
vscext "editorconfig.editorconfig"
vscext "HookyQR.beautify"
vscext "ms-vscode.PowerShell"
vscext "msjsdiag.debugger-for-chrome"
vscext "PeterJausovec.vscode-docker"
