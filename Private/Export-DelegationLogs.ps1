function Export-DelegationLogs {
    [CmdletBinding()]
    param(
        $CanonicalNameOU,
        $OutputFromDelegation,
        [ValidateSet('Add', 'Remove', 'Skip')][string[]] $LogOption
    )
    foreach ($Type in @('Skip', 'Add', 'Remove', 'Warnings', 'Errors')) {
        foreach ($D in $OutputFromDelegation.$Type) {
            if ($Type -eq 'Skip') {
                if ($LogOption -notcontains 'Skip') {
                    continue
                }
                $Action = 'Skipping'
                $ActionSign = '[s]'
                $ActionColor = [System.ConsoleColor]::DarkMagenta
            } elseif ($Type -eq 'Add') {
                if ($LogOption -notcontains 'Add') {
                    continue
                }
                $Action = 'Adding'
                $ActionSign = '[+]'
                $ActionColor = [System.ConsoleColor]::Green
            } elseif ($Type -eq 'Remove') {
                if ($LogOption -notcontains 'Remove') {
                    continue
                }
                $Action = 'Removing'
                $ActionSign = '[-]'
                $ActionColor = [System.ConsoleColor]::DarkRed
            } elseif ($Type -eq 'Warnings') {
                $Action = 'Warning'
                $ActionSign = '[!]'
                $ActionColor = [System.ConsoleColor]::DarkMagenta
                Write-Color -Text $ActionSign, "[$($CanonicalNameOU)]", "[$Action] ", $D -Color $ActionColor, DarkGray, $ActionColor, White
                continue
            } elseif ($Type -eq 'Errors') {
                $Action = 'Error'
                $ActionSign = '[!]'
                $ActionColor = [System.ConsoleColor]::Red
                Write-Color -Text $ActionSign, "[$($CanonicalNameOU)]", "[$Action] ", $D -Color $ActionColor, DarkGray, $ActionColor, White
                continue
            }
            $OptionColor = [System.ConsoleColor]::DarkGray
            $ValueColor = [System.ConsoleColor]::Magenta
            $BracketColor = [System.ConsoleColor]::DarkGray
            if ($D.Permissions.AccessControlType -eq 'Allow') {
                $ColorAccessControlType = [System.ConsoleColor]::Green
            } else {
                $ColorAccessControlType = [System.ConsoleColor]::Red
            }
            $PrincipalColor = [System.ConsoleColor]::Magenta
            Write-Color -Text @(
                $ActionSign,
                "[$($CanonicalNameOU)]",
                "[$Action]",
                "[Principal: ", $($D.Principal), "]",
                "[AccessControlType: ", $($D.Permissions.AccessControlType), "]",
                "[ActiveDirectoryRights: ", $($D.Permissions.ActiveDirectoryRights), "]",
                "[ObjectTypeName: ", $($D.Permissions.ObjectTypeName), "]",
                "[InheritedObjectTypeName: ", $($D.Permissions.InheritedObjectTypeName), "]",
                "[InheritanceType: ", $($D.Permissions.InheritanceType), "]"
            ) -Color $ActionColor, DarkGray, $ActionColor, $OptionColor, $PrincipalColor, $BracketColor, $OptionColor, $ColorAccessControlType, $OptionColor, $BracketColor, $ValueColor, $BracketColor, $OptionColor, $ValueColor, $BracketColor, $OptionColor, $ValueColor, $BracketColor, $OptionColor, $ValueColor, $BracketColor, $OptionColor, $ValueColor, $BracketColor
        }
    }
}