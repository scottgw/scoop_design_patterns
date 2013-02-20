class
	LOG

inherit
	PERIODIC_ALGORITHM
		redefine
			step
		end

	STRING_HELPER

create
	make_with_conduit

feature {NONE}
	make_with_conduit (a_conduit: separate ASYNC_QUEUE_CONDUIT [separate STRING]; a_interval: INTEGER)
		do
			make (a_interval)
			create receiver.make (a_conduit)
		end

feature
	step
		do
			process (receiver.receive)
		end

feature {NONE}
	receiver: ASYNC_QUEUE_RECEIVER [separate STRING]

	process (sep_string: separate STRING)
		local
			str: STRING
		do
			str := local_str (sep_string)
			io.put_string ("[LOG]]: " + str + "%N")
		end

end


