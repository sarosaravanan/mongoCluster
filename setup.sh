#Create folders for replica sets
#===========================================================================================================================
mkdir	a0	#primary on shard one
mkdir	a1	#secondary on shard one
mkdir 	a2	#secondary on shard one
#===========================================================================================================================
mkdir	b0	#primary on shard two
mkdir	b1	#secondary on shard two
mkdir	b2	#secondary on shard two
#===========================================================================================================================
#folders for config server
mkdir	conf0
mkdir	conf1
mkdir	conf2
#===========================================================================================================================
#folder to capture log files
mkdir	log
#===========================================================================================================================
#Start config servers
mongod --configsvr --dbpath conf0 --port 26050 --fork --logpath log/log.conf0 --logappend
mongod --configsvr --dbpath conf1 --port 26051 --fork --logpath log/log.conf1 --logappend
mongod --configsvr --dbpath conf2 --port 26052 --fork --logpath log/log.conf2 --logappend
#===========================================================================================================================
#start first shard server with replica set
mongod --shardsvr --replSet a --dbpath a0 --port 27000 --fork --logpath log/log.a0 --logappend --smallfiles --oplogSize 50
mongod --shardsvr --replSet a --dbpath a1 --port 27001 --fork --logpath log/log.a1 --logappend --smallfiles --oplogSize 50
mongod --shardsvr --replSet a --dbpath a2 --port 27002 --fork --logpath log/log.a2 --logappend --smallfiles --oplogSize 50
#===========================================================================================================================
#start second shard server with replica set
mongod --shardsvr --replSet b --dbpath b0 --port 27003 --fork --logpath log/log.b0 --logappend --smallfiles --oplogSize 50
mongod --shardsvr --replSet b --dbpath b1 --port 27004 --fork --logpath log/log.b1 --logappend --smallfiles --oplogSize 50
mongod --shardsvr --replSet b --dbpath b2 --port 27005 --fork --logpath log/log.b2 --logappend --smallfiles --oplogSize 50
#===========================================================================================================================
#start mongos process
mongos --configdb pmone:26050,pmone:26051,pmone:26052 --fork --logpath log/log.mongos0
#===========================================================================================================================
#Connect to first shard (mongod) processes
mongo --port 27000
#===========================================================================================================================
#Once connected, initiate replica set using below command
rs.initiate({
    "_id" : "a",
    "version" : 1,
    "members" : [
                  {
                     "_id" : 0,
                     "host" : "pmone:27000",
                     "priority" : 2
                  },
                  {
                     "_id" : 1,
                     "host" : "pmone:27001",
                     "priority" : 1
                  },
                  {
                     "_id" : 2,
                     "host" : "pmone:27002",
                     "priority" : 0.5
                  }
     ]
});

#===========================================================================================================================
#Connect to second shard (mongod) processes
mongo --port 27003
#===========================================================================================================================
#Once connected, initiate replica set using below command
rs.initiate({
    "_id" : "b",
    "version" : 1,
    "members" : [
                  {
                     "_id" : 0,
                     "host" : "pmone:27003",
                     "priority" : 2
                  },
                  {
                     "_id" : 1,
                     "host" : "pmone:27004",
                     "priority" : 1
                  },
                  {
                     "_id" : 2,
                     "host" : "pmone:27005",
                     "priority" : 0.5
                  }
     ]
});
#===========================================================================================================================
#Connect to mongos process running on a default port
mongo
#===========================================================================================================================
#Use below commands to add shards in the cluster
sh.addShard("a/pmone:27000");
sh.addShard("b/pmone:27003");
#===========================================================================================================================
#Enable sharding
sh.enableSharding("location");
sh.shardCollection("checkin",{location_type:1});
