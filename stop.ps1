param()
$guardPath = Join-Path $PSScriptRoot 'guard.ps1'
Get-CimInstance Win32_Process -Filter "Name='powershell.exe'" |
    Where-Object {
        $_.ProcessId -ne $PID -and
        $_.CommandLine -and
        $_.CommandLine.Contains('-File "' + $guardPath + '"')
    } | ForEach-Object { Stop-Process -Id $_.ProcessId }
