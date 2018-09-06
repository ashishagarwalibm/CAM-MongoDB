#!/bin/bash

echo "Script for replicaset started"

ssh root@129.40.118.36 << EOF
mkdir -p ~/mongosvr/rs-db
mongod --dbpath ~/mongosvr/rs-db --replSet set --port 27091 --logpath ~/mongosvr/mongod.log  --bind_ip 0.0.0.0 --fork
EOF


ssh root@129.40.118.6 << EOF
mkdir -p ~/mongosvr/rs-db
mongod --dbpath ~/mongosvr/rs-db --replSet set --port 27091 --logpath ~/mongosvr/mongod.log  --bind_ip 0.0.0.0 --fork
EOF

ssh root@129.40.118.9 << EOF
mkdir -p ~/mongosvr/rs-db
mongod --dbpath ~/mongosvr/rs-db --replSet set --port 27091 --logpath ~/mongosvr/mongod.log  --bind_ip 0.0.0.0 --fork
EOF

sleep 5

cfg="{
    _id: 'set',
    members: [
        {_id: 1, host: '129.40.118.36:27091'},
        {_id: 2, host: '129.40.118.6:27091'},
        {_id: 3, host: '129.40.118.9:27091'}
    ]
}"

ssh root@129.40.118.36 << EOF
mongo 129.40.118.36:27091 --eval "JSON.stringify(db.adminCommand({'replSetInitiate' : $cfg}))"
EOF

echo "Script Completed"
