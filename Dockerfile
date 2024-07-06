FROM debian:stable

RUN apt-get update && apt-get install -y curl git && apt-get clean

RUN mkdir -p /opt/radicle
ENV PATH="/opt/radicle:${PATH}"

RUN curl -sSf https://radicle.xyz/install | sh --prefix=/opt/radicle

COPY init.sh /opt/radicle/init.sh
RUN chmod +x /opt/radicle/init.sh

EXPOSE 8080
EXPOSE 8776

ENTRYPOINT ["/opt/radicle/init.sh"]
