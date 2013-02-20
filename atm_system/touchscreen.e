class
	TOUCHSCREEN

inherit
	REPLY_RECEIVER [MESSAGE, MESSAGE]
	ASYNC_IO

create
	make

feature
	read_pin (a_pin: INTEGER)
		local
			l_message: MESSAGE
		do
			l_message := receive
			if l_message.is_pin_retrieval_message then
				reply (create {MESSAGE}.make_for_pin_report (a_pin))
			end
		end

	select_withdrawal (a_amount: INTEGER)
		local
			l_message: MESSAGE
		do
			l_message := receive
			if l_message.is_command_retrieval_message then
				reply (create {MESSAGE}.make_for_withdrawal (-1, a_amount))
			end
		end

	select_transfer (a_amount: INTEGER; a_destination_account_number: INTEGER)
		local
			l_message: MESSAGE
		do
			l_message := receive
			if l_message.is_command_retrieval_message then
				reply (create {MESSAGE}.make_for_transfer (-1, a_amount, a_destination_account_number))
			end
		end

	select_balance_retrieval
		local
			l_message: MESSAGE
		do
			l_message := receive
			if l_message.is_command_retrieval_message then
				reply (create {MESSAGE}.make_for_balance_retrieval (-1))
			end
		end

	balance: INTEGER
		local
			l_message: MESSAGE
		do
			l_message := receive
			Result := l_message.balance_report_message.balance
			reply (create {MESSAGE}.make_for_success_report)
		end

	has_succeeded: BOOLEAN
		local
			l_message: MESSAGE
		do
			l_message := receive
			if l_message.is_report_message then
				Result := l_message.report_message.has_succeeded
				reply (create {MESSAGE}.make_for_success_report)
			end
		end

end
