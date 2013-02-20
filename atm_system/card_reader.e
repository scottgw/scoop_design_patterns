class
	CARD_READER

inherit
	ASYNC_IO

create
	make

feature {NONE}
	atm_send_interface: BUFFER_SENDER [MESSAGE]
	atm_receive_interface: BUFFER_RECEIVER [MESSAGE]
	card: ATM_CARD

	make (a_send_conduit: separate BUFFER_CONDUIT [MESSAGE]; a_receive_conduit: separate BUFFER_CONDUIT [MESSAGE])
		do
			create atm_send_interface.make (a_send_conduit)
			create atm_receive_interface.make (a_receive_conduit)
		end

feature
	take_card (a_card: ATM_CARD)
		do
			card := a_card
			atm_send_interface.send (create {MESSAGE}.make_for_card_inserted (a_card.card_number))
		end

	return_card: ATM_CARD
		local
			l_message: MESSAGE
		do
			l_message := atm_receive_interface.receive
			Result := card
		end

end
