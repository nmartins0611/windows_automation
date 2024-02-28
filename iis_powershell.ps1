# Define the remote server details
$remoteServer = "REMOTE_SERVER_NAME_OR_IP"
$username = "USERNAME"
$password = "PASSWORD"

# Define the script block to be executed on the remote server
$scriptBlock = {
    # Install IIS
    Install-WindowsFeature -Name Web-Server -IncludeManagementTools

    # Set up a simple HTML webpage content
    $htmlContent = @"
<!DOCTYPE html>
<html>
<head>
    <title>Sample Page</title>
</head>
<body>
    <h1>Hello from PowerShell and IIS!</h1>
</body>
</html>
"@

    # Create the directory for the website
    $webDir = "C:\inetpub\wwwroot\SampleSite"
    New-Item -Path $webDir -ItemType Directory -Force | Out-Null

    # Create and write the HTML content to index.html
    $htmlContent | Out-File -FilePath "$webDir\index.html" -Force

    # Create a new IIS website
    New-Website -Name "SampleSite" -PhysicalPath $webDir -Port 8080 -Force
}

# Create a PSCredential object
$securePassword = ConvertTo-SecureString $password -AsPlainText -Force
$credential = New-Object System.Management.Automation.PSCredential ($username, $securePassword)

# Execute the script block on the remote server
Invoke-Command -ComputerName $remoteServer -Credential $credential -ScriptBlock $scriptBlock
