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
            foreach ($Type in @('Skip', 'Add', 'Remove', 'Warnings', 'Errors')) {
                foreach ($D in $OutputFromDelegation.$Type) {
                    if ($Type -eq 'Skip') {
                        $Action = 'Skipping'
                        $ActionSign = '[i]'
                        $ActionColor = [System.ConsoleColor]::Yellow
                    } elseif ($Type -eq 'Add') {
                        $Action = 'Adding'
                        $ActionSign = '[+]'
                        $ActionColor = [System.ConsoleColor]::Green
                    } elseif ($Type -eq 'Remove') {
                        $Action = 'Removing'
                        $ActionSign = '[-]'
                        $ActionColor = [System.ConsoleColor]::DarkRed
                    } elseif ($Type -eq 'Warnings') {
                        $Action = 'Warning'
                        $ActionSign = '[!]'
                        $ActionColor = [System.ConsoleColor]::DarkMagenta
                        Write-Color -Text $ActionSign, "[$($CanonicalNameOU)]", "[$Action] ", $D -Color $ActionColor, DarkGray, $ActionColor, White
                        continue
                    } elseif ($Type -eq 'Errors') {
                        $Action = 'Error'
                        $ActionSign = '[!]'
                        $ActionColor = [System.ConsoleColor]::Red
                        Write-Color -Text $ActionSign, "[$($CanonicalNameOU)]", "[$Action] ", $D -Color $ActionColor, DarkGray, $ActionColor, White
                        continue
                    }
                    $OptionColor = [System.ConsoleColor]::DarkGray

                    $ValueColor = [System.ConsoleColor]::Magenta
                    $BracketColor = [System.ConsoleColor]::DarkGray
                    if ($D.Permissions.AccessControlType -eq 'Allow') {
                        $ColorAccessControlType = [System.ConsoleColor]::Green
                    } else {
                        $ColorAccessControlType = [System.ConsoleColor]::Red
                    }
                    $PrincipalColor = [System.ConsoleColor]::Magenta
                    Write-Color -Text @(
                        $ActionSign,
                        "[$($CanonicalNameOU)]",
                        "[$Action]",
                        "[Principal: ", $($D.Principal), "]",
                        "[AccessControlType: ", $($D.Permissions.AccessControlType), "]",
                        "[ActiveDirectoryRights: ", $($D.Permissions.ActiveDirectoryRights), "]",
                        "[ObjectTypeName: ", $($D.Permissions.ObjectTypeName), "]",
                        "[InheritedObjectTypeName: ", $($D.Permissions.InheritedObjectTypeName), "]",
                        "[InheritanceType: ", $($D.Permissions.InheritanceType), "]"
                    ) -Color $ActionColor, DarkGray, $ActionColor, $OptionColor, $PrincipalColor, $BracketColor, $OptionColor, $ColorAccessControlType, $OptionColor, $BracketColor, $ValueColor, $BracketColor, $OptionColor, $ValueColor, $BracketColor, $OptionColor, $ValueColor, $BracketColor, $OptionColor, $ValueColor, $BracketColor, $OptionColor, $ValueColor, $BracketColor
                }
            }
            if ($ObjectOutput) {
                $OutputFromDelegation
            }
        }
    }
}