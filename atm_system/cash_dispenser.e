class
	CASH_DISPENSER

inherit
	BUFFER_RECEIVER [MESSAGE]

create
	make

feature
	dispense_cash: INTEGER
		local
			l_message: MESSAGE
		do
			l_message := receive
			Result := l_message.cash_dispensing_message.amount
		end
end
