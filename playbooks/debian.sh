#!/bin/sh

#Remove unwanted apps
apt -y remove --purge gnome-calendar gnome-clocks gnome-color-manager gnome-contacts gnome-font-viewer gnome-maps gnome-music gnome-sound-recorder gnome-todo gnome-weather shotwell rhythmbox simple-scan vinagre aisleriot five-or-more four-in-a-row gnome-chess gnome-klotski gnome-mahjongg gnome-nibbles gnome-robots gnome-tetravex hitori hoichess iagno lightsoff quadrapassell swell-foop tali

apt -y autoremove
apt -y autoclean

apt-add-repository contrib && apt-add-repository non-free

apt -y install rsync vim htop zsh tlp tlp-rdw papirus-icon-theme evolution git screen openssh-server neofetch flatpak gnome-software-plugin-flatpak rhythmbox vlc

flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

flatpak install flathub com.spotify.Client.flatpakref org.libreoffice.LibreOffice.flatpakref org.mozilla.firefox.flatpakrefi io.atom.Atom.flatpakref
    user:
      name: "{{ user }}"
      groups: sudo
      create_home: yes
      shell: /bin/zsh

## Comment out if not running against desktop.
  - name: Start TLP for power savings on portable computers
    service:
      name: tlp
      state: started
      enabled: yes

  - name: Enable sshd for SSHing into this computer
    service:
      name: sshd
      state: started
      enabled: yes

  - name: Implement no-password sudo
    lineinfile:
      path: /etc/sudoers.d/{{ user }}
      line: '{{ user }} ALL=(ALL:ALL) NOPASSWD: ALL'
      create: yes
      validate: /usr/sbin/visudo -csf %s

  - name: Placing .zshrc in new user's home directory
    copy:
      src: "files/zshrc"
      dest: /home/{{ user }}/.zshrc
      owner: "{{ user }}"
      mode: '0644'

  - name: Importing Manjaro's excellent ZSH plugins to make your life better
    synchronize:
      src: "files/zsh"
      dest: /usr/share/

  - name: Importing Yaru theme. You know you want it.
    synchronize:
      src: "files/themes/icons"
      dest: /usr/share

  - synchronize: 
      src: "files/themes/themes"
      dest: /usr/share

  - name: Clean up 'df' output by excluding snap and tmpfs from output
    lineinfile:
      path: /home/{{ user }}/.zshrc
      line: alias dfh='df -h -x squashfs -x tmpfs'

  - name: Install Ubuntu wallpapers
    synchronize:
      src: "files/ubuntu_things"
      dest: /home

  - shell: "apt -y install /home/ubuntu_things/*.deb"

  - file:
      state: absent
      path: ~/ubuntu_things
