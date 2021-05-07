FUNCTION Search-String
{
	[CmdletBinding()]
	PARAM (
		[Parameter(Mandatory = $true, Position = 1)]
		[string]$Folder,
		[Parameter(Mandatory = $true, Position = 2)]
		[string]$Search,
		[Parameter(Mandatory = $false, Position = 2)]
		[bool]$Recurse = $false
	)
	
	IF ($Recurse -eq $true)
	{
		Get-ChildItem -Path $Folder -Recurse | Select-String $Search | Select-Object LineNumber, Path, @{ Name = "LineText"; Expression = { $_.Line.Trim() } } | Sort-Object Path
		
	}
	ELSE
	{
		Get-ChildItem -Path $Folder | Select-String $Search | Select-Object LineNumber, Path, @{ Name = "LineText"; Expression = { $_.Line.Trim() } } | Sort-Object Path
	}
}