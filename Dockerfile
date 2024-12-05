# FROM debian:stretch-20170907
FROM debian:bullseye

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y --no-install-recommends \
        apt-utils \
        forensics-all \
        foremost \
        binwalk \
        exiftool \
        outguess \
        pngtools \
        pngcheck \
        stegosuite \
        git \
        hexedit \
        python3-pip \
        autotools-dev \
        automake \
        libevent-dev \
        bsdmainutils \
        ffmpeg \
        crunch \
        cewl \
        sonic-visualiser \
        xxd \
        atomicparsley && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN pip3 install --no-cache-dir python-magic tqdm

COPY install /tmp/install
RUN chmod a+x /tmp/install/*.sh && \
    for script in /tmp/install/*.sh; do /bin/bash "$script"; done && \
    rm -rf /tmp/install

COPY examples /examples

# COPY scripts /opt/scripts
# RUN chmod a+x /opt/scripts/*.{sh,py}

COPY scripts /opt/scripts
RUN if [ -d /opt/scripts ]; then \
        find /opt/scripts -type f \( -name '*.sh' -o -name '*.py' \) -exec chmod a+x {} +; \
    fi

ENV PATH="/opt/scripts:${PATH}"

WORKDIR /data
