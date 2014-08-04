#!/bin/bash

if [ ! -d "work" ]; then
	echo "Creating work/ directory"
	mkdir work
fi


# Determine latest version of Minecraft server
MINECRAFT_LATEST=$(basename `curl -s "https://minecraft.net/download" | grep -P -o 'https://s3.*?/minecraft_server.*?.jar' -`)
echo "Latest version of Minecraft server ==> $MINECRAFT_LATEST"

# Get latest version of Minecraft
if [ ! -f "work/$MINECRAFT_LATEST" ]; then
	echo "Getting latest version of Minecraft server"
	wget $(curl -s "https://minecraft.net/download" | grep -P -o 'https://s3.*?/minecraft_server.*?.jar' -) -O work/$MINECRAFT_LATEST
else
	echo "Already downloaded!"
fi


# Determine latest version of CraftBukkit server
CRAFTBUKKIT_LATEST=$(curl -s "http://dl.bukkit.org/downloads/craftbukkit/" | grep -P -o '/downloads/craftbukkit/get/.*?-dev.jar' - | head -n 1 | awk '{split($0,a,"/");print a[5]}')
echo "Latest version of CraftBukkit server ==> $CRAFTBUKKIT_LATEST"

# Get latest version of CraftBukkit
if [ ! -f "work/craftbukkit-${CRAFTBUKKIT_LATEST}-dev.jar" ]; then
	echo "Getting latest version of CraftBukkit server"
	wget "http://dl.bukkit.org/downloads/craftbukkit/get/${CRAFTBUKKIT_LATEST}/craftbukkit-dev.jar" -O "work/craftbukkit-${CRAFTBUKKIT_LATEST}-dev.jar"
else
	echo "Already downloaded!"
fi


# Generate run.sh
echo "Generating run.sh"
cat <<EOF > scripts/run.sh
#!/bin/bash
exec /usr/bin/java -Xmx1024M -Xms1024M -jar /opt/minecraft/bin/craftbukkit-${CRAFTBUKKIT_LATEST}-dev.jar nogui
EOF


# Create a data directory to share with the container
if [ ! -d "data" ]; then
	echo "Creating data/ directory"
	mkdir data
fi

# Agree to the EULA
if [ ! -f "data/eula.txt" ]; then
	echo "Agreeing to EULA"
	echo "eula=true" > data/eula.txt
fi


# Build the image
echo "Build the docker image"
sudo docker build -t minecraft/craftbukkit --rm=true .
