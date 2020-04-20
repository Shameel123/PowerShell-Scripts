#Following code gets list of computers  and iterates through the list and test online and offline computers.

$computer_list = get-content -path D:\computer_list.txt
$onComputers = @() #declaring arrays
$offComputers= @() #declaring arrays
foreach ($i in $computer_list)
{
   If (Test-Connection -ComputerName $i -Count 1 -Quiet)
   {
      Write-Host "$i is Online" 
      $onComputers += $i 
   } else {
      Write-Host "$i is offline" 
      $offComputers += $i
   }
}


#Following code helps you create separte texts files for Online and Offline computers. Please provide path yourself for your own PCs. 
$onComputers | Out-File D:\online_computers.txt
$offComputers| Out-File D:\offline_computers.txt


#following code is used to generate a proper date and time for the log file to be saved.
$hour = get-date -Format "hh"
$minute = get-date -Format "mm"
$day = get-date -Format "dd" 
$month = get-date -Format "MM"
$year = get-date -format "yy"
$folder_name = ((Get-Date).ToString('yyyy-MM-dd'))
$date = "proc"+"_"+"$day" + "-" + "$month" + "-" + "$year" + "_" + "$hour" + "-"+ "$minute" + ".log"

#this creates a folder
if(-not(Test-Path D:\shameel\$folder_name)) #checks if the folder doesn't exist so it creates one
{
 New-Item -ItemType Directory -Path "D:\shameel\.\$((Get-Date).ToString('yyyy-MM-dd'))"  #creates directory according to date's name.
}

#the main code

Invoke-Command -ComputerName $onComputers -ScriptBlock { get-process | where {$_.starttime} | 
select Name,ID,@{Name='Running Processes';Expression={(Get-Date)-$_.starttime}} |
sort Run -Descending | Select -first 50 }|
Out-File -FilePath D:\shameel\$folder_name\$date
#second expression suggests that current date is going to be subtracted from startTime
#thrid expression sorts top 50 in descending order 
