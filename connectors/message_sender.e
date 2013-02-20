note
	description: "Summary description for {MESSAGE_SENDER}."
	author: ""
	date: "$Date: 2012-04-05 12:42:33 +0200 (Thu, 05 Apr 2012) $"
	revision: "$Revision$"

deferred class
	MESSAGE_SENDER [G]

feature
	send (msg: separate G)
		deferred
		end

end
