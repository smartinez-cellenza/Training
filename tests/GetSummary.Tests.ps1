[System.Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseDeclaredVarsMoreThanAssignments', '')]
Param()

BeforeAll {
    Import-Module .\src\training.psm1
}

Describe "GetSummary tests" -Tag "UnitTests" {

    Context "GetSummary Tests" {

        BeforeAll {
            Mock Write-Host {}
            Mock Write-Warning {}
            Mock Out-File {}
        }

        It "Should set githubUsername of trainer" {
            Mock Get-TrainingSummary {return @{
                trainer = "sylvain.martinez@cellenza.com";
                trainees = @("first@trainee.com", "second@trainee.com");
                trainingType = "Terraform";
                issueUrl = "https://github.com/issues/42"
            }}
            .\src\GetSummary.ps1 -issueMarkdownContent "lol" -issueName "42" -issueUrl "ici"
            Assert-MockCalled Write-Host -Exactly 1 -Scope It -ParameterFilter { $Object -eq "::set-output name=trainerUsername::smartinez-cellenza" }
        }

        It "Should warn when githubUsername not found" {
            $trainerEmail = "maistesquienfait@ettuviensdou.com"
            Mock Get-TrainingSummary {return @{
                trainer = $trainerEmail;
                trainees = @("first@trainee.com", "second@trainee.com");
                trainingType = "Terraform";
                issueUrl = "https://github.com/issues/42"
            }}
            .\src\GetSummary.ps1 -issueMarkdownContent "lol" -issueName "42" -issueUrl "ici"
            Assert-MockCalled Write-Warning -Exactly 1 -Scope It -ParameterFilter {  $Message -eq "Can't find trainer $($trainerEmail). Won't be able to assign PR." }
        }

        It "Should set trainer email" {
            $trainerEmail = "maistesquienfait@ettuviensdou.com"
            Mock Get-TrainingSummary {return @{
                trainer = "sylvain.martinez@cellenza.com";
                trainees = @("first@trainee.com", "second@trainee.com");
                trainingType = "Terraform";
                issueUrl = "https://github.com/issues/42"
            }}
            .\src\GetSummary.ps1 -issueMarkdownContent "lol" -issueName "42" -issueUrl "ici"
            Assert-MockCalled Write-Host -Exactly 1 -Scope It -ParameterFilter { $Object -eq "::set-output name=trainerEmail::sylvain.martinez@cellenza.com" }
        }

        It "Should create training file" {
            $trainerEmail = "maistesquienfait@ettuviensdou.com"
            Mock Get-TrainingSummary {return @{
                trainer = "sylvain.martinez@cellenza.com";
                trainees = @("first@trainee.com", "second@trainee.com");
                trainingType = "Terraform";
                issueUrl = "https://github.com/issues/42"
            }}
            .\src\GetSummary.ps1 -issueMarkdownContent "lol" -issueName "42" -issueUrl "ici"
            Assert-MockCalled Out-File -Exactly 1 -Scope It
        }
    }
}