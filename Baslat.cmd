@echo off
REM MrClean baslatici (v2.0.0) - cift tiklayin. UAC ister, siyah cmd birakmaz.
REM ASCII only (cmd Turkce / ozel karakterleri bozar).
REM
REM Neden bazi PC'lerde siyah pencere vardi:
REM  1) MRC_SELF elevate'den SONRA set ediliyordu -> UAC sonrasi bos cmd.exe kaliyordu.
REM  2) "zaten acik mi" kontrolu gorunur powershell.exe idi (WindowStyle Hidden yok).
REM  3) Windows Terminal varsayilan olunca powershell -WindowStyle Hidden yutulmayabiliyor.
REM Cozum: conhost --headless + yollar en basta + hatalar MessageBox.
setlocal
set "MRC_SELF=%~f0"
set "PS1=%~dp0TemizlikAsistani.ps1"
set "EXE=%~dp0TemizlikAsistani.exe"
set "PWSH=%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe"
set "CH=%SystemRoot%\System32\conhost.exe"

if /I "%~1"=="_MRC" goto :BODY
start "" "%CH%" --headless cmd.exe /d /c "%MRC_SELF%" _MRC
exit /b

:BODY
net session >nul 2>&1
if errorlevel 1 goto :ELEVATE
goto :ADMIN_OK

:ELEVATE
"%PWSH%" -NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -Command "Start-Process -FilePath '%CH%' -Verb RunAs -ArgumentList '--headless cmd.exe /d /c \"%MRC_SELF%\" _MRC'"
exit /b

:ADMIN_OK
cd /d "%~dp0"
if exist "%EXE%" goto :RUN_EXE
if not exist "%PS1%" goto :NOFILE

"%PWSH%" -NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -Command "if (Get-CimInstance Win32_Process -Filter \"Name='powershell.exe'\" | Where-Object { $_.ProcessId -ne $PID -and $_.CommandLine -like '*TemizlikAsistani.ps1*' }) { exit 1 } else { exit 0 }"
if errorlevel 1 goto :RUNNING

start "" "%CH%" --headless "%PWSH%" -NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File "%PS1%"
exit /b 0

:RUN_EXE
start "" "%EXE%"
exit /b 0

:RUNNING
"%PWSH%" -NoProfile -WindowStyle Hidden -Command "Add-Type -AssemblyName PresentationFramework; [void][System.Windows.MessageBox]::Show('MrClean zaten acik - gorev cubugunu kontrol edin.','MrClean')"
exit /b

:NOFILE
"%PWSH%" -NoProfile -WindowStyle Hidden -Command "Add-Type -AssemblyName PresentationFramework; [void][System.Windows.MessageBox]::Show('HATA: TemizlikAsistani.ps1 bu klasorde bulunamadi.','MrClean')"
exit /b 1
