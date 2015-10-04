# Packer-Windows10
A Packer build to make a pretty vanilla Windows 10 x64 box for use with VMWare Desktop or Virtualbox.

This project is just a clone of my [other Windows Packer project](https://github.com/luciusbono/Packer-Windows81) with some very minor changes. Eventually the two projects will merge and form like Voltron.


In essence, the build does the following:

* Use an existing, vanilla, Windows 10 x64 Enterprise trial ISO
* Enable WinRM (in a slightly scary, Unauthenticated mode, for Packer/Vagrant to use)
* Create a Vagrant user (as is the style)
* Grab all the Windows updates is can
* Install VMWare Tools
* Turn off Hibernation
* Turn on RDP
* Set the network type for the virtual adapter to 'Private' and not bug you about it
* Turns autologin *off* because I like simulating end user environments, ok?

## Requirements

* **A copy of the [Windows 10 x64 Enterprise Trial](https://www.microsoft.com/en-us/evalcenter/evaluate-windows-10-enterprise)**
* **Packer / Vagrant** - Duh. Tested with Packer 0.86 and Vagrant 1.7.4. 
* **VMWare Workstation or Fusion with The [Vagrant VMWare Provider](http://www.vagrantup.com/vmware)** or **[Virtualbox](https://www.virtualbox.org/)** 
* **An RDP client** (built in on Windows, available [here](https://www.microsoft.com/en-us/download/details.aspx?id=18140) for Mac
* **[Git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)**

This project works great with Virtualbox, so don't bother shelling out for VMWare Fusion without trying VirtualBox first. 

## Usage

This guide will assume you zero knowledge of any or all of these systems. 

1. Install [Vagrant](https://www.vagrantup.com/).
2. Install [Packer](https://packer.io/) - these [instructions](https://www.packer.io/intro/getting-started/setup.html) help. 
3. Download and install [Virtualbox](https://www.virtualbox.org/) or [VMWare Fusion](http://www.vmware.com/products/fusion)/Workstation (with the [Vagrant Plugin](https://www.vagrantup.com/vmware)).
4. Ensure you have an RDP client (you do if you're running Windows) - for Mac, install [this](https://www.microsoft.com/en-us/download/details.aspx?id=18140)
5. Download the [Windows 10 x64 Enterprise Trial](https://www.microsoft.com/en-us/evalcenter/evaluate-windows-10-enterprise), save the ISO someplace you'll remember.
6. Make a working directory somewhere (OSX suggestion `mkdir ~/Packer_Projects/`) and `cd` to that directory (e.g. `cd ~/Packer_Projects/`).
7. Clone this repo to your working directory: `git clone https://github.com/luciusbono/Packer-Windows10` (if you don't have `git` installed: [here are instructions](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git).
8. Determine the **MD5 hash** of your iso: `md5 [path to iso]` in OSX `FCIV -md5 [path to iso]` in Windows (download it [here](https://support.microsoft.com/en-us/kb/841290#bookmark-4)) -- Linux people are smarter than me and likely can just calculate the md5 hash through ether-magic. 
9. For **Virtualbox** run `packer build -only=virtualbox-iso -var 'iso_path=[path to iso]' -var 'iso_md5=[md5 of iso]' packer.json` for **VMWare Fusion/Workstation** run `packer build -only=vmware-iso -var 'iso_path=[path to iso]' -var 'iso_md5=[md5 of iso]' packer.json`
10. Wait a loooooooooooonnnnngggg time (an unupdated base ISO may take a couple of hours to pack).
11. Run `vagrant box add --name [vagrant box name] [name of .box file]`. The name can be anything you want. For example, this command is valid for Virtualbox: `vagrant box add --name windows10 virtualbox-iso_windows-10.box`
12. Make a working directory for your Vagrant VM (OSX suggestion `mkdir ~/Vagrant_Projects/windows10`) and `cd` to that directory (e.g. `cd ~/Vagrant_Projects/windows10`)
13. Type `vagrant init [vagrant box name]` - for example `vagrant init windows10`
14. Type `vagrant up` and once the box has been launched type `vagrant rdp`
15. Continue through any certificate errors and login with the username: `vagrant` and the password: `vagrant`
16. Feel free to delete the `.box` file that packer created. You may also delete your `.iso` you downloaded if you wish. 
17. Stop the box by typing `vagrant halt`. Destroy the box by typing `vagrant destroy`

### Usage Explanation

The `packer.json` file requires two variables to validate. You can confirm these with a `packer inspect packer.json`

```
$ packer inspect packer.json 
Optional variables and their defaults:

  iso_md5  = 
  iso_path = 

Builders:

  virtualbox-iso
  vmware-iso    

Provisioners:

  powershell
```

Since there are two Builders, you also likely want to specify one or the other. 

Valid options are `virtualbox-iso` or `vmware-iso`. 

The other two variables, `iso_md5` and `iso_path`, are the path and the MD5 hash of the Windows 10 Enterprise trial ISO. 


## Other things to note

The update grabbing script is a bit of a grey-box, as I basically just hijacked it (as well as lots of other code) from [this awesome project](https://github.com/joefitzgerald/packer-windows) - which I think is the defacto standard for Windows / Packer relations - but I wanted a leaner build. This project started as a frankenstein build, but is turning more into a ground-up rewrite of a lot of other projects' scripts and code. With the exception of the `update-windows.ps1` script, which I only modified very slightly, I will slowly go through all the code in this project and make sure I kill all the cruft.

If, for some reason, you have VMWare Fusion and the VMMware Vagrant plugin, but want to run this project in Virtualbox, you need to specify the provider in your `vagrant up` statement like so: `vagrant up --provider=virtualbox`

Almost nobody will fall into the camp, but it's worth mentioning. Have fun!
