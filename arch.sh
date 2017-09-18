#!/bin/bash
########################################
# 前置工作：
# - 硬碟分割
# - 掛載相關分割至 /mnt 之下
########################################

step1(){
	read -p "hostname: " hostname

	echo 'Configure mirrorlist ...'
	mv /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.bak
	echo 'Server = http://archlinux.cs.nctu.edu.tw/$repo/os/$arch' >> /etc/pacman.d/mirrorlist
	echo 'Server = http://shadow.ind.ntou.edu.tw/archlinux/$repo/os/$arch' >> /etc/pacman.d/mirrorlist
	echo 'Server = http://ftp.tku.edu.tw/Linux/ArchLinux/$repo/os/$arch' >> /etc/pacman.d/mirrorlist
	echo 'Server = http://ftp.yzu.edu.tw/Linux/archlinux/$repo/os/$arch' >> /etc/pacman.d/mirrorlist

	echo 'Install ArchLinux ...'
	pacstrap /mnt base

	echo 'Generate fstab ...'
	genfstab -p -U /mnt >> /mnt/etc/fstab

	#chroot
	cp $0 /mnt/install.sh
	arch-chroot /mnt bash /install.sh --config $hostname
	rm /mnt/install.sh

	echo 'System installed. Please reboot.'
	exit
}

step2(){

	echo 'Configure pacman ...'
	sed -i '/^#\[multilib\]$/{N;s/#//g;P;D;}' /etc/pacman.conf
	# yaourt 套件源
	echo '[archlinuxfr]' >> /etc/pacman.conf
	echo 'SigLevel = Never' >> /etc/pacman.conf
	echo 'Server = http://repo.archlinux.fr/$arch' >> /etc/pacman.conf

	echo 'Install packages ...'
	# 字型
		# adobe-source-code-pro-fonts - 等寬字
		# adobe-source-han-sans-cn-fonts
		# adobe-source-han-sans-jp-fonts
		# adobe-source-han-sans-otc-fonts
		# adobe-source-han-sans-tw-fonts
		# adobe-source-sans-pro-fonts
		# adobe-source-serif-pro-fonts
		# ttf-arphic-uming - CJKUnifonts
		# ttf-baekmuk - arch wiki 建議
		# ttf-freefont - arch wiki 建議
		# ttf-inconsolata - 開發者用字型(待確認)
	# 系統工具
		# alsa-utils - 系統音效
		# at - 特定時間執行指令
		# btrfs-progs - Btrfs 檔案系統工具
		# cronie - crontab
		# gparted - 圖形介面分割工具
		# linux-headers - 核心檔頭，編譯用
		# lsof - 指令 lsof，觀察程序用
		# ntfs-3g - NTFS 讀寫支援
		# ntp - 網路校時
		# openssh - SSH Server & Client
		# parted - 文字介面分割工具
		# rp-pppoe - ADSL 支援
		# screen
		# sudo - sudo 指令
		# unrar
		# unzip
		# wget
		# yaourt - AUR 套件安裝
	# 文字介面
		# fbterm - 可顯示中文的文字介面 (加裝fcitx-fbterm來支援中文輸入)
	# 圖形介面
		# xf86-video-intel
		## lib32-mesa-libgl - 32 位元的 OpenGL 驅動(或者選這個？)
		## lib32-mesa-vdapu - 32 位元的影片播放器硬體加速
		## lib32-nvidia-304xx-libgl - 32 位元的 NVIDIA OpenGL 驅動
		## lib32-nvidia-304xx-utils - 32 位元的 NVIDIA 驅動，給 wine 虛擬用
		## lib32-opencl-nvidia-304xx - 32 位元的 NVIDIA OpenCL 驅動
		## lib32-libvdpau - 32 位元的影片播放器硬體加速函式庫
		# libva-vdpau-driver - 影片播放器硬體加速
		# libva-intel-driver
		# libvdpau - 影片播放器硬體加速
		## mesa-libgl - OpenGL 驅動
		# nvidia-304xx - NVIDIA 閉源驅動(或者選這個？)
		# nvidia-304xx-libgl - NVIDIA 閉源驅動(或者選這個？)
		# opencl-nvidia-304xx - NVIDIA OpenCL Support
		## xf86-video-nv - 開源驅動
		# xorg - X11
		# xorg-server-devel - NVIDIA 設定工具需要
	# 桌面環境
		# gnome
		# gnome-extra
		# file-roller - 圖形環境解壓工具
		# gnome-system-monitor - 系統監控
		# lightdm - 圖形登入介面
		# lightdm-gtk-greeter - 圖形登入介面相關函式庫
		# lilyterm - 終端機
		# numlockx - 開啟 NumLock 用
		# networkmanager - 網路管理
		# networkmanager-openconnect - NetworkManager 擴充 VPN 連線支援
		# networkmanager-openvpn - NetworkManager 擴充 VPN 連線支援
		# networkmanager-pptp - NetworkManager 擴充 VPN 連線支援
		# networkmanager-vpnc - NetworkManager 擴充 VPN 連線支援
	# 影音播放
		# banshee - 放音樂
		# eom - 看圖
		# gst-libav - 編碼支援
		# gst-plugins-ugly - 編碼支援
		# mpv - 影片播放器(可選)
		# smplayer - 影片播放器
		# vlc - 影片播放器
	# 輸入法
		# fcitx - 輸入法整合
		# fcitx-chewing - fcitx 酷音輸入法支援
		# fcitx-configtool - fcitx 設定工具
		# fcitx-fbterm - fcitx 搭配 fbterm 純文字模式輸入
		# fcitx-gtk2 - fcitx GTK2 支援
		# fcitx-gtk3 - fcitx GTK3 支援
		# fcitx-qt4 - fcitx qt4 支援
		# fcitx-qt5 - fcitx qt5 支援
		# libchewing - 酷音輸入法
	# 虛擬環境
		# lxc
		# wine
		# wine-mono
		# wine_gecko
	# 程式開發
		# base-devel - 開發用套件集
		# git
		# nodejs
		# npm - Node.JS 套件管理
	# 編輯器
		# gedit
		# vim
	# 應用程式/雜項
		# brasero - 燒錄軟體
		# chromium
		# deluge
		# firefox
		# firefox-i18n-zh-tw - 繁體中文語言包
		# filezilla
		# irssi - IRC Client
	pacman -Sy --noconfirm \
		adobe-source-code-pro-fonts adobe-source-han-sans-cn-fonts adobe-source-han-sans-jp-fonts \
    adobe-source-han-sans-tw-fonts ttf-arphic-uming ttf-freefont \
		\
		alsa-utils at cronie gparted linux-headers base-devel lsof ntfs-3g ntp openssh parted \
		rp-pppoe screen sudo unrar unzip wget yaourt \
		\
		libva-vdpau-driver libvdpau xf86-video-intel mesa-libgl xorg \
		xorg-server-devel \
		\
		gnome sddm gnome-system-monitor \
		\
		gst-libav gst-plugins-ugly vlc\
		\
		fcitx fcitx-rime fcitx-configtool fcitx-gtk2 fcitx-gtk3 fcitx-qt4 \
		fcitx-qt5 libchewing\
		\
		gedit vim fish zsh tmux\
		\
   	  firefox grub os-prober

	echo 'Change system limit ...'
	echo '*               -       nofile          10000' >> /etc/security/limits.conf

	echo 'Configure sudo ...'
	sed -i 's/^# \(%wheel ALL=(ALL) ALL\)$/\1/' /etc/sudoers

	echo 'Configure network ...'
	echo "$hostname" > /etc/hostname
	systemctl enable NetworkManager

	echo 'Configure time ...'
	# 時區
	ln -s /usr/share/zoneinfo/Asia/Taipei /etc/localtime
	# 網路時間同步
	systemctl enable ntpd.service

	echo 'Configure IME ...'
	
	mv /etc/locale.gen /etc/locale.gen.bak
	echo 'zh_TW.UTF-8 UTF-8' >> /etc/locale.gen
	echo 'en_US.UTF-8 UTF-8' >> /etc/locale.gen
	echo 'ja_JP.UTF-8 UTF-8' >> /etc/locale.gen
	locale-gen

	echo 'LANG=zh_TW.UTF-8' >> /etc/skel/.xprofile
	echo 'export GTK_IM_MODULE=fcitx' >> /etc/skel/.xprofile
	echo 'export QT_IM_MODULE=fcitx' >> /etc/skel/.xprofile
	echo 'export XMODIFIERS=@im=fcitx' >> /etc/skel/.xprofile

	echo 'Configure text UI ...'
	echo 'input-method=fcitx-fbterm' >> /etc/skel/.fbtermrc
	# 解決快速鍵問題
	chmod u+s /usr/bin/fbterm
	# 取代預設 tty
	# 安裝 fcitx-fbterm 以解決無法輸入中文的問題？
	# 設定字型、字集

	echo 'Configure graphical UI...'
	systemctl enable sddm.service

	echo 'Creating boot image ...'
	mkinitcpio -p linux

	echo 'Create user account'
	useradd rocky
	usermod -aG wheel rocky
	# fbterm 執行的必要權限
	usermod -aG video rocky
	exit
}

if [ $# != 0 ] && [ "$1" == "--config" ]; then
	hostname=$2
	step2;
else
	step1;
fi
