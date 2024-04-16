FROM debian:stable

RUN apt-get update && apt-get install -y curl git && apt-get clean

ENV RAD_PATH="/opt/radicle"
RUN mkdir -p /opt/radicle
ENV PATH="${RAD_PATH}:${PATH}"

RUN curl -sSf https://radicle.xyz/install | sh

COPY init.sh /opt/radicle/init.sh
RUN chmod +x /opt/radicle/init.sh

ENTRYPOINT ["/opt/radicle/init.sh"]