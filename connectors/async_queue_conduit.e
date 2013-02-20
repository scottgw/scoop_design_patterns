note
	description: "Summary description for {ASYNC_QUEUE_CONDUIT}."
	author: ""
	date: "$Date: 2012-05-11 11:54:27 +0200 (Fri, 11 May 2012) $"
	revision: "$Revision$"

class
	ASYNC_QUEUE_CONDUIT [G]

inherit
	CONDUIT [G]

create
	make

feature {NONE}
	make
		do
			create queue.make (100)
		end

feature
	enqueue (x: G)
		do
			queue.extend (x)
		end

	dequeue: G
		do
			Result := queue.item
			queue.remove
		end

	is_empty: BOOLEAN
		do
			Result := queue.is_empty
		end

feature {NONE}
	queue: ARRAYED_QUEUE [G]

end
