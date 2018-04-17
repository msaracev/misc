#POWERSHELL TO EXECUTE ON REMOTE SERVER (Azure VM) BEGINS HERE  
$DNSName = $env:AzureVMName 
#Ensure PS remoting is enabled, although this is enabled by default for Azure VMs 
Enable-PSRemoting -Force   
#Create rule in Windows Firewall 
New-NetFirewallRule -Name "WinRM HTTPS" -DisplayName "WinRM HTTPS" -Enabled True -Profile "Any" -Action "Allow" -Direction "Inbound" -LocalPort 5986 -Protocol "TCP"    
#Create Self Signed certificate and store thumbprint 
$thumbprint = (New-SelfSignedCertificate -DnsName $DNSName -CertStoreLocation Cert:\LocalMachine\My).Thumbprint   
#Run WinRM configuration on command line. DNS name set to computer hostname, you may wish to use a FQDN 
$cmd = "winrm create winrm/config/Listener?Address=*+Transport=HTTPS @{Hostname=""$DNSName""; CertificateThumbprint=""$thumbprint""}" 
cmd.exe /C $cmd   
#POWERSHELL TO EXECUTE ON REMOTE SERVER ENDS HERE

#Create NSG Inbound rule for WinRM_HTTPS
#1100 Any Any WinRM (TCP/5986) Allow

#Execute code/command on a remote server.  Change IP as needed.
            $sessionOptions = New-PSSessionOption -SkipCACheck -SkipCNCheck                 
            Invoke-Command -ComputerName 52.191.175.20 -Credential $VMCredential -UseSSL -SessionOption $sessionOptions -ScriptBlock {  
            #Code to be executed in the remote session goes here 
            $hostname = hostname 
            Write-Output "test" 
            } 


#Setup Enter-PSSession.  Change IP as needed. 
            $sessionOptions = New-PSSessionOption -SkipCACheck -SkipCNCheck                 
            Enter-PSSession -ComputerName 52.191.175.20 -Credential $VMCredential -UseSSL -SessionOption $sessionOptions  
            
            