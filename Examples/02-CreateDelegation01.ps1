Import-Module .\DelegationModel.psd1 -Force
Import-Module C:\Support\GitHub\ADEssentials\ADEssentials.psd1 -Force

$AdministrativeUnit = 'FR_IT_Team06'

Start-DelegationModel -Domain 'ad.evotec.xyz' -ProtectedFromAccidentalDeletion $true -Verbose {
    New-DelegationOU -CanonicalNameOU "Tier2\Accounts01" -DelegationInheritance 'Disabled' -Delegation @(
        Export-ADACLObject -ADObject 'DC=ad,DC=evotec,DC=xyz' -OneLiner -ExcludePrincipal @(
            'BUILTIN\Pre-Windows 2000 Compatible Access'
            'EVOTEC\Exchange Servers'
            'EVOTEC\Delegated Setup'
            'Everyone'
        )
        New-ADACLObject -Principal 'przemyslaw.klys' -AccessControlType Allow -ObjectType All -InheritedObjectTypeName All -AccessRule GenericAll -InheritanceType None
    ) -ProtectedFromAccidentalDeletion $true

    # New-DelegationOU -CanonicalNameOU "Tier2\Devices\$AdministrativeUnit" -DelegationInheritance Enabled -Delegation @(
    #     New-ADACLObject -Principal 'przemyslaw.klys' -AccessControlType Allow -ObjectType All -InheritedObjectTypeName 'All' -AccessRule GenericAll -InheritanceType None
    #     New-ADACLObject -Principal "DL_Tier2_Devices_$AdministrativeUnit" -AccessControlType Allow -ObjectType 'All' -InheritedObjectTypeName Computer -AccessRule 'CreateChild', 'DeleteChild' -InheritanceType Descendents
    #     New-ADACLObject -Principal "DL_Tier2_Devices_$AdministrativeUnit" -AccessControlType Allow -ObjectType 'Reset Password' -InheritedObjectTypeName Computer -AccessRule 'ExtendedRight' -InheritanceType Descendents
    #     New-ADACLObject -Principal "DL_Tier2_Devices_$AdministrativeUnit" -AccessControlType Allow -ObjectType 'Change Password' -InheritedObjectTypeName Computer -AccessRule 'ExtendedRight' -InheritanceType Descendents
    #     New-ADACLObject -Principal "DL_Tier2_Devices_$AdministrativeUnit" -AccessControlType Allow -ObjectType 'Validated write to service principal name' -InheritedObjectTypeName Computer -AccessRule 'ExtendedRight' -InheritanceType Descendents
    #     New-ADACLObject -Principal "DL_Tier2_Devices_$AdministrativeUnit" -AccessControlType Allow -ObjectType 'Validated write to DNS host name' -InheritedObjectTypeName Computer -AccessRule 'ExtendedRight' -InheritanceType Descendents
    #     New-ADACLObject -Principal "DL_Tier2_Devices_$AdministrativeUnit" -AccessControlType Allow -ObjectType 'Validated write to computer attributes.' -InheritedObjectTypeName Computer -AccessRule 'ExtendedRight' -InheritanceType Descendents
    #     New-ADACLObject -Principal "DL_Tier2_Devices_$AdministrativeUnit" -AccessControlType Allow -ObjectType 'Allowed to Authenticate' -InheritedObjectTypeName Computer -AccessRule 'ExtendedRight' -InheritanceType Descendents
    #     New-ADACLObject -Principal "DL_Tier2_Devices_$AdministrativeUnit" -AccessControlType Allow -ObjectType 'Account Restrictions' -InheritedObjectTypeName Computer -AccessRule 'ExtendedRight' -InheritanceType Descendents
    #     New-ADACLObject -Principal "DL_Tier2_Devices_$AdministrativeUnit" -AccessControlType Deny -ObjectType 'ms-Mcs-AdmPwd' -InheritedObjectTypeName Computer -AccessRule 'ReadProperty', 'WriteProperty' -InheritanceType Descendents
    #     New-ADACLObject -Principal "DL_Tier2_Devices_$AdministrativeUnit" -AccessControlType Deny -ObjectType 'ms-Mcs-AdmPwdExpirationTime' -InheritedObjectTypeName Computer -AccessRule 'ReadProperty', 'WriteProperty' -InheritanceType Descendents
    #     New-ADACLObject -Principal "DL_Tier2_DevicesLAPSRead_$AdministrativeUnit" -AccessControlType Allow -ObjectType 'ms-Mcs-AdmPwd' -InheritedObjectTypeName Computer -AccessRule 'ReadProperty' -InheritanceType Descendents
    #     New-ADACLObject -Principal "DL_Tier2_DevicesLAPSRead_$AdministrativeUnit" -AccessControlType Allow -ObjectType 'ms-Mcs-AdmPwdExpirationTime' -InheritedObjectTypeName Computer -AccessRule 'ReadProperty' -InheritanceType Descendents
    #     New-ADACLObject -Principal "DL_Tier2_OU_$AdministrativeUnit" -AccessControlType Allow -ObjectType organizationalUnit -InheritedObjectTypeName OrganizationalUnit -AccessRule 'CreateChild', 'DeleteChild' -InheritanceType Descendents
    #     #New-ADACLObject -Principal "DL_Tier2_OU_$AdministrativeUnit" -AccessControlType Allow -ObjectType organizationalUnit -InheritedObjectTypeName OrganizationalUnit -AccessRule 'DeleteChild' -InheritanceType Descendents


    # ) -Description "Accounts for users in $AdministrativeUnit" -ProtectedFromAccidentalDeletion $false

    # New-DelegationOU -CanonicalNameOU "Tier2\DevicesVIP\$AdministrativeUnit" -DelegationInheritance Enabled -Delegation @(
    #     New-ADACLObject -Principal 'przemyslaw.klys' -AccessControlType Allow -ObjectType All -InheritedObjectTypeName 'All' -AccessRule GenericAll -InheritanceType None
    #     New-ADACLObject -Principal "DL_Tier2_DevicesVIP_$AdministrativeUnit" -AccessControlType Allow -ObjectType 'All' -InheritedObjectTypeName Computer -AccessRule 'CreateChild', 'DeleteChild' -InheritanceType Descendents
    #     New-ADACLObject -Principal "DL_Tier2_DevicesVIP_$AdministrativeUnit" -AccessControlType Allow -ObjectType 'Reset Password' -InheritedObjectTypeName Computer -AccessRule 'ExtendedRight' -InheritanceType Descendents
    #     New-ADACLObject -Principal "DL_Tier2_DevicesVIP_$AdministrativeUnit" -AccessControlType Allow -ObjectType 'Change Password' -InheritedObjectTypeName Computer -AccessRule 'ExtendedRight' -InheritanceType Descendents
    #     New-ADACLObject -Principal "DL_Tier2_DevicesVIP_$AdministrativeUnit" -AccessControlType Allow -ObjectType 'Validated write to service principal name' -InheritedObjectTypeName Computer -AccessRule 'ExtendedRight' -InheritanceType Descendents
    #     New-ADACLObject -Principal "DL_Tier2_DevicesVIP_$AdministrativeUnit" -AccessControlType Allow -ObjectType 'Validated write to DNS host name' -InheritedObjectTypeName Computer -AccessRule 'ExtendedRight' -InheritanceType Descendents
    #     New-ADACLObject -Principal "DL_Tier2_DevicesVIP_$AdministrativeUnit" -AccessControlType Allow -ObjectType 'Validated write to computer attributes.' -InheritedObjectTypeName Computer -AccessRule 'ExtendedRight' -InheritanceType Descendents
    #     New-ADACLObject -Principal "DL_Tier2_DevicesVIP_$AdministrativeUnit" -AccessControlType Allow -ObjectType 'Allowed to Authenticate' -InheritedObjectTypeName Computer -AccessRule 'ExtendedRight' -InheritanceType Descendents
    #     New-ADACLObject -Principal "DL_Tier2_DevicesVIP_$AdministrativeUnit" -AccessControlType Allow -ObjectType 'Account Restrictions' -InheritedObjectTypeName Computer -AccessRule 'ExtendedRight' -InheritanceType Descendents
    #     New-ADACLObject -Principal "DL_Tier2_DevicesVIP_$AdministrativeUnit" -AccessControlType Deny -ObjectType 'ms-Mcs-AdmPwd' -InheritedObjectTypeName Computer -AccessRule 'ReadProperty', 'WriteProperty' -InheritanceType Descendents
    #     New-ADACLObject -Principal "DL_Tier2_DevicesVIP_$AdministrativeUnit" -AccessControlType Deny -ObjectType 'ms-Mcs-AdmPwdExpirationTime' -InheritedObjectTypeName Computer -AccessRule 'ReadProperty', 'WriteProperty' -InheritanceType Descendents
    #     New-ADACLObject -Principal "DL_Tier2_DevicesVIPLAPSRead_$AdministrativeUnit" -AccessControlType Allow -ObjectType 'ms-Mcs-AdmPwd' -InheritedObjectTypeName Computer -AccessRule 'ReadProperty' -InheritanceType Descendents
    #     New-ADACLObject -Principal "DL_Tier2_DevicesVIPLAPSRead_$AdministrativeUnit" -AccessControlType Allow -ObjectType 'ms-Mcs-AdmPwdExpirationTime' -InheritedObjectTypeName Computer -AccessRule 'ReadProperty' -InheritanceType Descendents
    #     New-ADACLObject -Principal "DL_Tier2_OU_$AdministrativeUnit" -AccessControlType Allow -ObjectType 'Create Organizational Unit objects' -InheritedObjectTypeName OrganizationalUnit -AccessRule 'CreateChild' -InheritanceType Descendents
    #     New-ADACLObject -Principal "DL_Tier2_OU_$AdministrativeUnit" -AccessControlType Allow -ObjectType 'Delete Organizational Unit objects' -InheritedObjectTypeName OrganizationalUnit -AccessRule 'DeleteChild' -InheritanceType Descendents
    # ) -Description "Accounts for users in $AdministrativeUnit" -ProtectedFromAccidentalDeletion $false

    # New-DelegationOU -CanonicalNameOU "Tier2\Instruments\$AdministrativeUnit" -DelegationInheritance Enabled -Delegation @(
    #     New-ADACLObject -Principal "DL_Tier2_OU_$AdministrativeUnit" -AccessControlType Allow -ObjectType 'Create Organizational Unit objects' -InheritedObjectTypeName OrganizationalUnit -AccessRule 'CreateChild' -InheritanceType Descendents
    #     New-ADACLObject -Principal "DL_Tier2_OU_$AdministrativeUnit" -AccessControlType Allow -ObjectType 'Delete Organizational Unit objects' -InheritedObjectTypeName OrganizationalUnit -AccessRule 'DeleteChild' -InheritanceType Descendents
    #     New-ADACLObject -Principal "DL_Tier2_Instruments_$AdministrativeUnit" -AccessControlType Allow -ObjectType 'Computer' -InheritedObjectTypeName 'Computer' -AccessRule 'CreateChild' -InheritanceType Descendents
    #     New-ADACLObject -Principal "DL_Tier2_Instruments_$AdministrativeUnit" -AccessControlType Allow -ObjectType 'Computer' -InheritedObjectTypeName 'Computer' -AccessRule 'DeleteChild' -InheritanceType Descendents
    #     New-ADACLObject -Principal "DL_Tier2_Instruments_$AdministrativeUnit" -AccessControlType Allow -ObjectType 'Computer' -InheritedObjectTypeName 'Reset Password' -AccessRule 'ExtendedRight' -InheritanceType Descendents
    #     New-ADACLObject -Principal "DL_Tier2_Instruments_$AdministrativeUnit" -AccessControlType Allow -ObjectType 'Computer' -InheritedObjectTypeName 'Change Password-2ndPhase' -AccessRule 'ExtendedRight' -InheritanceType Descendents
    #     New-ADACLObject -Principal "DL_Tier2_Instruments_$AdministrativeUnit" -AccessControlType Allow -ObjectType 'Computer' -InheritedObjectTypeName 'Validated write to service principal name' -AccessRule 'ExtendedRight' -InheritanceType Descendents
    #     New-ADACLObject -Principal "DL_Tier2_Instruments_$AdministrativeUnit" -AccessControlType Allow -ObjectType 'Computer' -InheritedObjectTypeName 'Validated write to DNS host name' -AccessRule 'ExtendedRight' -InheritanceType Descendents
    #     New-ADACLObject -Principal "DL_Tier2_Instruments_$AdministrativeUnit" -AccessControlType Allow -ObjectType 'Computer' -InheritedObjectTypeName 'Validate write to computer attributes' -AccessRule 'ExtendedRight' -InheritanceType Descendents
    #     New-ADACLObject -Principal "DL_Tier2_Instruments_$AdministrativeUnit" -AccessControlType Allow -ObjectType 'Computer' -InheritedObjectTypeName 'Allowed to Authenticate' -AccessRule 'ExtendedRight' -InheritanceType Descendents
    #     New-ADACLObject -Principal "DL_Tier2_Instruments_$AdministrativeUnit" -AccessControlType Allow -ObjectType 'Computer' -InheritedObjectTypeName 'Account Restrictions' -AccessRule 'ExtendedRight' -InheritanceType Descendents
    #     New-ADACLObject -Principal "DL_Tier2_Instruments_$AdministrativeUnit" -AccessControlType Deny -ObjectType 'Computer' -InheritedObjectTypeName 'ms-Mcs-AdmPwd' -AccessRule 'ReadProperty' -InheritanceType Descendents
    #     New-ADACLObject -Principal "DL_Tier2_Instruments_$AdministrativeUnit" -AccessControlType Deny -ObjectType 'Computer' -InheritedObjectTypeName 'ms-Mcs-AdmPwd' -AccessRule 'WriteProperty' -InheritanceType Descendents
    #     New-ADACLObject -Principal "DL_Tier2_Instruments_$AdministrativeUnit" -AccessControlType Deny -ObjectType 'Computer' -InheritedObjectTypeName 'ms-Mcs-AdmPwdExpirationTime' -AccessRule 'ReadProperty' -InheritanceType Descendents
    #     New-ADACLObject -Principal "DL_Tier2_Instruments_$AdministrativeUnit" -AccessControlType Deny -ObjectType 'Computer' -InheritedObjectTypeName 'ms-Mcs-AdmPwdExpirationTime' -AccessRule 'WriteProperty' -InheritanceType Descendents
    #     New-ADACLObject -Principal "DL_Tier2_InstrumentsLAPSRead_$AdministrativeUnit" -AccessControlType Allow -ObjectType 'Computer' -InheritedObjectTypeName 'ms-Mcs-AdmPwd' -AccessRule 'ReadProperty' -InheritanceType Descendents
    # ) -Description "Accounts for instruments in $AdministrativeUnit" -ProtectedFromAccidentalDeletion $false

    # New-DelegationOU -CanonicalNameOU "Tier2\Users\$AdministrativeUnit" -DelegationInheritance Enabled -Delegation @(
    #     #New-ADACLObject -Principal "DL_Tier2_User_$AdministrativeUnit" -AccessControlType Allow -ObjectType 'All' -InheritedObjectTypeName 'User' -AccessRule 'CreateChild', 'DeleteChild' -InheritanceType Descendents
    #     New-ADACLObject -Principal "DL_Tier2_User_$AdministrativeUnit" -AccessControlType Allow -ObjectType 'All' -InheritedObjectTypeName 'User' -AccessRule 'GenericAll' -InheritanceType Descendents
    #     New-ADACLObject -Principal "DL_Tier2_OU_$AdministrativeUnit" -AccessControlType Allow -ObjectType Organiz -InheritedObjectTypeName 'Organizational Unit' -AccessRule 'CreateChild' -InheritanceType Descendents
    #     New-ADACLObject -Principal "DL_Tier2_OU_$AdministrativeUnit" -AccessControlType Allow -ObjectType 'Delete Organizational Unit' -InheritedObjectTypeName 'Organizational Unit' -AccessRule 'DeleteChild' -InheritanceType Descendents
    # )

    # New-DelegationOU -CanonicalNameOU "Tier2\UsersVIP\$AdministrativeUnit" -DelegationInheritance Enabled -Delegation @(
    #     #New-ADACLObject -Principal "DL_Tier2_UserVIP_$AdministrativeUnit" -AccessControlType Allow -ObjectType 'All' -InheritedObjectTypeName 'User' -AccessRule 'CreateChild', 'DeleteChild' -InheritanceType Descendents
    #     New-ADACLObject -Principal "DL_Tier2_UserVIP_$AdministrativeUnit" -AccessControlType Allow -ObjectType 'All' -InheritedObjectTypeName 'User' -AccessRule 'GenericAll' -InheritanceType Descendents
    #     New-ADACLObject -Principal "DL_Tier2_OU_$AdministrativeUnit" -AccessControlType Allow -ObjectType 'Create Organizational Unit' -InheritedObjectTypeName 'Organizational Unit' -AccessRule 'CreateChild' -InheritanceType Descendents
    #     New-ADACLObject -Principal "DL_Tier2_OU_$AdministrativeUnit" -AccessControlType Allow -ObjectType 'Delete Organizational Unit' -InheritedObjectTypeName 'Organizational Unit' -AccessRule 'DeleteChild' -InheritanceType Descendents
    # )

    # New-DelegationOU -CanonicalNameOU "Tier2\Groups\$AdministrativeUnit" -DelegationInheritance Enabled -Delegation @(
    #     #New-ADACLObject -Principal "DL_Tier2_Groups_$AdministrativeUnit" -AccessControlType Allow -ObjectType 'All' -InheritedObjectTypeName 'Group' -AccessRule 'CreateChild' -InheritanceType Descendents
    #     #New-ADACLObject -Principal "DL_Tier2_Groups_$AdministrativeUnit" -AccessControlType Allow -ObjectType 'All' -InheritedObjectTypeName 'Group' -AccessRule 'DeleteChild' -InheritanceType Descendents
    #     New-ADACLObject -Principal "DL_Tier2_Groups_$AdministrativeUnit" -AccessControlType Allow -ObjectType 'All' -InheritedObjectTypeName 'Group' -AccessRule 'GenericAll' -InheritanceType Descendents
    # )

    # New-DelegationOU -CanonicalNameOU "Tier2\Optional\TestPWDMgmt" -DelegationInheritance Enabled -Delegation @(
    #     New-ADACLObject -Principal "DL_Tier2_PWDMgmt_$AdministrativeUnit" -AccessControlType Allow -ObjectType 'Reset Password' -InheritedObjectTypeName 'User' -AccessRule 'ExtendedRight' -InheritanceType Descendents
    #     New-ADACLObject -Principal "DL_Tier2_PWDMgmt_$AdministrativeUnit" -AccessControlType Allow -ObjectType 'pwdLastSet' -InheritedObjectTypeName 'User' -AccessRule 'ReadProperty' -InheritanceType Descendents
    #     New-ADACLObject -Principal "DL_Tier2_PWDMgmt_$AdministrativeUnit" -AccessControlType Allow -ObjectType 'pwdLastSet' -InheritedObjectTypeName 'User' -AccessRule 'WriteProperty' -InheritanceType Descendents
    #     New-ADACLObject -Principal "DL_Tier2_PWDMgmt_$AdministrativeUnit" -AccessControlType Allow -ObjectType 'lockoutTime' -InheritedObjectTypeName 'User' -AccessRule 'ReadProperty' -InheritanceType Descendents
    #     New-ADACLObject -Principal "DL_Tier2_PWDMgmt_$AdministrativeUnit" -AccessControlType Allow -ObjectType 'lockoutTime' -InheritedObjectTypeName 'User' -AccessRule 'WriteProperty' -InheritanceType Descendents
    # )

    # New-DelegationOU -CanonicalNameOU "Tier2\Optional\TestRSOP" -DelegationInheritance Enabled -Delegation @(
    #     New-ADACLObject -Principal "DL_Tier2_RSOP_$AdministrativeUnit" -AccessControlType Allow -ObjectType 'Generate Resultant Set of Policy (Logging)' -InheritedObjectTypeName 'All' -AccessRule 'ExtendedRight' -InheritanceType Descendents
    #     New-ADACLObject -Principal "DL_Tier2_RSOP_$AdministrativeUnit" -AccessControlType Allow -ObjectType 'Generate Resultant Set of Policy (Planning)' -InheritedObjectTypeName 'All' -AccessRule 'ExtendedRight' -InheritanceType Descendents
    #     New-ADACLObject -Principal "DL_Tier2_RSOP_$AdministrativeUnit" -AccessControlType Allow -ObjectType 'All' -InheritedObjectTypeName 'All' -AccessRule 'ReadProperty' -InheritanceType Descendents
    # )

} -LogFile "$PSScriptRoot\Logs\Delegation_$((Get-Date).ToString('yyyy-MM-dd_HH_mm_ss')).log" -LogOption Add, Remove #, Skip