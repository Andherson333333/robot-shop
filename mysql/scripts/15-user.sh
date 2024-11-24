#!/bin/bash
until mysql -uroot &> /dev/null; do
  echo "Waiting for MySQL..."
  sleep 1
done

mysql -uroot << EOF
CREATE USER IF NOT EXISTS 'ratings'@'%' IDENTIFIED BY 'iloveit';
CREATE DATABASE IF NOT EXISTS ratings DEFAULT CHARACTER SET 'utf8';
GRANT ALL PRIVILEGES ON ratings.* TO 'ratings'@'%';
FLUSH PRIVILEGES;
EOF
echo "Ratings user and database created successfully"
