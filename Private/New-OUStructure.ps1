function New-OUStructure {
    [cmdletBinding()]
    param(
        [string] $CanonicalNameOU,
        [System.Collections.IDictionary] $ConfigurationOU,
        [string] $BasePath
    )
    $IgnoredProperties = @('Delegation', 'DelegationInheritance')
    $PartsOU = $CanonicalNameOU.Split("\")

    $LevelPath = $BasePath
    for ($i = 0; $i -lt $PartsOU.Length; $i++) {
        $O = $PartsOU[$i]
        $CurrentPath = 'OU=' + $O + ',' + $LevelPath

        # lets create new OU, but if it exists we will just inform user
        try {
            $newADOrganizationalUnitSplat = @{
                Name                            = $O
                Path                            = $LevelPath
                ProtectedFromAccidentalDeletion = $False
                Server                          = $DC
                ErrorAction                     = 'Stop'
            }
            if ($i -eq ($PartsOU.Count - 1)) {
                foreach ($V in $ConfigurationOU.Keys) {
                    if ($V -notin $IgnoredProperties) {
                        $newADOrganizationalUnitSplat[$V] = $ConfigurationOU[$V]
                    }
                }
            }
            Remove-EmptyValue -Hashtable $newADOrganizationalUnitSplat
            if ($newADOrganizationalUnitSplat.Count -eq 1) {
                #Write-Color -Text '[!] ', "No OU will be created ", $CurrentPath -Color Red, White
            } else {
                New-ADOrganizationalUnit @newADOrganizationalUnitSplat
                #Write-Verbose -Message "New-OUStructure - Created new OU $CurrentPath"
                Write-Color -Text '[+] ', "Created new OU ", $CurrentPath -Color Green, White
            }
        } catch {
            if ($_.Exception.Message -notlike '*with a name that is already in use*') {
                #Write-Warning -Message "New-OUStructure - Error: $($5_.Exception.message)"
                Write-Color -Text '[!] ', "Error: ", $_.Exception.message -Color Red, White
            } else {
                #Write-Verbose -Message "New-OUStructure - Skipped new OU $CurrentPath, already exists."
                Write-Color -Text '[!] ', "Skipped new OU ", $CurrentPath, ", already exists." -Color Red, White
            }
        }
        # once the OU is created we should update it with DEscription,
        # Write-Verbose -Message "New-OUStructure - Updating OU $CurrentPath"
        Write-Color -Text '[+] ', "Updating OU ", $CurrentPath -Color Green, White
        $setADOrganizationalUnitSplat = @{
            Identity = $CurrentPath
            #Description = $Description
            #ProtectedFromAccidentalDeletion = $ProtectedFromAccidentalDeletion
        }

        if ($i -eq ($PartsOU.Count - 1)) {
            foreach ($V in $ConfigurationOU.Keys) {
                if ($V -notin $IgnoredProperties) {
                    $setADOrganizationalUnitSplat[$V] = $ConfigurationOU[$V]
                }
            }
        }
        if ($setADOrganizationalUnitSplat.Count -eq 1) {
            #Write-Verbose -Message "New-OUStructure - Nothing to update for OU $CurrentPath"
            Write-Color -Text '[!] ', "Nothing to update for OU ", $CurrentPath -Color Red, White
            continue
        }
        Set-ADOrganizationalUnit @setADOrganizationalUnitSplat
        $LevelPath = 'OU=' + $O + ',' + $LevelPath
    }
}