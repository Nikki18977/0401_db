FROM postgres:15.2-alpine as init

ARG DBNAME=db
ARG DBUSER=app
ARG DBPASS=pass

ENV POSTGRES_USER=${DBUSER}
ENV POSTGRES_PASSWORD=${DBPASS}
ENV POSTGRES_DB=${DBNAME}
ENV PGDATA=/data

COPY docker-entrypoint-initdb.d /docker-entrypoint-initdb.d/
RUN ["sed", "-i", "s/exec \"$@\"/echo \"skipping...\"/", "/usr/local/bin/docker-entrypoint.sh"]

RUN ["/usr/local/bin/docker-entrypoint.sh", "postgres"]

FROM postgres:15.2-alpine
COPY --from=init /data $PGDATA
