function New-DelegationGroup {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][string] $Name,
        [string] $DisplayName,
        [Parameter(Mandatory)][string] $Path,
        [string] $Description,
        [Parameter(Mandatory)]
        [Microsoft.ActiveDirectory.Management.ADGroupScope] $GroupScope = [Microsoft.ActiveDirectory.Management.ADGroupScope]::DomainLocal,
        [Microsoft.ActiveDirectory.Management.ADGroupCategory] $GroupCategory = [Microsoft.ActiveDirectory.Management.ADGroupCategory]::Security,
        [string[]][ValidateSet('Add', 'Remove')] $MembersBehaviour,
        [string[]] $Members,
        [string[]] $MemberOf,
        [bool] $ProtectedFromAccidentalDeletion
    )
    [ordered] @{
        Name                            = $Name
        DisplayName                     = if (-not $DisplayName) { $Name } else { $DisplayName }
        Path                            = $Path
        Description                     = $Description
        GroupScope                      = $GroupScope
        GroupCategory                   = $GroupCategory
        ProtectedFromAccidentalDeletion = if ($PSBoundParameters.ContainsKey('ProtectedFromAccidentalDeletion')) { $ProtectedFromAccidentalDeletion } else { $null }
        MembersBehaviour                = $MembersBehaviour
        Members                         = if ($PSBoundParameters.ContainsKey('Members')) { $Members } else { $null }
        MemberOf                        = if ($PSBoundParameters.ContainsKey('MemberOf')) { $MemberOf } else { $null }
    }
}