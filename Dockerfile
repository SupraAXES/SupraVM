FROM ubuntu:23.10

RUN apt update && apt install -y --no-install-recommends \
    apt-utils \
    binutils \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

COPY apt /etc/apt

RUN apt update && DEBIAN_FRONTEND=noninteractive apt install -y \
    quickemu \
    wget \
    xz-utils \
    && rm -rf /var/lib/apt/lists/*

RUN adduser --disabled-password --gecos "" --uid 1711 supra

COPY supra-windows-env-0.0.1.tar.xz /opt/vm/
COPY supra-linux-env-0.0.1.tar.xz /opt/vm/
RUN cd /opt/vm/ \
    && tar xvf supra-windows-env-0.0.1.tar.xz \
    && tar xvf supra-linux-env-0.0.1.tar.xz \
    && rm supra-windows-env-0.0.1.tar.xz \
    && rm supra-linux-env-0.0.1.tar.xz \
    && chown -R supra:supra /opt/vm

COPY quickemu /usr/bin/runvm
COPY supra supra

ENV PATH=/supra/bin:$PATH
CMD ["entry.sh"]
