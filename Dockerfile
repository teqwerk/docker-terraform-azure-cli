ARG ALPINE_VERSION=3

FROM --platform=$BUILDPLATFORM alpine:${ALPINE_VERSION} AS build

ARG HASHICORP_PRODUCT=terraform
ARG TERRAFORM_VERSION
ARG TARGETOS
ARG TARGETARCH

# Install Terraform
RUN apk add --update --virtual .deps --no-cache gnupg && \
    cd /tmp && \
    wget https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_${TARGETOS}_${TARGETARCH}.zip && \
    wget https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_SHA256SUMS && \
    wget https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_SHA256SUMS.sig && \
    wget -qO- https://www.hashicorp.com/.well-known/pgp-key.txt | gpg --import && \
    gpg --verify terraform_${TERRAFORM_VERSION}_SHA256SUMS.sig terraform_${TERRAFORM_VERSION}_SHA256SUMS && \
    grep terraform_${TERRAFORM_VERSION}_${TARGETOS}_${TARGETARCH}.zip terraform_${TERRAFORM_VERSION}_SHA256SUMS | sha256sum -c && \
    unzip /tmp/terraform_${TERRAFORM_VERSION}_${TARGETOS}_${TARGETARCH}.zip -d /tmp && \
    mv /tmp/terraform /usr/bin/terraform && \
    rm -f /tmp/terraform_${TERRAFORM_VERSION}_${TARGETOS}_${TARGETARCH}.zip terraform_${TERRAFORM_VERSION}_SHA256SUMS ${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_SHA256SUMS.sig && \
    apk del .deps


FROM alpine:${ALPINE_VERSION} AS final

ARG HASHICORP_PRODUCT=terraform
ARG TERRAFORM_VERSION
ARG AZURE_CLI_VERSION

ENV PIP_PREFER_BINARY=1

RUN adduser -S app -G users

# Install Azure CLI
RUN apk add --no-cache --update python3 py3-pip 
RUN apk add --no-cache --update --virtual=build gcc musl-dev python3-dev libffi-dev openssl-dev cargo make && \ 
    pip3 install --no-cache-dir azure-cli==${AZURE_CLI_VERSION} --break-system-packages

# Add terraform binary 
RUN apk add --quiet --no-cache --upgrade git openssh
COPY --from=build ["/usr/bin/terraform", "/usr/bin/terraform"]

# Add tooling
RUN apk add --quiet --no-cache --upgrade bash bash-completion curl jq

USER app
WORKDIR /home/app

# Configure Azure CLI
RUN echo "source /usr/bin/az.completion.sh" >> ~/.bashrc && \
    az config set core.collect_telemetry=no

# Configure Terraform
RUN terraform -install-autocomplete && \
    # Add common alias for terraform
    echo "alias tf=terraform" >> ~/.bashrc && \
    echo "alias tfyolo='terraform apply -auto-approve'" >> ~/.bashrc && \
    # Add bash completion for alias
    echo "complete -C /usr/bin/terraform tf" >> ~/.bashrc

ENV AZ_INSTALLER=DOCKER

CMD ["/bin/bash"]