#!/bin/bash

# Skript pingt Master an und betaetigt Reset 
# wenn Master nicht erreichbar

sleep 60

while true
do
  COUNT=$(ping -c 5 Master | grep 'received' | awk -F',' '{ print $2 }' | awk '{print $1}')
  if [ $COUNT -eq 0 ]; then
    echo "Host: Master ist ausgefallen! Datum: $(date)" >> ~/Logs/PingLog.txt
    echo "Host: Master wurde neu gestartet! Datum: $(date)" >> ~/Logs/PingLog.txt
    echo "1" >/sys/class/gpio/gpio2/value
    sleep 0.01
    echo "0" >/sys/class/gpio/gpio2/value
  fi
sleep 120
done
