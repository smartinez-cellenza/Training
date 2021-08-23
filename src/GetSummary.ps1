param(
    [Parameter(Mandatory=$true)]
    [string]$issueMarkdownContent,
    [Parameter(Mandatory=$true)]
    [string]$issueName
)

Import-Module .\src\training.psm1
$trainingSummary = Get-TrainingSummary -issueMarkdownContent $issueMarkdownContent
$trainingSummary | ConvertTo-Json -Depth 10 | Out-File "$issueName.json"
# Write-Output $jsonTrainingSummary
# Write-Host "::set-output name=trainingSummary::$jsonTrainingSummary"