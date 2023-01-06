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
    $ForestInformation = Get-WinADForestDetails
    if (-not $ForestInformation) {
        Write-Color -Text '[-] ', "Forest information could not be retrieved. Please check your connection to the domain controller." -Color Red, White
        return
    }
    $DC = $ForestInformation['QueryServers'][$Domain].HostName[0]

    foreach ($CanonicalNameOU in $Definition.Keys) {
        $ConfigurationOU = $Definition[$CanonicalNameOU]
        New-OUStructure -CanonicalNameOU $CanonicalNameOU -ConfigurationOU $ConfigurationOU -BasePath $BasePath -DC $DC
    }
    foreach ($CanonicalNameOU in $Definition.Keys) {
        $ConfigurationOU = $Definition[$CanonicalNameOU]
        if ($ConfigurationOU.Delegation) {
            New-DelegationModel -Domain $Domain -CanonicalNameOU $CanonicalNameOU -ConfigurationOU $ConfigurationOU -BasePath $BasePath
        }
    }
}