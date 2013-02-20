note
	description: "Summary description for {ASYNC_QUEUE_SENDER}."
	author: ""
	date: "$Date: 2012-05-10 14:12:18 +0200 (Thu, 10 May 2012) $"
	revision: "$Revision$"

class
	ASYNC_QUEUE_SENDER [G]

inherit
	MESSAGE_SENDER [G]

create
	make

feature {NONE}
	make (a_conduit: separate ASYNC_QUEUE_CONDUIT [separate G])
		do
			conduit := a_conduit
		end

feature
	send (x: separate G)
		do
			sep_send (conduit, x)
		end

feature {NONE}
	conduit: separate ASYNC_QUEUE_CONDUIT [separate G]

	sep_send (a_conduit: separate ASYNC_QUEUE_CONDUIT [separate G];
	          x: separate G)
		do
			a_conduit.enqueue (x)
		end

end
