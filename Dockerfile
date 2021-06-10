FROM ubuntu:latest
MAINTAINER Anarkrypto <anarkrypto@gmail.com>
LABEL Description="WordPress LAMP stack, based on latest Ubuntu. Includes PHP7.4, MySQL server and .htaccess support. " \
	License="MIT License" \
	Version="1.0"

#Enable Non Interactive mode
ENV DEBIAN_FRONTEND noninteractive

ARG DB_NAME
ARG DB_USER
ARG DB_PASSWD

# Set time zone
COPY ./assets/timezone /etc/timezone
RUN export TZ=$(cat /etc/timezone); echo "Setting timezone to: $TZ"
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime

# Copy and run install script
COPY ./assets/install.sh /tmp/
RUN chmod +x /tmp/install.sh
RUN /tmp/install.sh && rm /tmp/install.sh

EXPOSE 80

# Copy startup script
COPY assets/entrypoint.sh /usr/sbin/entrypoint.sh
RUN chmod +x /usr/sbin/entrypoint.sh

ENTRYPOINT "/usr/sbin/entrypoint.sh"

