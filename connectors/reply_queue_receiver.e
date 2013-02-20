class
	REPLY_QUEUE_RECEIVER [G, H]

inherit
	MESSAGE_RECEIVER [G]

create
	make

feature {NONE}
	sender_conduit: separate REPLY_QUEUE_CONDUIT [G]
	receive_conduit: separate REPLY_QUEUE_CALLBACK [H]
	sender: detachable separate ANY

	make (a_send_conduit: separate REPLY_QUEUE_CONDUIT [G];
	      a_receive_conduit: separate REPLY_QUEUE_CALLBACK [H])
		do
			sender_conduit := a_send_conduit
			receive_conduit := a_receive_conduit
		end

feature
	receive: G
		do
			Result := sep_receive (sender_conduit)
		end

	reply (a_message: H)
		do
			sep_reply (receive_conduit, a_message)
		end

feature {NONE}
	sep_receive (a_conduit: separate REPLY_QUEUE_CONDUIT [G]): G
		require
			not a_conduit.is_empty
		do
			a_conduit.remove
			sender := a_conduit.item.sender
			Result := a_conduit.item.msg
		end

	sep_reply (a_receive_conduit: separate REPLY_QUEUE_CALLBACK [H]; a_message: H)
		do
			a_receive_conduit.put (a_message, sender)
		end
end
