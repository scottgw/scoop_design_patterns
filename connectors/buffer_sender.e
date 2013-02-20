note
	description: "Summary description for {BUFFER_SENDER}."
	author: ""
	date: "$Date: 2012-06-04 10:27:40 +0200 (Mon, 04 Jun 2012) $"
	revision: "$Revision$"

class
	BUFFER_SENDER [G]

inherit
	MESSAGE_SENDER [G]

create
	make

feature {NONE}
	make (a_conduit: separate BUFFER_CONDUIT [G])
		do
			conduit := a_conduit
		end

feature
	send (a_msg: G)
		do
			sep_send (conduit, a_msg)
			sep_rendezvous (conduit)
		end

feature {NONE}
	sep_send (a_conduit: separate BUFFER_CONDUIT [G]; a_msg: G)
		require
			not a_conduit.is_filled and not a_conduit.is_working
		do
			a_conduit.fill (a_msg)
		ensure
			a_conduit.is_filled
		end

	sep_rendezvous (a_conduit: separate BUFFER_CONDUIT [G])
		require
			not a_conduit.is_filled and a_conduit.is_working
		do
			a_conduit.finish_working
		end


	conduit: separate BUFFER_CONDUIT [G]

end
