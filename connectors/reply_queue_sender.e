note
	description: "Summary description for {REPLY_SENDER}."
	author: ""
	date: "$Date: 2012-06-04 10:27:40 +0200 (Mon, 04 Jun 2012) $"
	revision: "$Revision: 2944 $"

class
	REPLY_QUEUE_SENDER [G, H]

inherit
	MESSAGE_SENDER [G]
	HASHABLE

create
	make

feature
	send (a_msg: G)
		do
			sep_send (a_msg, sender_conduit)
		end

	accept: separate H
		do
			Result := sep_accept (receive_conduit)
		end

feature {NONE}
	hash_code: INTEGER
		do
			Result := 0
		end

	sender_conduit: separate REPLY_QUEUE_CONDUIT [G]
	receive_conduit: separate REPLY_QUEUE_CALLBACK [H]

	make (a_send_conduit: separate REPLY_QUEUE_CONDUIT [G];
	      a_receive_conduit: separate REPLY_QUEUE_CALLBACK [H])
		do
			sender_conduit := a_send_conduit
			receive_conduit := a_receive_conduit
		end



	sep_send (a_msg: G; a_sender_conduit: separate REPLY_QUEUE_CONDUIT [G])
		require
			not a_sender_conduit.is_full
		do
			a_sender_conduit.put (a_msg, Current)
		end

	sep_accept (a_receive_conduit: separate REPLY_QUEUE_CALLBACK [H]): separate H
		require
			a_receive_conduit.has_answer_for (Current)
		do
			Result := a_receive_conduit.remove (Current)
		end

end
