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
        Set-ADACLInheritance -ADObject $DNOU -Inheritance $ConfigurationOU.DelegationInheritance -WarningAction SilentlyContinue -WarningVariable warnings #-ErrorVariable errors -ErrorAction SilentlyContinue
        foreach ($W in $Warnings) {
            Write-Color -Text "[!]", "[$CanonicalNameOU]", "[Warning]", " ACL Inheritance: $($W)" -Color DarkMagenta, DarkGray, DarkMagenta, White
        }
        # foreach ($E in $Errors) {
        #     Write-Color -Text "[!]", "[$CanonicalNameOU]", "[Error]", " ACL Inheritance: $($E.Exception.Message)" -Color Red, DarkGray, Red, White
        # }
    }
    Set-ADACL -ADObject $DNOU -ACLSettings $ConfigurationOU.Delegation -Inheritance $ConfigurationOU.DelegationInheritance -WarningAction SilentlyContinue
}