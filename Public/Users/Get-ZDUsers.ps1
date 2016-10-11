﻿<#
.Synopsis
   Short description
.DESCRIPTION
   Long description
.EXAMPLE
   Example of how to use this cmdlet
.EXAMPLE
   Another example of how to use this cmdlet
#>
function Get-ZDUsers
{
    [CmdletBinding()]
    [Alias()]
    [OutputType([int])]
    Param
    (
        # Param2 help description
        [Parameter(ParameterSetName='Filter')]
        [ValidateSet('end-user','agent','admin')]
        [string[]]$Role,

        [Parameter(ParameterSetName='Filter')]
        $GroupID,

        [Parameter(ParameterSetName='Filter')]
        $OrganizationID
    )

    Begin
    {
        $RoleString = @()

        if ($Role)
        {
            if ($role.Count -gt 1)
            {
                for ($i = 0; $i -le $role.count; $i++)
                {
                    $RoleString += "role[]=$r&"
                }
            }
            else
            {
                $RoleString = "role=$role"
            }
        }
        else
        {
            $RoleString = ''
        }
    }
    Process
    {
        try
        {
            if ($GroupID)
            {
                $params = @{
                    Uri = ("https://$Domain.zendesk.com/api/v2/groups/$GroupID/users.json?$RoleString").TrimEnd('&')
                    Method = 'Get'
                    Headers = $Headers
                }
            }
            elseif ($OrganizationID)
            {
                $params = @{
                    Uri = ("https://$Domain.zendesk.com/api/v2/organizations/$OrganizationID/users.json?$RoleString").TrimEnd('&')
                    Method = 'Get'
                    Headers = $Headers
                }
            }
            else
            {
                $params = @{
                    Uri = ("https://$Domain.zendesk.com/api/v2/users.json?$RoleString").TrimEnd('&')
                    Method = 'Get'
                    Headers = $Headers
                }
            }

            $Result = Invoke-RestMethod @params
        }
        catch
        {
            throw 'Error searching for users'
        }
    }
    End
    {
        return $Result
    }
}