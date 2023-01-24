function Convert-DelegationGroups {
    <#
    .SYNOPSIS
    Internal function that converts the groups to a hashtable and makes sure all values are set as expected

    .DESCRIPTION
    Internal function that converts the groups to a hashtable and makes sure all values are set as expected

    .PARAMETER GroupInformation
    Converts the groups to a hashtable that are created by New-DelegationGroup

    .PARAMETER Groups
    Fixes the groups that are created by hashtable approach

    .PARAMETER Destination
    The destination OU where the groups will be created. This is used when user doesn't provide Path for given group

    .PARAMETER MembersBehaviour
    The behaviour for members. This is used when user doesn't provide MembersBehaviour for given group

    .EXAMPLE
    $Groups = Convert-DelegationGroups -GroupInformation $DelegationOutput -Destination $Destination -MembersBehaviour $MembersBehaviour

    .EXAMPLE
    $Groups = Convert-DelegationGroups -Groups $Groups -Destination $Destination -MembersBehaviour $MembersBehaviour

    .NOTES
    General notes
    #>
    [CmdletBinding()]
    param(
        [System.Collections.IDictionary[]] $GroupInformation,
        [System.Collections.IDictionary] $Groups,
        [string] $Destination,
        [string[]][ValidateSet('Add', 'Remove')] $MembersBehaviour,
        [bool] $ProtectedFromAccidentalDeletion

    )
    $Count = 0
    if ($GroupInformation) {
        $GroupsInfo = [ordered] @{}
        foreach ($Group in $GroupInformation) {
            $Count++
            $GroupNameToUse = $Group.Name + $Count

            if (-not $Group.Name) {
                $DefaultGroupName = $GroupName
            } else {
                $DefaultGroupName = $Group.Name
            }
            if (-not $Group.DisplayName) {
                $DefaultGroupDisplayName = $DefaultGroupName
            } else {
                $DefaultGroupDisplayName = $Group.DisplayName
            }

            $GroupsInfo[$GroupNameToUse] = [ordered] @{
                Name                            = $DefaultGroupName
                DisplayName                     = $DefaultGroupDisplayName
                Path                            = if ($Group.Path) { $Group.Path } else { $Destination }
                Description                     = $Group.Description
                GroupScope                      = $Group.GroupScope
                GroupCategory                   = $Group.GroupCategory
                ProtectedFromAccidentalDeletion = if ($null -eq $Group.ProtectedFromAccidentalDeletion) { $ProtectedFromAccidentalDeletion } else { $Group.ProtectedFromAccidentalDeletion }
                MembersBehaviour                = if ($Group.MembersBehaviour) { $Group.MembersBehaviour } else { $MembersBehaviour }
                Members                         = if ($Group.Members) { $Group.Members } else { $null }
                MemberOf                        = if ($Group.MemberOf) { $Group.MemberOf } else { $null }
            }
            Remove-EmptyValue -Hashtable $GroupsInfo[$GroupNameToUse]
        }
        $GroupsInfo
    } else {
        $GroupsInfo = [ordered] @{}
        foreach ($GroupName in [string[]] $Groups.Keys) {
            $Count++
            $Group = $Groups[$GroupName]
            $GroupNameToUse = $GroupName + $Count

            if (-not $Group.Name) {
                $DefaultGroupName = $GroupName
            } else {
                $DefaultGroupName = $Group.Name
            }
            if (-not $Group.DisplayName) {
                $DefaultGroupDisplayName = $DefaultGroupName
            } else {
                $DefaultGroupDisplayName = $Group.DisplayName
            }
            $GroupsInfo[$GroupNameTouse] = [ordered] @{
                Name                            = $DefaultGroupName
                DisplayName                     = $DefaultGroupDisplayName
                Path                            = if ($Group.Path) { $Group.Path } else { $Destination }
                Description                     = $Group.Description
                GroupScope                      = $Group.GroupScope
                GroupCategory                   = $Group.GroupCategory
                ProtectedFromAccidentalDeletion = if ($null -eq $Group.ProtectedFromAccidentalDeletion) { $ProtectedFromAccidentalDeletion } else { $Group.ProtectedFromAccidentalDeletion }
                MembersBehaviour                = if ($Group.MembersBehaviour) { $Group.MembersBehaviour } else { $MembersBehaviour }
                Members                         = if ($Group.Members) { $Group.Members } else { $null }
                MemberOf                        = if ($Group.MemberOf) { $Group.MemberOf } else { $null }
            }
            Remove-EmptyValue -Hashtable $GroupsInfo[$GroupNameToUse]
        }
        $GroupsInfo
    }
}