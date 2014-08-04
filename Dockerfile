FROM ubuntu-base

RUN apt-get -y install openjdk-7-jre-headless supervisor

# Add scripts
ADD scripts/supervisord-craftbukkit.conf /etc/supervisor/conf.d/craftbukkit.conf
ADD scripts/start.sh /opt/minecraft/start.sh
ADD scripts/run.sh /opt/minecraft/run.sh
RUN chmod +x /opt/minecraft/start.sh /opt/minecraft/run.sh

# Add binaries
RUN mkdir -p /opt/minecraft/bin
ADD work/ /opt/minecraft/bin/

# Data persistence
VOLUME ["/opt/minecraft/data"]

# Change to this directory for CraftBukkit to store its files in
WORKDIR /opt/minecraft/data

# Expose the port
EXPOSE 25565

CMD ["/bin/bash", "/opt/minecraft/start.sh"]
