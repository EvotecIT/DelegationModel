function Start-DelegationModel {
    [cmdletBinding()]
    param(
        [scriptblock] $DelegationModelDefinition,
        [Parameter(Mandatory)][string] $Domain,
        [System.Collections.IDictionary] $Definition,
        [bool] $ProtectedFromAccidentalDeletion,
        [switch] $ObjectOutput
    )

    $Script:Cache = [ordered] @{}
    $Script:Reporting = [ordered] @{}
    $Script:Reporting['Version'] = Get-GitHubVersion -Cmdlet 'Start-DelegationModel' -RepositoryOwner 'evotecit' -RepositoryName 'DelegationModel'
    $Script:Reporting['Settings'] = @{
        ShowError   = $ShowError.IsPresent
        ShowWarning = $ShowWarning.IsPresent
        HideSteps   = $HideSteps.IsPresent
    }

    Write-Color '[i]', "[DelegationModel] ", 'Version', ' [Informative] ', $Script:Reporting['Version'] -Color Yellow, DarkGray, Yellow, DarkGray, Magenta
    $BasePath = ConvertTo-DistinguishedName -CanonicalName $Domain
    if (-not $BasePath) {
        return
    }
    Write-Color '[i]', "[DelegationModel] ", 'Getting forest information' -Color Yellow, DarkGray, Yellow
    $ForestInformation = Get-WinADForestDetails
    if (-not $ForestInformation) {
        Write-Color -Text '[-] ', "Forest information could not be retrieved. Please check your connection to the domain controller." -Color Red, White
        return
    }

    $DC = $ForestInformation['QueryServers'][$Domain].HostName[0]

    Write-Color '[i]', "[DelegationModel] ", 'Preparing data to be configured' -Color Yellow, DarkGray, Yellow
    if ($PSBoundParameters.ContainsKey('DelegationModelDefinition')) {
        $DelegationInput = Invoke-Command -ScriptBlock $DelegationModelDefinition -Verbose
        $Definition = Convert-DelegationModel -DelegationInput $DelegationInput -Destination $Destination -ProtectedFromAccidentalDeletion $ProtectedFromAccidentalDeletion
    } else {
        $Definition = Convert-DelegationModel -Definition $Definition -Destination $Destination -ProtectedFromAccidentalDeletion $ProtectedFromAccidentalDeletion
    }

    Write-Color '[i]', "[DelegationModel] ", 'Managing Organizational Units' -Color Yellow, DarkGray, Yellow
    foreach ($CanonicalNameOU in $Definition.Keys) {
        $ConfigurationOU = $Definition[$CanonicalNameOU]
        New-OUStructure -CanonicalNameOU $CanonicalNameOU -ConfigurationOU $ConfigurationOU -BasePath $BasePath -DC $DC
    }
    Write-Color '[i]', "[DelegationModel] ", 'Managing Delegation' -Color Yellow, DarkGray, Yellow
    foreach ($CanonicalNameOU in $Definition.Keys) {
        $ConfigurationOU = $Definition[$CanonicalNameOU]
        if ($ConfigurationOU.Delegation) {
            $OutputFromDelegation = New-DelegationModel -Domain $Domain -CanonicalNameOU $CanonicalNameOU -ConfigurationOU $ConfigurationOU -BasePath $BasePath
            Export-DelegationLogs -OutputFromDelegation $OutputFromDelegation -CanonicalNameOU $CanonicalNameOU
            if ($ObjectOutput) {
                $OutputFromDelegation
            }
        }
    }
}