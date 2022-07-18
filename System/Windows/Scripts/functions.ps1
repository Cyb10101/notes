# Get Process tree
function Show-ProcessTree([int] $processId = 0) {
    $procs = Get-WmiObject Win32_Process

    function Get-ProcessChildren($mainProcess, [int] $depth = 1) {
        $procs | Where-Object {$_.ParentProcessId -eq $mainProcess.ProcessID -and $_.ParentProcessId -ne 0} | ForEach-Object {
            "{0}|- {1} ({2})" -f (" " * 3 * ($depth - 1)), $_.Name, $_.ProcessID
            Get-ProcessChildren $_ (++$depth)
            $depth--
        }
    }

    $filter = {-not (Get-Process -Id $_.ParentProcessId -ErrorAction SilentlyContinue) -or $_.ParentProcessId -eq 0}
    if ($processId -gt 0) {
      $filter = {$_.ProcessID -eq $processId}
    }

    $procs | Where-Object $filter | Sort-Object ProcessID | ForEach-Object {
        "{0} ({1})" -f $_.Name, $_.ProcessID
        Get-ProcessChildren $_
    }
}
Show-ProcessTree
Show-ProcessTree 4

# Show listening ports
Get-NetTCPConnection |
  Where-Object {@("9009", "9010", "9011", "9012", "9013") -contains $_.LocalPort} |
  Sort-Object -Property LocalPort |
  Select-Object -Property Local*, Remote*, state, OwningProcess,
    @{Name="Process";Expression={(Get-Process -Id $_.OwningProcess).ProcessName}},
    @{Name="FileName";Expression={(Get-Process -Id $_.OwningProcess -FileVersionInfo).FileName}} |
  Format-Table -AutoSize

# Get processes by port
Get-Process -Id (Get-NetTCPConnection -LocalPort 80).OwningProcess
Get-Process -Id (Get-NetTCPConnection -LocalPort 9009).OwningProcess
