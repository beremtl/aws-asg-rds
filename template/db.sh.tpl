#! /bin/bash
sudo apt update && sudo apt install -y postgresql-client
PGPASSWORD=${passwd} psql -h ${host} -p ${port} -U ${username} -d ${db_name} <<EOF
DROP TABLE IF EXISTS times;

CREATE TABLE times (id SERIAL PRIMARY KEY,timesnow DATE NOT NULL);

INSERT INTO times (timesnow)
VALUES (current_timestamp);
EOF
