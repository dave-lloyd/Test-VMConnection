# Test-VMConnection

This script is called Test-VMConnection for the reason that I typically use this against VM's - often when I'm deploying multiple VMs and want to do an initial connectivity test against them, but ultimately, this script isn't specifically for use in a VMware environment.

This script is basically a wrapper to the Test-NetConnection cmdlet, to :
1) Provide a simplified set of options - you can either do an ICMP test or an ICMP plus TCP Port check. It basically returns TRUE if responsive, and FALSE if not.
2) You can supply a list of devices to check, by supplying a .csv file with the IPs. The .csv file needs at least 1 column labelled "ComputerName".

It's not the most elegant, efficient bit of script, but it does a job and will allow you to do a basic test for example on a VM as to whether it pings and is actively listening on say port 389 for RDP or 22 for SSH.

You may also want to use it to check connectivity on certain VMware components, eg, checking port 80, 443, 90, 5480, 7443 etc.

