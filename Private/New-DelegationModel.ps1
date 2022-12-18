function New-DelegationModel {
    [cmdletBinding()]
    param(
        [string] $CanonicalNameOU,
        [System.Collections.IDictionary] $ConfigurationOU,
        [string] $BasePath,
        [string] $Domain
    )
    $CanonicalNameOU = $CanonicalNameOU.Replace("\", "/")
    $DNOU = ConvertTo-DistinguishedName -CanonicalName "$Domain/$($CanonicalNameOU)" -ToOU
    if ($null -ne $ConfigurationOU.DelegationInheritance) {
        Set-ADACLInheritance -ADObject $DNOU -Inheritance $ConfigurationOU.DelegationInheritance
    }
    Set-ADACL -ADObject $DNOU -ACLSettings $ConfigurationOU.Delegation -Inheritance $ConfigurationOU.DelegationInheritance
}