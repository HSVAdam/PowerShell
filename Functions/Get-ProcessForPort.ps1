FUNCTION Get-ProcessForPort($Port)
{
	Get-Process -Id (Get-NetTCPConnection -LocalPort $Port).OwningProcess
}