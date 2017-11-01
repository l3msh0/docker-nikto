FROM alpine:3.6
LABEL maintainer="L3msh0@gmail.com"

ARG NIKTO_VERSION="2.1.6"
ARG NIKTO_URL="https://github.com/sullo/nikto/archive/${NIKTO_VERSION}.tar.gz"
ARG NIKTO_DIR="/nikto"

RUN \
  apk add --upgrade --no-cache perl openssl perl-net-ssleay ca-certificates && \
  update-ca-certificates && \
  wget https://github.com/sullo/nikto/archive/${NIKTO_VERSION}.tar.gz -O /tmp/nikto.tar.gz && \
  adduser -D -h ${NIKTO_DIR} nikto && \
  tar -zxf /tmp/nikto.tar.gz --strip-components=1 -C ${NIKTO_DIR} && \
  rm /tmp/nikto.tar.gz && \
  chmod 755 ${NIKTO_DIR}/program/nikto.pl && \
  chown -R nikto:nikto ${NIKTO_DIR} && \
  mkdir /work && \
  chown nikto:nikto /work

USER nikto
WORKDIR ${NIKTO_DIR}/program

RUN ./nikto.pl -update

VOLUME /work
ENTRYPOINT ["./nikto.pl"]
CMD ["-h"]
