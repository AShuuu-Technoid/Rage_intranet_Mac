#!/bin/bash

apt="RageKiosk"

chk(){
    if [ -d "/Applications/$apt.app" ]; then
        rm -rf "/Applications/RageKiosk.app/"
        rm -rf "/Users/$usn/Library/Application Support/RageKiosk"

    fi

}

down_pack(){
	PASSWD=`cat RageKiosk/.encry.txt | openssl aes-256-cbc -a -d -salt -pass pass:Secret@123#`
	url="http://rgrage:$PASSWD@mobile.ragewip.com/ragekiosk/mac.zip"
	curl -O $url 2>&1
	unzip mac.zip >/dev/null 2>&1
}

namechg(){

	usn=$(ls -t /Users | awk 'NR==1 {print $1}')

	perl -pi -w -e "s/username=.*/username=$usn/g;" RageKiosk/loginInfo/userInformation.ini
	cp -rf RageKiosk "/Users/$usn/Library/Application Support/"
	chown -R $usn "/Users/$usn/Library/Application Support/RageKiosk"
	chmod 777 "/Users/$usn/Library/Application Support/RageKiosk/log"
}

inst(){
	hdiutil mount RageKiosk.dmg
	cp -rvf "/Volumes/RageKiosk/RageKiosk.app" /Applications/
}

remve(){
	hdiutil unmount "/Volumes/RageKiosk/"
	perl -pi -w -e "s/username=.*/username=/g;" RageKiosk/loginInfo/userInformation.ini
	SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
    rm -rf $SCRIPT_DIR
}

chk
down_pack
namechg
inst
remve
