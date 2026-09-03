FROM alpine:3.19

# Install Ansible and necessary connection tools
RUN apk add --no-cache \
    ansible \
    openssh-client \
    sshpass \
    python3 \
    py3-pip \
    bash

# Prepare SSH directory
RUN mkdir -p /root/.ssh && chmod 700 /root/.ssh

# Install Docker SDK for Python so Ansible can control Docker on the VPS
RUN pip3 install --no-cache-dir --break-system-packages docker

WORKDIR /ansible

# Standard DevOps optimization: don't hang on new SSH keys
ENV ANSIBLE_HOST_KEY_CHECKING=False

CMD ["ansible-playbook", "--version"]
