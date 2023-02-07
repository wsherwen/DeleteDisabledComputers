
$Logfile = "$env:windir\Temp\Logs\DeleteDisabledComputers.log"
Function LogWrite{
   Param ([string]$logstring)
   Add-content $Logfile -value $logstring
   write-output $logstring
}

function Get-TimeStamp {
    return "[{0:dd/MM/yy} {0:HH:mm:ss}]" -f (Get-Date)
}

if (!(Test-Path "$env:windir\Temp\Logs\"))
{
   mkdir $env:windir\Temp\Logs
   LogWrite "$(Get-TimeStamp): Script has started."
   LogWrite "$(Get-TimeStamp): Log directory created."
}
else
{
    LogWrite "$(Get-TimeStamp): Script has started."
    LogWrite "$(Get-TimeStamp): Log directory exists."
}

LogWrite "$(Get-TimeStamp): Importing the Active Directory module."
Import-Module ActiveDirectory

LogWrite "$(Get-TimeStamp): Collecting the list of disabled computers."
$Computers = Get-ADComputer -Filter {(Enabled -eq $False)}

LogWrite "$(Get-TimeStamp): Exporting list of disabled computers."
$Computers | Export-Csv $env:windir\Temp\Logs\InactiveComputers.csv

LogWrite "$(Get-TimeStamp): Deleting disabled computers."
ForEach ($Computer in $Computers){
  $DName = $Computer.DistinguishedName
  Remove-ADComputer -Identity $DName
  LogWrite "$(Get-TimeStamp): Deleted the computer $DName."
}

LogWrite "$(Get-TimeStamp): The script has been executed, now exiting..."
exit
