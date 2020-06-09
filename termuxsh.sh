#!/bin/bash
clear
function ohmy(){
	apt install -y git zsh
	git clone https://github.com/Cabbagec/termux-ohmyzsh.git "$HOME/termux-ohmyzsh" --depth 1
	mv "$HOME/.termux" "$HOME/.termux.bak.$(date +%Y.%m.%d-%H:%M:%S)"
	cp -R "$HOME/termux-ohmyzsh/.termux" "$HOME/.termux"
	git clone git://github.com/robbyrussell/oh-my-zsh.git "$HOME/.oh-my-zsh" --depth 1
	mv "$HOME/.zshrc" "$HOME/.zshrc.bak.$(date +%Y.%m.%d-%H:%M:%S)"
	cp "$HOME/.oh-my-zsh/templates/zshrc.zsh-template" "$HOME/.zshrc"
	sed -i '/^ZSH_THEME/d' "$HOME/.zshrc"
	sed -i '1iZSH_THEME="cloud"' "$HOME/.zshrc"
	echo "alias chcolor='$HOME/.termux/colors.sh'" >> "$HOME/.zshrc"
	echo "alias chfont='$HOME/.termux/fonts.sh'" >> "$HOME/.zshrc"
	git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$HOME/.zsh-syntax-highlighting" --depth 1
	echo "source $HOME/.zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> "$HOME/.zshrc"
	echo "oh-my-zsh install complete!\nChoose your color scheme now~"
	$HOME/.termux/colors.sh
	$HOME/.termux/fonts.sh
}
function home(){
	      #echo -e "\n\n\n\n\n\n\n\n\n\n"
	      echo -e "1     换源\n"
	      echo -e "2     必备\n"
	      echo -e "3     zsh&oh-my-zsh\n"
	      echo -e "4     双排键盘\n"
	      echo -e "5     ohmyzsh&美化&插件\n"
	      echo -e "6     背景色调整\n"
	      echo -e "0     退出"
}
function option(){
	cd ~
	read -p "localhost ~>" home
	case $home in
	    1)
	    list;;
	    2)
	    pkg in -y git curl wget openssh unzip vim
	    clear
	    home
	    echo -e "\ngit curl wget openssh unzip vim已安装\n"
	    option;;
	    3)
	    ohmy
	    chsh -s zsh
	    termux-reload-settings
	    home;option;;
	    4)
	    if test -d ~/.termux/ ; then
	        :
	    else
	        mkdir -p ~/.termux/
	    fi
	    echo -e "extra-keys = [['ESC','(','HOME','UP','END',')','PGUP'],['CTRL','[','LEFT','DOWN','RIGHT',']','TAB']]" > ~/.termux/termux.properties
	    termux-reload-settings
	    clear
	    echo "更换完成，重启终端适配"
	    home;option
	    ;;
	    5)
	    git clone https://github.com/zsh-users/zsh-completions ~/.oh-my-zsh/custom/plugins/zsh-completions
	    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
	    git clone https://github.com/zsh-users/zsh-autosuggestions  ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
    if test -w ~/.zshrc ; then
	    sed -i "/^plugins=/c plugins=\(git zsh-autosuggestions zsh-completions zsh-syntax-highlighting\)" $HOME/.zshrc
	    else
	        echo "请先安装oh-my-zsh"
	    fi
	    home;option;;
	    6)
	    if test -d ~/termux-ohmyzsh/ ; then
	        cd ~
	        sed -i -e '/^background/c background=#282c33' -e '/^foreground/c foreground=#abb2bf' -e '/^cursor/c cursor=#fafafa' ~/termux-ohmyzsh/.termux/colors.properties
	        termux-reload-settings
	        clear
	    else
	        echo "请先安装oh-my-zsh"
	    fi
	    home
	    echo -e "\n\n完成\n"
	    option
	    ;;
	    0)
	    clear
	    ;;
	    *)
	    clear
	    echo "请输入正确的数字"
	    home;option
	    esac
	}
	function option1(){
	cd ~
	read -p "localhost ~>" list
	case $list in
	    1)
	    echo "开始换源"
	    sed -i '/^deb/d' $PREFIX/etc/apt/sources.list
	    sed -i '$adeb https:\/\/termux.org\/packages\/ stable main' $PREFIX/etc/apt/sources.list
		apt update && apt upgrade -y
		list
		;;
		2)
		echo "更换清华源"
		sed -i 's@^\(deb.*stable main\)$@#\1\ndeb https://mirrors.tuna.tsinghua.edu.cn/termux stable main@' $PREFIX/etc/apt/sources.list
		sed -i 's@^\(deb.*stable main\)$@#\1\ndeb https://mirrors.tuna.tsinghua.edu.cn/termux/termux-packages-24 stable main@' $PREFIX/etc/apt/sources.list
	    sed -i 's@^\(deb.*games stable\)$@#\1\ndeb https://mirrors.tuna.tsinghua.edu.cn/termux/game-packages-24 games stable@' $PREFIX/etc/apt/sources.list.d/game.list
	    sed -i 's@^\(deb.*science stable\)$@#\1\ndeb https://mirrors.tuna.tsinghua.edu.cn/termux/science-packages-24 science stable@' $PREFIX/etc/apt/sources.list.d/science.list
		apt update && apt upgrade -y
		list
		;;
		0)
		clear
		home;option
	    esac
	}
	function list(){
	    clear
	    echo -e "1     官方源\n"
	    echo -e "2     清华源\n"
	    echo -e "0     返回上级"
	    option1
	}
	home;option
