#!/bin/bash

# Skript pingt Slaves an und betaetigt Reset 
# wenn Slave nicht erreichbar

sleep 60

while true
do

while read HOST
do
  COUNT=$(ping -c 5 $HOST | grep 'received' | awk -F',' '{ print $2 }' | awk '{print $1}')
  if [ $COUNT -eq 0 ]; then
    echo "Host: "$HOST "ist ausgefallen! Datum: $(date)" >> ~/Logs/PingLog.txt
    echo "Host: "$HOST "wurde neu gestartet! Datum: $(date)" >> ~/Logs/PingLog.txt

    SLAVENO=$(echo "$HOST" | awk -F'-' '{ print $2}')
   
    if (( $SLAVENO % 2 ==  1 )); then
    	ssh -n Slave-$(( $SLAVENO + 1 )) "echo "1" >/sys/class/gpio/gpio2/value"
    	sleep 0.01
    	ssh -n Slave-$(( $SLAVENO + 1 )) "echo "0" >/sys/class/gpio/gpio2/value"
    
    else 
    	ssh -n Slave-$(( $SLAVENO - 1 )) "echo "1" >/sys/class/gpio/gpio2/value"
    	sleep 0.01
    	ssh -n Slave-$(( $SLAVENO - 1 )) "echo "0" >/sys/class/gpio/gpio2/value"
    fi
  fi
done < Slaves.txt
sleep 120
done
