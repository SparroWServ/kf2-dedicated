#!/bin/bash

# update server's data
/home/steam/steamcmd/steamcmd.sh \
    +force_install_dir /home/steam/kf2-dedicated \
    +login anonymous \
    +app_update 232130 \
    +exit

# start the server
/home/steam/kf2-dedicated/Binaries/Win64/KFGameSteamServer.bin.x86_64 'KF-BurningParis' -Port=7779 -QueryPort=27017 -WebAdminPort=8080

exit 0
