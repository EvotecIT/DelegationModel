function Initialize-DelegationModel {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][string] $Domain
    )
    $Script:Reporting = [ordered] @{}
    $Script:Reporting['Version'] = Get-GitHubVersion -Cmdlet 'Start-DelegationModel' -RepositoryOwner 'evotecit' -RepositoryName 'DelegationModel'
    $Script:Reporting['Settings'] = @{
        ShowError   = $ShowError.IsPresent
        ShowWarning = $ShowWarning.IsPresent
        HideSteps   = $HideSteps.IsPresent
    }

    if ($LogFile) {
        $FolderPath = [io.path]::GetDirectoryName($LogFile)
        if (-not (Test-Path -LiteralPath $FolderPath)) {
            $null = New-Item -Path $FolderPath -ItemType Directory -Force -WhatIf:$false
        }
        $PSDefaultParameterValues = @{
            "Write-Color:LogFile" = $LogFile
        }
        Write-Color '[i]', "[DelegationModel] ", 'Version ', $Script:Reporting['Version'] -Color Yellow, DarkGray, Yellow, DarkGray, Magenta
        $CurrentLogs = Get-ChildItem -LiteralPath $FolderPath | Sort-Object -Property CreationTime -Descending | Select-Object -Skip $LogMaximum
        if ($CurrentLogs) {
            Write-Color -Text '[i]', "[DelegationModel] ", "Logs directory has more than ", $LogMaximum, " log files. Cleanup required..." -Color Yellow, DarkCyan, Red, DarkCyan
            foreach ($Log in $CurrentLogs) {
                try {
                    Remove-Item -LiteralPath $Log.FullName -Confirm:$false -WhatIf:$false
                    Write-Color -Text '[i]', "[DelegationModel] ", '[log deleted] ', "Deleted ", "$($Log.FullName)" -Color Yellow, White, Green
                } catch {
                    Write-Color -Text '[i]', "[DelegationModel] ", '[log error] ', "Couldn't delete log file $($Log.FullName). Error: ', "$($_.Exception.Message) -Color Yellow, White, Red
                }
            }
        }
    } else {
        Write-Color '[i]', "[DelegationModel] ", 'Version ', $Script:Reporting['Version'] -Color Yellow, DarkGray, Yellow, DarkGray, Magenta
    }

    Write-Color '[i]', "[DelegationModel] ", 'Getting forest information' -Color Yellow, DarkGray, Yellow
    $ForestInformation = Get-WinADForestDetails
    if (-not $ForestInformation) {
        Write-Color -Text '[-] ', "Forest information could not be retrieved. Please check your connection to the domain controller." -Color Red, White
        return
    }

    $DC = $ForestInformation['QueryServers'][$Domain]
    $DC = $DC.HostName[0]
    if (-not $DC) {
        Write-Color -Text '[!] ', "Given domain $Domain can't be found in the forest. Please make sure to provide proper value." -Color Red, White
        return
    }
    $DC
}