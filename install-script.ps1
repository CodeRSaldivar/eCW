[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
Set-ExecutionPolicy -Scope Process -ExecutionPolicy RemoteSigned

$URL = "https://flpack6fixvpxu8q3vapp.ecwcloud.com/mobiledoc/jsp/webemr/login/newLogin.js"

Write-Host `n"Installing eClinicalWorks, please wait..." -f white

Push-Location -Path C:\Users\Public

$processes = "chrome", "msiexec", "msedge", "msedgewebview2", "ms-teams"
foreach ($process in $processes) {
Get-Process -Name "$process" -ea 0 | Stop-Process -Force -ea 0
}

curl -L -O https://aka.ms/vs/17/release/vc_redist.x86.exe --silent --show-error
Start-Sleep -Seconds 3
start /wait .\vc_redist.x86.exe /install /passive /norestart

curl -L -O https://aka.ms/vs/17/release/vc_redist.x64.exe --silent --show-error
Start-Sleep -Seconds 3
start /wait .\vc_redist.x64.exe /install /passive /norestart

curl -L -O https://download.microsoft.com/download/7/A/F/7AFA5695-2B52-44AA-9A2D-FC431C231EDC/vstor_redist.exe --silent --show-error
Start-Sleep -Seconds 3
start /wait .\vstor_redist.exe /install /passive /norestart

curl -L -O https://raw.githubusercontent.com/CodeRSaldivar/eCW/refs/heads/main/sxs.zip.001 --silent --show-error
curl -L -O https://raw.githubusercontent.com/CodeRSaldivar/eCW/refs/heads/main/sxs.zip.002 --silent --show-error
curl -L -O https://raw.githubusercontent.com/CodeRSaldivar/eCW/refs/heads/main/sxs.zip.003 --silent --show-error
curl -L -O https://raw.githubusercontent.com/CodeRSaldivar/eCW/refs/heads/main/sxs.zip.004 --silent --show-error

cmd.exe /c copy /y /b .\sxs.zip.001 + .\sxs.zip.002 + .\sxs.zip.003 + .\sxs.zip.004 .\sxs.zip

Expand-Archive -Path '.\sxs.zip' -DestinationPath '.\'

Dism /Online /Enable-Feature /FeatureName:NetFx3 /All /LimitAccess /Source:.\sxs

curl -L -O https://ecwversionreleasefiles01.blob.core.windows.net/ecwversionreleasefiles01-4b89-81bb-dcbb5e3949b9/Windows_Plugin_6.3.992/Setup.zip?sv=2023-01-03&st=2025-01-23T06:50:52Z&se=2028-01-24T06:50:00Z&sr=b&sp=r&sig=K4KYU066BuImyurWnZ5L8pfBRqgMX9Q5c4KErDqVYNs%3D --silent --show-error

#tar -xf Setup.zip
Expand-Archive -Path '.\sxs.zip' -DestinationPath '.\'

.\Setup.msi SERVERURL=$URL /passive

curl -L -O https://ecwversionreleasefiles01.blob.core.windows.net/ecwversionreleasefiles01-4b89-81bb-dcbb5e3949b9/hotfix-chrome_IR_5994741/hotfix-chrome.exe?sv=2023-01-03&st=2025-01-18T16:24:05Z&se=2028-01-19T16:24:00Z&sr=b&sp=r&sig=tlYdTdTGq9BlrN9l34zRCNqouvRiNWeBynhu2/7z48Y%3D --silent --show-error

Start-Sleep -Seconds 15

.\hotfix-chrome.exe

Start-Sleep -Seconds 15

Rename-Item -Path "C:\Users\Public\Desktop\eClinicalWorks - Web.lnk" -NewName "C:\Users\Public\Desktop\eCW - West.lnk" -Force -ea 0

$files = "vc_redist.x86.exe", "vc_redist.x64.exe", "vstor_redist.exe", "sxs.zip.001", "sxs.zip.002", "sxs.zip.003", "sxs.zip.004", "sxs.zip", "Setup.zip", "setup.exe", "Setup.msi", "hotfix-chrome.exe"
foreach ($file in $files) {
Remove-Item -Path "C:\Users\Public\$file" -Force -ea 0
}

Remove-Item -Path '.\sxs' -Recurse -Force

Pop-Location

Write-Host `n"-----------------------------------------------"
Write-Host "Success: eClinicalWorks plugin has been installed successfully"`n -f green
