# Set the path of the VMWare Tools ISO - this is set in the Packer JSON file

$isopath = "C:\Windows\Temp\windows.iso"

# Mount the .iso, then build the path to the installer by getting the Driveletter attribute from Get-DiskImage piped into Get-Volume and adding a :\setup64.exe
# A separate variable is used for the parameters. There are cleaner ways of doing this. I chose the /qr MSI Installer flag because I personally hate silent installers
# Even though our build is headless. 


Mount-DiskImage -ImagePath $isopath
$exe = ((Get-DiskImage -ImagePath $isopath | Get-Volume).Driveletter + ':\setup64.exe')
$parameters = '/S /v "/qr REBOOT=R"'

# Now we execute the process with Start-Process, which lets the script wait until the process is complete. 

Start-Process $exe $parameters -Wait

#Time to clean up - dismount the image and delete the original ISO

Dismount-DiskImage -ImagePath $isopath
Remove-Item $isopath
