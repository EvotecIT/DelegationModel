function Find-GroupMembersActions {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [string] $Identity,
        [Array] $ExpectedMembers,
        [string] $DC
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
            #Write-Color -Text '[-] ', "Member ", $Member, " already exists in ", $Group -Color Red, Yellow, Red, Yellow
            continue
        } else {
            Write-Color -Text '[+] ', "Member ", $Member, " will be added to ", $Group -Color Green, Yellow, Green, Yellow
            $Member
        }
    }
    $MemberToRemove = foreach ($Member in $MemberExists) {
        if ($Member.SamAccountName -notin $ExpectedMembers -and $Member.distinguishedName -notin $ExpectedMembers -and $Member.SID.Value -notin $ExpectedMembers) {
            Write-Color -Text '[-] ', "Member ", $Member, " will be removed from ", $Group -Color Red, Yellow, Red, Yellow
            $Member
        } else {
            #Write-Color -Text '[+] ', "Member ", $Member, " already exists in ", $Group -Color Green, Yellow, Green, Yellow
            continue
        }
    }

    foreach ($Member in $MemberToRemove) {
        try {
            Remove-ADGroupMember -Identity $Group -Members $Member -ErrorAction Stop -Confirm:$false -Server $DC
            Write-Color -Text '[+] ', "Member ", $Member, " removed from $Group" -Color Green, White, Green, White
        } catch {
            Write-Color -Text '[-] ', "Member ", $Member, " removal from $Group failed. Error: ", $_.Exception.Message -Color Red, Yellow, Red, Yellow
        }
    }
    foreach ($Member in $MemberToAdd) {
        try {
            Add-ADGroupMember -Identity $Group -Members $Member -ErrorAction Stop -Server $DC
            Write-Color -Text '[+] ', "Member ", $Member, " added to $Group" -Color Green, White, Green, White
        } catch {
            Write-Color -Text '[-] ', "Member ", $Member, " addition to $Group failed. Error: ", $_.Exception.Message -Color Red, Yellow, Red, Yellow
        }
    }
}