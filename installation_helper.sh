#!/bin/bash 

#set rights before running chmod a+x <path>/<name>         
#FONT STYLE:=> 00=none 01=bold 04=underscore 05=blink 07=reverse 08=concealed 
#FONT COLORS:=> 30=black 31=red 32=green 33=yellow 34=blue 35=magenta 36=cyan 37=white
#BACKGROUND COLORS:=> 40=black 41=red 42=green 43=yellow 44=blue 45=magenta 46=cyan 47=white

function message_notice {
  echo -e "\e[0;33m $1 \e[0m" 
} 

function action_required_notice {
  echo -e "\e[1;33m $1 \e[0m" 
}

function message_info {
  echo -e "\e[01;34m $1 \e[0m" 
}

function message_alert {
  echo -e "\e[0;31m $1 \e[0m" 
}

function message_success {
  echo -e "\e[0;31m $1 \e[0m" 
}

function message_question {
  echo -e "\e[0;35m $1 \e[0m" 
}

function install_app {
  message_question "install "$1"? ("$2")" 
  read PROCEED
  if [ "$PROCEED" = "Y" ]; then
    message_info "proceed with installation of "$1"..."	
    RES=1;
  else 
    if [ "$PROCEED" = "I" ]; then
      RES=2
    else
      RES=0;
    fi 
  fi
}

function remove_app {
  message_question "remove "$1"? ("$2")"
  read PROCEES
  if [ "$PROCEED" = "Y" ]; then
    message_info "proceed with removal of "$1"..."	
    RES=1;
  else 
    if [ "$PROCEED" = "I" ]; then
      RES=2
    else
      RES=0;
    fi
  fi
}

message_info "INSTALLATION HELPER"
message_info "Author: Marcel Wijnen"
message_info "Date: Summer 2012"

#Apache2
install_app "APACHE2" "Y/N"
if [ $RES = 1 ]; then
  sudo apt-get install apache2
fi

#Ruby version manager
install_app "RVM" "Y/N"
if [ "$RES" = 1 ]; then
  curl -L get.rvm.io | bash -s stable
  source /home/tiny/.rvm/scripts/rvm
fi

#Build essential
install_app "BUILD-ESSENTIAL" "Y/N"
if [ "$RES" = 1 ]; then
  sudo apt-get install build-essential openssl libreadline6 libreadline6-dev curl git-core zlib1g zlib1g-dev libssl-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt-dev autoconf libc6-dev ncurses-dev automake libtool bison subversion
fi

#MongoDB
install_app "MONGODB" "I/N"
if [ "$RES" = 2 ]; then 
  message_notice "This installation is performed according to: http://brilliantcorners.org/2010/12/a-better-way-to-install-mongodb/"
  action_required_notice "ADD: deb http://downloads.mongodb.org/distros/ubuntu 10.10 10gen TO: /etc/apt/sources.list" 
  message_notice "ONLY proceed after this has been done!"
  install_app "MONGODB" "Y/N"
  if [ "$RES" = 1 ]; then
    sudo apt-key adv --keyserver keyserver.ubuntu.com --recv 7F0CEB10
    sudo apt-get update
    sudo apt-get install mongodb-stable
    sudo apt-get install mongodb-server
    message_notice "Note that MONGODB is running directly after the installation has been performed... In order to close MONGODB perform the following:"
    message_notice "$ mongo"
    message_notice "> use admin"
    message_notice "> db.shutdownServer()"
    action_required_notice "ADD DIRECTORY: sudo mkdir /data/db"
    action_required_notice "SET RIGHTS: sudo chown `id -u` /data/db "
  fi  
fi

#Rubies
install_app "RUBIES" "Y/N"
if [ "$RES" = 1 ]; then
  rvm install ruby-1.8.7-head 
  rvm install ruby-1.9.3
  rvm install ruby-1.9.3-head
fi

#Node.js
install_app "NODE.JS" "Y/N"
if [ "$RES" = 1 ]; then
  message_notice "Node.js is needed in order for RoR applications to work with javascript. This installation is according to: https://github.com/joyent/node/wiki/Installing-Node.js-via-package-manager"
  sudo apt-get install python-software-properties
  sudo apt-add-repository ppa:chris-lea/node.js
  sudo apt-get update
  sudo apt-get install nodejs npm
fi

#Phussion passenger
install_app "PHUSSION-PASSENGER" "I/N"
if [ "$RES" = 2 ]; then
  message_notice "It is important to use Phussion Passenger correctly in combination with RVM. This installation is according to: http://blog.phusion.nl/2010/09/21/phusion-passenger-running-multiple-ruby-versions/"
  action_required_notice "RUN: rvm --default use 1.9.3-head"
  action_required_notice "RUN: rvm gemset create rails323"
  action_required_notice "RUN: rvm --default use 1.9.3-head@rails232"
  action_required_notice "RUN: gem install passenger"
  action_required_notice "RUN: passenger-install-apache2-module"
fi

#Rails
install_app "RAILS" "I/N"
if [ "$RES" = 2 ]; then
  action_required_notice "rvm all do gem install rails -v 3.2.3"
fi

#GitHub
install_app "GIT-HUB" "Y/N"
if [ "$RES" = 1 ]; then
  git config --global user.name "Marcel"
  git config --global user.email mmfwwijnen@gmail.com
  git config --global alias.co checkout
fi

#ImageMagic
install_app "IMAGE-MAGIC" "I/N"
if [ "$RES" = 2 ]; then
  action_required_notice "sudo apt-get update"
  action_required_notice "sudo apt-get install imagemagick --fix-missing"
fi

#ZeroMQ
install_app "ZEROMQ" "Y/N"
if [ "$RES" = 1 ]; then
  message_notice "Install required packages for installation"
  sudo apt-get install libtool autoconf automake
  message_notice "Install required packages for installation"
  sudo apt-get install uuid-dev uuid e2fsprogs
  action_required_notice "Install the source code from github"
  action_required_notice "RUN: git clone git@github.com:zeromq/zeromq2-x.git"
  message_notice "cd into the directory in which zeromq source code is downloaded"
  message_notice "RUN: ./autogen.sh"
  message_notice "RUN: ./configure"
  message_notice "RUN: make"
  message_notice "To install system wide. RUN: sudo make install"
  message_notice "RUN: sudo ldconfig" 
fi

#NGINX
install_app "NGINX" "Y/N"
if [ "$RES" = 1 ]; then
  sudo apt-get install nginx
fi

#AUTO-REMOVE-UNNEEDED_PACKAGES
remove_app "UNREQUIRED-PACKAGES" "Y/N"
if [ "$RES" = 1 ]; then
  sudo apt-get autoremove 
fi

