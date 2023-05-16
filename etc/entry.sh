#!/bin/bash

# update server's data
/home/steam/steamcmd/steamcmd.sh \
    +force_install_dir /home/steam/kf2-dedicated \
    +login anonymous \
     +app_update 232130 \
    +exit

# start the server
/home/steam/kf2-dedicated/Binaries/Win64/KFGameSteamServer.bin.x86_64 'KF-BurningParis'

exit 0
