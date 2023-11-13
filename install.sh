#!/bin/bash



function install_app() {
    sudo $1 install -y $2
    if [ $? -ne 0 ]; then
        echo "$1 install $2 failed"
        exit 1
    fi
}

function install() {
    echo $OS
    if [ "$OS" == "Fedora" ]; then
        install_app dnf $1
    elif [ "$OS" == "Ubuntu" ]; then
        install_app apt $1
    elif [ "$OS" == "CentOS" ]; then
        install_app yum $1
    elif [ "$OS" == "Debian" ]; then
        install_app apt $1
    elif [ "$OS" == "OpenSUSE" ]; then
        install_app zypper $1
    elif [ "$OS" == "RedHat" ]; then
        install_app yum $1
    else
        echo "$1 installation failed for unknown OS"
        exit 1
    fi
    echo "$1 installed successfully"

}

function check_kitty() {
    if [ -x "$(command -v kitty)" ]; then
        echo "Kitty is installed"
    else
        echo "Kitty is not installed, now install it ......"
        install kitty
    fi
}

function wget_download() {
    if [ -f "$HOME/.local/share/fonts/$2" ]; then
        echo "$2 is installed in $HOME/.local/share/fonts"
    else
        echo "$2 is not installed, now install it ......"
        wget -O "$HOME/.local/share/fonts/$2" $1
        if [ $? -ne 0 ]; then
            echo "Failed to download Fira Code Medium Nerd Font Complete Mono Windows Compatible.ttf"
            exit 1
        fi
        echo "Download $2 successfully"
    fi
}

function install_fonts() {
    wget_download 'https://github.com/ryanoasis/nerd-fonts/blob/master/patched-fonts/FiraCode/Medium/complete/Fira%20Code%20Medium%20Nerd%20Font%20Complete%20Mono%20Windows%20Compatible.ttf' 'Fira Code Medium Nerd Font Complete Mono Windows Compatible.ttf'
    wget_download 'https://github.com/ryanoasis/nerd-fonts/blob/master/patched-fonts/FiraCode/Medium/complete/Fira%20Code%20Medium%20Nerd%20Font%20Complete%20Mono.ttf' 'Fira Code Medium Nerd Font Complete Mono.ttf'
    wget_download 'https://github.com/ryanoasis/nerd-fonts/blob/master/patched-fonts/FiraCode/Medium/complete/Fira%20Code%20Medium%20Nerd%20Font%20Complete%20Windows%20Compatible.ttf' 'Fira Code Medium Nerd Font Complete Windows Compatible.ttf'
    wget_download 'https://github.com/ryanoasis/nerd-fonts/blob/master/patched-fonts/FiraCode/Medium/complete/Fira%20Code%20Medium%20Nerd%20Font%20Complete.ttf' 'Fira Code Medium Nerd Font Complete.ttf'
}

function check_fonts() {
    if [ -d "$HOME/.local/share/fonts" ]; then
        echo "Fonts directory is exist"
    else
        echo "Fonts directory is not exist, now create it"
        mkdir -p $HOME/.local/share/fonts
        if [ $? -ne 0 ]; then
            echo "Create fonts directory failed"
            exit 1
        fi
        echo "Fonts directory created successfully in $HOME/.local/share/fonts"
    fi
}

function config() {
    check_kitty
    if [ ! -d $HOME/.config/kitty ]; then
        echo "Kitty config file not exists, now create it ......"
        mkdir -p $HOME/.config/kitty
    fi
    if [ -f $HOME/.config/kitty/kitty.conf ]; then
        echo "Kitty config file already exists, will backup it to kitty.conf.bak"
        mv $HOME/.config/kitty/kitty.conf $HOME/.config/kitty/kitty.conf.bak
    fi
    if [ -f $HOME/.config/kitty/current-theme.conf ]; then
        echo "Kitty theme config file already exists, will backup it to current-theme.conf.bak"
        mv $HOME/.config/kitty/current-theme.conf $HOME/.config/kitty/current-theme.conf.bak
    fi
    cp current-theme.conf ~/.config/kitty/current-theme.conf
    if [ $? -ne 0 ]; then
        echo "Kitty theme config file copy failed"
        exit 1
    fi
    echo "Kitty theme config file created successfully in $HOME/.config/kitty/current-theme.conf"
    cp kitty.conf ~/.config/kitty/kitty.conf
    if [ $? -ne 0 ]; then
        echo "Kitty config file copy failed"
        exit 1
    fi
    echo "Kitty config file created successfully in $HOME/.config/kitty/kitty.conf"
    check_fonts
    install_fonts
    echo "Kitty fonts config successfully"
}

function tips() {
    echo "Configuration: Kitty config successfully"
    echo "Please restart your terminal"
    echo "Tips:"
    echo "=============================="
    echo "If you want to change the theme, please run the following command:"
    echo "kitty +kitten themes"
    echo "=============================="
    echo "If you want to list the supporting fonts, please run the following command:"
    echo "kitty +list-fonts"
    echo "=============================="
    echo "If you want to set kitty config, please run the following command:"
    echo "vim ~/.config/kitty/kitty.conf"
    echo "after that, please restart your terminal"
    echo "=============================="
    echo "Enjoy it"
}

main() {
    if [ ! -x "$(command -v lsb_release)" ]; then
        echo "lsb_release is not installed, please install it first"
        exit 1
    fi
    OS=`lsb_release -si`
    if [ ! -x "$(command -v wget)" ]; then
        echo "wget is not installed, now install it ......"
        install wget
    fi
    config
    tips
}

main $@
