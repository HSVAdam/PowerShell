<#
	.SYNOPSIS
		Add or Del entries from Windows host file.

	.DESCRIPTION
		Modifies the Windows host file with Add or Del actions to provi

	.PARAMETER  IPAddress
		IP address of the host entry, only required for Add actions.

	.PARAMETER  HostName
		The host name of the server you with to map.

	.PARAMETER Action
		The action to take on the execution, Add or Del.

	.PARAMETER Verbose
		Verbose output

	.EXAMPLE
		PS C:\> Modify-HostFile -IPAddress '192.168.1.1' -HostName 'router.home.net' -Action 'Add'
		This example will add a new entry to the host file with router.home.net pointing to 192.168.1.1.

	.EXAMPLE
		PS C:\> Modify-HostFile -HostName 'router.home.net' -Action 'Del'
		This exmaple will del the HostName entry from the host file.
#>
FUNCTION Modify-HostFile
{
	[CmdletBinding()]
	PARAM (
		[Parameter(Position = 0, Mandatory = $false)]
		[ValidateScript({ $_ -match [IPAddress]$_ })]
		[System.String]$IPAddress,
		[Parameter(Position = 1, Mandatory = $true)]
		[System.String]$HostName,
		[Parameter(Position = 2, Mandatory = $true)]
		[ValidateSet('Add', 'Del')]
		[System.String]$Action
	)
	BEGIN
	{
		TRY
		{
			# Get content of current host file
			$global:HostFile = Get-Content -Path "$($Env:WinDir)\system32\Drivers\etc\hosts"
		}
		CATCH
		{
			# Error unable to obtain content of host file
			Write-Host 'Failure on Modify-HostFile'
			Write-Host $error[0]
		}
	}
	PROCESS
	{
		TRY
		{
			# Cleanup -HostName and search for it in the host file
			$CleanHostName = [Regex]::Escape($Hostname)
			$HostPattern = ".*$IPAddress\s+$CleanHostName.*"
			
			# If hostname is found within the host file and the $Action is to (Del)ete, remove the line
			IF (($global:HostFile) -match $HostPattern -and $Action -eq 'Del')
			{
				$global:HostFile -notmatch ".*\s+$CleanHostName.*" | Out-File "$($Env:WinDir)\system32\Drivers\etc\hosts"
				Write-Verbose "$IPAddress - $HostName REMOVING from host file."
			}
			# If hostname is NOT found in host file and the $Action is to (Add), add it to the file
			ELSEIF (($global:HostFile) -notmatch $HostPattern -and $Action -eq 'Add')
			{
				Add-Content -Encoding UTF8 -Path "$($Env:WinDir)\system32\Drivers\etc\hosts" ("$IPAddress".PadRight(20, ' ') + "$HostName")
				Write-Verbose "$IPAddress - $HostName ADDED to host file."
			}
			# The system is unable to determine what you want
			ELSE
			{
				Write-Verbose 'Modify-HostFile - WTF do you want here?'
			}
		}
		CATCH
		{
			# Error unable to modify host file
			Write-Host 'Failure on Modify-HostFile'
			Write-Host $error[0]
		}
	}
	END
	{
	}
}