FROM mono:latest
RUN apt-get update && apt-get -y install curl entr nuget && \
    useradd -s /bin/bash -d /home/app -m -c App app && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

EXPOSE 80
USER root
WORKDIR /app
CMD ["./run-docker.sh"]
