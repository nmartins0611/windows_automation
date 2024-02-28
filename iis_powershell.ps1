# Define variables
$remoteServer = "your_remote_server_address"
$username = "your_username"
$password = "your_password"
$webpageContent = @"
<html>
<head>
    <title>Simple Web Page</title>
</head>
<body>
    <h1>Hello, World!</h1>
    <p>This is a simple webpage hosted on port 8080.</p>
</body>
</html>
"@

# Ignore certificate errors
$sessionOption = New-PSSessionOption -SkipCACheck -SkipCNCheck -SkipRevocationCheck

# Create a PSSession to the remote server
$remoteSession = New-PSSession -ComputerName $remoteServer -Credential (Get-Credential -Credential $username) -SessionOption $sessionOption

# Script block to execute on the remote server
$scriptBlock = {
    # Install IIS
    Install-WindowsFeature -Name Web-Server -IncludeManagementTools

    # Create a simple HTML file
    $webpagePath = "C:\inetpub\wwwroot\index.html"
    Set-Content -Path $webpagePath -Value $using:webpageContent -Force
}

# Invoke the script block on the remote server
Invoke-Command -Session $remoteSession -ScriptBlock $scriptBlock

# Close the remote session
Remove-PSSession $remoteSession
