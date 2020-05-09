#!/bin/bash 

PUBLIC_IP="$1"
PORT_CHECK="$2"

counter=0
set +x

until [ $counter -gt 2 ]
do
    echo "Trying to connect to server!!"
    ((counter++))
    
    if nc -zv "$PUBLIC_IP" "$PORT_CHECK" 2>/dev/null
    then 
        echo "The application is up and running!! :$PUBLIC_IP"
        break
    fi
    sleep 10
done


