---
author: ["Kai Mackall"]
title: "My PC Build and vHomelab: A 6-Month Retrospective"
description: "A comprehensive look into everything I've learned since building my PC and lab"
date: 2025-11-25
draft: false
tags: ["homelab", "cybersecurity"]
categories: ["writeups"] 
type: post
stage: "budding"
---

I built my PC and officially started my virtual homelab in late May 2025, so I thought it would be a good idea to do a bit of a retrospective. 

When I first decided to build a homelab, my goal was simple: create a safe place to experiment with real-world IT concepts without breaking my actual computer. I didn’t expect the process to teach me so much about hardware compatibility, troubleshooting, system administration, and structured problem-solving.

In this post, I’ll walk through how I built my homelab from start to finish, what challenges I ran into, and the skills I gained along the way. If you’re thinking about building your own, this guide should give you an idea of what to expect.

---

## **Why I Built a Virtual Homelab**

A little bit of background: I technically started my homelab on my HP laptop running Windows 10. I used it for CTFs, coursework, and playing around with VMs. But I eventually ran into a few issues (mainly with storage space and performance) and decided I needed an upgrade. So I went into this project with some prior experience, but I wanted to gain more hands-on experience with:

- Virtual machines
    
- Windows and Linux administration
    
- Networking and firewall configuration
    
- System troubleshooting
    
- Automating updates and maintenance
    

I had learned these concepts academically, but learning them _hands-on_ and from the ground up is a completely different experience. A homelab gave me a safe, controlled environment to break things and fix them, and (most importantly) to really challenge myself and apply the skills I learned in class.

---

## **Selecting Components (and Making Sure They Actually Worked Together)**

The first step was building my first PC from scratch. I didn’t want to break the bank, but I needed reliable virtualization performance.

Here’s what I looked for:

- **CPU support for virtualization**
    
- **At least 16GB of RAM** so I could run multiple VMs
    
- **SSD or NVMe storage** to reduce VM boot times
    
- A motherboard with enough SATA and M.2 slots for expansion
    

I spent a lot of time cross-checking each part for compatibility, which started with PC Part Picker and some research via Google. I also ended up using manufacturer spec sheets and PC building forums for extra guidance. This process alone taught me more about hardware selection than any class I've taken.

## My Build:
##### Here's a list of the components I went with:
##### CPU: Intel Core i5-10400
Probably the hardest thing to pin down. I was pretty confident when looking for all of the other components, but the CPU was definitely the thing I researched and second-guessed the most. I'm a casual gamer, the games I play aren't that demanding so I knew I didn't need a CPU capable of things like overclocking. 
##### GPU: GeForce RTX 3060 Lite Hash Rate
My last and probably most regrettable purchase. It works fine for the most part, but I can definitely see myself upgrading in the future.
##### Motherboard: ASRock H510M-HDV/M.2 SE
To be honest, I didn't really get the difference between ATX and micro-ATX motherboards (beyond compatibility with other components). 
##### RAM: TEAMGROUP T-Force Vulcan Z DDR4 16GB Kit (2x8GB)

##### Storage: KingSpec M2 SSD 1TB & Samsung T7 Portable SSD 1TB
##### PSU: EVGA 500 BQ
##### Case: Cooler Master Q300L V2 Micro-ATX Tower
This case is pretty small (it is a micro-ATX tower after all). I've heard mixed reviews about it, but I went with it out of convenience. I cared more about the other components than I did about the case. It's not terrible, it's affordable and suits my needs.
##### Fans: Arctic P12 Pro A-RGB (3 pack)
Funny story, I really didn't want RGB-anything in my PC at first. I was content with using the Cooler Master fans that came with the case, but after a few months I realized that their performance wasn't all that great for my needs. I came across these Arctic RGB fans and I caved. They were surprisingly affordable and I'd heard good things about them, so no complaints here (except for one, which I'll get into later). They look quite nice too, so that's a plus.
##### OS: Linux Mint 22.2 Cinnamon
This deserves its own little section. Going into this project, I knew I wanted my PC to use a Linux distro. I've used Windows machines pretty much my entire life, and occasionally used MacOS machines in school. Before competing in my first CTF about 5 years ago, I had zero experience with Linux. But after getting comfortable with it, I realized there are a lot of things Linux has that Windows doesn't (and a lot of things Linux doesn't have that Windows does...the bloatware). I wanted something lightweight and user-friendly, but also highly customizable, and Linux Mint checked every box. 
The only downside is that there are a few apps that aren't compatible with Linux that I wish I could use (which aren't supported by Wine either, sadly). But I think this is a good trade-off. I can always use my Windows laptop for those things anyway.

Side note about my only very minor issue with the RGB fans: it has nothing to do with the fans and everything to do with the fact that there are almost no solutions that allow you to change the colors of the fans *on Linux Machines*. Sure, we have OpenRGB, but the fans I bought aren't compatible with the app sadly. Again, very minor issue that was fixed by purchasing an LED switch. But hopefully they expand the list of compatible devices, or come out with a Linux-friendly solution.

---

## **Setting Up the Environment**

Once the machine was assembled and Linux Mint was installed, I set up **VirtualBox** to manage my VMs.

My initial lab included:

- **Kali Linux VM**
    
- **REMnux VM**
    
- **Windows 11 VM**
    
- **Windows Server 2025 VM** (recently added)
    
- **pfSense** as a virtual firewall
    

The Kali and REMnux VMs were migrated directly from my old laptop. I was especially excited about Windows Server 2025 since I had only used Server 2016 before, and I wanted to see what had changed.

---

## **The Problems I Ran Into (And What They Taught Me)**

### **1. Boot Issues & BIOS Settings**

The system didn’t recognize my bootable USB drive at first.  
It turned out that secure boot was enabled and legacy USB booting was disabled. Fixing this required exploring BIOS options I hadn’t touched before.

### **2. Network Connectivity Problems**

Some VMs couldn’t reach each other. After troubleshooting, I realized the issue was a misconfigured VirtualBox network adapter.

I learned to:

- Switch between NAT, bridged, and host-only networking
    
- Set up port forwarding
    
- Use tools like `ip a`, `ping`, and `traceroute` to diagnose issues
    
### **4. GPU Issues**

**Problem:**  
After installing a refurbished Nvidia GPU, my display suddenly developed a persistent green tint. This issue is surprisingly common with certain refurbished cards and seems to stem from incorrect color output settings or a problematic default display mode. At first, I tried fixing it through the Nvidia Settings GUI, adjusting color profiles and display modes. These changes worked temporarily, but the settings would reset every time I rebooted, bringing the green tint back. I also tried reinstalling the drivers, which also didn't work.

**Root Cause (Likely):**  
Nvidia Settings does not persist certain display-mode overrides unless they’re explicitly applied through a config file or set at runtime. In my case, the default display mode wasn’t retaining the _ForceCompositionPipeline_ setting, which helps correct the tint issue.

**Interim Solution:**  
Until I find a permanent fix (likely through an updated xorg.conf file or a persistent script), I apply the following command after each reboot:
```
nvidia-settings --assign CurrentMetaMode="HDMI-0: 1920x1080_100_0 {ForceCompositionPipeline=On}"
```
This forces the correct display mode and removes the green tint immediately.

**Next Steps:**  
I’m currently testing a more permanent solution using a custom X11 configuration and startup scripts so the setting applies automatically on boot.
### **3. Automating Updates**

I set up **cron jobs** on Linux to handle:

- Security updates
    
- Log cleanup
    
- Service restarts
    

This was my first real experience using automation to maintain a system without manually touching it every day.

---

## **Skills I Gained**

By the time my homelab stabilized, I had practical experience with:

- Troubleshooting hardware and OS issues
    
- Installing and configuring Linux Mint
    
- Configuring VMs (Kali Linux, REMnux, Windows 11)
    
- Managing user accounts and permissions
    
- Setting up and testing firewall rules
    
- Documenting changes so I could recreate or revert configurations
    
- Using command line tools as part of daily administration
    

The amount I learned from doing all this hands-on was honestly more valuable than just reading about it.

---

## **Final Thoughts and Plans Going Forward**

This project has easily been one of the most rewarding technical projects I’ve done. It helped me bridge the gap between theory and practice, and it gave me confidence to apply for IT roles knowing I had real experience troubleshooting systems. Looking back on what I learned, I'm quite proud of my progress. I have **a lot** of things I want to build in the future, but right now I'm looking into expanding my set-up by building a Plex server.

If you’re still on the fence about building one, I highly recommend it. Start small, break things, fix them, and document **everything**. You’ll learn more than you expect.

Here are some sites and resources I used that really helped me through this process:  
 PC building forums:  
	 https://pcpartpicker.com/forums/  
	 https://www.reddit.com/r/buildapc/  
	 https://forums.mysuperpc.com/  
 Compatibility:  
	 https://pcpartpicker.com/  
 Green screen issue:  
	 https://www.nvidia.com/en-us/geforce/forums/game-ready-drivers/13/512571/green-ish-screen-after-change-to-a-customized-reso/  

Also be sure to check out my other write-ups! In this one, I walk through how to set up a VM on VirtualBox:
-