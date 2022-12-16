function Start-DelegationGroups {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter()][string] $Destination,
        [Parameter(Mandatory)][string] $Domain,
        [System.Collections.IDictionary] $Groups
    )
    $Properties = @('Name', 'Description', 'DisplayName', 'GroupScope', 'GroupCategory')
    $PropertiesChangable = @('Description', 'DisplayName', 'GroupScope', 'GroupCategory')

    $BasePath = ConvertTo-DistinguishedName -CanonicalName $Domain
    if (-not $BasePath) {
        return
    }

    $OUCheck = $true
    foreach ($Group in $Groups.Keys) {
        $GroupObject = $Groups[$Group]
        if ($GroupObject.Path) {
            try {
                $null = Get-ADOrganizationalUnit -Identity $GroupObject.Path -ErrorAction Stop
            } catch {
                $OUCheck = $false
                Write-Color -Text '[-] ', "Path OU $($GroupObject.Path)", " verification failed. Please create all organizational Units before continuing. Error: ", $_.Exception.Message -Color Red, Yellow, White
            }
        }
    }
    if ($OUCheck) {
        Write-Color -Text "[i] ", "Processing creation of groups" -Color DarkBlue, White
        foreach ($Group in $Groups.Keys) {
            $GroupObject = $Groups[$Group]
            $newADGroupSplat = @{
                WhatIf        = $false
                Path          = $GroupObject.Path
                Name          = if ($GroupObject.Name) { $GroupObject.Name } else { $Group }
                GroupScope    = $GroupObject.GroupScope
                GroupCategory = $GroupObject.GroupCategory
                Description   = $GroupObject.Description
                DisplayName   = if ($GroupObject.DisplayName) { $GroupObject.DisplayName } else { $Group }
            }
            Remove-EmptyValue -Hashtable $newADGroupSplat
            $GroupExists = Get-ADGroup -Filter "Name -eq '$Group'" -Properties $Properties
            if (-not $GroupExists) {
                try {
                    $null = New-ADGroup @newADGroupSplat -ErrorAction Stop
                    Write-Color -Text '[+] ', "Group ", $Group, " created" -Color Green, White, Green, White
                } catch {
                    Write-Color -Text '[-] ', "Group ", $Group, " creation failed. Error: ", $_.Exception.Message -Color Red, White, Red, White
                }
            } else {
                Write-Color -Text '[-] ', "Group ", $Group, " already exists" -Color Red, White, Yellow, White
                foreach ($Key in $PropertiesChangable) {
                    # we need to check whether key is defined at all and user wants to update it
                    if ($null -ne $GroupObject.$Key -and $GroupExists.$Key -ne $GroupObject.$Key) {
                        try {
                            # we need to make sure DisplayName, Name are not empty, rest can be empty
                            if ($Key -in @('DisplayName', 'Name') -and -not $Key) {
                                continue
                            }
                            Set-ADGroup -Identity $Group -Replace @{ $Key = $GroupObject.$Key } -ErrorAction Stop
                            Write-Color -Text '[+] ', "Group ", $Group, " ", $Key, " updated" -Color Green, White, Green, White, Green, White
                        } catch {
                            Write-Color -Text '[-] ', "Group ", $Group, " ", $Key, " update failed. Error: ", $_.Exception.Message -Color Red, White, Red, White, Red
                        }
                    }
                }
            }
        }
        Write-Color -Text "[i] ", "Processing Members for groups" -Color DarkBlue, White
        foreach ($Group in $Groups.Keys) {
            if ($null -ne $Groups[$Group].Members) {
                Find-GroupMembersActions -Identity $Group -ExpectedMembers $Groups[$Group].Members
            }
        }
        # MemberOf we will not attempt to cleanup as this may be some special group
        Write-Color -Text "[i] ", "Processing MemberOf for groups" -Color DarkBlue, White
        foreach ($Group in $Groups.Keys) {
            if ($null -ne $Groups[$Group].MemberOf) {
                foreach ($MemberOf in $Groups[$Group].MemberOf) {
                    Add-GroupMembersOf -Identity $MemberOf -Group $Group
                }
            }
        }
    }
}