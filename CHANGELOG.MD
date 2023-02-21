
### 0.0.5
- Fixes an issue with members being incorrectly added to non-existing group

### 0.0.4
- Fixes issue with members/memberof for statically named groups
- Adjusted some colors that should look better on PowerShell 5.1
- Reworked some internal logic
- Improved output to logs
- Added logging for DelegationGroups

### 0.0.3
- Added `MembersBehaviour` to both `New-DelegationGroup` and `Start-DelegationGroups` that controls Members action (Add, Remove)
- Added new way to manage groups, the old one is still valid
- Improved groups creation, modification
- Added `ProtectedFromAccidentalDeletion` as a feature
- Fixes OU creation, where it would create some OUs at the root by mistake
- Added logging to file
- Added logging options to allow to display some or all of the information (Add, Skip or Remove)

```powershell
Start-DelegationGroups -MembersBehaviour 'Add', 'Remove' -Destination 'OU=Delegation,OU=Groups,OU=Production,DC=ad,DC=evotec,DC=xyz' -Domain 'ad.evotec.xyz' -Verbose {
    foreach ($AdministrativeUnit in $AdministrativeUnits) {
        New-DelegationGroup -Name "DL_Tier2_PUIDs_A_$AdministrativeUnit" -Path $OUPath -GroupScope 'DomainLocal' -GroupCategory 'Security' -Description 'Testing description' -DisplayName "DL_Tier2_PUIDs_A_$AdministrativeUnit" -ProtectedFromAccidentalDeletion
        New-DelegationGroup -Name "DL_Tier2_Groups_A_$AdministrativeUnit" -Path $OUPath -GroupScope 'DomainLocal' -GroupCategory 'Security'
        New-DelegationGroup -Name "DL_Tier2_Contacts_A_$AdministrativeUnit" -Path $OUPath -GroupScope 'DomainLocal' -GroupCategory 'Security'
        New-DelegationGroup -Name "DL_Tier2_Computers_A_$AdministrativeUnit" -Path $OUPath -GroupScope 'DomainLocal' -GroupCategory 'Security'
        New-DelegationGroup -Name "DL_Tier2_Devices_$AdministrativeUnit" -Path $OUPath -GroupScope 'DomainLocal' -GroupCategory 'Security'
        New-DelegationGroup -Name "DL_Tier2_LAPS_A_Administrator_$AdministrativeUnit" -Path $OUPath -GroupScope 'DomainLocal' -GroupCategory 'Security'
        New-DelegationGroup -Name "DL_Tier2_User_Account_B_$AdministrativeUnit" -Path $OUPath -GroupScope 'DomainLocal' -GroupCategory 'Security'
        New-DelegationGroup -Name "DL_Tier2_Groups_B_$AdministrativeUnit" -Path $OUPath -GroupScope 'DomainLocal' -GroupCategory 'Security'
        New-DelegationGroup -Name "DL_Tier2_Contacts_B_$AdministrativeUnit" -Path $OUPath -GroupScope 'DomainLocal' -GroupCategory 'Security'
        New-DelegationGroup -Name "DL_Tier2_Computers_B_$AdministrativeUnit" -Path $OUPath -GroupScope 'DomainLocal' -GroupCategory 'Security'
        New-DelegationGroup -Name "DL_Tier2_Devices_$AdministrativeUnit" -Path $OUPath -GroupScope 'DomainLocal' -GroupCategory 'Security'
        New-DelegationGroup -Name "DL_Tier2_LAPS_B_Administrator_$AdministrativeUnit" -Path $OUPath -GroupScope 'DomainLocal' -GroupCategory 'Security'

        New-DelegationGroup -Name "GG_Tier2_Service_Desk_Admins" -Path $OUPath -GroupScope 'DomainLocal' -GroupCategory 'Security' -Members @(

        ) -MemberOf @(
            "DL_Tier2_User_Account_B_$AdministrativeUnit"
            "DL_Tier2_Groups_B_$AdministrativeUnit"
        )
        New-DelegationGroup -Name "GG_Tier2_LDAP_Admins_$AdministrativeUnit" -Path $OUPath -GroupScope 'DomainLocal' -GroupCategory 'Security' -Members @(

        ) -MemberOf @(
            "DL_Tier2_LAPS_A_Administrator_$AdministrativeUnit"
        )
        $newDelegationGroupSplat = @{
            Name          = "GG_Tier2_Multiple_Objects_Admins_$AdministrativeUnit"
            Path          = $OUPath
            GroupScope    = 'DomainLocal'
            GroupCategory = 'Security'
            Members       = @(
                #'przemyslaw.klys'
                'dennis.vanburen'
            )
            MemberOf      = @(
                "DL_Tier2_PUIDs_A_$AdministrativeUnit"
                "DL_Tier2_Groups_A_$AdministrativeUnit"
                "DL_Tier2_Contacts_A_$AdministrativeUnit"
                "DL_Tier2_Computers_A_$AdministrativeUnit"
                "DL_Tier2_LAPS_A_Administrator_$AdministrativeUnit"
            )
        }
        New-DelegationGroup @newDelegationGroupSplat -MembersBehaviour 'Add', 'Remove'
    }
}
```

### 0.0.2 - 2023.01.03
- Released for testing

### 0.0.1 - 2022.12.18
- Initial release