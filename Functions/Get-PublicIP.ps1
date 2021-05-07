FUNCTION Get-PublicIP
{
	Invoke-RestMethod http://ifconfig.me/ip
}