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
    $Script:Reporting = [ordered] @{}
    $Script:Reporting['Version'] = Get-GitHubVersion -Cmdlet 'Start-DelegationModel' -RepositoryOwner 'evotecit' -RepositoryName 'DelegationModel'
    $Script:Reporting['Settings'] = @{
        ShowError   = $ShowError.IsPresent
        ShowWarning = $ShowWarning.IsPresent
        HideSteps   = $HideSteps.IsPresent
    }

    if ($LogFile) {
        $FolderPath = [io.path]::GetDirectoryName($LogFile)
        if (-not (Test-Path -LiteralPath $FolderPath)) {
            $null = New-Item -Path $FolderPath -ItemType Directory -Force -WhatIf:$false
        }
        $PSDefaultParameterValues = @{
            "Write-Color:LogFile" = $LogFile
        }
        Write-Color '[i]', "[DelegationModel] ", 'Version', $Script:Reporting['Version'] -Color Yellow, DarkGray, Yellow, DarkGray, Magenta
        $CurrentLogs = Get-ChildItem -LiteralPath $FolderPath | Sort-Object -Property CreationTime -Descending | Select-Object -Skip $LogMaximum
        if ($CurrentLogs) {
            Write-Color -Text '[i] ', "[DelegationModel] ", "Logs directory has more than ", $LogMaximum, " log files. Cleanup required..." -Color Yellow, DarkCyan, Red, DarkCyan
            foreach ($Log in $CurrentLogs) {
                try {
                    Remove-Item -LiteralPath $Log.FullName -Confirm:$false -WhatIf:$false
                    Write-Color -Text '[i] ', "[DelegationModel] ", '[log deleted] ', "Deleted ", "$($Log.FullName)" -Color Yellow, White, Green
                } catch {
                    Write-Color -Text '[i] ', "[DelegationModel] ", '[log error] ', "Couldn't delete log file $($Log.FullName). Error: ', "$($_.Exception.Message) -Color Yellow, White, Red
                }
            }
        }
    } else {
        Write-Color '[i]', "[DelegationModel] ", 'Version', $Script:Reporting['Version'] -Color Yellow, DarkGray, Yellow, DarkGray, Magenta
    }
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

    # lets reset the cache of users and groups
    # this is required since we often just created groups in the same run
    $null = New-ADACLObject -Principal 'S-1-5-11' -AccessControlType Allow -ObjectType All -InheritedObjectTypeName All -AccessRule GenericAll -InheritanceType None -Force

    Write-Color '[i]', "[DelegationModel] ", 'Preparing data to be configured' -Color Yellow, DarkGray, Yellow
    if ($PSBoundParameters.ContainsKey('DelegationModelDefinition')) {
        $DelegationInput = Invoke-Command -ScriptBlock $DelegationModelDefinition -Verbose -WarningAction SilentlyContinue -WarningVariable Warnings
        #$DelegationInput = Invoke-CommandCustom -ScriptBlock $DelegationModelDefinition -ReturnVerbose -ReturnError -ReturnWarning
        # foreach ($W in $DelegationInput.Warning) {
        #     Write-Color -Text "[!]", "[Delegationmodel]", "[Warning]", " Preloading rules, $($W)" -Color DarkMagenta, DarkGray, DarkMagenta, White
        # }
        # foreach ($W in $DelegationInput.Error) {
        #     Write-Color -Text "[!]", "[Delegationmodel]", "[Error]", " Preloading rules, $($W)" -Color DarkMagenta, DarkGray, DarkMagenta, White
        # }
        #$Definition = Convert-DelegationModel -DelegationInput $DelegationInput.Output -Destination $Destination -ProtectedFromAccidentalDeletion $ProtectedFromAccidentalDeletion
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
            Export-DelegationLogs -LogOption $LogOption -OutputFromDelegation $OutputFromDelegation -CanonicalNameOU $CanonicalNameOU
            if ($DontSuppress) {
                $OutputFromDelegation
            }
        }
    }
}