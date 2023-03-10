function Start-DelegationGroups {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [scriptblock] $DelegationGroupsDefinition,
        [Parameter()][string] $Destination,
        [Parameter(Mandatory)][string] $Domain,
        [System.Collections.IDictionary] $Groups,
        [string[]][ValidateSet('Add', 'Remove')] $MembersBehaviour = @('Add', 'Remove'),
        [bool] $ProtectedFromAccidentalDeletion,
        [ValidateSet('Add', 'Remove', 'Skip')][string[]] $LogOption = @('Add', 'Skip', 'Remove')
    )

    $Properties = @('Name', 'Description', 'DisplayName', 'GroupScope', 'GroupCategory', 'ProtectedFromAccidentalDeletion')
    $PropertiesChangable = @('Description', 'DisplayName', 'ProtectedFromAccidentalDeletion', 'Path')
    $StandardChangable = @("GroupCategory", "GroupScope", "Name", "Path", "ProtectedFromAccidentalDeletion")

    $BasePath = ConvertTo-DistinguishedName -CanonicalName $Domain
    if (-not $BasePath) {
        return
    }

    # Initialize Delegation Model
    $DC = Initialize-DelegationModel -Domain $Domain
    if (-not $DC) {
        return
    }

    if ($PSBoundParameters.ContainsKey('DelegationGroupsDefinition')) {
        $DelegationOutput = & $DelegationGroupsDefinition
        $Groups = Convert-DelegationGroups -GroupInformation $DelegationOutput -Destination $Destination -MembersBehaviour $MembersBehaviour -ProtectedFromAccidentalDeletion $ProtectedFromAccidentalDeletion
    } else {
        $Groups = Convert-DelegationGroups -Groups $Groups -Destination $Destination -MembersBehaviour $MembersBehaviour -ProtectedFromAccidentalDeletion $ProtectedFromAccidentalDeletion
    }

    $OUCheck = $true
    foreach ($Group in $Groups.Keys) {
        # we need to check whether OU exists first, if not terminate and ask user to create it
        $GroupObject = $Groups[$Group]
        if ($GroupObject.Path) {
            try {
                $null = Get-ADOrganizationalUnit -Identity $GroupObject.Path -ErrorAction Stop -Server $DC
            } catch {
                $OUCheck = $false
                Write-Color -Text '[!] ', "Path OU $($GroupObject.Path)", " verification failed. Please create all organizational Units before continuing. Error: ", $_.Exception.Message -Color Red, Yellow, White
            }
        }
    }
    if ($OUCheck) {
        # lets fix the groups
        Write-Color -Text "[i] ", "Processing creation of groups" -Color Cyan, White
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
            $GroupExists = Get-ADGroup -Filter "Name -eq '$($GroupObject.Name)'" -Properties $Properties -Server $DC
            if (-not $GroupExists) {
                # if the group does not exist, we will create it
                try {
                    $null = New-ADGroup @newADGroupSplat -ErrorAction Stop
                    if ($LogOption -contains 'Add') {
                        Write-Color -Text '[+] ', "Group ", $GroupObject.Name, " created" -Color Green, White, Green, White
                    }
                } catch {
                    Write-Color -Text '[!] ', "Group ", $GroupObject.Name, " creation failed. Error: ", $_.Exception.Message -Color Red, White, Red, White
                }
            } else {
                # if the group exists, we will check whether it needs to be updated
                Repair-GroupData -Group $GroupObject.Name -PropertiesChangable $PropertiesChangable -StandardChangable $StandardChangable -GroupObject $GroupObject -GroupExists $GroupExists -DC $DC -LogOption $LogOption
            }
        }
        Write-Color -Text "[i] ", "Processing Members for groups" -Color Cyan, White
        foreach ($Group in $Groups.Keys) {
            $GroupObject = $Groups[$Group]
            if ($null -ne $Groups[$Group].Members) {
                Find-GroupMembersActions -Identity $GroupObject.Name -ExpectedMembers $Groups[$Group].Members -DC $DC -MembersBehaviour $Groups[$Group].MembersBehaviour -LogOption $LogOption
            }
        }
        # MemberOf we will not attempt to cleanup as this may be some special group
        Write-Color -Text "[i] ", "Processing MemberOf for groups" -Color Cyan, White
        foreach ($Group in $Groups.Keys) {
            $GroupObject = $Groups[$Group]
            if ($null -ne $Groups[$Group].MemberOf) {
                foreach ($MemberOf in $Groups[$Group].MemberOf) {
                    Add-GroupMembersOf -Identity $MemberOf -Group $GroupObject.Name -DC $DC -LogOption $LogOption
                }
            }
        }
    }
}