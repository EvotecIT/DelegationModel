﻿function New-OUStructure {
    [cmdletBinding()]
    param(
        [Parameter(Mandatory)][string] $CanonicalNameOU,
        [Parameter(Mandatory)][System.Collections.IDictionary] $ConfigurationOU,
        [Parameter(Mandatory)][string] $BasePath,
        [Parameter(Mandatory)][string] $DC
    )
    $IgnoredProperties = @('Delegation', 'DelegationInheritance', 'CanonicalNameOU')
    $PartsOU = $CanonicalNameOU.Split("\")

    $LevelPath = $BasePath
    for ($i = 0; $i -lt $PartsOU.Length; $i++) {
        $O = $PartsOU[$i]
        $CurrentPath = 'OU=' + $O + ',' + $LevelPath
        $CanonicalCurrentPath = ConvertFrom-DistinguishedName -DistinguishedName ($CurrentPath.Replace(",$BasePath", "")) -ToCanonicalName

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
                Write-Color -Text '[+]', "[$CanonicalCurrentPath]", "[Adding]", " Added new organizational unit" -Color Green, DarkGray, Green, White
            }
        } catch {
            if ($_.Exception.Message -notlike '*with a name that is already in use*') {
                Write-Color -Text '[!]', "[$CanonicalCurrentPath]", "[Error]", " Error $($_.Exception.message)" -Color Red, DarkGray, Yellow, DarkMagenta, White
            } else {
                Write-Color -Text '[*]', "[$CanonicalCurrentPath]", "[Skipping]", " Skipped new organizational unit, already exists!" -Color DarkMagenta, DarkGray, Yellow, DarkMagenta, White
            }
        }
        # once the OU is created we should update it with additional fields
        $setADOrganizationalUnitSplat = @{
            Identity = $CurrentPath
            Server   = $DC
        }

        $PropertiesToUpdate = if ($i -eq ($PartsOU.Count - 1)) {
            foreach ($V in $ConfigurationOU.Keys) {
                if ($V -notin $IgnoredProperties) {
                    $V
                    $setADOrganizationalUnitSplat[$V] = $ConfigurationOU[$V]
                }
            }
        }
        if ($setADOrganizationalUnitSplat.Count -eq 2) {
            #Write-Color -Text '[!] ', "Nothing to update for OU ", $CurrentPath -Color Red, White
        } else {
            Write-Color -Text '[+]', "[$CanonicalCurrentPath]", "[Updating]", " Updating organizational unit with fields: ", ($PropertiesToUpdate -join ", ") -Color Green, DarkGray, Green, White
            Set-ADOrganizationalUnit @setADOrganizationalUnitSplat
        }
        $LevelPath = 'OU=' + $O + ',' + $LevelPath
    }
}