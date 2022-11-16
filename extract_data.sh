#!/bin/bash

set -euo pipefail

echo "Starting extract of data"

PGPASSWORD=${transformation_db_password} psql -h${transformation_db_host} -p${transformation_db_port} -d${transformation_db_name} -U${transformation_db_username} << EOF

CREATE EXTENSION IF NOT EXISTS postgres_fdw;
DROP SERVER IF EXISTS import_replica_server CASCADE;
CREATE SERVER IF NOT EXISTS import_replica_server FOREIGN DATA WRAPPER postgres_fdw OPTIONS (host '${replica_db_host}', port '${replica_db_port}', dbname '${replica_db_name}');
CREATE USER MAPPING FOR user SERVER import_replica_server OPTIONS (user '${replica_db_username}', password '${replica_db_password}');
CREATE schema IF NOT EXISTS transformation;
IMPORT FOREIGN SCHEMA replica from SERVER import_replica_server into transformation;
EOF