function New-OUStructure {
    [cmdletBinding()]
    param(
        [string] $CanonicalNameOU,
        [System.Collections.IDictionary] $ConfigurationOU
    )
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
                    $newADOrganizationalUnitSplat[$V] = $ConfigurationOU[$V]
                }
            }
            Remove-EmptyValue -Hashtable $newADOrganizationalUnitSplat
            New-ADOrganizationalUnit @newADOrganizationalUnitSplat
            Write-Verbose -Message "New-OUStructure - Created new OU $CurrentPath"

        } catch {
            if ($_.Exception.Message -notlike '*with a name that is already in use*') {
                Write-Warning -Message "New-OUStructure - Error: $($5_.Exception.message)"
            } else {
                Write-Verbose -Message "New-OUStructure - Skipped new OU $CurrentPath, already exists."
            }
        }
        # once the OU is created we should update it with DEscription,
        Write-Verbose -Message "New-OUStructure - Updating OU $CurrentPath"
        $setADOrganizationalUnitSplat = @{
            Identity    = $CurrentPath
            Description = $Description
            #ProtectedFromAccidentalDeletion = $ProtectedFromAccidentalDeletion
        }

        if ($i -eq ($PartsOU.Count - 1)) {
            foreach ($V in $ConfigurationOU.Keys) {
                $setADOrganizationalUnitSplat[$V] = $ConfigurationOU[$V]
            }
        }

        Set-ADOrganizationalUnit @setADOrganizationalUnitSplat
        $LevelPath = 'OU=' + $O + ',' + $LevelPath
    }
}