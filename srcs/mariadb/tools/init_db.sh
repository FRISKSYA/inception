#!/bin/bash

if [ ! -d "/var/lib/mysql/mysql" ]; then
    # Initialize MySQL data directory
    mysql_install_db --datadir=/var/lib/mysql

    # Start MariaDB daemon
    mysqld_safe &

    # Wait for MariaDB to be ready
    until mysqladmin ping >/dev/null 2>&1; do
        sleep 1
    done

    # Create database and user using environment variables
    mysql -u root <<EOF
    ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
    CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};
    CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
    GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';
    FLUSH PRIVILEGES;
EOF

    # Stop MariaDB daemon safely
    mysqladmin -u root -p${MYSQL_ROOT_PASSWORD} shutdown
fi

# Start MariaDB
exec mysqld