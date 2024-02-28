# Install IIS and required features
Install-WindowsFeature -Name Web-Server -IncludeManagementTools

# Set up sample index.html content
$indexHtmlContent = @"
<!DOCTYPE html>
<html>
<head>
    <title>Welcome to My Website</title>
</head>
<body>
    <h1>Hello, World!</h1>
    <p>This is a sample webpage hosted by IIS on port 8080.</p>
</body>
</html>
"@

# Define path for index.html file
$indexHtmlPath = "C:\inetpub\wwwroot\index.html"

# Write sample index.html content to file
$indexHtmlContent | Set-Content -Path $indexHtmlPath -Force

# Create a new site in IIS
$siteName = "SampleSite"
New-WebSite -Name $siteName -Port 8080 -PhysicalPath "C:\inetpub\wwwroot" -Force

# Start the IIS service
Start-Service -Name W3SVC
