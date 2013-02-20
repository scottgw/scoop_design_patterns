note
	description: "Summary description for {BUFFER_CONDUIT}."
	author: ""
	date: "$Date: 2012-06-04 10:27:40 +0200 (Mon, 04 Jun 2012) $"
	revision: "$Revision$"

class
	BUFFER_CONDUIT [G]

inherit
	CONDUIT [G]


feature
	is_filled: BOOLEAN
		do
			Result := message /= Void
		end

	is_working: BOOLEAN

	finish_working
		do
			is_working := False
		ensure
			not is_working
		end

	fill (a_msg: G)
		require
			not is_filled and not is_working
		do
			create message.put (a_msg)
			is_working := True
		ensure
			is_filled and is_working
		end

	drain: G
		require
			is_filled and is_working
		do
			Result := message.item
			message := Void
		ensure
			not is_filled
		end

feature {NONE}
	message: CELL [G]

end
