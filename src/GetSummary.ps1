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
$configuration = Get-Content ./src/configuration.json | ConvertFrom-Json
Write-Host "Trainer is $($trainerSummary.trainer)"
$trainerInfo = $configuration.trainers | Where-Object {$_.email -eq $traininSummary.trainer}
if($trainerInfo) {
    Write-Host "::set-output name=trainerUsername::$($trainerInfo.githubUsername)"
}
else {
    Write-Warning "Can't fin trainer $($traininSummary.trainer). Won't be able to assign PR."
    Write-Host "::set-output name=trainerUsername::''"
}
Write-Host "::set-output name=trainerEmail::$($trainerSummary.trainer)"
$trainingSummary | ConvertTo-Json -Depth 10 | Out-File "$issueName.json"

