FUNCTION Get-IPLocation
{
	PARAM (
		[string]$IPAddress
	)
	
	$Request = Invoke-RestMethod -Method Get -Uri "http://ip-api.com/json/$IPAddress"
	RETURN $Request
}