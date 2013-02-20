note
	description: "Summary description for {ASYNC_QUEUE_RECEIVER}."
	author: ""
	date: "$Date: 2012-05-11 09:31:21 +0200 (Fri, 11 May 2012) $"
	revision: "$Revision$"

class
	ASYNC_QUEUE_RECEIVER [G]

inherit
	MESSAGE_RECEIVER [G]

create
	make

feature {NONE}
	make (a_conduit: separate ASYNC_QUEUE_CONDUIT [G])
		do
			conduit := a_conduit
		end

feature
	receive: separate G
		do
			Result := sep_receive (conduit)
		end

feature {NONE}
	conduit: separate ASYNC_QUEUE_CONDUIT [G]

	sep_receive (a_conduit: separate ASYNC_QUEUE_CONDUIT [G]): separate G
		require
			not a_conduit.is_empty
		do
			Result := a_conduit.dequeue
		end

end
