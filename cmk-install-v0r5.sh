#!/bin/bash

Black='\033[0;30m'        # Black
Red='\033[0;31m'          # Red
Green='\033[0;32m'        # Green
Yellow='\033[0;33m'       # Yellow
Blue='\033[0;34m'         # Blue
Purple='\033[0;35m'       # Purple
Cyan='\033[0;36m'         # Cyan
White='\033[0;37m'        # White

echo
echo -e "${Yellow}                                :::::::::                                                           "
echo -e "${Yellow}                             :::::::::::::::                                                        "
echo -e "${Yellow}                           ::::::::  :::::::::                                                      "
echo -e "${Yellow}                         :::::::         ::::::                                                     "
echo -e "${Yellow}                        ::::::             ::::::                                                   "
echo -e "${Yellow}                       :::::                ::::::                                                  "
echo -e "${Yellow}                      :::::                  ::::::                                                 "
echo -e "${Yellow}                     :::::                     :::::                                                "
echo -e "${Yellow}                    :::::                       :::::                                               "
echo -e "${Yellow}                                                                                                    "
echo -e "${Green}     ++++++        ++++++   ++++++  +++++       +++++      ++++++       +++++++         ${Yellow}        :::::"
echo -e "${Green}  +++++++++++++    ++++++   ++++++++++++++++    +++++      ++++++    +++++++++++++      ${Yellow}       ::::: "
echo -e "${Green} +++++    ++++++   ++++++   ++++++++ +++++++    +++++      ++++++   ++++++   ++++++     ${Yellow}      :::::  "
echo -e "${Green} +++++     +++++   ++++++   ++++++      +++++   +++++      ++++++   +++++     +++++     ${Yellow}      :::::  "
echo -e "${Green} ++++++++          ++++++   ++++++      +++++   +++++      ++++++   +++++++++           ${Yellow}     :::::   "
echo -e "${Green}   +++++++++++     ++++++   ++++++      +++++   +++++      ++++++     ++++++++++++      ${Yellow}   :::::    "
echo -e "${Green}        ++++++++   ++++++   ++++++      +++++   +++++      ++++++          ++++++++     ${Yellow}  :::::     "
echo -e "${Green}+++++      +++++   ++++++   ++++++      +++++   +++++      ++++++  +++++      +++++     ${Yellow} :::::      "
echo -e "${Green} +++++    ++++++   ++++++   ++++++      +++++    ++++++++++++++++   ++++++   ++++++     ${Yellow}:::::       "
echo -e "${Green}  +++++++++++++    ++++++   ++++++      +++++     +++++++++++++++    +++++++++++++     ${Yellow}::::::       "
echo -e "${Green}      +++++                                         +++++                +++++        ${Yellow}::::::        "
echo -e "${Yellow}                                                                                     ::::::         "
echo -e "${Yellow}:: :        :          :   :        :        :        :     :::::                   ::::::          "
echo -e "${Yellow}: :: :: :   : ::  ::   : : : :::: : : ::: :  : : : : :::     ::::::                ::::::           "
echo -e "${Yellow}:  : : : :: : ::  : :: : : : :: : : :: :: :: : : : : :: ::    ::::::              :::::             "
echo -e "${Yellow}                                                               :::::::          ::::::              "
echo -e "${Yellow}                                                                 :::::::::::::::::::                "
echo -e "${Yellow}                                                                   :::::::::::::::                  "
echo -e "${Yellow}                                                                      :::::::::                     "
echo
echo -e '\033[0m'

echo Arbeit Arbeit!

echo +++++++++++++++++++++++++++++++
sleep 0.5
echo Sinus Checkmk Installation Tool
sleep 0.5
echo +++++++++++++++++++++++++++++++
sleep 5

set_timezone_localtime() {
    sudo ln -sf /usr/share/zoneinfo/Europe/Berlin /etc/localtime
    echo "Zeitzone wurde auf Berlin eingestellt."
}

set_timezone_localtime

function check_ubuntu_version {
    cat /etc/lsb-release > temp.txt
    uv=$(grep -i "CODENAME" temp.txt)
    uversion=${uv#*CODENAME=}
}

function offline_installation {

    check_ubuntu_version

    echo Prüfung auf lokale Installationsdatei...

    find check-mk-raw-*.deb > temp.txt
    cmk=$(cat temp.txt)

    if [ -z "$cmk" ] || [[ "$cmk" != *"$uversion"* ]]; then
        echo "Keine lokale Installationsdatei gefunden! Online Installation wird in 3 Sekunden gestartet!"

        echo 3
        sleep 1
        echo 2
        sleep 1
        echo 1
        sleep 1

        online_installation
    fi
    
    echo "Lokale Installationsdatei gefunden! Installation wird in 3 Sekunden gestartet"
    
    echo 3
    sleep 1
    echo 2
    sleep 1
    echo 1
    sleep 1
    
    checkmk_installation

}

function online_installation {

    apt update && apt dist-upgrade -y
	apt-get install gdebi-core -y
	apt-get install chrony -y
	apt-get install snmpd -y
	apt-get install smstools -y
	apt-get install postfix libsasl2-modules bsd-mailx -y
			
    check_ubuntu_version

    ubu18="bionic"
    ubu20="focal"
    ubu22="jammy"
    ubu24="noble"

    if [ $uversion = $ubu18 ]; then
        PS3="Select Checkmk Version: "

        select cv in 2.1.0p47 2.0.0p39 Quit
        do
            case $cv in
                "2.1.0p47")
                    cversion="2.1.0p47"
                    break;;
                "2.0.0p39")
                    cversion="2.0.0p39"
                    break;;
                "Quit")
                    exit 0;;
                *)
                    echo "Error";;
            esac
        done
    
    elif [ $uversion = $ubu20 ]; then
        PS3="Select Checkmk Version: "

        select cv in 2.3.0p16 2.2.0p34 2.1.0p47 2.0.0p39 Quit
        do
            case $cv in
                "2.3.0p16")
                    cversion="2.3.0p16"
                    break;;
                "2.2.0p34")
                    cversion="2.2.0p34"
                    break;;
                "2.1.0p47")
                    cversion="2.1.0p47"
                    break;;
                "2.0.0p39")
                    cversion="2.0.0p39"
                    break;;
                "Quit")
                    exit 0;;
                *)
                    echo "Error";;
            esac
        done

    elif [ $uversion = $ubu22 ]; then
        PS3="Select Checkmk Version: "

        select cv in 2.3.0p16 2.2.0p34 2.1.0p47 2.0.0p39 Quit
        do
            case $cv in
                "2.3.0p16")
                    cversion="2.3.0p16"
                    break;;
                "2.2.0p34")
                    cversion="2.2.0p34"
                    break;;
                "2.1.0p47")
                    cversion="2.1.0p47"
                    break;;
                "2.0.0p39")
                    cversion="2.0.0p39"
                    break;;
                "Quit")
                    exit 0;;
                *)
                    echo "Error";;
            esac
        done

    elif [ $uversion = $ubu24 ]; then
        PS3="Select Checkmk Version: "

        select cv in 2.3.0p16 2.2.0p34 Quit
        do
            case $cv in
                "2.3.0p16")
                    cversion="2.3.0p16"
                    break;;
                "2.2.0p34")
                    cversion="2.2.0p34"
                    break;;
                "Quit")
                    exit 0;;
                *)
                    echo "Error";;
            esac
        done

    fi

    wget https://download.checkmk.com/checkmk/"$cversion"/check-mk-raw-"$cversion"_0."$uversion"_amd64.deb

    checkmk_installation

}

function checkmk_installation {

    check_ubuntu_version

    apt install ./check-mk-raw-*"$uversion"_amd64.deb -y

    read -p "Enter site name: " sitename

    omd create $sitename > temp.txt
    grep -i "The admin user for the" temp.txt > login
    a=$(cat login)
    b=${a#*d: }
    echo $b > cmkadmin
    rm temp.txt
    rm login

    if [ $cversion = "2.3.0p16" ] || [ $cversion = "2.2.0p34" ]; then
        echo "multisite_users.update({'cmkadmin': {'alias': 'cmkadmin', 'roles': ['admin'], 'locked': False, 'connector': 'htpasswd'}, 'automation': {'alias': 'Check_MK Automation - used for calling web services', 'automation_secret': '1ltxUYifNgyjsyqxOwClm5NE', 'roles': ['admin'], 'locked': False, 'language': 'en', 'connector': 'htpasswd'}, 'agent_registration': {'alias': 'Check_MK Agent Registration - used for agent registration', 'automation_secret': 'UC3k9XNHojE3s2aKt04vCgLP', 'roles': ['agent_registration'], 'locked': False, 'language': 'en', 'connector': 'htpasswd'}, 'sinus': {'alias': 'sinus', 'roles': ['admin', 'agent_registration'], 'locked': False, 'connector': 'htpasswd'}})" > /omd/sites/$sitename/etc/check_mk/multisite.d/wato/users.mk
        echo "sinus:\$2a\$12\$Op8X/ETAzsaQEUi/gQ/R7ezjqwc9eg.qtSz/RmZND.GPDpivIHOwe" >> /omd/sites/$sitename/etc/htpasswd
    elif [ $cversion = "2.1.0p47" ]; then
        echo "multisite_users.update({'cmkadmin': {'alias': 'cmkadmin', 'roles': ['admin'], 'locked': False, 'connector': 'htpasswd'}, 'automation': {'alias': 'Check_MK Automation - used for calling web services', 'automation_secret': '1ltxUYifNgyjsyqxOwClm5NE', 'roles': ['admin'], 'locked': False, 'language': 'en', 'connector': 'htpasswd'}, 'sinus': {'alias': 'sinus', 'roles': ['admin'], 'locked': False, 'connector': 'htpasswd'}})" > /omd/sites/$sitename/etc/check_mk/multisite.d/wato/users.mk
        echo "sinus:\$2a\$12\$Op8X/ETAzsaQEUi/gQ/R7ezjqwc9eg.qtSz/RmZND.GPDpivIHOwe" >> /omd/sites/$sitename/etc/htpasswd
    else
        echo "multisite_users.update({'cmkadmin': {'alias': 'cmkadmin', 'roles': ['admin'], 'locked': False}, 'automation': {'alias': 'Check_MK Automation - used for calling web services', 'automation_secret': '374b3114-0a71-4802-b196-883ccc1e3ea8', 'roles': ['admin'], 'locked': False, 'language': 'en'}, 'sinus': {'alias': 'sinus', 'locked': False, 'roles': ['admin'], 'force_authuser': False, 'nav_hide_icons_title': None, 'icons_per_item': None, 'show_mode': None}})" > /omd/sites/$sitename/etc/check_mk/multisite.d/wato/users.mk
        echo "sinus:\$5\$rounds=535000\$AehGbw.zn3eI9G0j\$NR6oqOq1rBQOZiZMmegvwDiZdh5N5hru9eT4et.xjz5" >> /omd/sites/$sitename/etc/htpasswd
    fi
    
    #echo "multisite_users.update({'cmkadmin': {'alias': 'cmkadmin', 'roles': ['admin'], 'locked': False, 'connector': 'htpasswd'}, 'automation': {'alias': 'Check_MK Automation - used for calling web services', 'automation_secret': '1ltxUYifNgyjsyqxOwClm5NE', 'roles': ['admin'], 'locked': False, 'language': 'en', 'connector': 'htpasswd'}, 'agent_registration': {'alias': 'Check_MK Agent Registration - used for agent registration', 'automation_secret': 'UC3k9XNHojE3s2aKt04vCgLP', 'roles': ['agent_registration'], 'locked': False, 'language': 'en', 'connector': 'htpasswd'}, 'sinus': {'alias': 'sinus', 'roles': ['admin', 'agent_registration'], 'locked': False, 'connector': 'htpasswd'}})" > /omd/sites/$sitename/etc/check_mk/multisite.d/wato/users.mk
    #echo "sinus:\$2a\$12\$Op8X/ETAzsaQEUi/gQ/R7ezjqwc9eg.qtSz/RmZND.GPDpivIHOwe" >> /omd/sites/$sitename/etc/htpasswd

    omd start $sitename 

    echo Die Seite "$sitename" wurde erfolgreich erstellt! Bitte Browser starten und Link http://IP-ADDRESS/"$sitename" öffnen!
	
	echo Arbeit ist vollbracht!

    exit 0
}

offline_installation
