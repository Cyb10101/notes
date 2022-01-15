FROM roundcube/roundcubemail:latest

RUN set -ex; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
        git zip unzip p7zip p7zip-full \
    ; \
    \
    curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer; \
    mv /usr/src/roundcubemail/composer.json-dist /usr/src/roundcubemail/composer.json; \
    \
    composer --working-dir=/usr/src/roundcubemail/ --no-interaction \
        config allow-plugins.roundcube/plugin-installer 1; \
    composer --working-dir=/usr/src/roundcubemail/ --no-interaction \
        --prefer-dist --prefer-stable \
        --optimize-autoloader --apcu-autoloader \
        require \
            roundcube/carddav \
    ;
