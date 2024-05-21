###########################################################
# Dockerfile that builds a KF2 Gameserver
###########################################################

# BUILD STAGE
FROM debian:bookworm-slim AS build_stage

LABEL maintainer="sparrow-server@outlook.com"
ENV HOMEDIR /home/steam
ENV USER steam
ENV STEAMCMDDIR "${HOMEDIR}/steamcmd"
ENV STEAMAPPID 232130
ENV STEAMAPP kf2
ENV STEAMAPPDIR "${HOMEDIR}/${STEAMAPP}-dedicated"
ARG PUID=1000


# Update OS, Get Requirements
RUN set -x \
	# Install, update & upgrade packages
	&& apt-get update \
	&& apt-get install -y --no-install-recommends --no-install-suggests \
		lib32stdc++6=12.2.0-14 \
		lib32gcc-s1=12.2.0-14 \
		ca-certificates=20230311 \
		nano=7.2-1 \
		curl=7.88.1-10+deb12u5 \
		locales=2.36-9+deb12u4 \
	&& sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen \
	&& dpkg-reconfigure --frontend=noninteractive locales \
	# Create unprivileged user
	&& useradd -u "${PUID}" -m "${USER}" \
	# Download SteamCMD, execute as user
	&& su "${USER}" -c \
		"mkdir -p \"${STEAMCMDDIR}\" \
                && curl -fsSL 'https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz' | tar xvzf - -C \"${STEAMCMDDIR}\" \
                && \"./${STEAMCMDDIR}/steamcmd.sh\" +quit \
                && ln -s \"${STEAMCMDDIR}/linux32/steamclient.so\" \"${STEAMCMDDIR}/steamservice.so\" \
                && mkdir -p \"${HOMEDIR}/.steam/sdk32\" \
                && ln -s \"${STEAMCMDDIR}/linux32/steamclient.so\" \"${HOMEDIR}/.steam/sdk32/steamclient.so\" \
                && ln -s \"${STEAMCMDDIR}/linux32/steamcmd\" \"${STEAMCMDDIR}/linux32/steam\" \
                && mkdir -p \"${HOMEDIR}/.steam/sdk64\" \
                && ln -s \"${STEAMCMDDIR}/linux64/steamclient.so\" \"${HOMEDIR}/.steam/sdk64/steamclient.so\" \
                && ln -s \"${STEAMCMDDIR}/linux64/steamcmd\" \"${STEAMCMDDIR}/linux64/steam\" \
                && ln -s \"${STEAMCMDDIR}/steamcmd.sh\" \"${STEAMCMDDIR}/steam.sh\"" \
	# Symlink steamclient.so; So misconfigured dedicated servers can find it
 	&& ln -s "${STEAMCMDDIR}/linux64/steamclient.so" "/usr/lib/x86_64-linux-gnu/steamclient.so" \
	&& rm -rf /var/lib/apt/lists/*

COPY etc/entry.sh "${HOMEDIR}/entry.sh"

# Switch to user
USER ${USER}

WORKDIR ${HOMEDIR}

CMD ["bash", "entry.sh"]

# Expose ports
EXPOSE 7779/udp \
	27017/udp \
	20560/udp \
    8080/tcp
