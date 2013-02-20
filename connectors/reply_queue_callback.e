note
	description: "Summary description for {REPLY_QUEUE_CALLBACK}."
	author: ""
	date: "$Date: 2012-04-27 13:11:02 +0200 (Fri, 27 Apr 2012) $"
	revision: "$Revision: 2742 $"

class
	REPLY_QUEUE_CALLBACK [G]

create
	make

feature {NONE}
	answers: LINKED_LIST [TUPLE[msg: G; sender: detachable separate ANY]]

	make
		do
			create answers.make
		end

feature
	put (a_answer: G; a_callback: detachable separate ANY)
		do
			answers.extend ([a_answer, a_callback])
		end

	has_answer_for (a_callback: detachable separate ANY): BOOLEAN
		do
			Result := False
			across answers as answer until Result loop
				if answer.item.item(2) = a_callback then
					Result := True
				end
			end
		end

	remove (a_callback: detachable separate ANY): G
		local
			answer_pair: TUPLE [msg: G; sender: detachable separate ANY]
		do
			from
				answers.start
			until
				answers.after
			loop
				answer_pair := answers.item
				if answer_pair.sender = a_callback then
					Result := answer_pair.msg
					answers.remove
				end
				if not answers.after then
					answers.forth
				end
			end
		end

end
