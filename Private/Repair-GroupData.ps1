function Repair-GroupData {
    [CmdletBinding()]
    param(
        [string] $Group,
        [Array]  $PropertiesChangable,
        [Array] $StandardChangable,
        [Microsoft.ActiveDirectory.Management.ADGroup] $GroupExists,
        [System.Collections.IDictionary]$GroupObject,
        [string] $DC,
        [ValidateSet('Add', 'Remove', 'Skip')][string[]] $LogOption
    )
    if ($LogOption -contains 'Skip') {
        Write-Color -Text '[s] ', "Group ", $Group, " already exists" -Color Magenta, White, Magenta, White
    }
    foreach ($Key in $PropertiesChangable) {
        # we need to check whether key is defined at all and user wants to update it
        if ($null -ne $GroupObject.$Key -and $GroupExists.$Key -ne $GroupObject.$Key) {
            try {
                # we need to make sure DisplayName, Name are not empty, rest can be empty
                if ($Key -in @('DisplayName', 'Name') -and -not $Key) {
                    continue
                }
                if ($Key -in $StandardChangable) {
                    $setADObjectSplat = @{
                        Identity    = $GroupExists.DistinguishedName
                        ErrorAction = 'Stop'
                        $Key        = $GroupObject.$Key
                        Server      = $DC
                    }
                    Set-ADObject @setADObjectSplat
                } else {
                    Set-ADGroup -Identity $Group -Replace @{ $Key = $GroupObject.$Key } -ErrorAction Stop -Server $DC
                }
                if ($LogOption -contains 'Add') {
                    Write-Color -Text '[+] ', "Group ", $Group, " ", $Key, " updated" -Color Green, White, Green, White, Green, White
                }
            } catch {
                Write-Color -Text '[!] ', "Group ", $Group, " ", $Key, " update failed. Error: ", $_.Exception.Message -Color Red, White, Red, White, Red
            }
        }
    }
    $Location = ConvertFrom-DistinguishedName -DistinguishedName $GroupExists.DistinguishedName -ToOrganizationalUnit
    if ($Location -ne $GroupObject.Path) {
        if ($GroupExists.ProtectedFromAccidentalDeletion) {
            $ProtectedFromAccidentalDeletionFailed = $false
            try {
                Set-ADObject -ProtectedFromAccidentalDeletion $false -Identity $GroupExists.DistinguishedName -ErrorAction Stop -Server $DC
            } catch {
                Write-Color -Text '[!] ', "Group ", $Group, " move to ", $GroupObject.Path, " failed. Couldn't disable ProtectedFromAccidentalDeletion. Error: ", $_.Exception.Message -Color Red, White, Red, White, Red
                $ProtectedFromAccidentalDeletionFailed = true
            }
        }
        if (-not $ProtectedFromAccidentalDeletionFailed) {
            $MoveFailed = $false
            try {
                $null = Move-ADObject -Identity $GroupExists.DistinguishedName -TargetPath $GroupObject.Path -ErrorAction Stop -Server $DC
                if ($LogOption -contains 'Add') {
                    Write-Color -Text '[+] ', "Group ", $Group, " moved to ", $GroupObject.Path -Color Green, White, Green, White
                }
            } catch {
                $MoveFailed = $true
                Write-Color -Text '[!] ', "Group ", $Group, " move to ", $GroupObject.Path, " failed. Error: ", $_.Exception.Message -Color Red, White, Red, White, Red
            }
            if (-not $MoveFailed) {
                $PathToGroup = $GroupObject.Path
            } else {
                $PathToGroup = $GroupExists.DistinguishedName
            }
            if ($GroupExists.ProtectedFromAccidentalDeletion) {
                try {
                    Set-ADObject -ProtectedFromAccidentalDeletion $true -Identity $PathToGroup -ErrorAction Stop -Server $DC
                } catch {
                    Write-Color -Text '[!] ', "Group ", $Group, " move to ", $GroupObject.Path, " failed (maybe?). Couldn't enable ProtectedFromAccidentalDeletion. Error: ", $_.Exception.Message -Color Red, White, Red, White, Red
                }
            }

        }
    }
}