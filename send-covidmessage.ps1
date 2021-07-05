$Username = 'nipper.brian@gmail.com'
$Password = 'jqdxkiucqajvlsdf'
$pass = ConvertTo-SecureString -AsPlainText $Password -Force

$SecureString = $pass
# Users you password securly
$cred = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $Username,$SecureString 

$Uri = "https://www.pcsb.org//site/UserControls/Minibase/MinibaseListWrapper.aspx?ModuleInstanceID=61037&PageModuleInstanceID=62143&FilterFields=comparetype%3AE%3AC%3B0%3AC%3A2021%3B1%3AE%3AOakhurst%20Elementary%20School%3B&DirectoryType=T&PageIndex=1&_=1613930046478";

$Request = Invoke-WebRequest $Uri;

$tableInfo = ($Request.ParsedHtml.getElementsByTagName("table"))[0].innerHTML;

$SendBody = "<table>" + $tableInfo + "</table>";

$From = "nipper.brian@gmail.com"
$CurrDate = Get-Date -Format "yyyy-MM-dd"
$Subject = "$CurrDate - Oakhurst COVID Data"
$SMTPServer = "smtp.gmail.com"
$SMTPPort = "587"

$Body = ($SendBody -join [Environment]::NewLine)
	
try {
    Send-MailMessage -From $From `
                    -To 'nipper.brian@gmail.com','ashfaynip@gmail.com' `
                    -Subject $Subject `
                    -Body $Body `
                    -BodyAsHtml `
                    -SmtpServer $SMTPServer `
                    -Port $SMTPPort `
                    -Credential $cred `
                    -UseSsl `
                    -DeliveryNotificationOption OnSuccess
}
catch {
    Write-Host "Error: $toEmail";
    Write-Host $_;
}