Function Get-ListeningTCPConnections
{
	[cmdletbinding()]
	Param (
	)
	
	Try
	{
		$TCPProperties = [System.Net.NetworkInformation.IPGlobalProperties]::GetIPGlobalProperties()
		$Connections = $TCPProperties.GetActiveTcpListeners()
		ForEach ($Connection In $Connections)
		{
			If ($Connection.address.AddressFamily -eq "InterNetwork")
			{
				$IPType = "IPv4"
			}
			Else
			{
				$IPType = "IPv6"
			}
			
			$OutputObj = New-Object -TypeName PSobject
			$OutputObj | Add-Member -MemberType NoteProperty -Name "LocalAddress" -Value $connection.Address
			$OutputObj | Add-Member -MemberType NoteProperty -Name "ListeningPort" -Value $Connection.Port
			$OutputObj | Add-Member -MemberType NoteProperty -Name "IPV4Or6" -Value $IPType
			$OutputObj
		}		
	}
	Catch
	{
		Write-Error "Failed to get listening connections. $_"
	}
}