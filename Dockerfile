###########################################################
# Dockerfile that builds a kf2 Gameserver
###########################################################
FROM cm2network/steamcmd:root as build_stage

ENV STEAMAPPID 232130
ENV STEAMAPP kf2
ENV STEAMAPPDIR "${HOMEDIR}/${STEAMAPP}-dedicated"
RUN mkdir -p "${STEAMAPPDIR}"

COPY etc/entry.sh "${HOMEDIR}/entry.sh"
COPY etc/kf2_start.sh "${STEAMAPPDIR}"

RUN set -x \
        # Install, update & upgrade packages
        && apt-get update \
        && apt-get install -y --no-install-recommends --no-install-suggests \
                wget=1.21-1+deb11u1 \
                ca-certificates=20210119 \
                lib32z1=1:1.2.11.dfsg-2+deb11u2 \
        # Add entry script
        && { \
                echo '@ShutdownOnFailedCommand 1'; \
                echo '@NoPromptForPassword 1'; \
                echo 'force_install_dir '"${STEAMAPPDIR}"''; \
                echo 'login anonymous'; \
                echo 'app_update '"${STEAMAPPID}"''; \
                echo 'quit'; \
           } > "${HOMEDIR}/${STEAMAPP}_update.txt" \
        && chmod +x "${HOMEDIR}/entry.sh" \
        && chown -R "${USER}:${USER}" "${HOMEDIR}/entry.sh" "${STEAMAPPDIR}" "${HOMEDIR}/${STEAMAPP}_update.txt" \
        # Clean up
        && rm -rf /var/lib/apt/lists/*

FROM build_stage AS bullseye-base

# Switch to user
USER steam
WORKDIR ${HOMEDIR}

CMD ["bash", "entry.sh"]

# Expose ports
EXPOSE 7777/udp \
        27015/udp \
        8080/tcp
