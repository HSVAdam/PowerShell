<#  STILL UNDER DEVELOPMENT #>

<#
	.DESCRIPTION
		Queries IIS for log folder and for each site folder found compress and move to destination.

	.PARAMETER  Destination
		The final backup location for the log zip file.

	.PARAMETER  ParameterB
		The description of a the ParameterB parameter.

	.EXAMPLE
		PS C:\> Clear-IISLogs -Destination 'Z:\Backups\IIS-Logs'

	.INPUTS
		System.String
#>
function Clear-IISLogs {
	[CmdletBinding()]
	param(
		[Parameter(Position=0, Mandatory=$true)]
		[System.String]
		$Destination
	)
	BEGIN
	{		
		TRY
		{
			$Today = Get-Date -Format 'yyyyMMdd'
			$CurTime = Get-Date -Format "HH:mm" | ForEach-Object { $_ -replace ":", "." }
			#IF((Test-Path -Path $Source) -eq $false) { throw "Source Folder: $Source does not exist." }
			#IF ((Test-Path -Path $Destination) -eq $false) { throw "Destination Folder: $Destination does not exist." }
			
			$ServerConfig = (Get-IISConfigSection -SectionPath 'system.applicationHost/log').ChildElements.RawAttributes | Select-Object -First 1
		}
		CATCH
		{
			throw "Terminating error in Begin statement."
		}
	}
	PROCESS
	{		
		TRY
		{
			# Get all folders within the $Source
			$SourceFolders = Get-ChildItem -Path $ServerConfig.directory -Directory
			
			IF ($SourceFolders)
			{
				# Create dated folder for backup files
				New-Item -Path $Destination -Name $Today -ItemType Directory | Out-Null
				
				FOREACH ($LogFolder IN $SourceFolders)
				{
					$ThisLog = $LogFolder.Name
					Compress-Archive -Path $LogFolder.FullName -DestinationPath "$Destination\$Today\$ThisLog-$CurTime.zip" -CompressionLevel Optimal
					
					IF ((Test-Path -Path "$Destination\$Today\$ThisLog-$CurTime.zip") -eq $true)
					{
						# Zip file found in destination, remove the original directory
						Remove-Item -Path $LogFolder.FullName -Recurse -Force
						Write-Host 'Removing original folder.'
					}
					ELSE
					{
						Write-Host 'Leaving original folder, zip file not found.'
					}
				}
			}
			ELSE
			{
				Write-Host 'Unable to retieve any folders to backup.'
			}
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