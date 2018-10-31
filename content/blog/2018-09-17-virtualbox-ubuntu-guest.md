---
author: Andrew B. Collier
draft: true
title: 'VirtualBox: Configuring an Ubuntu Guest'
tags: ["Ubuntu", "VirtualBox"]
date: 2018-09-17T02:00:00Z
---

1. Install a recent version of VirtualBox. This will be based on the version 5.2.18. Accept all of the default options during the installation process.

2. Create a new Virtual Machine. Choose a suitable name.

2. Give it sufficient memory. On a machine with 16 Gb RAM I'd give it at least 4 Gb.

2. Select *Create a virtual hard disk now*.

2. Select VDI for the hard disk file type.

2. Choose to have storage space dynamically allocated.

2. Allocate a decent chunk of disk space. How much you choose will depend on how much data you are planning to stash on the new Virtual Machine. Something around 10 Gb should be sufficient for the operating system and a decent amount of user space.

3. Press Start. Select start-up disk. Press Start.

4. Install Ubuntu, selecting all default options.

5. Start Ubuntu guest.

6. Open a terminal.

$ sudo apt update
$ sudo apt upgrade -y
$ sudo apt install linux-headers-$(uname -r) build-essential dkms

7. Restart Ubuntu guest.

8. Devices -> Insert Guest Additions CD image... Click Run to start installation.

9. Open a terminal.

$ sudo adduser USERNAME vboxsf

Substitute your username.

10. Stop the Ubuntu guest.

11. Select the guest and then press the Settings button. Select the Shared Folder tab.

12. Click the button with the green plus sign. In the Folder Path field select a folder from the host machine. Check the Auto-mount field. Press the OK button. Press the OK button.

![](/img/2018/09/virtualbox-shared-folder.png)

13. Start the Ubuntu guest. You should find an icon for the shared folder on the desktop.

You will probably also want to enable copy and paste between host and guest. Select Devices -> Shared Clipboard -> Bidirectional.
