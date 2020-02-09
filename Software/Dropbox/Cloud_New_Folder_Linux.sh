#!/bin/sh

vDate=`date +%Y-%m-%d`
vTime=`date +%H:%M:%S`
mkdir ${vDate}" New_Folder"
cd ${vDate}" New_Folder"

touch "0 user1 ["${vDate}"]"
touch "0 user2 ["${vDate}"]"
touch "0 user3 ["${vDate}"]"
