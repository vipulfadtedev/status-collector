#!/bin/bash

temp=`vcgencmd measure_temp | cut -d '=' -f2 | cut -d "'" -f1`
timestamp=`echo $(($(date +%s%N)/1000000))`
curl --location --request POST 'http://10.0.0.7:5000/stats' \
 --header 'Content-Type: application/json' \
 --data-raw '{"host": "'$(hostname)'", "timestamp": '$timestamp',"counter": "temp", "value": "'$temp'"}'

