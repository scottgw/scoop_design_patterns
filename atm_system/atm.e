class
	ATM

inherit
	STATE_DEPENDENT

	STRING_HELPER

create
	make_with_id

feature
	card_reader_receive_interface: BUFFER_RECEIVER [MESSAGE]
	card_reader_send_interface: BUFFER_SENDER [MESSAGE]
	server_send_interface: REPLY_QUEUE_SENDER [MESSAGE, MESSAGE]
	touchscreen_send_interface: REPLY_SENDER [MESSAGE, MESSAGE]
	receipt_printer_send_interface: BUFFER_SENDER [MESSAGE]
	cash_dispenser_send_interface: BUFFER_SENDER [MESSAGE]
--	log_send_interface: ASYNC_QUEUE_SENDER [separate STRING]

feature
	id: INTEGER

	make_with_id (
		a_server_send_conduit: separate REPLY_QUEUE_CONDUIT [MESSAGE];
		a_server_reply_conduit: separate REPLY_QUEUE_CALLBACK [MESSAGE];
		a_id: INTEGER
	)
		local
			l_send_buffer_conduit: separate BUFFER_CONDUIT [MESSAGE]
			l_reply_buffer_conduit: separate BUFFER_CONDUIT [MESSAGE]
			l_receive_buffer_conduit: separate BUFFER_CONDUIT [MESSAGE]

			l_touchscreen: separate TOUCHSCREEN
			l_card_reader: separate CARD_READER
			l_receipt_printer: separate RECEIPT_PRINTER
			l_cash_dispenser: separate CASH_DISPENSER

			l_log: separate LOG
			l_async_queue_conduit: separate ASYNC_QUEUE_CONDUIT [separate STRING]
		do
			create l_receive_buffer_conduit
			create l_send_buffer_conduit
			create l_card_reader.make (l_receive_buffer_conduit, l_send_buffer_conduit)
			create card_reader_receive_interface.make (l_receive_buffer_conduit)
			create card_reader_send_interface.make (l_send_buffer_conduit)

			create l_send_buffer_conduit
			create l_reply_buffer_conduit
			create l_touchscreen.make (l_send_buffer_conduit, l_reply_buffer_conduit)
			create touchscreen_send_interface.make (l_send_buffer_conduit, l_reply_buffer_conduit)

			create l_send_buffer_conduit
			create l_receipt_printer.make (l_send_buffer_conduit)
			create receipt_printer_send_interface.make (l_send_buffer_conduit)

			create l_send_buffer_conduit
			create l_cash_dispenser.make (l_send_buffer_conduit)
			create cash_dispenser_send_interface.make (l_send_buffer_conduit)

			create configuration.make (l_card_reader, l_touchscreen, l_receipt_printer, l_cash_dispenser)

			create server_send_interface.make (a_server_send_conduit, a_server_reply_conduit)

--			create l_async_queue_conduit.make
--			create l_log.make_with_conduit (l_async_queue_conduit, 1000 * 1000)
--			create log_send_interface.make (l_async_queue_conduit)
--			start_log (l_log)

			id := a_id
		end

	configuration: separate ATM_CONFIGURATION

--	start_log (a_log: separate LOG)
--		do
--			a_log.start
--		end

feature
	start
		local
			l_message: MESSAGE
			l_card_number: INTEGER
			l_pin: INTEGER
			l_amount: INTEGER
			l_destination_account_number: INTEGER
			l_balance: INTEGER
		do
			from

			until
				False
			loop
				l_message := card_reader_receive_interface.receive
				l_card_number := l_message.card_inserted_message.card_number

				l_pin := touchscreen_send_interface.send (create {MESSAGE}.make_for_pin_retrieval).pin_report_message.pin
				if is_pin_valid (l_card_number, l_pin) then
--					log_send_interface.send (separate_str ("PIN valid"))

					l_message := touchscreen_send_interface.send (create {MESSAGE}.make_for_success_report)
					l_message := touchscreen_send_interface.send (create {MESSAGE}.make_for_command_retrieval)

					if l_message.is_withdrawal_message then
						l_amount := l_message.withdrawal_message.amount
						server_send_interface.send (create {MESSAGE}.make_for_withdrawal (l_card_number, l_amount))
						if server_send_interface.accept.report_message.has_succeeded then
							l_message := touchscreen_send_interface.send (create {MESSAGE}.make_for_success_report)
							receipt_printer_send_interface.send (create {MESSAGE}.make_for_receipt_printing)
							card_reader_send_interface.send (create {MESSAGE}.make_for_card_return)
							cash_dispenser_send_interface.send (create {MESSAGE}.make_for_cash_dispensing (l_amount))
						else
							l_message := touchscreen_send_interface.send (create {MESSAGE}.make_for_failure_report)
						end
					elseif l_message.is_transfer_message then
						l_amount := l_message.transfer_message.amount
						l_destination_account_number := l_message.transfer_message.destination_account_number
						server_send_interface.send (create {MESSAGE}.make_for_transfer (l_card_number, l_amount, l_destination_account_number))
						if server_send_interface.accept.report_message.has_succeeded then
							l_message := touchscreen_send_interface.send (create {MESSAGE}.make_for_success_report)
							receipt_printer_send_interface.send (create {MESSAGE}.make_for_receipt_printing)
							card_reader_send_interface.send (create {MESSAGE}.make_for_card_return)
						else
							l_message := touchscreen_send_interface.send (create {MESSAGE}.make_for_failure_report)
						end
					elseif l_message.is_balance_retrieval_message then
						server_send_interface.send (create {MESSAGE}.make_for_balance_retrieval (l_card_number))
						l_balance := server_send_interface.accept.balance_report_message.balance
						l_message := touchscreen_send_interface.send (create {MESSAGE}.make_for_balance_report (l_balance))
						receipt_printer_send_interface.send (create {MESSAGE}.make_for_receipt_printing)
						card_reader_send_interface.send (create {MESSAGE}.make_for_card_return)
					end
				else
--					log_send_interface.send (separate_str ("PIN invalid"))
					l_message := touchscreen_send_interface.send (create {MESSAGE}.make_for_failure_report)
				end
			end
		end

feature
	is_successful: BOOLEAN

	withdraw (a_atm_card_number: INTEGER; a_pin: INTEGER; a_amount: INTEGER)
		do
			if is_pin_valid (a_atm_card_number, a_pin) then
				server_send_interface.send (create {MESSAGE}.make_for_withdrawal (a_atm_card_number, a_amount))
				if server_send_interface.accept.report_message.has_succeeded then
					is_successful := True
				else
					is_successful := False
				end
			else
				is_successful := False
			end
		end

	transfer (a_atm_card_number: INTEGER; a_pin: INTEGER; a_amount: INTEGER; a_destination_account_number: INTEGER)
		do
			if is_pin_valid (a_atm_card_number, a_pin) then
				server_send_interface.send (create {MESSAGE}.make_for_transfer (a_atm_card_number, a_amount, a_destination_account_number))
				if server_send_interface.accept.report_message.has_succeeded then
					is_successful := True
				else
					is_successful := False
				end
			else
				is_successful := False
			end
		end

	retrieve_balance (a_atm_card_number: INTEGER; a_pin: INTEGER)
		do
			if is_pin_valid (a_atm_card_number, a_pin) then
				is_successful := True
				server_send_interface.send (create {MESSAGE}.make_for_balance_retrieval (a_atm_card_number))
				balance := server_send_interface.accept.balance_report_message.balance
			else
				is_successful := False
			end
		end

	balance: INTEGER

	is_pin_valid (a_atm_card_number: INTEGER; a_pin: INTEGER): BOOLEAN
		do
			server_send_interface.send (create {MESSAGE}.make_for_pin_validation (a_atm_card_number, a_pin))
			Result := server_send_interface.accept.report_message.has_succeeded
		end

feature {NONE}

end
