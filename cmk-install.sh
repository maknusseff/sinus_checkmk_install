#!/bin/bash

function check_ubuntu_version {
    cat /etc/lsb-release > temp.txt
    uv=$(grep -i "CODENAME" temp.txt)
    uversion=${uv#*CODENAME=}
}

function offline_installation {

    check_ubuntu_version

    echo Check if local installer is available...

    find check-mk-raw-*.deb > temp.txt
    cmk=$(cat temp.txt)

    if [ -z "$cmk" ] || [[ "$cmk" != *"$uversion"* ]]; then
        echo "No local installer found! Continue with online installation in 3 seconds"
        sleep 3
        online_installation
    fi
    
    echo "Local installer found! Installation will start in 3 seconds"
    sleep 3
    
    checkmk_installation

}


function online_installation {

    apt update && apt dist-upgrade -y

    check_ubuntu_version

    ubu18="bionic"
    ubu20="focal"
    ubu22="jammy"
    ubu24="noble"

    if [ $uversion = $ubu18 ]; then
        PS3="Select Checkmk Version: "

        select cv in 2.1.0p46 2.0.0p39 Quit
        do
            case $cv in
                "2.1.0p46")
                    cversion="2.1.0p46"
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

        select cv in 2.3.0p13 2.2.0p32 2.1.0p46 2.0.0p39 Quit
        do
            case $cv in
                "2.3.0p13")
                    cversion="2.3.0p13"
                    break;;
                "2.2.0p32")
                    cversion="2.2.0p32"
                    break;;
                "2.1.0p46")
                    cversion="2.1.0p46"
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

        select cv in 2.3.0p13 2.2.0p32 2.1.0p46 2.0.0p39 Quit
        do
            case $cv in
                "2.3.0p13")
                    cversion="2.3.0p13"
                    break;;
                "2.2.0p32")
                    cversion="2.2.0p32"
                    break;;
                "2.1.0p46")
                    cversion="2.1.0p46"
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

        select cv in 2.3.0p13 2.2.0p32 Quit
        do
            case $cv in
                "2.3.0p13")
                    cversion="2.3.0p13"
                    break;;
                "2.2.0p32")
                    cversion="2.2.0p32"
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

    if [ $cversion = "2.3.0p13" ] || [ $cversion = "2.2.0p32" ]; then
        echo "multisite_users.update({'cmkadmin': {'alias': 'cmkadmin', 'roles': ['admin'], 'locked': False, 'connector': 'htpasswd'}, 'automation': {'alias': 'Check_MK Automation - used for calling web services', 'automation_secret': '1ltxUYifNgyjsyqxOwClm5NE', 'roles': ['admin'], 'locked': False, 'language': 'en', 'connector': 'htpasswd'}, 'agent_registration': {'alias': 'Check_MK Agent Registration - used for agent registration', 'automation_secret': 'UC3k9XNHojE3s2aKt04vCgLP', 'roles': ['agent_registration'], 'locked': False, 'language': 'en', 'connector': 'htpasswd'}, 'sinus': {'alias': 'sinus', 'roles': ['admin', 'agent_registration'], 'locked': False, 'connector': 'htpasswd'}})" > /omd/sites/$sitename/etc/check_mk/multisite.d/wato/users.mk
        echo "sinus:\$2a\$12\$Op8X/ETAzsaQEUi/gQ/R7ezjqwc9eg.qtSz/RmZND.GPDpivIHOwe" >> /omd/sites/$sitename/etc/htpasswd
    elif [ $cversion = "2.1.0p46" ]; then
        echo "multisite_users.update({'cmkadmin': {'alias': 'cmkadmin', 'roles': ['admin'], 'locked': False, 'connector': 'htpasswd'}, 'automation': {'alias': 'Check_MK Automation - used for calling web services', 'automation_secret': '1ltxUYifNgyjsyqxOwClm5NE', 'roles': ['admin'], 'locked': False, 'language': 'en', 'connector': 'htpasswd'}, 'sinus': {'alias': 'sinus', 'roles': ['admin'], 'locked': False, 'connector': 'htpasswd'}})" > /omd/sites/$sitename/etc/check_mk/multisite.d/wato/users.mk
        echo "sinus:\$2a\$12\$Op8X/ETAzsaQEUi/gQ/R7ezjqwc9eg.qtSz/RmZND.GPDpivIHOwe" >> /omd/sites/$sitename/etc/htpasswd
    else
        echo "multisite_users.update({'cmkadmin': {'alias': 'cmkadmin', 'roles': ['admin'], 'locked': False}, 'automation': {'alias': 'Check_MK Automation - used for calling web services', 'automation_secret': '374b3114-0a71-4802-b196-883ccc1e3ea8', 'roles': ['admin'], 'locked': False, 'language': 'en'}, 'sinus': {'alias': 'sinus', 'locked': False, 'roles': ['admin'], 'force_authuser': False, 'nav_hide_icons_title': None, 'icons_per_item': None, 'show_mode': None}})" > /omd/sites/$sitename/etc/check_mk/multisite.d/wato/users.mk
        echo "sinus:\$5\$rounds=535000\$AehGbw.zn3eI9G0j\$NR6oqOq1rBQOZiZMmegvwDiZdh5N5hru9eT4et.xjz5" >> /omd/sites/$sitename/etc/htpasswd
    fi
    
    #echo "multisite_users.update({'cmkadmin': {'alias': 'cmkadmin', 'roles': ['admin'], 'locked': False, 'connector': 'htpasswd'}, 'automation': {'alias': 'Check_MK Automation - used for calling web services', 'automation_secret': '1ltxUYifNgyjsyqxOwClm5NE', 'roles': ['admin'], 'locked': False, 'language': 'en', 'connector': 'htpasswd'}, 'agent_registration': {'alias': 'Check_MK Agent Registration - used for agent registration', 'automation_secret': 'UC3k9XNHojE3s2aKt04vCgLP', 'roles': ['agent_registration'], 'locked': False, 'language': 'en', 'connector': 'htpasswd'}, 'sinus': {'alias': 'sinus', 'roles': ['admin', 'agent_registration'], 'locked': False, 'connector': 'htpasswd'}})" > /omd/sites/$sitename/etc/check_mk/multisite.d/wato/users.mk
    #echo "sinus:\$2a\$12\$Op8X/ETAzsaQEUi/gQ/R7ezjqwc9eg.qtSz/RmZND.GPDpivIHOwe" >> /omd/sites/$sitename/etc/htpasswd

    omd start $sitename 

    echo Your site "$sitename" was created successfully! Continue on http://IP-ADDRESS/"$sitename"

    exit 0
}

offline_installation
#sinus:$5$rounds=535000$AehGbw.zn3eI9G0j$NR6oqOq1rBQOZiZMmegvwDiZdh5N5hru9eT4et.xjz5
#multisite_users.update({'cmkadmin': {'alias': 'cmkadmin', 'roles': ['admin'], 'locked': False}, 'automation': {'alias': 'Check_MK Automation - used for calling web services', 'automation_secret': '374b3114-0a71-4802-b196-883ccc1e3ea8', 'roles': ['admin'], 'locked': False, 'language': 'en'}, 'sinus': {'alias': 'sinus', 'locked': False, 'roles': ['admin'], 'force_authuser': False, 'nav_hide_icons_title': None, 'icons_per_item': None, 'show_mode': None}})
