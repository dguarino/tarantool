-- create space
box.sql.execute("CREATE TABLE foobar (foo PRIMARY KEY, bar) WITHOUT ROWID")

-- prepare data
box.sql.execute("INSERT INTO foobar VALUES (1, 'foo')")
box.sql.execute("INSERT INTO foobar VALUES (2, 'bar')")
box.sql.execute("INSERT INTO foobar VALUES (1000, 'foobar')")

box.sql.execute("INSERT INTO foobar VALUES (1, 'duplicate')")

-- simple select
box.sql.execute("SELECT bar, foo, 42, 'awesome' FROM foobar")
box.sql.execute("SELECT bar, foo, 42, 'awesome' FROM foobar LIMIT 2")
box.sql.execute("SELECT bar, foo, 42, 'awesome' FROM foobar WHERE foo=2")
box.sql.execute("SELECT bar, foo, 42, 'awesome' FROM foobar WHERE foo>2")
box.sql.execute("SELECT bar, foo, 42, 'awesome' FROM foobar WHERE foo>=2")
box.sql.execute("SELECT bar, foo, 42, 'awesome' FROM foobar WHERE foo=10000")
box.sql.execute("SELECT bar, foo, 42, 'awesome' FROM foobar WHERE foo>10000")
box.sql.execute("SELECT bar, foo, 42, 'awesome' FROM foobar WHERE foo<2")
box.sql.execute("SELECT bar, foo, 42, 'awesome' FROM foobar WHERE foo<2.001")
box.sql.execute("SELECT bar, foo, 42, 'awesome' FROM foobar WHERE foo<=2")
box.sql.execute("SELECT bar, foo, 42, 'awesome' FROM foobar WHERE foo<100")
box.sql.execute("SELECT bar, foo, 42, 'awesome' FROM foobar WHERE bar='foo'")
box.sql.execute("SELECT count(*) FROM foobar")
box.sql.execute("SELECT count(*) FROM foobar WHERE bar='foo'")
box.sql.execute("SELECT bar, foo, 42, 'awesome' FROM foobar ORDER BY bar")
box.sql.execute("SELECT bar, foo, 42, 'awesome' FROM foobar ORDER BY bar DESC")

-- updates
box.sql.execute("REPLACE INTO foobar VALUES (1, 'cacodaemon')")
box.sql.execute("SELECT COUNT(*) FROM foobar WHERE foo=1")
box.sql.execute("SELECT COUNT(*) FROM foobar WHERE bar='cacodaemon'")
box.sql.execute("DELETE FROM foobar WHERE bar='cacodaemon'")
box.sql.execute("SELECT COUNT(*) FROM foobar WHERE bar='cacodaemon'")

-- cleanup
box.space.foobar:drop()

-- multi-index

-- create space
box.sql.execute("CREATE TABLE barfoo (bar, foo NUM PRIMARY KEY) WITHOUT ROWID")
box.sql.execute("CREATE UNIQUE INDEX barfoo2 ON barfoo(bar)")

-- prepare data
box.space.barfoo:insert({'foo', 1})
box.space.barfoo:insert({'bar', 2})
box.space.barfoo:insert({'foobar', 1000})

-- prove barfoo2 was created
box.space.barfoo:insert({'xfoo', 1})

box.sql.execute("SELECT foo, bar FROM barfoo")
box.sql.execute("SELECT foo, bar FROM barfoo WHERE foo==2")
box.sql.execute("SELECT foo, bar FROM barfoo WHERE bar=='foobar'")
box.sql.execute("SELECT foo, bar FROM barfoo WHERE foo>=2")
box.sql.execute("SELECT foo, bar FROM barfoo WHERE foo<=2")

-- cleanup
box.sql.execute("DROP INDEX barfoo2")
barfoo:drop()
