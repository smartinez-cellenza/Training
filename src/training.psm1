<#
.SYNOPSIS
Get training summary

.DESCRIPTION
Get training summary (trainer, trainees, source issue url, training type) as PSCustomObject from issue's markdown

.PARAMETER issueMarkdownContent
Issue body markdown

.PARAMETER issueUrl
Issue Url

.EXAMPLE
Get-TrainingSummary -issueMarkdownContent $markdownContent -issueUrl "https://myissueurl.com"

.NOTES
General notes
#>
function Get-TrainingSummary {
    param(
        [Parameter(Mandatory=$true)]
        [string]$issueMarkdownContent,
        [Parameter(Mandatory=$true)]
        [string]$issueUrl
    )

    $issueContent = ConvertFrom-Markdown -InputObject $issueMarkdownContent

    # Trainer
    $trainerEmailContent = $issueContent.Tokens[1].Inline.FirstChild.Content
    $trainerEmailStartIndex = $trainerEmailContent.Start
    $trainerEmailLength = $trainerEmailContent.Length
    $trainerEmail = $trainerEmailContent.Text.Substring($trainerEmailStartIndex,$trainerEmailLength)

    # Trainees
    $traineesEnumerator = $issueContent.Tokens[3].Inline.GetEnumerator()
    $traineeList = @()
    foreach($currentTrainee in $traineesEnumerator) {
        if($currentTrainee.Content) {
            $currentTraineeStartIndex = $currentTrainee.Content.Start
            $currentTraineeLength = $currentTrainee.Content.Length
            $currentTraineeEmail = $currentTrainee.Content.Text.Substring($currentTraineeStartIndex,$currentTraineeLength)
            $traineeList += $currentTraineeEmail
        }
    }

    # Training type
    $trainingTypeContent = $issueContent.Tokens[5].Inline.FirstChild.Content
    $trainingTypeStartIndex = $trainingTypeContent.Start
    $trainingTypeLength = $trainingTypeContent.Length
    $trainingType = $trainingTypeContent.Text.Substring($trainingTypeStartIndex,$trainingTypeLength)

    @{
        trainer = $trainerEmail;
        trainees = $traineeList;
        trainingType = $trainingType;
        issueUrl = $issueUrl
    }
}

Export-ModuleMember -Function Get-TrainingSummary