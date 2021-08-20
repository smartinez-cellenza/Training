param(
    [Parameter(Mandatory=$true)]
    [string]$issueMarkdownContent
)

$issueContent = ConvertFrom-Markdown -InputObject $issueMarkdownContent

# Trainer
$trainerEmailContent = $issueContent.Tokens[1].Inline.FirstChild.Content
$trainerEmailstartIndex = $trainerEmailContent.Start
$trainerEmailEndIndex = $trainerEmailContent.End
$trainerEmail = $trainerEmailContent.Text.Substring($trainerEmailstartIndex,$trainerEmailEndIndex)
Write-Host "Trainer is $trainerEmail"