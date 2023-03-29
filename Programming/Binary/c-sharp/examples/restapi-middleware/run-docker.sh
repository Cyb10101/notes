#!/usr/bin/env bash
echo 'Running docker script ...'

if [ ! -d /app/Microsoft.Net.Http* ]; then
    echo 'Installing package: Microsoft.Net.Http ...'
    nuget install Microsoft.Net.Http
fi
if [ ! -d /app/System.Web.Extensions* ]; then
    echo 'Installing package: System.Web.Extensions ...'
    nuget install System.Web.Extensions
fi
if [ ! -d /app/Newtonsoft.Json.13.0.2 ]; then
    echo 'Installing package: Newtonsoft.Json ...'
    nuget install Newtonsoft.Json -Version 13.0.2
fi

# sudo apt install mono-complete
find /app -iname '*.cs' | entr -r bash -c \
    "echo '[Entr] Compile and run ...'; \
    mcs -sdk:4.5 \
    -r:System.Net.Http \
    -r:System.Web.Extensions \
    -out:/app/restapi-middleware.exe /app/restapi-middleware.cs && mono /app/restapi-middleware.exe"

