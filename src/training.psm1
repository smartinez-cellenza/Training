function Get-TrainingSummary {
    param(
        [Parameter(Mandatory=$true)]
        [string]$issueMarkdownContent
    )

    $issueContent = ConvertFrom-Markdown -InputObject $issueMarkdownContent

    # Trainer
    $trainerEmailContent = $issueContent.Tokens[1].Inline.FirstChild.Content
    $trainerEmailStartIndex = $trainerEmailContent.Start
    $trainerEmailLength = $trainerEmailContent.Length
    $trainerEmail = $trainerEmailContent.Text.Substring($trainerEmailStartIndex,$trainerEmailLength)
    Write-Host "Trainer is $trainerEmail"

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
    Write-Host "Training type is $trainingType"

    @{
        trainer = $trainerEmail;
        trainees = $traineeList;
        trainingType = $trainingType;
    }
}

Export-ModuleMember -Function Get-TrainingSummary