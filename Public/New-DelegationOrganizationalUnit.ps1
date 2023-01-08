function New-DelegationOrganizationalUnit {
    [alias('New-DelegationOU')]
    [CmdletBinding()]
    param(
        [parameter(Mandatory)][string] $CanonicalNameOU,
        [string] $Description,
        [ValidateSet('Enabled', 'Disabled')][string] $DelegationInheritance,
        [Array] $Delegation,
        [bool] $ProtectedFromAccidentalDeletion
    )

    $InputData = [ordered] @{
        CanonicalNameOU                 = $CanonicalNameOU
        Description                     = $Description
        DelegationInheritance           = $DelegationInheritance
        Delegation                      = $Delegation
        ProtectedFromAccidentalDeletion = If ($PSBoundParameters.ContainsKey('ProtectedFromAccidentalDeletion')) { $ProtectedFromAccidentalDeletion } else { $null }
    }
    Remove-EmptyValue -Hashtable $InputData
    $InputData
}