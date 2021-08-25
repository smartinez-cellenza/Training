[System.Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingWriteHost', '')]

param(
    [Parameter(Mandatory=$true)]
    [string]$issueMarkdownContent,
    [Parameter(Mandatory=$true)]
    [string]$issueName,
    [Parameter(Mandatory=$true)]
    [string]$issueUrl
)

Import-Module .\src\training.psm1

$configuration = Get-Content .\src\configuration.json | ConvertFrom-Json
$trainingSummary = Get-TrainingSummary -issueMarkdownContent $issueMarkdownContent -issueUrl $issueUrl
$trainerInfo = $configuration.trainers | Where-Object {$_.email -eq $trainingSummary.trainer}
if($trainerInfo) {
    Write-Host "::set-output name=trainerUsername::$($trainerInfo.githubUsername)"
}
else {
    Write-Warning "Can't find trainer $($trainingSummary.trainer). Won't be able to assign PR."
    Write-Host "::set-output name=trainerUsername::''"
}
Write-Host "::set-output name=trainerEmail::$($trainingSummary.trainer)"
$trainingSummary | ConvertTo-Json -Depth 10 | Out-File "$issueName.json"

