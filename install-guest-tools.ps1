# Set the path of the VMWare Tools ISO - this is set in the Packer JSON file

$isopath = "C:\Windows\Temp\windows.iso"

# Mount the .iso, then build the path to the installer by getting the Driveletter attribute from Get-DiskImage piped into Get-Volume and adding a :\setup64.exe
# A separate variable is used for the parameters. There are cleaner ways of doing this. I chose the /qr MSI Installer flag because I personally hate silent installers
# Even though our build is headless. 


Mount-DiskImage -ImagePath $isopath

function vmware {

$exe = ((Get-DiskImage -ImagePath $isopath | Get-Volume).Driveletter + ':\setup64.exe')
$parameters = '/S /v "/qr REBOOT=R"'

Start-Process $exe $parameters -Wait

}

function virtualbox {

$certpath = ((Get-DiskImage -ImagePath $isopath | Get-Volume).Driveletter + ':\cert\oracle-vbox.cer')
certutil -addstore -f "TrustedPublisher" $certpath

$exe = ((Get-DiskImage -ImagePath $isopath | Get-Volume).Driveletter + ':\VBoxWindowsAdditions.exe')
$parameters = '/S'

Start-Process $exe $parameters -Wait

}

if ($ENV:PACKER_BUILDER_TYPE -eq "vmware-iso") {
    vmware
} else {
    virtualbox
}

#Time to clean up - dismount the image and delete the original ISO

Dismount-DiskImage -ImagePath $isopath
Remove-Item $isopath
