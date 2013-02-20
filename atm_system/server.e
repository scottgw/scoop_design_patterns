class
	SERVER

inherit
	REPLY_QUEUE_RECEIVER [MESSAGE, MESSAGE]
		redefine
			make
		end
	ASYNC_COORDINATOR

create
	make

feature
	-- log_send_interface: ASYNC_QUEUE_SENDER [separate STRING]

feature
	make (a_send_conduit: separate REPLY_QUEUE_CONDUIT [MESSAGE];
	      a_receive_conduit: separate REPLY_QUEUE_CALLBACK [MESSAGE])
	    local
	    	l_async_queue_conduit: separate ASYNC_QUEUE_CONDUIT [separate STRING]
	    	-- l_log: separate LOG
		do
			Precursor (a_send_conduit, a_receive_conduit)
			-- create l_async_queue_conduit.make
			-- create l_log.make (l_async_queue_conduit)
			-- create log_send_interface.make (l_async_queue_conduit)
		end

	initialize (a_number_of_customers: INTEGER)
			-- Add the indicated number of customers. Add a pension with pin 0, card number 0, account number 0, and balance 0.
		local i: INTEGER
		do
			-- Add customers.
			create pins.make (a_number_of_customers)
			create accounts.make (a_number_of_customers)
			create balances.make (a_number_of_customers)
			from
				i := 1
			until
				i > a_number_of_customers
			loop
				pins.put (i, i)
				accounts.put (i, i)
				balances.put (1000, i)
				i := i + 1
			end

			-- Pension.
			pins.put (0, 0)
			accounts.put (0, 0)
			balances.put (0, 0)
		end

	start
		local
			l_received_message: MESSAGE
			l_card_number: INTEGER
			l_amount: INTEGER
			l_pin: INTEGER
			l_destination_account_number: INTEGER
		do
			from
			until False
			loop
				l_received_message := receive;
				-- (create {EXECUTION_ENVIRONMENT}).sleep (1 * 10 * 1000 * 1000)
				if l_received_message.is_pin_validation_message then
					l_card_number := l_received_message.pin_validation_message.card_number
					l_pin := l_received_message.pin_validation_message.pin
					if
						pins.has (l_card_number) and then
						pins.item (l_card_number) = l_pin
					then
						reply (create {MESSAGE}.make_for_success_report)
					else
						reply (create {MESSAGE}.make_for_failure_report)
					end
				elseif l_received_message.is_withdrawal_message then
					l_card_number := l_received_message.withdrawal_message.card_number
					l_amount := l_received_message.withdrawal_message.amount
					if
						accounts.has_key (l_card_number) and then
						balances.item (accounts.item (l_card_number)) >= l_amount
					then
						balances.force (
							balances.item (accounts.item (l_card_number)) - l_amount,
							accounts.item (l_card_number)
						)
						reply (create {MESSAGE}.make_for_success_report)
					else
						reply (create {MESSAGE}.make_for_failure_report)
					end
				elseif l_received_message.is_transfer_message then
					l_card_number := l_received_message.transfer_message.card_number
					l_amount := l_received_message.transfer_message.amount
					l_destination_account_number := l_received_message.transfer_message.destination_account_number
					if
						accounts.has_key (l_card_number) and then
						balances.item (accounts.item (l_card_number)) >= l_amount and then
						balances.has_key (l_destination_account_number)
					then
						balances.force (
							balances.item (accounts.item (l_card_number)) - l_amount,
							accounts.item (l_card_number)
						)
						balances.force (
							balances.item (l_destination_account_number) + l_amount,
							l_destination_account_number
						)
						reply (create {MESSAGE}.make_for_success_report)
					else
						reply (create {MESSAGE}.make_for_failure_report)
					end
				elseif l_received_message.is_balance_retrieval_message then
					l_card_number := l_received_message.balance_retrieval_message.card_number
					reply (create {MESSAGE}.make_for_balance_report (balances.item (accounts.item (l_card_number))))
				end
			end
		end

feature {NONE}
	pins: HASH_TABLE [INTEGER, INTEGER] -- Map from card numbers to pins.
	accounts: HASH_TABLE [INTEGER, INTEGER] -- Map from card numbers to account numbers.
	balances: HASH_TABLE [INTEGER, INTEGER] -- Map from account numbers to balances.
end
