#!/bin/bash

echo "Конфигугируем MONGO / Сервис конфигурации (configSrv)"

docker compose exec -T configSrv mongosh --port 27017 <<EOF
rs.initiate(
  {
    _id : "config_server",
       configsvr: true,
    members: [
      { _id : 0, host : "configSrv:27017" }
    ]
  }
);
exit();
EOF

echo "Конфигугируем MONGO / Шард 1 (shard1)"

docker compose exec -T shard1 mongosh --port 27018 <<EOF
rs.initiate(
    {
      _id : "shard1",
      members: [
        { _id : 0, host : "shard1:27018" },
        { _id : 1, host : "shard11:27021" },
        { _id : 2, host : "shard12:27022" }
      ]
    }
);
exit();
EOF

echo "Конфигугируем MONGO / Шард 2 (shard2)"

docker compose exec -T shard2 mongosh --port 27019 <<EOF
rs.initiate(
    {
      _id : "shard2",
      members: [
        { _id : 0, host : "shard2:27019" },
        { _id : 1, host : "shard21:27023" },
        { _id : 2, host : "shard22:27024" }
      ]
    }
);
exit();
EOF

echo "Конфигугируем MONGO / Роутер (mongos_router)"

docker compose exec -T mongos_router mongosh --port 27020 <<EOF
sh.addShard("shard1/shard1:27018");
sh.addShard("shard2/shard2:27019");
sh.enableSharding("somedb");
sh.shardCollection("somedb.helloDoc", { "name" : "hashed" } )
exit();
EOF

echo "Инициализируем БД somedb / helloDoc (mongos_router)"

docker compose exec -T mongos_router mongosh --port 27020 <<EOF
use somedb
for(var i = 0; i < 1000; i++) db.helloDoc.insertOne({age:i, name:"ly"+i})
exit();
EOF
