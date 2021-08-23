param(
    [Parameter(Mandatory=$true)]
    [string]$issueMarkdownContent,
    [Parameter(Mandatory=$true)]
    [string]$issueName,
    [Parameter(Mandatory=$true)]
    [string]$issueUrl
)

Import-Module .\src\training.psm1
$trainingSummary = Get-TrainingSummary -issueMarkdownContent $issueMarkdownContent -issueUrl $issueUrl
Write-Host "::set-output name=trainerEmail::$($trainerSummary.trainer)"
$trainingSummary | ConvertTo-Json -Depth 10 | Out-File "$issueName.json"
# Write-Output $jsonTrainingSummary
