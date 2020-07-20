<#
Import-PELicense.ps1 - Imports licenses into iDRAC.

_author_ = Ravikanth Chaganti <Ravikanth_Chaganti@Dell.com> _version_ = 1.0

Copyright (c) 2020, Dell, Inc.

This software is licensed to you under the GNU General Public License, version 2 (GPLv2). There is NO WARRANTY for this software, express or implied, including the implied warranties of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. You should have received a copy of GPLv2 along with this software; if not, see http://www.gnu.org/licenses/old-licenses/gpl-2.0.txt
#>
function Import-PELicense
{
    [CmdletBinding()]
    param 
    (
        [Parameter(Mandatory = $true)]
        $iDRACSession,

        [Parameter()]
        [String]
        $DeviceFQDD = 'iDRAC.Embedded.1',

        [Parameter(Mandatory = $true)]
        [String]
        $LicenseFilePath,

        [Parameter()]
        [ValidateRange(0,2)]
        [Int]
        $ImportOption = 0
    )

    $properties= @{SystemCreationClassName="DCIM_SPComputerSystem";SystemName="systemmc";CreationClassName="DCIM_LicenseManagementService";Name="DCIM:LicenseManagementService";}
    $instance = New-CimInstance -ClassName DCIM_LicenseManagementService -Namespace root/dcim -ClientOnly -Key @($properties.keys) -Property $properties    
    
    $licenseXmlContent = Get-Content -Path $LicenseFilePath
    $base64License = [Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($licenseXmlContent))

    $parameters = @{
        LicenseFile = $base64License
        FQDD = $DeviceFQDD
        ImportOptions = $ImportOption
    }

    $job = Invoke-CimMethod -InputObject $instance -MethodName ImportLicense -CimSession $iDRACSession -Arguments $parameters

    return $job
}
