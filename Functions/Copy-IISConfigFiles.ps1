<#
	.DESCRIPTION
		Recursively searched supplied path for IIS *.config files as well as appsettings.json and copies to destination while retaining directory structure.

	.PARAMETER  Source
		Source folder of your IIS web interfaces.

	.PARAMETER  Destination
		Destination where you would like your config files backed up to.

	.EXAMPLE
		PS C:\> Copy-IISConfigFiles -Source 'C:\inetpub\wwwroot' -Destination 'Z:\Backups\IIS-Config-Files'

	.INPUTS
		System.String
#>
FUNCTION Copy-IISConfigFiles
{
	PARAM (
		[Parameter(Mandatory = $true, Position = 1)]
		[ValidateScript({
				IF (-Not ($_ | Test-Path)) { THROW "Check source path." }
				RETURN $true
			})]
		[String]$Source,
		[Parameter(Mandatory = $true, Position = 2)]
		[ValidateScript({
				IF (-Not ($_ | Test-Path)) { THROW "Check destination path." }
				RETURN $true
			})]
		[String]$Destination
	)
	
	# Create dated folder within destination directory
	$DatedDestination = Join-Path -Path $Destination -ChildPath (Get-Date -Format 'yyyyMMdd')
	IF ((Test-Path -Path $DatedDestination) -eq $false)
	{
		New-Item -Path $Destination -Name (Get-Date -Format 'yyyyMMdd') -ItemType Directory
	}
	
	# Begin recursively processing each folder for *.config files.  Any file found will keep its
	# directory structure when copied to $Destination folder.
	Get-ChildItem $Source -Recurse -Include *.config, appsettings.json | `
	ForEach-Object {
		$targetFile = $DatedDestination + $_.FullName.SubString($Source.Length);
		New-Item -ItemType File -Path $targetFile -Force;
		Copy-Item $_.FullName -destination $targetFile
	}
}