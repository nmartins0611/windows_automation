# Variables
$remoteServer = "your_remote_server_hostname_or_IP"
$adminUsername = "your_admin_username"
$adminPassword = "your_admin_password"
$certThumbprint = "your_SSL_certificate_thumbprint"
$websiteName = "SampleWebsite"
$webpageContent = @"
<html>
<head>
    <title>Sample Web Page</title>
</head>
<body>
    <h1>Welcome to the Sample Website!</h1>
    <p>This is a sample webpage hosted on IIS.</p>
</body>
</html>
"@

# Set up WinRM for HTTPS communication
$winrmConfig = @{
    CertificateThumbprint = $certThumbprint
    Port = 5986
    Force = $true
}
Invoke-Command -ComputerName $remoteServer -ScriptBlock {
    Enable-PSRemoting -Force
    Set-WSManQuickConfig -UseSSL -Force
    Register-PSSessionConfiguration -Name "PowerShell" @PSBoundParameters -Force
} -Credential (Get-Credential -Credential $adminUsername)

# Establish a remote PowerShell session
$session = New-PSSession -ComputerName $remoteServer -Credential (Get-Credential -Credential $adminUsername)
Invoke-Command -Session $session -ScriptBlock {
    Import-Module WebAdministration
    # Create a new website
    New-Website -Name $using:websiteName -Port 8080 -PhysicalPath "C:\inetpub\wwwroot\$using:websiteName"
    # Create a new index.html file for the website
    Set-Content -Path "C:\inetpub\wwwroot\$using:websiteName\index.html" -Value $using:webpageContent
    # Start the website
    Start-Website -Name $using:websiteName
}

# Clean up the session
Remove-PSSession $session
