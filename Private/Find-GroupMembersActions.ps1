function Find-GroupMembersActions {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [parameter(Mandatory)][string] $Identity,
        [parameter()][Array] $ExpectedMembers,
        [parameter(Mandatory)][string] $DC,
        [parameter(Mandatory)][string[]] $MembersBehaviour,
        [ValidateSet('Add', 'Remove', 'Skip')][string[]] $LogOption
    )
    $CacheMembers = [ordered] @{}
    $MemberExists = Get-ADGroupMember -Identity $Identity -Server $DC
    foreach ($Member in $MemberExists) {
        $CacheMembers[$Member.SamAccountName] = $Member
        $CacheMembers[$Member.DistinguishedName] = $Member
        $CacheMembers[$Member.SID.Value] = $Member
    }

    $MemberToAdd = foreach ($Member in $ExpectedMembers) {
        if ($CacheMembers[$Member]) {
            #Write-Color -Text '[-] ', "Member ", $Member, " already exists in ", $Identity -Color Red, Yellow, Red, Yellow
            continue
        } else {
            #Write-Color -Text '[+] ', "Member ", $Member, " will be added to ", $Identity -Color Green, Yellow, Green, Yellow
            $Member
        }
    }
    $MemberToRemove = foreach ($Member in $MemberExists) {
        if ($Member.SamAccountName -notin $ExpectedMembers -and $Member.distinguishedName -notin $ExpectedMembers -and $Member.SID.Value -notin $ExpectedMembers) {
            #Write-Color -Text '[-] ', "Member ", $Member, " will be removed from ", $Identity -Color Red, Yellow, Red, Yellow
            $Member
        } else {
            #Write-Color -Text '[+] ', "Member ", $Member, " already exists in ", $Identity -Color Green, Yellow, Green, Yellow
            continue
        }
    }

    if ($MembersBehaviour -contains 'Remove') {
        foreach ($Member in $MemberToRemove) {
            try {
                Remove-ADGroupMember -Identity $Identity -Members $Member -ErrorAction Stop -Confirm:$false -Server $DC
                if ($LogOption -contains 'Remove') {
                    Write-Color -Text '[+] ', "Member ", $Member, " removed from $Identity" -Color Green, White, Green, White
                }
            } catch {
                Write-Color -Text '[!] ', "Member ", $Member, " removal from $Identity failed. Error: ", $_.Exception.Message -Color Red, Yellow, Red, Yellow
            }
        }
    }
    if ($MembersBehaviour -contains 'Add') {
        foreach ($Member in $MemberToAdd) {
            try {
                Add-ADGroupMember -Identity $Identity -Members $Member -ErrorAction Stop -Server $DC
                if ($LogOption -contains 'Add') {
                    Write-Color -Text '[+] ', "Member ", $Member, " added to $Identity" -Color Green, White, Green, White
                }
            } catch {
                Write-Color -Text '[!] ', "Member ", $Member, " addition to $Identity failed. Error: ", $_.Exception.Message -Color Red, Yellow, Red, Yellow
            }
        }
    }
}