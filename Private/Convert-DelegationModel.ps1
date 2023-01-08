function Convert-DelegationModel {
    [cmdletBinding()]
    param(
        [System.Collections.IDictionary[]] $DelegationInput,
        [System.Collections.IDictionary] $Definition,
        [string] $Destination,
        [bool] $ProtectedFromAccidentalDeletion
    )
    if ($DelegationInput) {
        $Output = [ordered] @{}
        foreach ($Delegation in $DelegationInput) {
            # $CanonicalNameOU = $Delegation.CanonicalNameOU
            # $ConfigurationOU = $Delegation.ConfigurationOU
            # $CanonicalNameOU = "$Destination\$CanonicalNameOU"
            $Output[$Delegation.CanonicalNameOU] = [ordered] @{}

            $Output[$Delegation.CanonicalNameOU].CanonicalNameOU = $Delegation.CanonicalNameOU
            $Output[$Delegation.CanonicalNameOU].Delegation = $Delegation.Delegation
            $Output[$Delegation.CanonicalNameOU].Description = $Delegation.Description
            $Output[$Delegation.CanonicalNameOU].DelegationInheritance = $Delegation.DelegationInheritance
            $Output[$Delegation.CanonicalNameOU].ProtectedFromAccidentalDeletion = if ($null -eq $Delegation.ProtectedFromAccidentalDeletion) {
                $ProtectedFromAccidentalDeletion
            } else {
                $Delegation.ProtectedFromAccidentalDeletion
            }
        }
        $Output
    } else {
        foreach ($CanonicalNameOU in $Definition.Keys) {
            $ConfigurationOU = $Definition[$CanonicalNameOU]
            #  $CanonicalNameOU = "$Destination\$CanonicalNameOU"
            # $Output[$CanonicalNameOU] = $ConfigurationOU
            # $Output[$CanonicalNameOU].Delegation = $true
            $Definition[$CanonicalNameOU].ProtectedFromAccidentalDeletion = if ($null -eq $ConfigurationOU.ProtectedFromAccidentalDeletion) {
                $ProtectedFromAccidentalDeletion
            } else {
                $ConfigurationOU.ProtectedFromAccidentalDeletion
            }
        }
        $Definition
    }
}