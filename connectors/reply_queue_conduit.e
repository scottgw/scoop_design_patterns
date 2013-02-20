class
	REPLY_QUEUE_CONDUIT [G]

inherit
	CONDUIT [G]

create
	make

feature {NONE}
	make
		do
			create messages.make
		end

feature
	is_full: BOOLEAN
		do
			Result := False
		end

	is_empty: BOOLEAN
		do
			Result := messages.is_empty
		end

	put (a_msg: G; a_callback: detachable separate ANY)
		require
			not is_full
		do
			messages.extend ([a_msg, a_callback])
		ensure
			not is_empty
		end

	item: TUPLE[msg: G; sender: detachable separate ANY]

	remove
		require
			not is_empty
		do
			item := messages.item
			messages.remove
		ensure
			not is_full
		end

feature {NONE}
	messages: LINKED_QUEUE [TUPLE[msg: G; sender: detachable separate ANY]]

end
