<p align="center">
  <a href="https://www.powershellgallery.com/packages/DelegtionModel"><img src="https://img.shields.io/powershellgallery/v/DelegtionModel.svg"></a>
  <a href="https://www.powershellgallery.com/packages/DelegtionModel"><img src="https://img.shields.io/powershellgallery/vpre/DelegtionModel.svg?label=powershell%20gallery%20preview&colorB=yellow"></a>
  <a href="https://github.com/EvotecIT/DelegtionModel"><img src="https://img.shields.io/github/license/EvotecIT/DelegtionModel.svg"></a>
</p>

<p align="center">
  <a href="https://www.powershellgallery.com/packages/DelegtionModel"><img src="https://img.shields.io/powershellgallery/p/DelegtionModel.svg"></a>
  <a href="https://github.com/EvotecIT/DelegtionModel"><img src="https://img.shields.io/github/languages/top/evotecit/DelegtionModel.svg"></a>
  <a href="https://github.com/EvotecIT/DelegtionModel"><img src="https://img.shields.io/github/languages/code-size/evotecit/DelegtionModel.svg"></a>
  <a href="https://www.powershellgallery.com/packages/DelegtionModel"><img src="https://img.shields.io/powershellgallery/dt/DelegtionModel.svg"></a>
</p>

<p align="center">
  <a href="https://twitter.com/PrzemyslawKlys"><img src="https://img.shields.io/twitter/follow/PrzemyslawKlys.svg?label=Twitter%20%40PrzemyslawKlys&style=social"></a>
  <a href="https://evotec.xyz/hub"><img src="https://img.shields.io/badge/Blog-evotec.xyz-2A6496.svg"></a>
  <a href="https://www.linkedin.com/in/pklys"><img src="https://img.shields.io/badge/LinkedIn-pklys-0077B5.svg?logo=LinkedIn"></a>
</p>

# DelegtionModel

**DelegtionModel** PowerShell module provides a simplified way to manage delegation in Active Directory. It's based on [ADEssentials](https://github.com/EvotecIT/ADEssentials) module and builts on top of it. This module is *Work in Progress* and requires further testing.

## ToDO

- [ ] add support for changing group scope
- [x] add support for moving groups based on path change
- [x] add support for reruning the script multiple times until nothing is left
- [x] add support for members behavior (replace, add, remove)
- [x] add support for ProtectedFromAccidentalDeletion
- [ ] add support for AuditMode
  - [ ] Groups
  - [ ] Delegation
- [ ] Detect if user is enabled for members
- [ ] Specify global options to use
- [ ] Add file/folder for Sysvol and Netlogon delegation
- [ ] Backup / Restore
- [ ] Verify delegation model
- [ ] Validation of Names in New-ADACLObject (check if it's a valid name and if not stop
- [ ] Detect ProtectedFromAccidentalDeletion and Everyone being affected