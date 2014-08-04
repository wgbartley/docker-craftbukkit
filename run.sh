#!/bin/bash

sudo docker run -d -t -i -p 5190:25565 -v `pwd`/data:/opt/minecraft/data --name=craftbukkit1 minecraft/craftbukkit
