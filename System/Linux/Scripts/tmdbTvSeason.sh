#!/bin/bash

getTmdbSeason() {
    local tvId=${1}
    local season=${2}
    local language=${3}

    appendCurl=''
    if [[ "${language}" != "" ]]; then
        appendCurl="language=${language}"
    fi
    if [[ "${appendCurl}" != "" ]]; then
        appendCurl="?${appendCurl}"
    fi

    if [[ "${language}" == "" ]]; then
        echo -e "\033[0;32m# English\033[0m"
    elif [[ "${language}" != "" ]]; then
        echo -e "\033[0;32m# German\033[0m"
    fi

    percent='Prozent'
    if [[ "${language}" == "de-DE" ]]; then
        percent='Prozent'
    fi

    curl -H "Accept: application/json" -H "Authorization: Bearer ${tmdb_apiKeyV4}" \
        -fsSL "https://api.themoviedb.org/3/tv/${tvId}/season/${season}${appendCurl}" | \
        jq -r --arg season ${season} '.episodes[] | "s\($season | lpad(2))e\(.episode_number | lpad(2)) \(.name)"' | \
        sed "s/[\?]//g; s/–/-/g; s/’//g; s/:/ -/g; s/%/${percent}/g"

    echo
}

tmdb_apiKeyV4=`jq -r '.tmdb_apiKeyV4' ~/Sync/private-notes/storage/api-keys.json`

# getTmdbSeason ${tvId} ${season} "${language}"
getTmdbSeason ${1} ${2} ''
getTmdbSeason ${1} ${2} 'de-DE'
