note
	description: "Summary description for {BUFFER_RECEIVER}."
	author: ""
	date: "$Date: 2012-04-05 12:42:33 +0200 (Thu, 05 Apr 2012) $"
	revision: "$Revision$"

class
	BUFFER_RECEIVER [G]

inherit
	MESSAGE_RECEIVER [G]

create
	make

feature {NONE}
	make (a_conduit: separate BUFFER_CONDUIT [G])
		do
			conduit := a_conduit
		end

feature
	receive: separate G
		do
			Result := sep_receive (conduit)
		end

feature {NONE}
	sep_receive (a_conduit: separate BUFFER_CONDUIT [G]): detachable separate G
		require
			a_conduit.is_filled
		do
			Result := a_conduit.drain
		end

	conduit: separate BUFFER_CONDUIT [G]

end
