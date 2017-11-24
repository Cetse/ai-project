# For developers only
# Open powershell as admin & execute the following once
# Set-ExecutionPolicy Unrestricted

# For clients
# Add the script to the Windows Task Scheduler at an interval (5min)
# Powershell.exe -ExecutionPolicy Bypass C:\sendLog\SendLogs.ps1

$user = "elastic"
$pass = "changeme"
$pair = "${user}:${pass}"

$bytes = [System.Text.Encoding]::ASCII.GetBytes($pair)
$base64 = [System.Convert]::ToBase64String($bytes)

$basicAuthValue = "Basic $base64"

$macOsqueryLogPath = "/var/log/osquery/osqueryd.results.log"
$macScriptLogPath = '~/Desktop/sendLog.log'

$windowsOsqueryLogPath = "C:\ProgramData\osquery\log\osqueryd.results.log"
$windowsScriptLogPath = "C:\SendLog\sendLog.log"

$ubuntuOsqueryLogPath = "/var/log/osquery/osqueryd.results.log"
$ubuntuScriptLogPath = "/var/log/sendLog/testlog.log"

Function MakeLogObject {
  Param(
    [string]$loggable
  )
  return '{"timestamp": "' + $(Get-Date -Format s) + '", "result":"' + $loggable + '"}'
}

Function SendToElasticSearch {
  Param(
    [string]$osqueryLogPath,
    [string]$scriptLogPath
  )

  Add-Content $scriptLogPath $(MakeLogObject -loggable 'run_start') 

  # Check for logs
  if (-Not (Test-Path $osqueryLogPath)) {
    Add-Content $scriptLogPath $(MakeLogObject -loggable 'no_file')
    return
  }

  # Read logdata
  $logContent = Get-Content -Path $osqueryLogPath
   
  # Remove file after read
  Remove-Item -Path $osqueryLogPath

  # Create web request
  $uri = "http://192.168.10.44:9200/osquery/query"
  $headers = @{ 
    'Authorization' = $basicAuthValue
  }

  $i = 1
  $total_succesfull = 0
  $total_failed = 0

  ForEach ($line in $($logContent -split "`r`n")) {
    # Send web request and store the response
    $response = Invoke-WebRequest `
      -UseBasicParsing $uri `
      -Method Post `
      -Headers $headers `
      -ContentType 'application/json' `
      -Body $line 

    # Counter
    Write-Host $i
    $i = $i + 1

    if ($response.Content -contains '"successful":1') {
      $total_succesfull = $total_succesfull + 1
     } else {
       $total_failed = $total_failed + 1
     }

    # Log the response
    # Add-Content $scriptLogPath $(MakeLogObject -loggable $response.Content) 
  }
  $prettyPrint = ' queries sent: ' + $i + ', total succesfull: '+ $total_succesfull + ', total failed ' + $total_failed
  Add-Content $scriptLogPath $(MakeLogObject -loggable $prettyPrint ) 

  Add-Content $scriptLogPath $(MakeLogObject -loggable 'run_end') 
}

SendToElasticSearch -scriptLogPath $windowsScriptLogPath -osqueryLogPath $windowsOsqueryLogPath
