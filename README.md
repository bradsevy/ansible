# Hi.
---
Here is where I will put all of my machinations.

My first franken-creation is an Ansible playbook to set up an Ubuntu system running GNOME. Most of it would work on any Debian-family OS, but it is targeted at Ubuntu and my package list is as as such.  

The playbook accepts a username and password for account creation, creates the user as a no-password sudoers with ZSH as default shell, copies in Manjaro's fantastic ZSH implementation and associated plugins, adds the Spotify and Atom repositories and associated keys (because snaps are still slow) and then installs a bunch of packages and runs apt upgrade. It enables TLP and sshd for better power management on laptops and ssh access, respectively. Lastly, it copies in my dconf settings to choose theme, wallpaper, apps on dock, and arrangement of folders within application view.  

So you. Automate everything. Especially if you install your system on a precarious LVM setup or you are distro hopper who somehow always makes it back to Ubuntu.  

My process was as such:  
1. Install Ubuntu on local drive from live installer  
2. Mount and `chroot` into new install on local disk. (Be sure to bind proc and sys and copy in your resolve.conf)  
3. Install ansible from within chroot  
4. Run the playbook with `--become`  
5. Import dconf settings with `dconf load / < saved_settings`  
6. Exit chroot and reboot  
7. Sign into system as newly-created user and feel like you never left home.

You can also run from within the OS from within the account you wish to apply changes to. It's whatever works for you.
