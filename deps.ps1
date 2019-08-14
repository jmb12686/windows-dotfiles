# TODO: Add VSCode settings import


# Check to see if we are currently running "as Administrator"
if (!(Verify-Elevated)) {
    $newProcess = new-object System.Diagnostics.ProcessStartInfo "PowerShell";
    $newProcess.Arguments = $myInvocation.MyCommand.Definition;
    $newProcess.Verb = "runas";
    [System.Diagnostics.Process]::Start($newProcess);
 
    exit
 }
 
 
 ### Update Help for Modules
 Write-Host "Updating Help..." -ForegroundColor "Yellow"
 Update-Help -Force
 
 ### Chocolatey
 Write-Host "Installing Desktop Utilities..." -ForegroundColor "Yellow"
 if ((which cinst) -eq $null) {
     iex (new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1')
     Refresh-Environment
     choco feature enable -n=allowGlobalConfirmation
 }
 
 # programming languages system and cli
 choco install curl                            --limit-output
 choco install git.install                     --limit-output -params '"/GitAndUnixToolsOnPath /NoShellIntegration"'
 choco install nvm.portable                    --limit-output
 choco install python                          --limit-output
 choco install golang                          --limit-output

 # browsers
 choco install GoogleChrome                    --limit-output; choco pin add --name GoogleChrome        --limit-output
 choco install Firefox                         --limit-output; choco pin add --name Firefox             --limit-output
 
 # dev tools and frameworks
 choco install vscode                          --limit-output; choco pin add --name vscode              --limit-output
 choco install sublimetext3                    --limit-output
 choco install docker-desktop                  --limit-output; choco pin add --name docker-desktop      --limit-output
 

# general utilities
choco install microsoft-windows-terminal       --limit-output
choco install openvpn                          --limit-output
 choco install vlc                             --limit-output
 choco install yarn                            --limit-output
 choco install adobereader                     --limit-output
 choco install 7zip.install                    --limit-output
 choco install putty.install                   --limit-output
 
 Refresh-Environment
 
 nvm on
 $nodeLtsVersion = choco search nodejs-lts --limit-output | ConvertFrom-String -TemplateContent "{Name:package-name}\|{Version:1.11.1}" | Select -ExpandProperty "Version"
 nvm install $nodeLtsVersion
 nvm use $nodeLtsVersion
 Remove-Variable nodeLtsVersion
 
 ### Windows Features
 Write-Host "Installing Windows Features..." -ForegroundColor "Yellow"

 # Hyper-V
 Enable-WindowsOptionalFeature -Online -All -FeatureName `
    "Microsoft-Hyper-V", `
    "HypervisorPlatform" `
    -NoRestart | Out-Null
    
### Microsoft Store
# Write-Host "Installing Microsoft Store Apps..." -ForegroundColor "Yellow"
# CanonicalGroupLimited.Ubuntu18.04onWindows
# Microsoft.WindowsTerminal


 ### Node Packages
 Write-Host "Installing Node Packages..." -ForegroundColor "Yellow"
 if (which npm) {
     npm update npm
     npm install -g serverless
     npm install -g typescript
 }

 ### Install VS Code Extensions
 Write-Host "Installing VS Code Extensions" -ForegroundColor "Yellow"
 code --install-extension christian-kohler.npm-intellisense
 code --install-extension eg2.vscode-npm-script
 code --install-extension ms-azuretools.vscode-docker
 code --install-extension ms-vscode-remote.remote-containers
 code --install-extension ms-vscode-remote.remote-ssh
 code --install-extension ms-vscode-remote.remote-ssh-edit
 code --install-extension ms-vscode-remote.remote-ssh-explorer
 code --install-extension ms-vscode-remote.remote-wsl
 code --install-extension ms-vscode-remote.vscode-remote-extensionpack
 code --install-extension ms-vscode.Go
 code --install-extension ms-vscode.powershell
 code --install-extension ms-vscode.vscode-typescript-tslint-plugin
 code --install-extension redhat.java
 code --install-extension VisualStudioExptTeam.vscodeintellicode
 code --install-extension vscjava.vscode-java-debug
 code --install-extension vscjava.vscode-java-dependency
 code --install-extension vscjava.vscode-java-pack
 code --install-extension vscjava.vscode-java-test
 code --install-extension vscjava.vscode-maven
 code --install-extension vscjava.vscode-spring-initializr
 

 ### Install WSL Ubuntu LTS Distro
 Write-Host "Installing Ubuntu WSL Distro" -ForegroundColor "Yellow"
 Invoke-WebRequest -Uri https://aka.ms/wsl-ubuntu-1804 -OutFile ~/wsl-ubuntu-1804.appx -UseBasicParsing
 Add-AppxPackage ~/wsl-ubuntu-1804.appx
