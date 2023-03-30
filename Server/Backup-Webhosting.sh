#!/bin/bash

# Useful for script
scriptPath="$(cd "$(dirname "${0}")" >/dev/null 2>&1; pwd -P)"

backupDatabase() {
    dbHost="${1}"
    dbUsername="${2}"
    dbPassword="${3}"
    dbDatabase="${4}"
    filename="${5}"
    if [ -z "${filename}" ]; then
        filename="${dbDatabase}"
    fi

    echo "Backup database '${filename}' ..."
    mysqldump --opt --skip-comments --host="${dbHost}" --user="${dbUsername}" --password="${dbPassword}" "${dbDatabase}" \
        | (echo "CREATE DATABASE IF NOT EXISTS \`${dbDatabase}\`;USE \`${dbDatabase}\`;" && cat) \
        > "${scriptPath}/$(date +%Y-%m-%d)_${filename}.sql"
}

backupFolder() {
    directory=$(dirname "${1}")
    filename=$(basename "${1}")

    echo "Backup folder '${filename}' ..."
    tar -C ${directory} -czf "${scriptPath}/$(date +%Y-%m-%d)_${filename}.tar.gz" ${filename}
}

# Start backup with:
# ssh server '/www/htdocs/user/0-backup/0-create.sh'
# Copy and delete backup with FileZilla: https://filezilla-project.org/

# website_www
# backupDatabase '127.0.0.1' 'USERNAME' 'PASSWORD' 'DATABASE' 'website_www'
# backupFolder '/www/htdocs/user/website_www'

# Script #######################################################################

# website_www
# backupDatabase '127.0.0.1' 'USERNAME' 'PASSWORD' 'DATABASE' 'website_www'
# backupFolder '/www/htdocs/user/website_www'
