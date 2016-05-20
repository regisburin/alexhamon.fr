#!/bin/bash

# +------------------------------------------------------------+
# | Bee Desktop Environment 0.7.2
# | Dist : Debian GNU/Linux 6.0 (Squeeze)
# | Arch : x86
# | Last update : 13-06-2011
# +------------------------------------------------------------+

# +------------------------------------------------------------+
# | Copyright 2008 Clément GILLARD | sleeper[at]kowazy[dot]be
# | Copyright 2011 Pascal Schalck | pschalck[at]juridique-csp[dot]com
# |
# | This program is free software; you can redistribute it and/or
# | modify it under the terms of the GNU General Public License
# | as published by the Free Software Foundation; either version
# | 3 of the License, or (at your option) any later version.
# | 
# | This program is distributed in the hope that it will be useful,
# | but WITHOUT ANY WARRANTY; without even the implied warranty
# | of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
# | See the GNU General Public License for more details.
# |
# | You should have received a copy of the GNU General Public
# | License along with this program; if not, write to the
# | Free Software Foundation, Inc., 51 Franklin St,
# | Fifth Floor, Boston, MA  02110-1301  USA
# +------------------------------------------------------------+

# +------------------------------------------------------------+
# | Acknowledgements
# +------------------------------------------------------------+
# | Di@bl@l
# | Thuban
# +------------------------------------------------------------+
  
#################################################################
# ! BabyBox style !                                             #
# +------------------------------------------------------------+
# | BabyBox remix by Alex HAMON | regisestuncool[AT]gmail[DOT]com
# | In default configuration (BabyBox selected during installation),
# | it add some apps and personalised config files to
# | the original Bee desktop, to turn it into BabyBox
# | See: http://forum.ubuntu-fr.org/viewtopic.php?id=762941
# | Last update: 24-01-2013
# +------------------------------------------------------------+

# +------------------------------------------------------------+
# | Check Version
# +------------------------------------------------------------+
VERSION=`grep -o 6.0 /etc/issue.net`

# +------------------------------------------------------------+
# | Var
# +------------------------------------------------------------+
USER=`grep 1000 /etc/passwd | awk -F: '{ print $1 }'`
DATE=`date "+%Y%m%d"`
DIALOG="/usr/share/bee/config/dialog"

BCOMM="/tmp/bee-common"
BSKEL="/tmp/bee-common/skel"
BDIST="/tmp/bee-squeeze"
BBACK="/home/$USER/.Bee-$DATE"
BUPDA="/usr/share/bee/config/update"
DEPOT="http://bee.saverne.info/downloads/common"
DEPON="http://bee.saverne.info/downloads/squeeze"
  
#################################################################
# ! BabyBox style !                                             #
DEPBB="http://alexhamon.fr/babybox"
BBBOX="/tmp/babybox-common"

# +------------------------------------------------------------+
# | Help
# +------------------------------------------------------------+
if [ "$1" = "" ] || [ "$1" = "--help" ] || [ "$1" = "-h" ]; then
  echo "bee -h : help"
  echo "bee -i : install"
  echo "bee -r : remove"
  exit 0
fi

# +------------------------------------------------------------+
# | Bee Uninstall
# +------------------------------------------------------------+
if [ "$1" = "-r" ]; then
  # autostartx
  if test -e /etc/skel/.profile-backup; then
    cd /etc/skel/
    mv .profile-backup .profile
  fi
  # autologin
  if test -e /usr/sbin/autologin; then
    rm /usr/sbin/autologin
    cd /etc/init/
    sed -e "s:-n -l /usr/sbin/autologin 38400 tty1:38400 tty1:g" tty1.conf > tty1.tmp && mv tty1.tmp tty1.conf
  fi
  # sudoers
  if test -e /etc/sudoers-backup; then
    mv /etc/sudoers-backup /etc/sudoers
  fi
  # lns
  rm /root/.gtkrc-2.0
  rm /root/.themes
  rm /root/.icons
  rm /etc/skel/wallpapers
  # bin
  rm /usr/local/bin/bee-calendar
  rm /usr/local/bin/bee-mpd
  rm /usr/local/bin/bee-session
  rm /usr/local/bin/flv-to-mp3
  rm /usr/local/bin/up-to-date
  # lib
  rm /usr/lib/thumbnailers/mplayer-thumbnailer 2> /dev/null
  # config files
  rm /etc/skel/.xsession
  rm /etc/skel/.gtkrc-2.0
  rm /etc/skel/.Xdefaults
  rm /etc/skel/.mpdconf 2> /dev/null
  # panel
  rm -r /etc/skel/.fbpanel 2> /dev/null
  rm /etc/skel/.pypanelrc 2> /dev/null
  # dot desktop
  rm /usr/share/xsessions/bee.desktop
  rm /usr/share/applications/nitrogen.desktop
  rm /usr/share/thumbnailers/mplayer-thumbnailer.desktop 2> /dev/null
  # dir
  rm -r /usr/share/bee/icons
  rm -r /etc/skel/Desktop
  rm -r /etc/skel/.config
  rm -r /etc/skel/.local
  # Ok
  echo "+------------------------------------------------------------+"
  echo "| Remove Bee [OK]"
  echo "+------------------------------------------------------------+"
  exit 0
fi

# +------------------------------------------------------------+
# | Bee Install
# +------------------------------------------------------------+
if [ "$1" = "-i" ] && [ $VERSION = "6.0" ]; then
  
  # +------------------------------------------------------------+
  # | Update ?
  # +------------------------------------------------------------+
  
  if test -e $BUPDA
    then UPDATE="yes"
  fi
  
  # +------------------------------------------------------------+
  # | Installation
  # +------------------------------------------------------------+
  
  # Go to root directory
  # Download bee files
  cd /tmp/
  wget -nc $DEPON/bee-common.tar.gz
  wget -nc $DEPON/bee-squeeze.tar.gz
  
  #################################################################
  # ! BabyBox style !                                             #
  wget -nc $DEPBB/babybox-common.tar.gz

  # Uncompress bee files
  tar zxvf bee-common.tar.gz > /dev/null
  tar zxvf bee-squeeze.tar.gz > /dev/null

  #################################################################
  # ! BabyBox style !                                             #
  tar zxvf babybox-common.tar.gz > /dev/null

  # Root files
  chown -R root:root bee-common/
  chown -R root:root bee-squeeze/

  #################################################################
  # ! BabyBox style !                                             #
  chown -R root:root babybox-common/

  # Backup old sources.list
  mv /etc/apt/sources.list /etc/apt/sources.list-backup
  # Move new sources.list
  #################################################################
  # ! BabyBox style !                                             #
  mv $BBBOX/sources.list /etc/apt/
  #mv $BDIST/sources.list /etc/apt/
  # Install keyring
  #wget -nc -q http://fr.packages.medibuntu.org/medibuntu-key.gpg -O- | apt-key add -
  # Update repository
  apt-get update
  # Install mc
  apt-get -y --force-yes install mc
  # Install bee-base
  apt-get -y --force-yes install xterm xorg dialog
  # Install bee-minimal
  apt-get -y --force-yes install openbox gdebi gmrun obconf obmenu synaptic nitrogen


  # Install bee-artwork 
  apt-get -y --force-yes install openbox-themes dmz-cursor-theme #Debian-mono 
  #wget -nc $DEPOT/bee-wallpapers_0.2_all.deb
  #dpkg -i bee-wallpapers_0.2_all.deb

  # Install bee-utils
  apt-get -y --force-yes install gnome-utils alsa-utils mesa-utils xarchiver unrar galternatives htop xfce4-taskmanager lxappearance
  # Install Language FR
  #apt-get -y --force-yes install language-pack-fr language-pack-gnome-fr language-support-fr

  # +------------------------------------------------------------+
  # | MakeDir
  # +------------------------------------------------------------+
  
  mkdir -p /usr/share/bee/config # ne doit jamais etre supprime
  mkdir -p /etc/skel/Desktop
  mkdir -p /etc/skel/.config
  mkdir -p /etc/skel/.local    
  #################################################################
  # ! BabyBox style !                                             #
  mkdir -p /usr/share/images/photos 
  mkdir -p /usr/share/wallpapers
  mkdir -p /etc/skel/.icons
  mkdir -p /etc/skel/.fonts
  mkdir -p /etc/skel/Images
  mkdir -p /etc/skel/.themes
  mkdir -p /home/$USER/Images
  # Install BabyBox Artwork
  cp $BBBOX/bg_babybox_800x600.png /usr/share/wallpapers/bg_babybox_800x600.png
  
  # +------------------------------------------------------------+
  # | Start Function
  # +------------------------------------------------------------+
  
  # Install GDM
  function gdma (){
    apt-get -y --force-yes install gdm
  }
  
  # Install Autostartx
  function stax (){
    cd /etc/skel/
    mv .profile .profile-backup
    mv $BSKEL/profile /etc/skel/.profile
  }
  
  # Install Autologin + Autostartx
  function auto (){
    # Autologin
    cd $BCOMM/sbin/
    sed -e "s/user/$USER/g" autologin > autologin.tmp && mv autologin.tmp autologin
    chmod +x autologin # ne doit jamais etre supprime
    mv autologin /usr/sbin/
    cd /etc/init/
    sed -e "s:38400 tty1:-n -l /usr/sbin/autologin 38400 tty1:g" tty1.conf > tty1.tmp && mv tty1.tmp tty1.conf
    # Autostartx
    stax # function
  }

  # Install Debian-Ambiance
  function ubam (){
    apt-get -y --force-yes install light-themes
    cd $BSKEL && sed -e "s/gtktheme/Ambiance/g;s/gtkicont/Debian-mono-dark/g" gtkrc-2.0 > gtkrc-2.0.tmp && mv gtkrc-2.0.tmp gtkrc-2.0
  }

  # Install Debian-Radiance
  function ubra (){
    apt-get -y --force-yes install light-themes
    cd $BSKEL && sed -e "s/gtktheme/Radiance/g;s/gtkicont/Debian-mono-light/g" gtkrc-2.0 > gtkrc-2.0.tmp && mv gtkrc-2.0.tmp gtkrc-2.0
  }
  
  # Install Shiki-Brave
  function shbr (){
    apt-get -y --force-yes install shiki-brave-theme
    cd $BSKEL && sed -e "s/gtktheme/Shiki-Brave/g;s/gtkicont/gnome-brave/g" gtkrc-2.0 > gtkrc-2.0.tmp && mv gtkrc-2.0.tmp gtkrc-2.0
  }
  
  # Install Shiki-Human
  function shhu (){
    apt-get -y --force-yes install shiki-human-theme
    cd $BSKEL && sed -e "s/gtktheme/Shiki-Human/g;s/gtkicont/gnome-human/g" gtkrc-2.0 > gtkrc-2.0.tmp && mv gtkrc-2.0.tmp gtkrc-2.0
  }
  
  # Install Shiki-Noble
  function shno (){
    apt-get -y --force-yes install shiki-noble-theme
    cd $BSKEL && sed -e "s/gtktheme/Shiki-Noble/g;s/gtkicont/gnome-noble/g" gtkrc-2.0 > gtkrc-2.0.tmp && mv gtkrc-2.0.tmp gtkrc-2.0
  }

  # Install Shiki-Wine
  function shwn (){
    apt-get -y --force-yes install shiki-wine-theme
    cd $BSKEL && sed -e "s/gtktheme/Shiki-Wine/g;s/gtkicont/gnome-wine/g" gtkrc-2.0 > gtkrc-2.0.tmp && mv gtkrc-2.0.tmp gtkrc-2.0
  }

  # Install Shiki-Wise
  function shws (){
    apt-get -y --force-yes install shiki-wise-theme
    cd $BSKEL && sed -e "s/gtktheme/Shiki-Wise/g;s/gtkicont/gnome-wise/g" gtkrc-2.0 > gtkrc-2.0.tmp && mv gtkrc-2.0.tmp gtkrc-2.0
  }

  # Install Shiki-Illustrious
  function shil (){
    apt-get -y --force-yes install shiki-illustrious-theme
    cd $BSKEL && sed -e "s/gtktheme/Shiki-Illustrious/g;s/gtkicont/gnome-illustrious/g" gtkrc-2.0 > gtkrc-2.0.tmp && mv gtkrc-2.0.tmp gtkrc-2.0
  }

  # Install Aurora
  function auro (){
    apt-get -y --force-yes install gtk2-engines-aurora
    cd $BSKEL && sed -e "s/gtktheme/Aurora/g;s/gtkicont/Humanity/g" gtkrc-2.0 > gtkrc-2.0.tmp && mv gtkrc-2.0.tmp gtkrc-2.0
  }

  # Install Mplayer Thumbnailer
  # appel de la fonction dans le script : mpth
  function mpth (){
    apt-get -y --force-yes install mplayer
    mkdir -p /usr/lib/thumbnailers
    mv $BCOMM/lib/mplayer-thumbnailer /usr/lib/thumbnailers/
    mkdir -p /usr/share/thumbnailers
    mv $BCOMM/dotdesktop/mplayer-thumbnailer.desktop /usr/share/thumbnailers/
  }
  
  # Install Thunar
  function thun (){
    apt-get -y --force-yes install thunar thunar-archive-plugin thunar-thumbnailers
    cd $BSKEL/config/openbox/
    sed -e "s/filemanager/thunar/g" rc.xml > rc.xml.tmp && mv rc.xml.tmp rc.xml
    sed -e "s/filemanager/thunar/g" menu.xml > menu.xml.tmp && mv menu.xml.tmp menu.xml
    cd $BSKEL/config/fbpanel/ && sed -e "s/filemanager/thunar/g" default > default.tmp && mv default.tmp default
  }
  
  # Install PCMan File Manager
  function pcma (){
    apt-get -y --force-yes install pcmanfm
    cd $BSKEL/config/openbox/
    sed -e "s/filemanager/pcmanfm/g" rc.xml > rc.xml.tmp && mv rc.xml.tmp rc.xml
    sed -e "s/filemanager/pcmanfm/g" menu.xml > menu.xml.tmp && mv menu.xml.tmp menu.xml
    cd $BSKEL/config/fbpanel/ && sed -e "s/filemanager/pcmanfm/g" default > default.tmp && mv default.tmp default
  }
  
  # Install Fbpanel FR 6.0
  function fbf6 (){
    wget -nc $DEPOT/fbpanel-fr_6.0-1_i386.deb
    dpkg -i fbpanel-fr_6.0-1_i386.deb
    mv $BSKEL/config/fbpanel/ /etc/skel/.fbpanel
    cd $BCOMM/bin/ && sed -e "s/panel/fbpanel/g" bee-session > bee-session.tmp && mv bee-session.tmp bee-session
  }
  
  # Install Fbpanel FR 4.12
  function fbpf (){
    wget -nc $DEPOT/fbpanel-fr_4.12-1_i386.deb
    dpkg -i fbpanel-fr_4.12-1_i386.deb
    mv $BSKEL/config/fbpanel/ /etc/skel/.fbpanel
    cd $BCOMM/bin/ && sed -e "s/panel/fbpanel/g" bee-session > bee-session.tmp && mv bee-session.tmp bee-session
  }
  
  # Install Fbpanel EN
  function fbpe (){
    apt-get -y --force-yes install fbpanel
    mv $BSKEL/config/fbpanel/ /etc/skel/.fbpanel
    cd $BCOMM/bin/ && sed -e "s/panel/fbpanel/g" bee-session > bee-session.tmp && mv bee-session.tmp bee-session
  }
   
  # Install Pypanel
  function pypa (){
    wget -nc $DEPOT/pypanel_2.4-1_i386.deb
    dpkg -i pypanel_2.4-1_i386.deb
    mv $BSKEL/pypanelrc /etc/skel/.pypanelrc
    cd $BCOMM/bin/ && sed -e "s/panel/pypanel/g" bee-session > bee-session.tmp && mv bee-session.tmp bee-session
  }
  
  # Install Tint2
  function tint (){
    apt-get -y --force-yes install tint2
    cd $BCOMM/bin/ && sed -e "s/panel/tint2/g" bee-session > bee-session.tmp && mv bee-session.tmp bee-session
  }
  
  # Install Network Manager
  function netm (){
    apt-get -y --force-yes install network-manager-gnome
    echo 'nm-applet --sm-disable &' >> $BBBOX/config/openbox/autostart
  }
  
  # Install Wicd
  function wicd (){
    apt-get -y --force-yes install wicd wicd-curses wicd-gtk
    echo 'wicd-client &' >> $BBBOX/config/openbox/autostart
  }
  
  # Install Firefox
  function fire (){
    apt-get -y --force-yes install firefox firefox-gnome-support
  }
  
  # Install Chromium
  function chro (){
    apt-get -y --force-yes install chromium-browser
  }
  
  # Install Midori
  function mido (){
    apt-get -y --force-yes install midori
  }
  
  # Install Leafpad
  function leaf (){
    apt-get -y --force-yes install leafpad
  }
  
  # Install Gpicview
  function gpic (){
    apt-get -y --force-yes install gpicview
  }
  
  # Install Evince
  function evin (){
    apt-get -y --force-yes install evince
  }
  
  # Install Xpdf
  function xpdf (){
    apt-get -y --force-yes install xpdf
  }
  
  # Install Brasero
  function bras (){
    apt-get -y --force-yes install brasero
  }
  
  # Install GNOME MPlayer
  function mpla (){
    apt-get -y --force-yes install mplayer smplayer gecko-mediaplayer
  }
  
  # Install VLC
  function vlcl (){
    apt-get -y --force-yes install vlc
  }
  
  # Install Audacious
  function auda (){
    apt-get -y --force-yes install audacious
  }
  
  # Install Sonata/mpd
  function sona (){
    apt-get -y --force-yes install sonata mpd 
    wget -nc $DEPOT/bee-music_0.1_all.deb
    dpkg -i bee-music_0.1_all.deb
    # mpd not start in rc
    invoke-rc.d mpd stop
    update-rc.d -f mpd remove # update-rc.d mpd defaults (remake)
    # copy config file
    mkdir -p /etc/skel/.config/bee/mpd/playlists
    mv $BSKEL/mpdconf /etc/skel/.mpdconf
    echo 'bee-mpd &' >> $BBBOX/config/openbox/autostart
  }
  
  # Install Pidgin
  function pidg (){
    apt-get -y --force-yes install pidgin
  }
  
  # Install Emesene
  function emes (){
    apt-get -y --force-yes install emesene
  }
  
  # Install The GIMP
  function gimp (){
    apt-get -y --force-yes install gimp
  }
  
  # Install Transmission
  function tran (){
    apt-get -y --force-yes install transmission-gtk
  }
  
  # Install Geany
  function gean (){
    apt-get -y --force-yes install geany
  }
 
  # Install OpenOffice.org
  function lbro (){
    #apt-get -y --force-yes install openoffice-writer openoffice-calc openoffice-impress openoffice-gtk openoffice-l10n-fr openoffice-help-fr
    apt-get -y --force-yes install openoffice.org
    # profile
    if test ! -e /etc/profile-backup; then
    cp /etc/profile /etc/profile-backup
    echo 'export OOO_FORCE_DESKTOP=gnome' >> /etc/profile
    fi
  }
  
  #################################################################
  # ! BabyBox style !                                             #
  # Install OOo4Kids                                              #
  function ooo4 (){
    apt-get -y --force-yes install ooo4kids-fr
    # profile
    if test ! -e /etc/profile-backup; then
    cp /etc/profile /etc/profile-backup
    echo 'export OOO_FORCE_DESKTOP=gnome' >> /etc/profile
    fi
  }
 
  # Install GNOME Office
  function goff (){
    apt-get -y --force-yes install abiword gnumeric
  }

  # Install Xcfa
  function xcfa (){
    apt-get -y --force-yes install xcfa
  }

  # Install Avidemux
  function avid (){
    apt-get -y --force-yes install avidemux
  }
  
  # Install GNOME Games
  function ggam (){
    apt-get -y --force-yes install gnome-games
  }
  

  # Install Wbar      #
  function wbar (){
    apt-get -y --force-yes install wbar
    #################################################################
    # ! BabyBox style !                                             #
    cp $BBBOX/config/wbarconf /etc/skel/.config
    echo 'sleep 5 && wbar -config /home/$USER/.config/wbarconf -above-desk -isize 72 -pos top -idist 30 -zoomf 1.3 &' >> $BBBOX/config/openbox/autostart
    #wget -nc $DEPOT/bee-wbar_0.1_all.deb
    #dpkg -i bee-wbar_0.1_all.deb
    #cp $DEPBB/
    #echo 'sleep 6 && bee-wbar &' >> $BSKEL/config/openbox/autostart
  }
  
  # Install Java
  function java (){
    apt-get -y --force-yes install default-jre sun-java6-jre
  }
  
  # Install MS Fonts
  function msfo (){
    apt-get -y --force-yes install ttf-mscorefonts-installer
  }
  
  # Install Codecs
  function code (){
    apt-get -y --force-yes install gstreamer0.10-ffmpeg gstreamer0.10-plugins-good gstreamer0.10-plugins-bad gstreamer0.10-plugins-ugly libdvdnav4 libdvdread4
  }
  
  # Install Flash
  function flas (){
    apt-get -y --force-yes install flashplugin-nonfree
  }
  
  #################################################################
  # ! BabyBox style !                                             #
  # Install BabyBox Apps                                          #
  function bbba (){
    apt-get -y --force-yes install gcompris gcompris-sound-fr tuxpaint tuxpaint-plugins-default tuxpaint-stamps-default tuxtype smc smc-music tuxmath x11-apps frozen-bubble
  }

  # Package status ( on = installed, off = not installed )
  function pstatus(){
    if dpkg-query -s "$1" 2> /dev/null | grep -q installed
    then echo "on"
    else echo "off"
    fi
  }
  
# +------------------------------------------------------------+
# | Stop Function
# +------------------------------------------------------------+

  # Install Login
  dialog --backtitle "BabyBox Desktop Environment" --title "Session" \
  --ok-label "Valider" --cancel-label "Quitter" \
  --radiolist "Veuillez choisir le mode de connexion à votre session.\nSélection avec la barre d'espace." 20 70 3 \
  "gdma" "GDM, gestionnaire de connexion graphique" off \
  "stax" "Auto startx après un login texte sur le TTY1" on \
  "auto" "Auto login, auto connexion sans taper le mot de passe" off 2> $DIALOG
  
  CONNEXION=`cat $DIALOG`
  
  case $CONNEXION in
  gdma) gdma ;;
  stax) stax ;;
  auto) auto ;;
  esac
  
  # Install GTK Theme
  dialog --backtitle "BabyBox Desktop Environment" --title "Thèmes GTK" \
  --ok-label "Valider" --cancel-label "Quitter" \
  --radiolist "Veuillez choisir le thème GTK désiré.\nSélection avec la barre d'espace." 20 70 9 \
  "ubam" "Debian Ambiance, thème mi-sombre Debian 6.0 (Murrine)" off \
  "ubra" "Debian Radiance, thème clair Debian 6.0 (Murrine)" off \
  "shbr" "Shiki-Brave, thème bleu mi-sombre (Murrine)" off \
  "shhu" "Shiki-Human, thème orange mi-sombre (Murrine)" off \
  "shno" "Shiki-Noble, thème violet mi-sombre (Murrine)" off \
  "shwn" "Shiki-Wine, thème rouge mi-sombre (Murrine)" off \
  "shws" "Shiki-Wise, thème vert mi-sombre (Murrine)" off \
  "shil" "Shiki-Illustrious, thème rose mi-sombre (Murrine)" on \
  "auro" "Aurora, thème gris bleuté (Aurora)" off 2> $DIALOG
  
  THEME=`cat $DIALOG`
  
  case $THEME in
  ubam) ubam ;;
  ubra) ubra ;;
  shbr) shbr ;;
  shhu) shhu ;;
  shno) shno ;;
  shwn) shwn ;;
  shws) shws ;;
  shil) shil ;;
  auro) auro ;;
  esac

  # Install File Manager
  dialog --backtitle "BabyBox Desktop Environment" --title "Gestionnaire de fichiers" \
  --ok-label "Valider" --cancel-label "Quitter" \
  --radiolist "Installation de votre gestionnaire de fichiers préféré.\nSélection avec la barre d'espace." 20 70 2 \
  "thun" "Thunar, navigateur de fichiers (recommandé)" off \
  "pcma" "PCman FM, navigateur de fichiers avec onglets" on 2> $DIALOG
  
  FILEMANAGER=`cat $DIALOG`
  
  case $FILEMANAGER in
  thun) thun ;;
  pcma) pcma ;;
  esac

 
  # Install Panel
  dialog --backtitle "BabyBox Desktop Environment" --title "Panel" \
  --ok-label "Valider" --cancel-label "Quitter" \
  --radiolist "Installation de votre panel préféré.\nSélection avec la barre d'espace." 20 70 5 \
  "fbf6" "FBPanel FR 6, panel GTK avec menu d'applications" off \
  "fbpf" "FBPanel FR 4, panel GTK avec menu d'applications" off \
  "fbpe" "FBPanel EN, panel GTK avec menu d'applications" off \
  "pypa" "Pypanel, panel en Python sans menu d'applications" off \
  "tint" "Tint2, le panel d'Openbox 3" off \
  "none" "NoPanel, j'utilise un autre panel." on 2> $DIALOG
  
  PANEL=`cat $DIALOG`
  
  case $PANEL in
  fbf6) fbf6 ;;
  fbpf) fbpf ;;
  fbpe) fbpe ;;
  pypa) pypa ;;
  tint) pypa ;;
  esac
  
  # Install Network Manager
  dialog --backtitle "BabyBox Desktop Environment" --title "Gestionnaire de réseaux" \
  --ok-label "Valider" --cancel-label "Quitter" \
  --radiolist "Veuillez choisir votre gestionnaire de connexion réseaux.\nServez vous de la barre d'espace et des flèches." 20 70 3 \
  "netm" "Network Manager, Filaire/Wifi DHCP/Fixe VPN" on \
  "wicd" "Wicd, Filaire/Wifi DHCP/Fixe" off \
  "none" "Aucun, vive le fichier /etc/network/interfaces" off 2> $DIALOG
  
  NETWORK=`cat $DIALOG`
  
  case $NETWORK in
  netm) netm ;;
  wicd) wicd ;;
  esac
  
  # --checklist texte hauteur largeur hauteur-de-liste [ marqueur1 item1 état] ...
  dialog --backtitle "BabyBox Desktop Environment" --title "Choix du navigateurs web" \
  --ok-label "Valider" --cancel-label "Quitter" \
  --checklist "Cochez vos navigateurs préférés avec la barre d'espace." 20 70 3 \
  "fire" "Firefox, le navigateur made in Mozilla" `if [ $UPDATE = "yes" ]; then pstatus firefox; else echo "off"; fi` \
  "chro" "Chromium, le navigateur made in Google" `if [ $UPDATE = "yes" ]; then pstatus chromium-browser; else echo "off"; fi` \
  "mido" "Midori, un navigateur léger basé sur WebKit" `if [ $UPDATE = "yes" ]; then pstatus midori; else echo "on"; fi` 2> $DIALOG
  
  # traitement de la réponse
  for i in `cat $DIALOG`
  do
  case $i in
  \"fire\") fire ;;
  \"chro\") chro ;;
  \"mido\") mido ;;
  esac
  done

  #################################################################
  # ! BabyBox style !                                             #
  # Install Apps                                                  #
  
  # --checklist texte hauteur largeur hauteur-de-liste [ marqueur1 item1 état] ...
  dialog --backtitle "BabyBox Desktop Environment" --title "Choix des applications" \
  --ok-label "Valider" --cancel-label "Quitter" \
  --checklist "Cochez vos applications préférées avec la barre d'espace." 20 70 15 \
  "leaf" "Leafpad, éditeur de texte (bloc-notes)" `if [ $UPDATE = "yes" ]; then pstatus leafpad; else echo "on"; fi` \
  "gpic" "Gpicview, visionneur d'images" `if [ $UPDATE = "yes" ]; then pstatus gpicview; else echo "on"; fi` \
  "evin" "Evince, lecteur de fichiers PDF" `if [ $UPDATE = "yes" ]; then pstatus evince; else echo "on"; fi` \
  "xpdf" "Xpdf, suite d'outils pour les fichiers PDF" `if [ $UPDATE = "yes" ]; then pstatus xpdf; else echo "off"; fi` \
  "bras" "Brasero, gravure CD & DVD" `if [ $UPDATE = "yes" ]; then pstatus brasero; else echo "off"; fi` \
  "mpla" "GNOME MPlayer, lecteur multimédia suprême" `if [ $UPDATE = "yes" ]; then pstatus gnome-mplayer; else echo "off"; fi` \
  "vlcl" "VLC, lecteur multimédia" `if [ $UPDATE = "yes" ]; then pstatus vlc; else echo "on"; fi` \
  "auda" "Audacious, lecteur audio (winamp-like)" `if [ $UPDATE = "yes" ]; then pstatus audacious; else echo "off"; fi` \
  "sona" "Sonata/mpd, lecteur audio (audiothèque)" `if [ $UPDATE = "yes" ]; then pstatus sonata; else echo "off"; fi` \
  "pidg" "Pidgin, client messagerie multi-protocoles" `if [ $UPDATE = "yes" ]; then pstatus pidgin; else echo "off"; fi` \
  "emes" "Emesene, client messagerie MSN" `if [ $UPDATE = "yes" ]; then pstatus emesene; else echo "off"; fi` \
  "gimp" "The GIMP, éditeur d'images" `if [ $UPDATE = "yes" ]; then pstatus gimp; else echo "off"; fi` \
  "tran" "Transmission, client BitTorrent" `if [ $UPDATE = "yes" ]; then pstatus transmission-gtk; else echo "off"; fi` \
  "gean" "Geany, IDE rapide et léger" `if [ $UPDATE = "yes" ]; then pstatus geany; else echo "off"; fi` \
  "lbro" "openoffice 3, suite bureautique complète" `if [ $UPDATE = "yes" ]; then pstatus openoffice-writer; else echo "off"; fi` \
  "ooo4" "OOo4Kid, suite bureautique pour les petits" `if [ $UPDATE = "yes" ]; then pstatus ooo4kids1.3; else echo "on"; fi` \
  "goff" "GNOME Office, Abiword + Gnumeric" `if [ $UPDATE = "yes" ]; then pstatus abiword; else echo "off"; fi` \
  "xcfa" "X Convert File Audio, convertisseur de fichier audio" `if [ $UPDATE = "yes" ]; then pstatus xcfa; else echo "off"; fi` \
  "avid" "Avidemux, éditeur de vidéo libre" `if [ $UPDATE = "yes" ]; then pstatus avidemux; else echo "off"; fi` \
  "ggam" "GNOME Games, collection de 17 petits jeux '5 minutes'" `if [ $UPDATE = "yes" ]; then pstatus gnome-games; else echo "on"; fi` \
  "wbar" "Lanceur d'applications / dock, Wbar." `if [ $UPDATE = "yes" ]; then pstatus bee-wbar; else echo "on"; fi` \
  "java" "Java OpenJDK 6" `if [ $UPDATE = "yes" ]; then pstatus default-jre; else echo "on"; fi` \
  "msfo" "MS Fonts, les polices Microsoft (recommandé)" `if [ $UPDATE = "yes" ]; then pstatus ttf-mscorefonts-installer; else echo "on"; fi` \
  "code" "Les codecs ffmpeg, gstreamer et DVD" `if [ $UPDATE = "yes" ]; then pstatus gstreamer0.10-ffmpeg; else echo "on"; fi` \
  "flas" "Adobe Flash Plugin 10" `if [ $UPDATE = "yes" ]; then pstatus flashplugin-installer; else echo "on"; fi` \
  "bbba" "BabyBox"  `if [ $UPDATE = "yes" ]; then pstatus gcompris; else echo "on"; fi` 2> $DIALOG
  
  # traitement de la réponse
  for i in `cat $DIALOG`
  do
  case $i in
  \"leaf\") leaf ;;
  \"gpic\") gpic ;;
  \"evin\") evin ;;
  \"xpdf\") xpdf ;;
  \"bras\") bras ;;
  \"mpla\") mpla ;;
  \"vlcl\") vlcl ;;
  \"auda\") auda ;;
  \"sona\") sona ;;
  \"pidg\") pidg ;;
  \"emes\") emes ;;
  \"gimp\") gimp ;;
  \"tran\") tran ;;
  \"gean\") gean ;;
  \"lbro\") lbro ;;
  \"ooo4\") ooo4 ;;
  \"goff\") goff ;;
  \"xcfa\") xcfa ;;
  \"avid\") avid ;;
  \"ggam\") ggam ;;
  \"wbar\") wbar ;;
  \"java\") java ;;
  \"msfo\") msfo ;;
  \"code\") code ;;
  \"flas\") flas ;;
  \"bbba\") bbba ;;
  esac
  done
   
  # Install Bee Files
  
  # config files
  mv $BSKEL/local/* /etc/skel/.local/
  mv $BSKEL/config/* /etc/skel/.config/
  mv $BSKEL/gtkrc-2.0 /etc/skel/.gtkrc-2.0
  mv $BSKEL/Xdefaults /etc/skel/.Xdefaults
  mv $BCOMM/dotdesktop/bee.desktop /usr/share/xsessions/
  mv $BCOMM/dotdesktop/nitrogen.desktop /usr/share/applications/
  echo "exec ck-launch-session bee-session" > /etc/skel/.xsession
  # bin
  chmod +x $BCOMM/bin/bee-session # ne doit jamais etre supprime
  mv $BCOMM/bin/* /usr/local/bin/
  #mv $BDIST/bin/* /usr/local/bin/

  #################################################################
  # ! BabyBox style !                                             #
  # Install BabyBox config files                                  #
  mv $BBBOX/icons/* /etc/skel/.icons/
  mv $BBBOX/config/* /etc/skel/.config/
  mv $BBBOX/fonts/* /etc/skel/.fonts/
  mv $BBBOX/photos/* /usr/share/images/photos/
  mv $BBBOX/themes/* /etc/skel/.themes/
  echo 'sleep 4 && xeyes -geometry 80x40+70+245 &' >> $BBBOX/config/openbox/autostart

  # lns
  #ln -sf /usr/share/bee/wallpapers /etc/skel/
  ln -sf /home/$USER/.gtkrc-2.0 /root/
  #ln -sf /home/$USER/.themes /root/
  ln -sf /home/$USER/.icons /root/
  ln -sf /usr/share/images/photos /home/$USER/Images
  #dir
  mv $BCOMM/icons/ /usr/share/bee/
  
  # Sudoers
  if test ! -e /etc/sudoers-backup; then
    cp /etc/sudoers /etc/sudoers-backup
    echo "ALL ALL=NOPASSWD:/sbin/shutdown" >> /etc/sudoers
    # echo "ALL ALL=NOPASSWD:/usr/sbin/update-manager" >> /etc/sudoers
  fi
  
  # Make backup dir
  #mkdir -p $BBACK
  #echo -e "Ce dossier contient une copie des fichiers de configuration qui ont été remplacés.\nFaites CTRL + H pour voir les fichiers cachés." > $BBACK/readme
  
  # Backup Config Files
  #cd /home/$USER
  # cp -r .[^.]* $BBACK/ # all config files
  #cp -r .config/ $BBACK/ 2> /dev/null
  #cp -r .config/fbpanel/ $BBACK/ 2> /dev/null
# fbpanel a sa conig dans .config à présent
  #cp -r .local/ $BBACK/ 2> /dev/null
  #cp .gtkrc-2.0 $BBACK/ 2> /dev/null
  #cp .Xdefaults $BBACK/ 2> /dev/null
  #cp .mpdconf $BBACK/ 2> /dev/null
  #cp .profile $BBACK/ 2> /dev/null
  #cp .pypanelrc $BBACK/ 2> /dev/null
  #mv .xsession $BBACK/ 2> /dev/null
  #mv .bash_profile $BBACK/ 2> /dev/null # preventif
  
  # Copy SKEL to Home
  cd /etc/skel/
  rm -f .bash_profile 2> /dev/null # preventif
  cp -r /etc/skel/. /home/$USER
  chown -R 1000:1000 /home/$USER
  
  # Clean
  cd /tmp/
  #rm -r bee-common/ bee-common.tar.gz
  #rm -r bee-Squeeze/ bee-Squeeze.tar.gz
  rm /usr/share/xsessions/openbox.desktop 2> /dev/null # preventif
  rm /usr/share/xsessions/openbox-gnome.desktop 2> /dev/null # preventif
  rm /usr/share/xsessions/openbox-kde.desktop 2> /dev/null # preventif
  rm $DIALOG
  
  #################################################################
  # ! BabyBox style !                                             #
  # fix locate/mlocate error
  updatedb

  # Creation du fichier update si premiere installation
  if test ! -e $BUPDA; then
  touch $BUPDA
  fi
  
  echo "+------------------------------------------------------------+"
  echo "| Install Bee [OK]"
  echo "+------------------------------------------------------------+"
  
  if test -e /usr/sbin/gdm; then
    # GDM start
    service gdm start
  else
    # Login
    login -f $USER
  fi
  
  exit 0
  
else
  
  echo "+------------------------------------------------------------+"
  echo "| Votre distribution n'est pas supportée par ce script."
  echo "| Ce script est prévu pour Debian 6.0"
  echo "| Si vous souhaitez de plus amples inforamtions concernant"
  echo "| l'utilisation de ce script, tapez : bee --help"
  echo "+------------------------------------------------------------+"
  
fi
