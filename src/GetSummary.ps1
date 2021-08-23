param(
    [Parameter(Mandatory=$true)]
    [string]$issueMarkdownContent
)

Import-Module .\src\training.psm1
$trainingSummary = Get-TrainingSummary -issueMarkdownContent $issueMarkdownContent
$jsonTrainingSummary = $trainingSummary | ConvertTo-Json -Depth 10
Write-Output $jsonTrainingSummary
Write-Host "::set-output name=trainingSummary::$jsonTrainingSummary"