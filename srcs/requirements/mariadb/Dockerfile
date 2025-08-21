FROM debian:bookworm

RUN apt-get update && \
    apt install -y mariadb-server && \
    rm -rf /var/lib/apt/lists/*

COPY conf/50-server.cnf /etc/mysql/mariadb.conf.d/

COPY tools/init-db.sh /
COPY tools/init.sql /tmp/

RUN chmod +x /init-db.sh

ENTRYPOINT [ "/init-db.sh" ]