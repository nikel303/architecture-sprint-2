#!/bin/bash

echo "ТЕСТЫ"

docker compose exec -T mongos_router mongosh --port 27020 <<EOF
use somedb
db.helloDoc.countDocuments()
EOF

docker compose exec -T shard1 mongosh --port 27018 <<EOF
use somedb
db.helloDoc.countDocuments()
EOF

docker compose exec -T shard11 mongosh --port 27021 <<EOF
use somedb
db.helloDoc.countDocuments()
EOF

docker compose exec -T shard12 mongosh --port 27022 <<EOF
use somedb
db.helloDoc.countDocuments()
EOF

docker compose exec -T shard2 mongosh --port 27019 <<EOF
use somedb
db.helloDoc.countDocuments()
EOF

docker compose exec -T shard21 mongosh --port 27023 <<EOF
use somedb
db.helloDoc.countDocuments()
EOF

docker compose exec -T shard22 mongosh --port 27024 <<EOF
use somedb
db.helloDoc.countDocuments()
EOF