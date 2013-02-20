note
	description: "Summary description for {REPLY_SENDER}."
	author: ""
	date: "$Date: 2012-06-04 10:27:40 +0200 (Mon, 04 Jun 2012) $"
	revision: "$Revision$"

class
	REPLY_SENDER [G, H]

inherit {NONE}
	BUFFER_SENDER [G]
		rename
			make as make_sender,
			conduit as send_conduit,
			send as buff_send
		end

	BUFFER_RECEIVER [H]
		rename
			make as make_receiver,
			conduit as receive_conduit
		end

create
	make

feature {NONE}
	make (a_send_conduit: separate BUFFER_CONDUIT [G];
	      a_receive_conduit: separate BUFFER_CONDUIT [H])
		do
			make_sender (a_send_conduit)
			make_receiver (a_receive_conduit)
		end

feature
	send (a_msg: G): separate H
		do
			buff_send (a_msg)
			Result := receive
		end

--	reply: separate H

end
