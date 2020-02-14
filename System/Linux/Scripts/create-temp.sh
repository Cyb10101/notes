#!/usr/bin/env bash

VAR_DATE=`date +%F`
VAR_TIME=`date +%H-%M-%S`

# Variant 1 - Date and time
createTempDateTime() {
	VAR_FOLDER='/tmp/'${1}'_'${VAR_DATE}'_'${VAR_TIME}
	mkdir -p ${VAR_FOLDER}
}

# Variant 2 - Generated
createTempGenerated() {
	VAR_FOLDER=`mktemp -d /tmp/${1}_XXXXXXXX`
}

#createTempDateTime 'cyb'
createTempGenerated 'cyb'

chmod og+r ${VAR_FOLDER}
nautilus ${VAR_FOLDER} &
exit 0;
