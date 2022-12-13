
FROM alpine:3.17
ARG MINEDMAP_VERSION=1.19.1

WORKDIR /home/minecraft
# Create a user/group, install dependencies, fetch sources
RUN adduser --disabled-password --uid 1000 minecraft && \
apk add --no-cache git cmake make clang gcc g++ pkgconfig zlib-dev libpng-dev && \
git clone --depth 1 --branch v${MINEDMAP_VERSION} https://github.com/NeoRaider/MinedMap.git /home/minecraft/minedmap-source

# Compile MinedMap
WORKDIR /home/minecraft/minedmap-build
RUN cmake ../minedmap-source -DCMAKE_BUILD_TYPE=RELEASE && \
make && \
# Move the binary to /usr/local/bin for convenience
mv /home/minecraft/minedmap-build/src/MinedMap /usr/local/bin/

WORKDIR /home/minecraft
RUN chown -R minecraft:minecraft /home/minecraft

# Install a webserver to serve the viewer
RUN apk add --no-cache caddy

USER minecraft

COPY entrypoint.sh /entrypoint.sh
CMD [ "/entrypoint.sh" ]

