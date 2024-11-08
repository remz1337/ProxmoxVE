#!/usr/bin/env bash

# Copyright (c) 2021-2024 tteck
# Author: tteck (tteckster)
# Co-Author: remz1337
# License: MIT
# https://github.com/remz1337/ProxmoxVE/raw/remz/LICENSE

#Thanks to:
#https://github.com/initLab/authentik-bare-metal/blob/master/install.sh
#https://github.com/gtsatsis/authentik-bare-metal/commits/master/
#https://github.com/tteck/Proxmox/discussions/2952

source /dev/stdin <<<"$FUNCTIONS_FILE_PATH"
color
verb_ip6
catch_errors
setting_up_container
network_check
update_os

msg_info "Installing Dependencies (Patience)"
$STD apt-get install -y {curl,sudo,mc}
$STD apt-get install -y gpg pkg-config libffi-dev
$STD apt-get install -y --no-install-recommends build-essential libpq-dev libkrb5-dev
msg_ok "Installed Dependencies"

msg_info "Installing Python 3.12"
# apt-get install -y software-properties-common
# apt-get install -y python3-launchpadlib
# add-apt-repository -y ppa:deadsnakes/ppa
# apt-get update
# apt-get install python3.12
wget -qO- https://www.python.org/ftp/python/3.12.1/Python-3.12.1.tgz | tar -zxf -
cd Python-3.12.1
#./configure --enable-optimizations --prefix="$DOTLOCAL"
./configure --enable-optimizations
make altinstall
cd -
rm -rf Python-3.12.1
#ln -s "${BIN_DIR}/python3.12" "${BIN_DIR}/python3"
update-alternatives --install /usr/bin/python3 python3 /usr/local/bin/python3.12 1
msg_ok "Installed Python 3.12"


######################### NEEDS POSTGRES + REDIS!!!!!!



# # Stage 1: Build website
# FROM --platform=${BUILDPLATFORM} docker.io/library/node:22 AS website-builder

# ENV NODE_ENV=production

# WORKDIR /work/website

# RUN --mount=type=bind,target=/work/website/package.json,src=./website/package.json \
    # --mount=type=bind,target=/work/website/package-lock.json,src=./website/package-lock.json \
    # --mount=type=cache,id=npm-website,sharing=shared,target=/root/.npm \
    # npm ci --include=dev

# COPY ./website /work/website/
# COPY ./blueprints /work/blueprints/
# COPY ./schema.yml /work/
# COPY ./SECURITY.md /work/

# RUN npm run build-bundled

# Stage 2: Build webui
# FROM --platform=${BUILDPLATFORM} docker.io/library/node:22 AS web-builder

# ARG GIT_BUILD_HASH
# ENV GIT_BUILD_HASH=$GIT_BUILD_HASH
# ENV NODE_ENV=production

# WORKDIR /work/web

# RUN --mount=type=bind,target=/work/web/package.json,src=./web/package.json \
    # --mount=type=bind,target=/work/web/package-lock.json,src=./web/package-lock.json \
    # --mount=type=bind,target=/work/web/packages/sfe/package.json,src=./web/packages/sfe/package.json \
    # --mount=type=bind,target=/work/web/scripts,src=./web/scripts \
    # --mount=type=cache,id=npm-web,sharing=shared,target=/root/.npm \
    # npm ci --include=dev

# COPY ./package.json /work
# COPY ./web /work/web/
# COPY ./website /work/website/
# COPY ./gen-ts-api /work/web/node_modules/@goauthentik/api

# RUN npm run build

NODE_VER="22"
msg_info "Installing Node.js ${NODE_VER}"
mkdir -p /etc/apt/keyrings
curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg
echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_${NODE_VER}.x nodistro main" >/etc/apt/sources.list.d/nodesource.list
$STD apt-get update
$STD apt-get install -y nodejs
msg_ok "Installed Node.js ${NODE_VER}"

msg_info "Building ${APP} website"
RELEASE=$(curl -s https://api.github.com/repos/goauthentik/authentik/releases/latest | grep "tarball_url" | awk '{print substr($2, 2, length($2)-3)}')
mkdir -p /opt/authentik
wget -qO authentik.tar.gz "${RELEASE}"
tar -xzf authentik.tar.gz -C /opt/authentik --strip-components 1 --overwrite
rm -rf authentik.tar.gz
cd /opt/authentik/website
npm install
npm run build-bundled
cd /opt/authentik/web
npm install
npm run build
msg_ok "Built ${APP} website"


################PUT This in service file
NODE_ENV=production
######################



# # Stage 3: Build go proxy
# FROM --platform=${BUILDPLATFORM} mcr.microsoft.com/oss/go/microsoft/golang:1.23-fips-bookworm AS go-builder

# ARG TARGETOS
# ARG TARGETARCH
# ARG TARGETVARIANT

# ARG GOOS=$TARGETOS
# ARG GOARCH=$TARGETARCH

# WORKDIR /go/src/goauthentik.io

# RUN --mount=type=cache,id=apt-$TARGETARCH$TARGETVARIANT,sharing=locked,target=/var/cache/apt \
    # dpkg --add-architecture arm64 && \
    # apt-get update && \
    # apt-get install -y --no-install-recommends crossbuild-essential-arm64 gcc-aarch64-linux-gnu

# RUN --mount=type=bind,target=/go/src/goauthentik.io/go.mod,src=./go.mod \
    # --mount=type=bind,target=/go/src/goauthentik.io/go.sum,src=./go.sum \
    # --mount=type=cache,target=/go/pkg/mod \
    # go mod download

# COPY ./cmd /go/src/goauthentik.io/cmd
# COPY ./authentik/lib /go/src/goauthentik.io/authentik/lib
# COPY ./web/static.go /go/src/goauthentik.io/web/static.go
# COPY --from=web-builder /work/web/robots.txt /go/src/goauthentik.io/web/robots.txt
# COPY --from=web-builder /work/web/security.txt /go/src/goauthentik.io/web/security.txt
# COPY ./internal /go/src/goauthentik.io/internal
# COPY ./go.mod /go/src/goauthentik.io/go.mod
# COPY ./go.sum /go/src/goauthentik.io/go.sum

# RUN --mount=type=cache,sharing=locked,target=/go/pkg/mod \
    # --mount=type=cache,id=go-build-$TARGETARCH$TARGETVARIANT,sharing=locked,target=/root/.cache/go-build \
    # if [ "$TARGETARCH" = "arm64" ]; then export CC=aarch64-linux-gnu-gcc && export CC_FOR_TARGET=gcc-aarch64-linux-gnu; fi && \
    # CGO_ENABLED=1 GOEXPERIMENT="systemcrypto" GOFLAGS="-tags=requirefips" GOARM="${TARGETVARIANT#v}" \
    # go build -o /go/authentik ./cmd/server


msg_info "Installing Golang"
cd ~
set +o pipefail
GO_RELEASE=$(curl -s https://go.dev/dl/ | grep -o -m 1 "go.*\linux-amd64.tar.gz")
wget -q https://golang.org/dl/${GO_RELEASE}
tar -xzf ${GO_RELEASE} -C /usr/local
$STD ln -s /usr/local/go/bin/go /usr/bin/go
set -o pipefail
msg_ok "Installed Golang"

msg_info "Building Go Proxy"
cd /opt/authentik
go mod download
go build -o /go/authentik ./cmd/server
go build -o /opt/authentik/authentik-server /opt/authentik/cmd/server/
msg_ok "Built Go Proxy"




# # Stage 4: MaxMind GeoIP
# FROM --platform=${BUILDPLATFORM} ghcr.io/maxmind/geoipupdate:v7.0.1 AS geoip

# ENV GEOIPUPDATE_EDITION_IDS="GeoLite2-City GeoLite2-ASN"
# ENV GEOIPUPDATE_VERBOSE="1"
# ENV GEOIPUPDATE_ACCOUNT_ID_FILE="/run/secrets/GEOIPUPDATE_ACCOUNT_ID"
# ENV GEOIPUPDATE_LICENSE_KEY_FILE="/run/secrets/GEOIPUPDATE_LICENSE_KEY"

# USER root
# RUN --mount=type=secret,id=GEOIPUPDATE_ACCOUNT_ID \
    # --mount=type=secret,id=GEOIPUPDATE_LICENSE_KEY \
    # mkdir -p /usr/share/GeoIP && \
    # /bin/sh -c "/usr/bin/entry.sh || echo 'Failed to get GeoIP database, disabling'; exit 0"


msg_info "Installing GeoIP"
cd ~
GEOIP_RELEASE=$(curl -s https://api.github.com/repos/maxmind/geoipupdate/releases/latest | grep "tag_name" | awk '{print substr($2, 3, length($2)-4) }')
#mkdir -p /opt/authentik
#https://github.com/maxmind/geoipupdate/releases/download/v7.0.1/geoipupdate_7.0.1_linux_amd64.deb
wget -qO geoipupdate.deb https://github.com/maxmind/geoipupdate/releases/download/v${GEOIP_RELEASE}/geoipupdate_${GEOIP_RELEASE}_linux_amd64.deb
dpkg -i geoipupdate.deb
rm geoipupdate.deb
#CONFIG IN /etc/GeoIP.conf
#---------> Maybe that's where to put the ENV VAR
msg_ok "Installed GeoIP"

############ ADD THIS TO ENV VAR IN service
# ENV GEOIPUPDATE_EDITION_IDS="GeoLite2-City GeoLite2-ASN"
# ENV GEOIPUPDATE_VERBOSE="1"
# ENV GEOIPUPDATE_ACCOUNT_ID_FILE="/run/secrets/GEOIPUPDATE_ACCOUNT_ID"
# ENV GEOIPUPDATE_LICENSE_KEY_FILE="/run/secrets/GEOIPUPDATE_LICENSE_KEY"






# # Stage 5: Python dependencies
# FROM ghcr.io/goauthentik/fips-python:3.12.7-slim-bookworm-fips-full AS python-deps

# ARG TARGETARCH
# ARG TARGETVARIANT

# WORKDIR /ak-root/poetry

# ENV VENV_PATH="/ak-root/venv" \
    # POETRY_VIRTUALENVS_CREATE=false \
    # PATH="/ak-root/venv/bin:$PATH"

# RUN rm -f /etc/apt/apt.conf.d/docker-clean; echo 'Binary::apt::APT::Keep-Downloaded-Packages "true";' > /etc/apt/apt.conf.d/keep-cache

# RUN --mount=type=cache,id=apt-$TARGETARCH$TARGETVARIANT,sharing=locked,target=/var/cache/apt \
    # apt-get update && \
    # # Required for installing pip packages
    # apt-get install -y --no-install-recommends build-essential pkg-config libpq-dev libkrb5-dev

# RUN --mount=type=bind,target=./pyproject.toml,src=./pyproject.toml \
    # --mount=type=bind,target=./poetry.lock,src=./poetry.lock \
    # --mount=type=cache,target=/root/.cache/pip \
    # --mount=type=cache,target=/root/.cache/pypoetry \
    # python -m venv /ak-root/venv/ && \
    # bash -c "source ${VENV_PATH}/bin/activate && \
    # pip3 install --upgrade pip && \
    # pip3 install poetry && \
    # poetry install --only=main --no-ansi --no-interaction --no-root && \
    # pip install --force-reinstall /wheels/*"

msg_info "Installing Python Dependencies"
cd /opt/authentik
#$STD apt-get install -y --no-install-recommends build-essential pkg-config libpq-dev libkrb5-dev
$STD apt install -y python3-pip
pip3 install --upgrade pip
pip3 install poetry
$STD ln -s /usr/local/bin/poetry /usr/bin/poetry
poetry install --only=main --no-ansi --no-interaction --no-root
#pip3 install --force-reinstall *.whl
msg_ok "Installed Python Dependencies"

# curl https://bootstrap.pypa.io/get-pip.py | ./.venv/bin/python3
# ./.venv/bin/pip install --no-cache-dir poetry poetry-plugin-export
# ./.venv/bin/poetry export -f requirements.txt --output requirements.txt
# ./.venv/bin/poetry export -f requirements.txt --with dev --output requirements-dev.txt
# ./.venv/bin/pip install --no-cache-dir -r requirements.txt -r requirements-dev.txt



######## NEXT STEP : Convert Stage 6



##########ORIGINAL DOCKERFILE


# Stage 6: Run
FROM ghcr.io/goauthentik/fips-python:3.12.7-slim-bookworm-fips-full AS final-image

ARG VERSION
ARG GIT_BUILD_HASH
ENV GIT_BUILD_HASH=$GIT_BUILD_HASH

LABEL org.opencontainers.image.url=https://goauthentik.io
LABEL org.opencontainers.image.description="goauthentik.io Main server image, see https://goauthentik.io for more info."
LABEL org.opencontainers.image.source=https://github.com/goauthentik/authentik
LABEL org.opencontainers.image.version=${VERSION}
LABEL org.opencontainers.image.revision=${GIT_BUILD_HASH}

WORKDIR /

# We cannot cache this layer otherwise we'll end up with a bigger image
RUN apt-get update && \
    # Required for runtime
    apt-get install -y --no-install-recommends libpq5 libmaxminddb0 ca-certificates libkrb5-3 libkadm5clnt-mit12 libkdb5-10 && \
    # Required for bootstrap & healtcheck
    apt-get install -y --no-install-recommends runit && \
    apt-get clean && \
    rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/ && \
    adduser --system --no-create-home --uid 1000 --group --home /authentik authentik && \
    mkdir -p /certs /media /blueprints && \
    mkdir -p /authentik/.ssh && \
    mkdir -p /ak-root && \
    chown authentik:authentik /certs /media /authentik/.ssh /ak-root

COPY ./authentik/ /authentik
COPY ./pyproject.toml /
COPY ./poetry.lock /
COPY ./schemas /schemas
COPY ./locale /locale
COPY ./tests /tests
COPY ./manage.py /
COPY ./blueprints /blueprints
COPY ./lifecycle/ /lifecycle
COPY ./authentik/sources/kerberos/krb5.conf /etc/krb5.conf
COPY --from=go-builder /go/authentik /bin/authentik
COPY --from=python-deps /ak-root/venv /ak-root/venv
COPY --from=web-builder /work/web/dist/ /web/dist/
COPY --from=web-builder /work/web/authentik/ /web/authentik/
COPY --from=website-builder /work/website/build/ /website/help/
COPY --from=geoip /usr/share/GeoIP /geoip

USER 1000

ENV TMPDIR=/dev/shm/ \
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PATH="/ak-root/venv/bin:/lifecycle:$PATH" \
    VENV_PATH="/ak-root/venv" \
    POETRY_VIRTUALENVS_CREATE=false

ENV GOFIPS=1

HEALTHCHECK --interval=30s --timeout=30s --start-period=60s --retries=3 CMD [ "ak", "healthcheck" ]

ENTRYPOINT [ "dumb-init", "--", "ak" ]





#######################################







#Source from: https://github.com/gtsatsis/authentik-bare-metal
#######

sudo apt update && sudo apt upgrade -yqq # Ensure up-to-date system
sudo apt install -yqq curl wget git build-essential libncursesw5-dev libssl-dev \
     libsqlite3-dev tk-dev libgdbm-dev libc6-dev libbz2-dev pkg-config libffi-dev zlib1g-dev libxmlsec1 libxmlsec1-dev libxmlsec1-openssl libmaxminddb0 # Install build dependencies

wget https://github.com/mikefarah/yq/releases/download/v4.30.8/yq_linux_amd64 -O /usr/bin/yq
chmod +x /usr/bin/yq

wget https://www.python.org/ftp/python/3.11.1/Python-3.11.1.tgz
tar xzf Python-3.11.1.tgz 
cd Python-3.11.1
./configure --enable-optimizations
sudo make altinstall # Install Python 3.11.1

cd $STARTING_DIR
rm -rf Python-3.11.1.tgz Python-3.11.1

# Install NodeJS 18
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt-get install -y nodejs

# Install Go 1.19
wget https://golang.org/dl/go1.19.linux-amd64.tar.gz
sudo tar -C /usr/local -xzf go1.19.linux-amd64.tar.gz
rm -rf go1.19.linux-amd64.tar.gz



#######

motd_ssh
customize

msg_info "Cleaning up"
$STD apt-get -y autoremove
$STD apt-get -y autoclean
msg_ok "Cleaned"