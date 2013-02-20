expanded class
	ATM_CARD

create
	make,
	default_create

feature {NONE}
	make (a_card_number: INTEGER)
		do
			card_number := a_card_number
		end

feature {CARD_READER, CUSTOMER}
	card_number: INTEGER

end
