#!/bin/bash

timestamp=`echo $(($(date +%s%N)/1000000))`

temp=`vcgencmd measure_temp | cut -d '=' -f2 | cut -d "'" -f1`
curl --location --request POST 'http://10.0.0.110:9090/stats' \
 --header 'Content-Type: application/json' \
 --data-raw '{"host": "'$(hostname)'", "timestamp": '$timestamp',"counter": "temp", "value": "'$temp'"}'


cpu=`top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1""}'`
curl --location --request POST 'http://10.0.0.110:9090/stats' \
 --header 'Content-Type: application/json' \
 --data-raw '{"host": "'$(hostname)'", "timestamp": '$timestamp',"counter": "cpu", "value": "'$cpu'"}'

memory=`free -t | awk 'NR == 2 {print $3/$2*100}'`
curl --location --request POST 'http://10.0.0.110:9090/stats' \
 --header 'Content-Type: application/json' \
 --data-raw '{"host": "'$(hostname)'", "timestamp": '$timestamp',"counter": "memory", "value": "'$memory'"}'

netDown=`ifstat -i eth0 -q 1 1 | awk 'NR==3 {print $1}'`
curl --location --request POST 'http://10.0.0.110:9090/stats' \
 --header 'Content-Type: application/json' \
 --data-raw '{"host": "'$(hostname)-down'", "timestamp": '$timestamp',"counter": "network", "value": "'$netDown'"}'

netUp=`ifstat -i eth0 -q 1 1 | awk 'NR==3 {print $2}'`
curl --location --request POST 'http://10.0.0.110:9090/stats' \
 --header 'Content-Type: application/json' \
 --data-raw '{"host": "'$(hostname)-up'", "timestamp": '$timestamp',"counter": "network", "value": "'$netUp'"}'
