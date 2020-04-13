<#
Export-PELicense.ps1 - Exports licenses from iDRAC as XML File.

_author_ = Ravikanth Chaganti <Ravikanth_Chaganti@Dell.com> _version_ = 1.0

Copyright (c) 2020, Dell, Inc.

This software is licensed to you under the GNU General Public License, version 2 (GPLv2). There is NO WARRANTY for this software, express or implied, including the implied warranties of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. You should have received a copy of GPLv2 along with this software; if not, see http://www.gnu.org/licenses/old-licenses/gpl-2.0.txt
#>
function Export-PELicense
{
    [CmdletBinding()]
    param 
    (
        [Parameter(Mandatory = $true)]
        $iDRACSession,

        [Parameter(Mandatory = $true)]
        [String]
        $EntitlementID,

        [Parameter(Mandatory = $true)]
        [String]
        $ExportFilePath
    )

    $properties= @{SystemCreationClassName="DCIM_SPComputerSystem";SystemName="systemmc";CreationClassName="DCIM_LicenseManagementService";Name="DCIM:LicenseManagementService";}
    $instance = New-CimInstance -ClassName DCIM_LicenseManagementService -Namespace root/dcim -ClientOnly -Key @($properties.keys) -Property $properties    
    
    $parameters = @{
        EntitlementID = '8316PA_ravikanth_chagant'
    }
    
    $job = Invoke-CimMethod -InputObject $instance -MethodName ExportLicense -CimSession $iDRACSession -Arguments $parameters

    if ($job.ReturnValue -eq 0)
    {
        $licenseString = [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($job.LicenseFile))
        $xmlFileName = "$($iDRACSession.ComputerName)_${EntitlementID}.xml"
        $licenseString | Out-FIle -FilePath "${ExportFilePath}\$xmlFileName"
    }
}
