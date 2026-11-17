param([switch]$Check)

$ErrorActionPreference = 'Stop'
$signature = 'diff\.autoRefreshIndex=false.*--find-renames --raw --no-abbrev --numstat'

function Stop-CodexDiff {
    param($GitProcess)
    if ($GitProcess.CommandLine -match $signature) {
        Stop-Process -Id $GitProcess.ProcessId -ErrorAction SilentlyContinue
    }
}

if ($Check) {
    Get-CimInstance Win32_Process -Filter "Name='git.exe'" |
        Where-Object CommandLine -Match $signature |
        Select-Object ProcessId, ParentProcessId
    return
}

$mutex = [Threading.Mutex]::new($false, 'Local\CodexGitDiffGuard')
try {
    try { $ownsMutex = $mutex.WaitOne(0) }
    catch [Threading.AbandonedMutexException] { $ownsMutex = $true }
    if (-not $ownsMutex) { return }

    $seen = @{}
    while ($true) {
        $current = @{}
        foreach ($git in Get-Process git -ErrorAction SilentlyContinue) {
            $key = $git.Id
            if (-not $seen.ContainsKey($key)) {
                Get-CimInstance Win32_Process -Filter "ProcessId=$key AND Name='git.exe'" |
                    ForEach-Object { Stop-CodexDiff $_ }
            }
            $current[$key] = $true
        }
        $seen = $current
        Start-Sleep -Milliseconds 250
    }
} finally {
    if ($ownsMutex) { $mutex.ReleaseMutex() }
    $mutex.Dispose()
}

