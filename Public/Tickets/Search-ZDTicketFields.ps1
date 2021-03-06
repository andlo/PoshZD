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
function Search-ZDTicketFields
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    Param
    (
        # Param1 help description
        [Parameter(ParameterSetName = 'All')]
        [switch]$AllTickets,

        [Parameter(ParameterSetName = 'Single')]
        # Param2 help description
        [int]$Ticket,

        [string]$SearchTerm
    )

    Begin
    {
        Write-Verbose -Message 'Creating parameters from Search-ZDTicketFields'

        if ($AllTickets)
        {
            $params = @{
                Uri = "https://$Domain.zendesk.com/api/v2/ticket_fields.json"
                Method = 'Get'
                Headers = $Headers
            }
       }
       else
       {
            $params = @{
                Uri = "https://$Domain.zendesk.com/api/v2/ticket_fields/$Ticket.json"
                Method = 'Get'
                Headers = $Headers
            }
       }
    }
    Process
    {
        Write-Verbose -Message 'Invoking Rest Method from Search-ZDTicketFields'

        $Result = Invoke-RestMethod @params

        $ReturnObject = @()

        for ($i = 0; $i -le $Result.count; $i++)
        {
            if (($Result.ticket_fields.title[$i] -match $SearchTerm) -or `
                ($Result.ticket_fields.custom_field_options.name[$i] -like $SearchTerm) -or `
                ($Result.ticket_fields.custom_field_options.value[$i] -like $SearchTerm) -or `
                ($Result.ticket_fields.type[$i] -like $SearchTerm) -or `
                ($Result.ticket_fields.tag[$i] -like $SearchTerm)) 
            {
                $TempObject = @()

                $params = @{
                    FieldID = $Result.ticket_fields.id[$i]
                    Title = $Result.ticket_fields.title[$i]
                    Type = $Result.ticket_fields.type[$i]
                    Tag = $Result.ticket_fields.tag[$i]
                    CustomFields = @{
                        ID = $Result.ticket_fields.custom_field_options.id[$i]
                        Name = $Result.ticket_fields.custom_field_options.name[$i]
                        Value = $Result.ticket_fields.custom_field_options.value[$i]
                    }
                }
            
                $TempObject = New-Object -TypeName PSCustomObject -Property $params
                $ReturnObject += $TempObject
            }
        }
    }
    End
    {
        Write-Verbose -Message 'Returning results from Search-ZDTicketFields'

        Add-ObjectDetail -InputObject $ReturnObject -TypeName PoshZD.Fields -DefaultProperties FieldID,Title,CustomFields
    }
}