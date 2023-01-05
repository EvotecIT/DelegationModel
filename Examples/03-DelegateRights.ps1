Import-Module .\DelegationModel.psd1 -Force
Import-Module C:\Support\GitHub\ADEssentials\ADEssentials.psd1 -Force

$AdministrativeUnit = 'FR_IT_Team03'
$Domain = 'ad.evotec.xyz'

$OUDefinition = @{
    "Tier2\Accounts01"                      = @{
        DelegationInheritance = 'Disabled'
        Delegation            = @(
            Export-ADACLObject -ADObject 'DC=ad,DC=evotec,DC=xyz' -OneLiner -ExcludePrincipal @(
                'BUILTIN\Pre-Windows 2000 Compatible Access'
                'EVOTEC\Exchange Servers'
                'EVOTEC\Delegated Setup'
                'Everyone'
            )
            New-ADACLObject -Principal 'przemyslaw.klys' -AccessControlType Allow -ObjectType All -InheritedObjectTypeName All -AccessRule GenericAll -InheritanceType None
            #New-ADACLObject -Principal 'dennis' -AccessControlType Allow -ObjectType All -InheritedObjectType All -AccessRule GenericAll -InheritanceType None
        )
    }
    # "Tier2\Accounts01\$AdministrativeUnit"  = @{
    #     Description                     = "Accounts for Standard users in $AdministrativeUnit"
    #     #ProtectedFromAccidentalDeletion = $true
    # }
    # "Tier2\Accounts02\$AdministrativeUnit"  = @{
    #     #Description                     = "Accounts for Vip users in $AdministrativeUnit"
    #     #ProtectedFromAccidentalDeletion = $true
    # }
    "Tier2\Devices01\$AdministrativeUnit"   = @{
        DelegationInheritance = 'Enabled'
        Delegation            = @(
            New-ADACLObject -Principal 'przemyslaw.klys' -AccessControlType Allow -ObjectType All -InheritedObjectTypeName All -AccessRule GenericAll -InheritanceType None

            @{ Principal = "DL_Tier2_Devices_$AdministrativeUnit"; AccessControlType = 'Allow';	ObjectTypeName = 'All'; InheritedObjectTypeName = 'Computer'; ActiveDirectoryRights = 'CreateChild', 'DeleteChild'; InheritanceType = 'Descendents' }
            #@{ Principal = "DL_Tier2_Devices_$AdministrativeUnit"; AccessControlType = 'Allow';	ObjectTypeName = 'All'; InheritedObjectTypeName = 'Computer'; ActiveDirectoryRights = 'GenericAll'	; InheritanceType = 'Descendents' }
            @{ Principal = "DL_Tier2_Devices_$AdministrativeUnit"; AccessControlType = 'Allow';	ObjectTypeName = 'Reset Password'; InheritedObjectTypeName = 'Computer'; ActiveDirectoryRights = 'ExtendedRight'	; InheritanceType = 'Descendents' }
            @{ Principal = "DL_Tier2_Devices_$AdministrativeUnit"; AccessControlType = 'Allow';	ObjectTypeName = 'Change Password'	; InheritedObjectTypeName = 'Computer'; ActiveDirectoryRights = 'ExtendedRight'	; InheritanceType = 'Descendents' }
            @{ Principal = "DL_Tier2_Devices_$AdministrativeUnit"; AccessControlType = 'Allow';	ObjectTypeName = 'Validated write to service principal name'	; InheritedObjectTypeName = 'Computer'; ActiveDirectoryRights = 'ExtendedRight'	; InheritanceType = 'Descendents' }
            @{ Principal = "DL_Tier2_Devices_$AdministrativeUnit"; AccessControlType = 'Allow';	ObjectTypeName = 'Validated write to DNS host name'	; InheritedObjectTypeName = 'Computer'; ActiveDirectoryRights = 'ExtendedRight'; InheritanceType = 'Descendents' }
            @{ Principal = "DL_Tier2_Devices_$AdministrativeUnit"; AccessControlType = 'Allow';	ObjectTypeName = 'Validated write to computer attributes.' ; InheritedObjectTypeName = 'Computer'; ActiveDirectoryRights = 'ExtendedRight'; InheritanceType = 'Descendents' }
            @{ Principal = "DL_Tier2_Devices_$AdministrativeUnit"; AccessControlType = 'Allow';	ObjectTypeName = 'Allowed to Authenticate'	; InheritedObjectTypeName = 'Computer'; ActiveDirectoryRights = 'ExtendedRight'	; InheritanceType = 'Descendents' }
            @{ Principal = "DL_Tier2_Devices_$AdministrativeUnit"; AccessControlType = 'Allow';	ObjectTypeName = 'Account Restrictions'	; InheritedObjectTypeName = 'Computer'; ActiveDirectoryRights = 'ExtendedRight'	; InheritanceType = 'Descendents' }
            @{ Principal = "DL_Tier2_Devices_$AdministrativeUnit"; AccessControlType = 'Deny';	ObjectTypeName = 'ms-Mcs-AdmPwd'; InheritedObjectTypeName = 'Computer'; ActiveDirectoryRights = 'ReadProperty', 'WriteProperty'	; InheritanceType = 'Descendents' }
            #@{ Principal = "DL_Tier2_Devices_$AdministrativeUnit"; AccessControlType = 'Deny';	ObjectTypeName = 'ms-Mcs-AdmPwd'; InheritedObjectTypeName = 'Computer'; ActiveDirectoryRights = 'WriteProperty'; InheritanceType = 'Descendents' }
            @{ Principal = "DL_Tier2_Devices_$AdministrativeUnit"; AccessControlType = 'Deny';	ObjectTypeName = 'ms-Mcs-AdmPwdExpirationTime'	; InheritedObjectTypeName = 'Computer'; ActiveDirectoryRights = 'ReadProperty', 'WriteProperty'	; InheritanceType = 'Descendents' }
            #@{ Principal = "DL_Tier2_Devices_$AdministrativeUnit"; AccessControlType = 'Deny';	ObjectTypeName = 'ms-Mcs-AdmPwdExpirationTime'	; InheritedObjectTypeName = 'Computer'; ActiveDirectoryRights = 'WriteProperty'	; InheritanceType = 'Descendents' }
        )
    }
    # "Tier2\Groups01\$AdministrativeUnit"    = @{

    # }
    "Tier2\Instruments\$AdministrativeUnit" = @{

    }
    # "Tier2\Resources\$AdministrativeUnit"   = @{

    # }
}

$Outpout = Start-DelegationModel -Domain $Domain -Definition $OUDefinition #-Verbose
$Outpout
# $Outpout.Add | Format-Table
# $Outpout.Remove | Format-Table

#Get-ADACL -ADObject 'OU=FR_IT_Team03,OU=Devices01,OU=Tier2,DC=ad,DC=evotec,DC=xyz' | Format-Table
#Get-ADACL -ADObject 'DC=ad,DC=evotec,DC=xyz' | Format-Table
#Export-ADACLObject -ADObject 'DC=ad,DC=evotec,DC=xyz' | Format-Table