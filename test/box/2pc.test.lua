fiber = require('fiber')

server_id = box.info().server.id
tx_id = fiber.id()

box.begin_two_phase(tx_id, server_id)
box.commit() -- error, because can't commit before prepare

box.prepare_two_phase()
box.commit() -- ok, the transaction is prepared

space = box.schema.space.create('test', { engine = 'vinyl' } )
pk = space:create_index('pk')

-- Make two-phase commit of some tuples.
box.begin_two_phase(tx_id, server_id)
space:replace({1})
space:replace({2})
space:select{}
box.prepare_two_phase()
box.commit()
space:select{}

-- Incorrect begin of two-phase transaction.
box.begin_two_phase('abc', server_id) -- fail with incorrect tx_id.
box.begin_two_phase(tx_id, 'abc')     -- fail with incorrect coordinator id.
box.begin_two_phase(tx_id)            -- not specified coordinator id.

-- Prepare not two-phase transaction.
box.begin()
space:replace({3})
space:replace({4})
box.prepare_two_phase()
box.rollback()
space:select{}

-- Rollback the two-phase transaction.
box.begin_two_phase(tx_id, server_id)
space:replace({3})
space:replace({4})
space:select{}
box.prepare_two_phase()
box.rollback()
space:select{}

-- Rollback before prepare.
box.begin_two_phase(tx_id, server_id)
space:replace({3})
space:replace({4})
space:select{}
box.rollback()
space:select{}

-- Try to change the prepared transaction.
box.begin_two_phase(tx_id, server_id)
space:replace({3})
space:replace({4})
space:select{}
box.prepare_two_phase()
space:replace({5})
box.commit()
space:select{}

space:drop()
