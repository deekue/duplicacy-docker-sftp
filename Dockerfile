# Use phusion/baseimage as base image. To make your builds
# reproducible, make sure you lock down to a specific version, not
# to `latest`! See
# https://github.com/phusion/baseimage-docker/blob/master/Changelog.md
# for a list of version numbers.
FROM phusion/baseimage:0.9.22

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]

# enable SSH/SFTP in baseimage-docker
RUN rm -f /etc/service/sshd/down

# Regenerate SSH host keys. baseimage-docker does not contain any, so you
# have to do that yourself. You may also comment out this instruction; the
# init system will auto-generate one during boot.
#RUN /etc/my_init.d/00_regen_ssh_host_keys.sh

## Duplicacy SFTP
COPY etc/sshd_config /etc/ssh/sshd_config
COPY usr/sbin/get_user_keys /usr/sbin/get_user_keys
VOLUME ["/storage", "/etc/ssh/keys"]
EXPOSE 22

# single user
ENV DUPLICACY_UID=1029
ENV DUPLICACY_GID=100
RUN useradd -d /storage -M -u $DUPLICACY_UID -g $DUPLICACY_GID -s /usr/lib/sftp-server duplicacy
RUN usermod -p '*' duplicacy

# user per client (not working yet)
#RUN groupadd sftpusers
#RUN some-script-to-sync-users-in /storage

# Upgrade OS in image
RUN apt-get update && apt-get upgrade -y -o Dpkg::Options::="--force-confold"

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
