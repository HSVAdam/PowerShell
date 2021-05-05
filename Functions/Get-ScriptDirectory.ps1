FUNCTION Get-ScriptDirectory
{
	$Invocation = (Get-Variable MyInvocation -Scope 1).Value
	$Global:ScriptName = $Invocation.MyCommand.Path
	RETURN Split-Path $Invocation.MyCommand.Path -Parent
}