note
	description : "behav_pattern application root class"
	date        : "$Date: 2012-05-10 14:12:18 +0200 (Thu, 10 May 2012) $"
	revision    : "$Revision$"

class
	CONNECTOR_TEST

inherit
	ARGUMENTS

create
	make

feature {NONE} -- Initialization

	make
		local
			async_conduit: separate ASYNC_QUEUE_CONDUIT [INTEGER]
			async_send: separate ASYNC_QUEUE_SENDER [INTEGER]
			async_recv: separate ASYNC_QUEUE_RECEIVER [INTEGER]
			i: INTEGER
		do
			create async_conduit.make
			create async_send.make (async_conduit)
			create async_recv.make (async_conduit)
			io.put_string ("Test%N")

			test_send (async_send, 42)
			test_send (async_send, 100)

			io.put_string(test_recv (async_recv).out + "%N")
			io.put_string(test_recv (async_recv).out + "%N")
		end

	test_recv (recv: separate ASYNC_QUEUE_RECEIVER [INTEGER]): INTEGER
		do
			Result := recv.receive
		end

	test_send (send: separate ASYNC_QUEUE_SENDER [INTEGER]; i: INTEGER)
		do
			send.send (i)
		end

end
