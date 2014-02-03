#Create folders for replica sets
#===============================================================================================
mkdir	a0	#primary on shard one
mkdir	a1	#secondary on shard one
mkdir 	a2	#secondary on shard one
#===============================================================================================
mkdir	b0	#primary on shard two
mkdir	b1	#secondary on shard two
mkdir	b2	#secondary on shard two
#===============================================================================================
#folders for config server
mkdir	conf0
mkdir	conf1
mkdir	conf2
#===============================================================================================
#folder to capture log files
mkdir	log
#===============================================================================================
#Start config servers
mongod --configsvr --dbpath conf0 --port 26050 --fork --logpath log/log.conf0 --logappend
mongod --configsvr --dbpath conf1 --port 26051 --fork --logpath log/log.conf1 --logappend
mongod --configsvr --dbpath conf2 --port 26052 --fork --logpath log/log.conf2 --logappend
#===============================================================================================
#start first shard server with replica set 
mongod --shardsvr --replSet a --dbpath a0 --port 27000 --fork --logpath log/log.a0 --logappend
mongod --shardsvr --replSet a --dbpath a1 --port 27001 --fork --logpath log/log.a1 --logappend
mongod --shardsvr --replSet a --dbpath a2 --port 27002 --fork --logpath log/log.a2 --logappend
#===============================================================================================
#start second shard server with replica set
mongod --shardsvr --replSet b --dbpath b0 --port 27003 --fork --logpath log/log.b0 --logappend
mongod --shardsvr --replSet b --dbpath b1 --port 27004 --fork --logpath log/log.b1 --logappend
mongod --shardsvr --replSet b --dbpath b2 --port 27005 --fork --logpath log/log.b2 --logappend
#===============================================================================================

