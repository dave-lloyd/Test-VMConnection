function Test-VMConnection {
    <#
 .SYNOPSIS
Test-VMConnection allows you to test basic connectivity (ICMP) or basic connectivity and a port check against a single VM or a list of VMs.

 .DESCRIPTION
Test-VMConnection allows you to test basic connectivity (ICMP) or basic connectivity and a port check against a single VM or a list of VMs.
The list of VMs is supplied by way of a .csv file, with the names (or likely IPs) and a column name of "ComputerName".
It is basically a wrapper to the Test-NetConnection cmdlet providing a simplified set of options - either ICMP test or ICMP and a
TCP port check. If you need more than this, you are better checking and using the full functionality offered by Test-NetConnection.

 .PARAMETER IP
IP for a single VM check.

 .PARAMETER Filename
Supply a .csv file for testing against a number of VMs. The .csv needs at least one column labelled "ComputerName".

 .PARAMETER Port
 TCP port to test. This is optional. Specify the port to be tested in addition to the ICMP test. Common ports you may wish to try include :
 22 - for SSH
 389 - for RDP
 80 - for HTTP
 443 - for HTTPS
 902 - Virtual console access.

 .EXAMPLE
 C:\PS> Test-VMConnection -FileName ServerList.csv -Port 389

 This will test against all VMs listed in the .csv file ServerList for ICMP and connectivity on port 389 (RDP)

 .EXAMPLE
 C:\PS> Test-VMConnection -FileName ServerList.csv -Port 22

 This will test against all VMs listed in the .csv file ServerList for ICMP and connectivity on port 22 (SSH)

 .EXAMPLE
 C:\PS> Test-VMConnection -IP 10.10.10.10 -Port 389

 This will test against IP 10.10.10.10 for ICMP and connectivity on port 389 (RDP)

 .EXAMPLE
 C:\PS> Test-VMConnection -IP 10.10.10.10 -Port 22

 This will test against IP 10.10.10.10 for ICMP and connectivity on port 22 (SSH)

 .NOTES
 Author          : Dave Lloyd
 Version         : 0.1

#>

    [cmdletbinding()]
    Param(

        [parameter(Mandatory = $true, ParameterSetName = "Multiple VM")]
        [ValidateNotNullOrEmpty()] 
        [String]$Filename,
    
        [parameter(Mandatory = $false, ParameterSetName = "Single VM")]
        [ValidateNotNullOrEmpty()]
        [String]$IP,    
     
        [parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [Int]$Port
    )

    $MultiVM = $false

    If ($Filename) {
        $ServerList = Import-Csv $Filename
        $MultiVM = $True
    }
    else {
        $ServerList = $IP
    }

    $result = foreach ($server in $ServerList) {
        if ($Port) {
            If ($MultiVM) {
                Test-NetConnection -Port $Port -ComputerName $Server.ComputerName  -WarningAction SilentlyContinue
            }
            else {
                Test-NetConnection -Port $Port -ComputerName $IP  -WarningAction SilentlyContinue
            }
        }
        else {
            if ($MultiVM) {
                Test-NetConnection -ComputerName $Server.ComputerName -WarningAction SilentlyContinue
            }
            else {
                Test-NetConnection -ComputerName $IP -WarningAction SilentlyContinue
            }
        }

    }
    $result | Select-Object RemoteAddress, PingSucceeded, RemotePort, TcpTestSucceeded 
}

