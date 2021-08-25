[System.Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseDeclaredVarsMoreThanAssignments', '')]
Param()

BeforeAll {
    Import-Module .\src\training.psm1
}

Describe "training module tests" -Tag "UnitTests" {

    Context "Get-Summary Tests" {

        BeforeAll {
            $singleTraineeIssueContent = Get-Content .\tests\testIssues\singleTraineeIssue.md -Raw
            $multipleTraineesIssueContent = Get-Content .\tests\testIssues\multipleTraineesIssue.md -Raw
        }

        It "Should get the email of the trainer" {
            $summary = Get-TrainingSummary -issueMarkdownContent $singleTraineeIssueContent -issueUrl "http://test.lol"
            $summary.trainer | Should -Be "sylvain.martinez@cellenza.com"
        }

        It "Should get single trainee" {
            $summary = Get-TrainingSummary -issueMarkdownContent $singleTraineeIssueContent -issueUrl "http://test.lol"
            $summary.trainees.Length | Should -Be 1
            $summary.trainees[0] | Should -Be "first@trainee.com"
        }

        It "Should get multiple trainees" {
            $summary = Get-TrainingSummary -issueMarkdownContent $multipleTraineesIssueContent -issueUrl "http://test.lol"
            $summary.trainees.Length | Should -Be 2
            $summary.trainees[0] | Should -Be "first@trainee.com"
            $summary.trainees[1] | Should -Be "second@trainee.com"
        }

        It "Should get training type" {
            $summary = Get-TrainingSummary -issueMarkdownContent $singleTraineeIssueContent -issueUrl "http://test.lol"
            $summary.trainingType | Should -Be "Terraform Introduction"
        }
    }
}