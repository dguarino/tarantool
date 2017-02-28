wa = require 'sqlworkaround'

test_run = require('test_run').new()

-- box.cfg()

-- create space
zoobar = box.schema.space.create("zzoobar")
_ = zoobar:create_index("primary",{parts={2,"number"}})

zoobar_pageno =  wa.sql_pageno(zoobar.id, zoobar.index.primary.id)

wa.sql_schema_put(0, "zzoobar"                   , zoobar_pageno , "CREATE TABLE zzoobar (c1, c2 PRIMARY KEY, c3, c4) WITHOUT ROWID")
wa.sql_schema_put(0, "sqlite_autoindex_zzoobar_1", zoobar_pageno , "")

box.sql.execute("CREATE UNIQUE INDEX zoobar2 ON zzoobar(c1, c4)")
box.sql.execute("CREATE        INDEX zoobar3 ON zzoobar(c3)")

-- Debug
-- box.sql.execute("PRAGMA vdbe_debug=ON ; INSERT INTO zzoobar VALUES (111, 222, 'c3', 444)")

-- Dummy entry
box.sql.execute("INSERT INTO zzoobar VALUES (111, 222, 'c3', 444)")

box.sql.execute("DROP INDEX zoobar2")
box.sql.execute("DROP INDEX zoobar3")

-- zoobar2 is dropped - should be OK
box.sql.execute("INSERT INTO zzoobar VALUES (111, 223, 'c3', 444)")

-- zoobar2 was dropped. Re-creation should  be OK
box.sql.execute("CREATE INDEX zoobar2 ON zzoobar(c3)")

-- Cleanup
box.sql.execute("DROP INDEX zoobar2")
box.sql.execute("DROP TABLE zzoobar")

-- Debug
-- require("console").start()
