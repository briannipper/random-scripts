# Should be called as follows
# send-mail.ps1 "nipper.brian@gmail.com" `
#	"South Largo - Mid-Week Field Service - Dec 7th thru Dec 11th - 9:00 AM" `
#	"smtp.gmail.com" `
#	"587" `
#	[Path to file that holds email content] `
#	[Path to file that holds list of e-mails] `
#	1

$cred = Get-Credential

$From = $args[0]
$Subject = $args[1]
$SMTPServer = $args[2]
$SMTPPort = $args[3] 

Get-Content $args[4] | Out-String -OutVariable SendBody | Out-Null
$Body = ($SendBody -join [Environment]::NewLine)

$count = 0;

Get-Content $args[5] | ForEach-Object {
	
	$temp = $_.trim();
	$result = $temp.Split(" ");
	$toEmail = ($result[$result.length - 1]).Replace('<','').Replace('>;','');
	
	$count = $count + 1;
	
	try {
		Send-MailMessage -From $From `
									-To $toEmail `
									-Bcc $args[0] `
									-Subject $Subject `
									-Body $Body `
									-SmtpServer $SMTPServer `
									-Port $SMTPPort `
									-Credential $cred `
									-UseSsl `
									-DeliveryNotificationOption OnSuccess

		Write-Host $toEmail;
		Write-Host $count;
		Write-Host "Sleep for $($args[6]) second"
		Start-Sleep -Seconds $args[6];
	 }
	 catch 
	 {
		Write-Host "Error: $toEmail";
		Write-Host $_;
		Add-Content -Path .\Error.txt -Value $toEmail;
		Add-Content -Path .\ErrorDetail.txt -Value $_;
	 }
}

Write-Host "Total Records Processed: $count";