#requires -Version 2 -Modules Hyper-V

#implicitly import hyperv module to avoid powercli cmdlets
if ((Get-Module -Name 'hyper-v') -ne $null) {
  Remove-Module -Name hyper-v
  Import-Module -Name hyper-v
}
else {
  Import-Module -Name hyper-v
}

$ProgressPreference = 'SilentlyContinue'

function Get-DefaultVMSwitch {
  [CmdletBinding()]
  param ($Name)

  $switches = Get-VMSwitch @PSBoundParameters
  
  if (-not $PSBoundParameters.ContainsKey('Name') -and (($switches.Name) -contains 'Default Switch') ) {
      # Looking for 'Default Switch' on Fall Creators Update or newer
      $switches = $switches | 
          Where-Object {$_.Name -like 'Default Switch'}    
  }

  $switches | 
      Select-Object -first 1 | 
      Select-Object Name, ID
}