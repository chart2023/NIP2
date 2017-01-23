db = db.getSiblingDB('m2m_nscl')
sh.enableSharding("m2m_nscl")
db.fs.chunks.createIndex( { files_id: 1, n: 1 }, { unique: true } );
sh.shardCollection("m2m_nscl.fs.chunks",{files_id : 1, n :1})
db.fs.chunks.getShardDistribution()
sh.status()
