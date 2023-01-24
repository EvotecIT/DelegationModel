function Start-DelegationModel {
    [cmdletBinding()]
    param(
        [scriptblock] $DelegationModelDefinition,
        [Parameter(Mandatory)][string] $Domain,
        [System.Collections.IDictionary] $Definition,
        [bool] $ProtectedFromAccidentalDeletion,
        [switch] $DontSuppress,
        [string] $LogFile,
        [int] $LogMaximum = 60,
        [ValidateSet('Add', 'Remove', 'Skip')][string[]] $LogOption = @('Add', 'Skip', 'Remove')
    )
    $Script:Cache = [ordered] @{}

    $BasePath = ConvertTo-DistinguishedName -CanonicalName $Domain
    if (-not $BasePath) {
        return
    }

    # Initialize Delegation Model
    $DC = Initialize-DelegationModel -Domain $Domain
    if (-not $DC) {
        return
    }

    Write-Color -Text '[i]', "[DelegationModel] ", 'Domain Controller ', $DC -Color Yellow, DarkGray, Yellow, DarkGray, Magenta
    # lets reset the cache of users and groups
    # this is required since we often just created groups in the same run
    $null = New-ADACLObject -Principal 'S-1-5-11' -AccessControlType Allow -ObjectType All -InheritedObjectTypeName All -AccessRule GenericAll -InheritanceType None -Force

    Write-Color '[i]', "[DelegationModel] ", 'Preparing data to be configured' -Color Yellow, DarkGray, Yellow
    if ($PSBoundParameters.ContainsKey('DelegationModelDefinition')) {
        $DelegationInput = Invoke-Command -ScriptBlock $DelegationModelDefinition -Verbose -WarningAction SilentlyContinue -WarningVariable Warnings
        #$DelegationInput = Invoke-CommandCustom -ScriptBlock $DelegationModelDefinition -ReturnVerbose -ReturnError -ReturnWarning
        # foreach ($W in $DelegationInput.Warning) {
        #     Write-Color -Text "[!]", "[Delegationmodel]", "[Warning]", " Preloading rules, $($W)" -Color Magenta, DarkGray, Magenta, White
        # }
        # foreach ($W in $DelegationInput.Error) {
        #     Write-Color -Text "[!]", "[Delegationmodel]", "[Error]", " Preloading rules, $($W)" -Color Magenta, DarkGray, Magenta, White
        # }
        #$Definition = Convert-DelegationModel -DelegationInput $DelegationInput.Output -Destination $Destination -ProtectedFromAccidentalDeletion $ProtectedFromAccidentalDeletion
        $Definition = Convert-DelegationModel -DelegationInput $DelegationInput -Destination $Destination -ProtectedFromAccidentalDeletion $ProtectedFromAccidentalDeletion
    } else {
        $Definition = Convert-DelegationModel -Definition $Definition -Destination $Destination -ProtectedFromAccidentalDeletion $ProtectedFromAccidentalDeletion
    }

    Write-Color '[i]', "[DelegationModel] ", 'Managing Organizational Units' -Color Yellow, DarkGray, Yellow
    foreach ($CanonicalNameOU in $Definition.Keys) {
        $ConfigurationOU = $Definition[$CanonicalNameOU]
        New-OUStructure -CanonicalNameOU $CanonicalNameOU -ConfigurationOU $ConfigurationOU -BasePath $BasePath -DC $DC # -ProtectedFromAccidentalDeletion $ProtectedFromAccidentalDeletion
    }
    Write-Color '[i]', "[DelegationModel] ", 'Managing Delegation' -Color Yellow, DarkGray, Yellow
    foreach ($CanonicalNameOU in $Definition.Keys) {
        $ConfigurationOU = $Definition[$CanonicalNameOU]
        if ($ConfigurationOU.Delegation) {
            $OutputFromDelegation = New-DelegationModel -Domain $Domain -CanonicalNameOU $CanonicalNameOU -ConfigurationOU $ConfigurationOU -BasePath $BasePath
            Export-DelegationLogs -LogOption $LogOption -OutputFromDelegation $OutputFromDelegation -CanonicalNameOU $CanonicalNameOU
            if ($DontSuppress) {
                $OutputFromDelegation
            }
        }
    }
}