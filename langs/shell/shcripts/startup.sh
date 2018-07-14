#! /usr/bin/env bash

IP=`ifconfig eth0 | grep "inet addr" | awk '{ print $2}' | awk -F: '{print $2}'`
PORT=12345

for i in {1..5}
do
    nohup node ./running/app.js --clientId="MS@${IP}:${PORT}-${i}" --ip="${IP}" --port="${PORT}${i}" > ./output.log 2>&1 &
done

ps -ef | grep -v grep | grep "./running/app.js" | awk '{print "kill " $2}' | sh

ps -ef | grep -v grep | grep "./running/app.js"
