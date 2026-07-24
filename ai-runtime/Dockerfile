ARG TARGETPLATFORM=linux/amd64

FROM --platform=${TARGETPLATFORM} ubuntu:22.04

ARG TARGETPLATFORM=linux/amd64
ARG DEBIAN_FRONTEND=noninteractive
ARG TZ=Asia/Shanghai

ENV LANG=C.UTF-8 \
    LC_ALL=C.UTF-8 \
    TZ=${TZ} \
    DOCKER_IMAGE_TARGET_PLATFORM=${TARGETPLATFORM}

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        apt-transport-https \
        bash-completion \
        build-essential \
        ca-certificates \
        coreutils \
        curl \
        dnsutils \
        file \
        findutils \
        git \
        gnupg \
        grep \
        gzip \
        htop \
        iproute2 \
        iputils-ping \
        jq \
        less \
        lsb-release \
        nano \
        net-tools \
        netcat-openbsd \
        openssh-client \
        procps \
        psmisc \
        python3 \
        python3-pip \
        python3-venv \
        sed \
        sudo \
        tar \
        telnet \
        traceroute \
        tzdata \
        unzip \
        vim-tiny \
        wget \
        zip \
    && ln -snf /usr/share/zoneinfo/${TZ} /etc/localtime \
    && echo "${TZ}" > /etc/timezone \
    && install -d -m 0755 /etc/apt/keyrings /usr/share/keyrings \
    && curl -fsSL https://repos.azul.com/azul-repo.key | gpg --dearmor -o /usr/share/keyrings/azul.gpg \
    && chmod 0644 /usr/share/keyrings/azul.gpg \
    && echo "deb [signed-by=/usr/share/keyrings/azul.gpg] https://repos.azul.com/zulu/deb stable main" > /etc/apt/sources.list.d/zulu.list \
    && curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg \
    && chmod 0644 /etc/apt/keyrings/nodesource.gpg \
    && echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_22.x nodistro main" > /etc/apt/sources.list.d/nodesource.list \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
        nodejs \
        zulu21-jdk \
    && install -d -m 0755 /opt/java \
    && javac_path="$(readlink -f "$(command -v javac)")" \
    && java_home_dir="$(dirname "$(dirname "${javac_path}")")" \
    && ln -s "${java_home_dir}" /opt/java/zulu \
    && npm install -g \
        @anthropic-ai/claude-code \
        opencode-ai \
    && npm cache clean --force \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /root/.npm

ENV JAVA_HOME=/opt/java/zulu \
    PATH=/opt/java/zulu/bin:${PATH}

COPY tool-versions /usr/local/bin/tool-versions

RUN chmod +x /usr/local/bin/tool-versions

WORKDIR /workspace

CMD ["/bin/bash"]
