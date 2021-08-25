param(
    [Parameter(Mandatory=$false)]
    [array]$testTag
)

$WarningPreference = 'SilentlyContinue'

Import-Module Pester

$configuration = [PesterConfiguration]::Default
$configuration.Output.Verbosity = "Detailed"
if($testTag) {
    $configuration.Filter.Tag = $testTag
}
$configuration.Run.Exit = $true

Invoke-Pester -Configuration $configuration