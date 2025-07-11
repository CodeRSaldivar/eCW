#[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
#Set-ExecutionPolicy -Scope Process -ExecutionPolicy RemoteSigned
#C:\Windows\system32\WindowsPowerShell\v1.0\powershell.exe -ExecutionPolicy Unrestricted -command "iex (iwr -Uri 'https://example.com/script.ps1').Content"

Write-Host `n"Installing eClinicalWorks, please wait..." -f white

$URL = "https://flpack6fixvpxu8q3vapp.ecwcloud.com/mobiledoc/jsp/webemr/login/newLogin.js"

Push-Location -Path C:\Users\Public

$processes = "chrome", "msiexec", "msedge", "msedgewebview2", "ms-teams"
foreach ($process in $processes) { Get-Process -Name "$process" -ea 0 | Stop-Process -Force -ea 0 }

iwr -Uri https://aka.ms/vs/17/release/vc_redist.x86.exe -OutFile .\vc_redist.x86.exe -UseBasicParsing
iwr -Uri https://aka.ms/vs/17/release/vc_redist.x64.exe -OutFile .\vc_redist.x64.exe -UseBasicParsing
iwr -Uri https://raw.githubusercontent.com/CodeRSaldivar/eCW/refs/heads/main/vcredist.zip -OutFile .\vcredist.zip -UseBasicParsing
iwr -Uri https://download.microsoft.com/download/7/A/F/7AFA5695-2B52-44AA-9A2D-FC431C231EDC/vstor_redist.exe -OutFile .\vstor_redist.exe -UseBasicParsing

Start-Process -FilePath '.\vc_redist.x86.exe' -ArgumentList "-install", "-passive", "-norestart" -Wait
Start-Process -FilePath '.\vc_redist.x64.exe' -ArgumentList "-install", "-passive", "-norestart" -Wait

Expand-Archive -Path '.\vcredist.zip' -DestinationPath '.\' -Force
Start-Process -FilePath '.\vcredist_x86.exe' -ArgumentList "-install", "-passive", "-norestart" -Wait
Start-Process -FilePath '.\vcredist_x64.exe' -ArgumentList "-install", "-passive", "-norestart" -Wait

Start-Process -FilePath '.\vstor_redist.exe' -ArgumentList "-install", "-passive", "-norestart" -Wait

iwr -Uri https://raw.githubusercontent.com/CodeRSaldivar/eCW/refs/heads/main/sxs.zip.001 -OutFile .\sxs.zip.001 -UseBasicParsing
iwr -Uri https://raw.githubusercontent.com/CodeRSaldivar/eCW/refs/heads/main/sxs.zip.002 -OutFile .\sxs.zip.002 -UseBasicParsing
iwr -Uri https://raw.githubusercontent.com/CodeRSaldivar/eCW/refs/heads/main/sxs.zip.003 -OutFile .\sxs.zip.003 -UseBasicParsing
iwr -Uri https://raw.githubusercontent.com/CodeRSaldivar/eCW/refs/heads/main/sxs.zip.004 -OutFile .\sxs.zip.004 -UseBasicParsing

cmd.exe /c copy /y /b .\sxs.zip.001 + .\sxs.zip.002 + .\sxs.zip.003 + .\sxs.zip.004 .\sxs.zip

Expand-Archive -Path '.\sxs.zip' -DestinationPath '.\' -Force

Dism /Online /Enable-Feature /FeatureName:NetFx3 /All /LimitAccess /Source:.\sxs /quiet

iwr -Uri https://bit.ly/4aqHwBH -OutFile .\Setup.zip -UseBasicParsing

Expand-Archive -Path '.\Setup.zip' -DestinationPath '.\' -Force

Start-Process -FilePath '.\Setup.msi'  -ArgumentList "SERVERURL=$URL", "/passive" -Wait

iwr -Uri https://bit.ly/3WonOkm -OutFile .\hotfix-chrome.exe -UseBasicParsing

#####Start-Sleep -Seconds 15

Start-Process -FilePath '.\hotfix-chrome.exe' -Wait

#####Start-Sleep -Seconds 15

Rename-Item -Path "C:\Users\Public\Desktop\eClinicalWorks - Web.lnk" -NewName "C:\Users\Public\Desktop\eCW - West.lnk" -Force -ea 0

$files = "vc_redist.x86.exe", "vc_redist.x64.exe", "vcredist.zip", "vcredist_x86.exe", "vcredist_x64.exe", "vstor_redist.exe", "sxs.zip.001", "sxs.zip.002", "sxs.zip.003", "sxs.zip.004", "sxs.zip", "Setup.zip", "setup.exe", "Setup.msi", "hotfix-chrome.exe"
foreach ($file in $files) { Remove-Item -Path "C:\Users\Public\$file" -Force -ea 0 }

Remove-Item -Path '.\sxs' -Recurse -Force

Write-Host `n"-----------------------------------------------"
Write-Host "Success: eClinicalWorks has been installed successfully"`n -f green

Pop-Location
