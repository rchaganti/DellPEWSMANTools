<#
Get-PELicense.ps1 - Exports licenses from iDRAC as XML File.

_author_ = Ravikanth Chaganti <Ravikanth_Chaganti@Dell.com> _version_ = 1.0

Copyright (c) 2020, Dell, Inc.

This software is licensed to you under the GNU General Public License, version 2 (GPLv2). There is NO WARRANTY for this software, express or implied, including the implied warranties of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. You should have received a copy of GPLv2 along with this software; if not, see http://www.gnu.org/licenses/old-licenses/gpl-2.0.txt
#>
function Get-PELicense
{
    [CmdletBinding()]
    param 
    (
        [Parameter(Mandatory = $true)]
        $iDRACSession
    )

    $licenseInfo = Get-CimInstance -CimSession $iDRACSession -ClassName DCIM_License -Namespace root/dcim
    if ($licenseInfo)
    {
        return $licenseInfo
    }
    else
    {
        throw 'License information could not be retrieved'
    }
}
