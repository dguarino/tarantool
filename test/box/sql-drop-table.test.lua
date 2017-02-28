wa = require 'sqlworkaround'

test_run = require('test_run').new()

-- box.cfg()

-- create space
zoobar = box.schema.space.create("zzzoobar")
_ = zoobar:create_index("primary",{parts={2,"number"}})

zoobar_pageno =  wa.sql_pageno(zoobar.id, zoobar.index.primary.id)

wa.sql_schema_put(0, "zzzoobar"                   , zoobar_pageno , "CREATE TABLE zzzoobar (c1, c2 PRIMARY KEY, c3, c4) WITHOUT ROWID")
wa.sql_schema_put(0, "sqlite_autoindex_zzzoobar_1", zoobar_pageno , "")

-- Debug
-- box.sql.execute("PRAGMA vdbe_debug=ON ; INSERT INTO zzzoobar VALUES (111, 222, 'c3', 444)")

-- Dummy entry
box.sql.execute("INSERT INTO zzzoobar VALUES (111, 222, 'c3', 444)")

box.sql.execute("DROP TABLE zzzoobar")

-- Table does not exist anymore. Should error here.
box.sql.execute("INSERT INTO zzzoobar VALUES (111, 222, 'c3', 444)")

-- Cleanup
-- DROP TABLE should do the job

-- Debug
-- require("console").start()
