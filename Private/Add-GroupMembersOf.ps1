function Add-GroupMembersOf {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [string] $Identity,
        [string] $Group
    )
    $CacheMembers = [ordered] @{}
    $MemberExists = Get-ADGroupMember -Identity $Identity
    foreach ($Member in $MemberExists) {
        $CacheMembers[$Member.SamAccountName] = $Member
        $CacheMembers[$Member.DistinguishedName] = $Member
        $CacheMembers[$Member.SID.Value] = $Member
    }
    try {
        if ($CacheMembers[$Group]) {
            Write-Color -Text '[-] ', "Member ", $Group, " already exists in ", $Identity -Color Red, Yellow, Red, Yellow
            continue
        }
        Add-ADGroupMember -Identity $Identity -Members $Group -ErrorAction Stop
        Write-Color -Text '[+] ', "Member ", $Group, " added to $Identity" -Color Green, White, Green, White
    } catch {
        Write-Color -Text '[-] ', "Member ", $Group, " addition to $Identity failed. Error: ", $_.Exception.Message -Color Red, Yellow, Red, Yellow
    }
}