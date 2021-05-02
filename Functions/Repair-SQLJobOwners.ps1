<#
	.SYNOPSIS
		A brief description of the Name function.

	.DESCRIPTION
		A detailed description of the Name function.

	.PARAMETER  ParameterA
		The description of a the ParameterA parameter.

	.PARAMETER  ParameterB
		The description of a the ParameterB parameter.

	.EXAMPLE
		PS C:\> Name -ParameterA 'One value' -ParameterB 32
		'This is the output'
		This example shows how to call the Name function with named parameters.

	.EXAMPLE
		PS C:\> Name 'One value' 32
		'This is the output'
		This example shows how to call the Name function with positional parameters.

	.INPUTS
		System.String,System.Int32

	.OUTPUTS
		System.String

	.NOTES
		For more information about advanced functions, call Get-Help with any
		of the topics in the links listed below.

	.LINK
		about_functions_advanced

	.LINK
		about_comment_based_help

	.LINK
		about_functions_advanced_parameters

	.LINK
		about_functions_advanced_methods
#>
FUNCTION Repair-SQLJobOwners
{
	[CmdletBinding()]
	PARAM (
		[Parameter(Position = 0, Mandatory = $true)]
		[System.String]$SQLServer,
		[Parameter(Position = 1, Mandatory = $false)]
		[System.String]$SA = 'sa'
	)
	BEGIN
	{
		TRY
		{
			Import-Module -Name dbatools
		}
		CATCH
		{
		}
	}
	PROCESS
	{
		TRY
		{
			Get-DbaAgentJob -SqlInstance $SQLServer | Where-Object { $_.OwnerLoginName -ne $SA -and $_.Enabled -eq $true } | Set-DbaAgentJob -OwnerLogin $SA
		}
		CATCH
		{
		}
	}
	END
	{
		TRY
		{
		}
		CATCH
		{
		}
	}
}