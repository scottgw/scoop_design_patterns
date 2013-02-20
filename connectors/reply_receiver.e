note
	description: "Summary description for {REPLY_RECEIVER}."
	author: ""
	date: "$Date: 2012-06-04 10:27:40 +0200 (Mon, 04 Jun 2012) $"
	revision: "$Revision$"

class
	REPLY_RECEIVER [G, H]

inherit
	BUFFER_RECEIVER [G]
		rename
			make as make_receiver,
			conduit as receive_conduit
		export {NONE}
		  receive
		end

	BUFFER_SENDER [H]
		rename
			make as make_sender,
			conduit as reply_conduit,
			send as reply
		end

create
	make

feature {NONE}
	make (a_receive_conduit: separate BUFFER_CONDUIT [G];
	      a_reply_conduit: separate BUFFER_CONDUIT [H])
		do
			make_receiver (a_receive_conduit)
			make_sender (a_reply_conduit)
		end

end
