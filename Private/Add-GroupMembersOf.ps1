function Add-GroupMembersOf {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [string] $Identity,
        [string] $Group,
        [string] $DC,
        [ValidateSet('Add', 'Remove', 'Skip')][string[]] $LogOption
    )
    $CacheMembers = [ordered] @{}
    try {
        $MemberExists = Get-ADGroupMember -Identity $Identity -Server $DC -ErrorAction Stop
    } catch {
        Write-Color -Text '[!] ', "Member ", $Group, " addition to $Identity failed. Error: ", $_.Exception.Message -Color Red, Yellow, Red, Yellow
        return
    }
    foreach ($Member in $MemberExists) {
        $CacheMembers[$Member.SamAccountName] = $Member
        $CacheMembers[$Member.DistinguishedName] = $Member
        $CacheMembers[$Member.SID.Value] = $Member
    }
    try {
        if ($CacheMembers[$Group]) {
            if ($LogOption -contains 'Skip') {
                Write-Color -Text '[s] ', "Member ", $Group, " already exists in ", $Identity -Color Magenta, Yellow, Magenta, Yellow
            }
            continue
        }
        Add-ADGroupMember -Identity $Identity -Members $Group -ErrorAction Stop -Server $DC
        if ($LogOption -contains 'Add') {
            Write-Color -Text '[+] ', "Member ", $Group, " added to $Identity" -Color Green, White, Green, White
        }
    } catch {
        Write-Color -Text '[!] ', "Member ", $Group, " addition to $Identity failed. Error: ", $_.Exception.Message -Color Red, Yellow, Red, Yellow
    }
}