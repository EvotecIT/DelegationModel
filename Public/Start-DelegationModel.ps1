function Start-DelegationModel {
    [cmdletBinding()]
    param(
        [Parameter(Mandatory)][string] $Domain,
        [System.Collections.IDictionary] $Definition
    )
    $BasePath = ConvertTo-DistinguishedName -CanonicalName $Domain
    if (-not $BasePath) {
        return
    }
    foreach ($CanonicalNameOU in $Definition.Keys) {
        $ConfigurationOU = $Definition[$CanonicalNameOU]
        New-OUStructure -CanonicalNameOU $CanonicalNameOU -ConfigurationOU $ConfigurationOU
    }
}