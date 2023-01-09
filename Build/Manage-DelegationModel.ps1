Clear-Host

$Configuration = @{
    Information = @{
        ModuleName        = 'DelegationModel'
        DirectoryProjects = 'C:\Support\GitHub'

        Manifest          = @{
            # Version number of this module.
            ModuleVersion              = '0.0.X'
            # Supported PSEditions
            CompatiblePSEditions       = @('Desktop', 'Core')
            # ID used to uniquely identify this module
            GUID                       = '25a17911-7a7a-4c86-8543-aefb907874f7'
            # Author of this module
            Author                     = 'Przemyslaw Klys'
            # Company or vendor of this module
            CompanyName                = 'Evotec'
            # Copyright statement for this module
            Copyright                  = "(c) 2011 - $((Get-Date).Year) Przemyslaw Klys @ Evotec. All rights reserved."
            # Description of the functionality provided by this module
            Description                = 'DelegationModel is a PowerShell module to create and manage delegation model'
            # Minimum version of the Windows PowerShell engine required by this module
            PowerShellVersion          = '5.1'
            # Functions to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no functions to export.
            # Private data to pass to the module specified in RootModule/ModuleToProcess. This may also contain a PSData hashtable with additional module metadata used by PowerShell.
            Tags                       = @('Windows')

            IconUri                    = 'https://evotec.xyz/wp-content/uploads/2023/01/DelegationModel.png'

            ProjectUri                 = 'https://github.com/EvotecIT/DelegationModel'

            RequiredModules            = @(
                @{ ModuleName = 'PSSharedGoods'; ModuleVersion = "Latest"; Guid = 'ee272aa8-baaa-4edf-9f45-b6d6f7d844fe' }
                @{ ModuleName = 'PSWriteColor'; ModuleVersion = "Latest"; Guid = '0b0ba5c5-ec85-4c2b-a718-874e55a8bc3f' }
                @{ ModuleName = 'PSWriteHTML'; ModuleVersion = "Latest"; Guid = 'a7bdf640-f5cb-4acf-9de0-365b322d245c' }
                @{ ModuleName = 'ADEssentials'; ModuleVersion = "Latest"; Guid = '9fc9fd61-7f11-4f4b-a527-084086f1905f' }
            )
            ExternalModuleDependencies = @(
                'ActiveDirectory'
                #"DnsServer"
                #"DnsClient"
            )
        }
    }
    Options     = @{
        Merge             = @{
            Sort           = 'None'
            FormatCodePSM1 = @{
                Enabled           = $true
                RemoveComments    = $true
                FormatterSettings = @{
                    IncludeRules = @(
                        'PSPlaceOpenBrace',
                        'PSPlaceCloseBrace',
                        'PSUseConsistentWhitespace',
                        'PSUseConsistentIndentation',
                        'PSAlignAssignmentStatement',
                        'PSUseCorrectCasing'
                    )

                    Rules        = @{
                        PSPlaceOpenBrace           = @{
                            Enable             = $true
                            OnSameLine         = $true
                            NewLineAfter       = $true
                            IgnoreOneLineBlock = $true
                        }

                        PSPlaceCloseBrace          = @{
                            Enable             = $true
                            NewLineAfter       = $false
                            IgnoreOneLineBlock = $true
                            NoEmptyLineBefore  = $false
                        }

                        PSUseConsistentIndentation = @{
                            Enable              = $true
                            Kind                = 'space'
                            PipelineIndentation = 'IncreaseIndentationAfterEveryPipeline'
                            IndentationSize     = 4
                        }

                        PSUseConsistentWhitespace  = @{
                            Enable          = $true
                            CheckInnerBrace = $true
                            CheckOpenBrace  = $true
                            CheckOpenParen  = $true
                            CheckOperator   = $true
                            CheckPipe       = $true
                            CheckSeparator  = $true
                        }

                        PSAlignAssignmentStatement = @{
                            Enable         = $true
                            CheckHashtable = $true
                        }

                        PSUseCorrectCasing         = @{
                            Enable = $true
                        }
                    }
                }
            }
            FormatCodePSD1 = @{
                Enabled        = $true
                RemoveComments = $false
            }
            Integrate      = @{
                ApprovedModules = @('Graphimo', 'PSSharedGoods', 'PSWriteColor', 'Connectimo', 'PSUnifi', 'PSWebToolbox', 'PSMyPassword', 'O365EmailAddressPolicy')
            }
        }
        Standard          = @{
            FormatCodePSM1 = @{

            }
            FormatCodePSD1 = @{
                Enabled = $true
                #RemoveComments = $true
            }
        }
        ImportModules     = @{
            Self            = $true
            RequiredModules = $false
            Verbose         = $false
        }
        PowerShellGallery = @{
            ApiKey   = 'C:\Support\Important\PowerShellGalleryAPI.txt'
            FromFile = $true
        }
        GitHub            = @{
            ApiKey   = 'C:\Support\Important\GithubAPI.txt'
            FromFile = $true
            UserName = 'EvotecIT'
            #RepositoryName = 'PSWriteHTML'
        }
        Documentation     = @{
            Path       = 'Docs'
            PathReadme = 'Docs\Readme.md'
        }
        Style             = @{
            PSD1 = 'Minimal' # Native
        }
    }
    Steps       = @{
        BuildModule        = @{  # requires Enable to be on to process all of that
            Enable           = $true
            DeleteBefore     = $false
            Merge            = $true
            MergeMissing     = $true
            SignMerged       = $true
            Releases         = $true
            ReleasesUnpacked = @{
                Enabled         = $false
                IncludeTagName  = $false
                Relative        = $true # default is $true
                Path            = "$PSScriptRoot\..\Artefacts"
                RequiredModules = @{
                    Enabled = $true
                    Path    = "$PSScriptRoot\..\Artefacts\Modules"
                }
                FilesOutput     = [ordered] @{
                    #"Examples\AdminManager.ps1" = "AdminManager.ps1"
                }
            }
            RefreshPSD1Only  = $false
        }
        BuildDocumentation = $false
        ImportModules      = @{
            Self            = $true
            RequiredModules = $false
            Verbose         = $false
        }
        PublishModule      = @{  # requires Enable to be on to process all of that
            Enabled      = $false
            Prerelease   = ''
            RequireForce = $false
            GitHub       = $false
        }
    }
}

New-PrepareModule -Configuration $Configuration