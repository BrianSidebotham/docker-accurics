FROM ubuntu:20.04

ENV PATH="/opt/bin:${PATH}"

WORKDIR /opt/bin

RUN apt-get update \
    && apt-get install -y git \
    wget \
    zip \
    && apt-get clean \
    && apt-get autoremove --yes

RUN wget -q https://github.com/accurics/terrascan/releases/download/v1.13.2/terrascan_1.13.2_Linux_x86_64.tar.gz \
    && tar xf terrascan*.tar.gz \
    && rm -f terrascan*.tar.gz \
    && chmod 755 ./terrascan

RUN wget -q https://downloads.accurics.com/cli/1.0.34/accurics_linux \
    && mv ./accurics_linux ./accurics \
    && chmod 755 ./accurics

RUN wget -q https://releases.hashicorp.com/terraform/1.1.7/terraform_1.1.7_linux_amd64.zip \
    && unzip terraform*.zip \
    && rm -f terraform*.zip \
    && chmod 755 ./terraform

# Usually this container is used to run CI and have the accurics tools available and not run the tool directly.
CMD ["/bin/bash"]
