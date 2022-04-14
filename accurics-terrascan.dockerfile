FROM ubuntu:20.04

ENV PATH="/opt/bin:${PATH}"

WORKDIR /opt/bin

COPY accurics_linux.md5 .
COPY terrascan_1.13.2_Linux_x86_64.tar.gz.md5 .

# Accurics uses git to determine information about the repo being scanned
RUN apt-get update \
    && apt-get install -y git \
    gpg \
    wget \
    zip \
    && apt-get clean \
    && apt-get autoremove --yes

RUN gpg --quick-generate-key --batch --passphrase "" human@example.com \
    && wget -q https://keybase.io/hashicorp/pgp_keys.asc \
    && gpg --import pgp_keys.asc \
    && gpg --batch --yes --sign-key 34365D9472D7468F

RUN wget -q https://github.com/accurics/terrascan/releases/download/v1.13.2/terrascan_1.13.2_Linux_x86_64.tar.gz \
    && tar xf terrascan*.tar.gz \
    && md5sum -c terrascan_1.13.2_Linux_x86_64.tar.gz.md5 \
    && rm -f terrascan*.tar.gz \
    && chmod 755 ./terrascan

RUN wget -q https://downloads.accurics.com/cli/1.0.34/accurics_linux \
    && md5sum -c accurics_linux.md5 \
    && mv ./accurics_linux ./accurics \
    && chmod 755 ./accurics

RUN wget -q https://releases.hashicorp.com/terraform/1.1.7/terraform_1.1.7_linux_amd64.zip \
    && wget -q https://releases.hashicorp.com/terraform/1.1.7/terraform_1.1.7_SHA256SUMS \
    && wget -q https://releases.hashicorp.com/terraform/1.1.7/terraform_1.1.7_SHA256SUMS.sig \
    && gpg --verify terraform_1.1.7_SHA256SUMS.sig terraform_1.1.7_SHA256SUMS \
    && shasum --ignore-missing -a 256 -c terraform_1.1.7_SHA256SUMS \
    && unzip terraform*.zip \
    && rm -f terraform*.zip \
    && chmod 755 ./terraform

# Usually this container is used to run CI and have the accurics tools available and not run the tool directly.
CMD ["/bin/bash"]
