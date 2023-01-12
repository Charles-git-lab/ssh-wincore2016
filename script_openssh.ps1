Write-Host "Demarrage du programme d'installation d'OpenSSH pour Windows server core 2016"
# Configuration de la securite SSL
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
Invoke-WebRequest -Uri "https://github.com/PowerShell/Win32-OpenSSH/releases/download/v9.1.0.0p1-Beta/OpenSSH-Win64.zip" -OutFile "OpenSSH-Win64.zip"
Expand-Archive -Path "OpenSSH-Win64.zip" -DestinationPath "C:\Program Files" -force

cd "C:\Program Files\OpenSSH-Win64"
.\install-sshd.ps1

Write-Host "Demarrage et configuration du service"
Start-Service -Name "sshd"
Set-Service -Name "sshd" -StartupType Automatic
Get-Service -Name "sshd"
(Get-Content "C:\ProgramData\ssh\sshd_config") | Select-String "^9" | Foreach-Object { $_.Line.Substring(1) } | Set-Content "C:\ProgramData\ssh\sshd_config"
Restart-Service "sshd"

New-NetFirewallRule -Name sshd -DisplayName 'OpenSSH Server (sshd) - Port 222' -Enabled True -Direction Inbound -Protocol TCP -Action Allow -LocalPort 222

Restart-Service "sshd"