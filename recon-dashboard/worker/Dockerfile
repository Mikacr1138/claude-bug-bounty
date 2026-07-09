# Build context is the recon-dashboard root so the shared `common` package
# can be copied into the image alongside the worker code.
FROM python:3.12-slim

WORKDIR /app

ARG NUCLEI_VERSION=3.11.0
ARG SUBFINDER_VERSION=2.14.0

RUN apt-get update \
 && apt-get install -y --no-install-recommends nmap ca-certificates curl unzip \
 && rm -rf /var/lib/apt/lists/*

# Prebuilt ProjectDiscovery binaries (static Go) — no toolchain or compile step.
# Kept in a dedicated dir and called by absolute path so they never clash with
# the python `httpx` console script on PATH.
RUN mkdir -p /opt/pdtools \
 && curl -sSL -o /tmp/nuclei.zip \
      "https://github.com/projectdiscovery/nuclei/releases/download/v${NUCLEI_VERSION}/nuclei_${NUCLEI_VERSION}_linux_amd64.zip" \
 && unzip -o /tmp/nuclei.zip nuclei -d /opt/pdtools \
 && curl -sSL -o /tmp/subfinder.zip \
      "https://github.com/projectdiscovery/subfinder/releases/download/v${SUBFINDER_VERSION}/subfinder_${SUBFINDER_VERSION}_linux_amd64.zip" \
 && unzip -o /tmp/subfinder.zip subfinder -d /opt/pdtools \
 && chmod +x /opt/pdtools/nuclei /opt/pdtools/subfinder \
 && rm -f /tmp/nuclei.zip /tmp/subfinder.zip

COPY worker/requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY common ./common
COPY worker/worker ./worker
COPY worker/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# nuclei templates are refreshed at startup and persisted in a mounted volume,
# keeping the image small.
ENTRYPOINT ["/entrypoint.sh"]
