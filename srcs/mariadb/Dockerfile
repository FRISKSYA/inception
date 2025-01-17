FROM debian:bullseye

# Install MariaDB and essential packages
RUN apt-get update && \
    apt-get install -y mariadb-server && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Environment variables
ENV MYSQL_ROOT_PASSWORD=''
ENV MYSQL_DATABASE=''
ENV MYSQL_USER=''
ENV MYSQL_PASSWORD=''

# Copy configuration file
COPY ./conf/my.cnf /etc/mysql/my.cnf

# Copy initialization script
COPY ./tools/init_db.sh /docker-entrypoint-initdb.d/
RUN chmod +x /docker-entrypoint-initdb.d/init_db.sh

# Set working directory
WORKDIR /var/lib/mysql

# Expose MariaDB port
EXPOSE 3306

USER mysql

# Set the entry point
ENTRYPOINT ["/docker-entrypoint-initdb.d/init_db.sh"]

CMD ["mariadbd"]