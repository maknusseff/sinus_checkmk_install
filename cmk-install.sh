#!/bin/bash

function offline_installation {

    echo Check if local installer is available...

    find check-mk-raw-*.deb > temp.txt
    cmk=$(cat temp.txt)

    if [ -z "$cmk" ]; then
        echo No local installer found! Continue with online installation
        online_installation
    fi
    
    echo Local installer found!
    
    checkmk_installation

}


function online_installation {

    apt update && apt dist-upgrade -y

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

    cat /etc/lsb-release > temp.txt
    uv=$(grep -i "CODENAME" temp.txt)
    uversion=${uv#*CODENAME=}

    wget https://download.checkmk.com/checkmk/"$cversion"/check-mk-raw-"$cversion"_0."$uversion"_amd64.deb

    checkmk_installation

}

function checkmk_installation {

    cat /etc/lsb-release > temp.txt
    uv=$(grep -i "CODENAME" temp.txt)
    uversion=${uv#*CODENAME=}

    apt install ./check-mk-raw-*"$uversion"_amd64.deb -y

    read -p "Enter site name: " sitename

    omd create $sitename > temp.txt
    grep -i "The admin user for the" temp.txt > login
    a=$(cat login)
    b=${a#*d: }
    echo $b > cmkadmin
    rm temp.txt
    rm login

    omd start $sitename
    echo Your site "$sitename" was created successfully! Your cmkadmin password is "$b". Continue on http://IP-ADDRESS/"$sitename"

    exit 0
}

offline_installation
