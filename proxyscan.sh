#!/bin/bash
# https://www.rmazzu.com/
# rmazzu 2021

# Scan IPs to get proxy socks/http
#
# USAGE: proxyscan.sh IP (Single IP or CIDR)
#


# Port to scan
PORT="8181,1080,8123,3128,9050,9051,32889,4145,59729,4153,47324,31050,3629,10801,35573,5678,43638,52666,34746,3629,8686,43153,61743,55583"

# User Agent for culr request
USER_AGENT="Mozilla/5.0 (Windows NT 6.1; WOW64; rv:54.0) Gecko/20100101 Firefox/54.0"

# Current Data
NOW=$(date +"%d-%m-%Y_%H-%M-%S")

# Validate IP
function valid_ip()
{
    local  ip=$1
    local  stat=1

    if [[ $ip =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
        OIFS=$IFS
        IFS='.'
        ip=($ip)
        IFS=$OIFS
        [[ ${ip[0]} -le 255 && ${ip[1]} -le 255 \
            && ${ip[2]} -le 255 && ${ip[3]} -le 255 ]]
        stat=$?
    fi
    return $stat
}


# Check if argument input is empty
if [ $# -lt 1 ];
then
        echo "Argomento mancante: IP"
	exit 0
fi

# Get IP from input for prefix files
ip=$(echo $1 | egrep -o '[0-9]{1,3}[.][0-9]{1,3}[.][0-9]{1,3}[.][0-9]{1,3}')
echo "Prefix File: $ip"

# Set filename
TEMP_FILE="${ip}_scanned.txt"
OUTPUT_FILE="${ip}_${NOW}_proxylist.txt"

# Check for another time if IP insert is valid
if valid_ip $ip;  then
	echo "IP Inserito: $ip"
else
	echo "IP non valido"
	exit 0
fi

#NOME=grep -Eo '[0-9]{1,3}[.][0-9]{1,3}[.][0-9]{1,3}[.][0-9]{1,3}' $1
#echo "Nome $NOME"

#scan with nmap
echo "Scanning $1 on port $PORT with Nmap.."
nmap -oG - -p$PORT $1 | awk '/^Host/ && /Ports/ { for (i=1;i<=NF;i++) { if (match($i,/open/)) { split($i,map,"/"); printf "%s:%s\n",$2,map[1] } } }'>$TEMP_FILE


#check if they work
while read line; do
        echo "Checking socks4: $line"
        res4=$(curl -s -m 15 -a $USER_AGENT -x socks4://$line https://api.ipify.org/)

	# Check if socks 4
        if [ -z "$res4" ];
        then
                echo "Checking socks5: $line"
                res5=$(curl -s -m 15 -a $USER_AGENT -x socks5://$line https://api.ipify.org/)

		# Check if socks 5
                if [ -z "$res5" ];
                then
			echo "Checking http: $line"
			respr=$(curl -s -m 15 -a $USER_AGENT -x $line https://api.ipify.org/)	
			
			# Check if http proxy
			if [ -n "$respr" ];
			then
				echo "http:$line" >>$OUTPUT_FILE
			fi
		else
                        echo "socks5:$line" >>$OUTPUT_FILE
                fi
        else
                echo "socks4:$line" >>$OUTPUT_FILE
        fi


done <$TEMP_FILE

# Print to screen result
if [ -f $OUTPUT_FILE ] 
then
	cat $OUTPUT_FILE
 
else
	echo "No Proxy Found!"
fi

#clean up the directory/files
rm $TEMP_FILE

