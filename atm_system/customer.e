class
	CUSTOMER

create
	make

feature {NONE}
	make
		do
		end

feature
	take_identity (a_identifier: INTEGER; a_atm_card_number: INTEGER; a_pin: INTEGER)
		do
			identifier := a_identifier
			atm_card := create {ATM_CARD}.make(a_atm_card_number)
			pin := a_pin
		end

feature {NONE}
	identifier: INTEGER
	atm_card: ATM_CARD
	pin: INTEGER

feature
	withdraw (a_atm_configuration: separate ATM_CONFIGURATION; a_amount: INTEGER)
		do
			insert_card (a_atm_configuration.card_reader)
			enter_pin (a_atm_configuration.touchscreen)
			if has_succeeded (a_atm_configuration.touchscreen) then
				select_withdrawal (a_atm_configuration.touchscreen, a_amount)
				if has_succeeded (a_atm_configuration.touchscreen) then
					receive_receipt (a_atm_configuration.receipt_printer)
					retrieve_card (a_atm_configuration.card_reader)
					receive_cash (a_atm_configuration.cash_dispenser)
					print ("Customer " + identifier.out + ": withdrawal successful.%N")
				else
					print ("Customer " + identifier.out + ": withdrawal failed due to insufficient balance.%N")
				end
			else
				print ("Customer " + identifier.out + ": withdrawal failed due to wrong pin.%N")
			end
		end

	transfer (a_atm_configuration: separate ATM_CONFIGURATION; a_amount: INTEGER; a_destination_account_number: INTEGER)
		do
			insert_card (a_atm_configuration.card_reader)
			enter_pin (a_atm_configuration.touchscreen)
			if has_succeeded (a_atm_configuration.touchscreen) then
				select_transfer (a_atm_configuration.touchscreen, a_amount, a_destination_account_number)
				if has_succeeded (a_atm_configuration.touchscreen) then
					receive_receipt (a_atm_configuration.receipt_printer)
					retrieve_card (a_atm_configuration.card_reader)
					print ("Customer " + identifier.out + ": transfer to " + a_destination_account_number.out + " successful%N")
				else
					print ("Customer " + identifier.out + ": transfer to " + a_destination_account_number.out + " failed due to insufficient balance%N")
				end
			else
				print ("Customer " + identifier.out + ": transfer to " + a_destination_account_number.out + " failed due to wrong pin%N")
			end
		end

	retrieve_balance (a_atm_configuration: separate ATM_CONFIGURATION)
		local
			l_balance: INTEGER
		do
			insert_card (a_atm_configuration.card_reader)
			enter_pin (a_atm_configuration.touchscreen)
			if has_succeeded (a_atm_configuration.touchscreen) then
				select_balance_retrieval (a_atm_configuration.touchscreen)
				print ("Customer " + identifier.out + ": balance is " + balance (a_atm_configuration.touchscreen).out + "%N")
				receive_receipt (a_atm_configuration.receipt_printer)
				retrieve_card (a_atm_configuration.card_reader)
			else
				print ("Customer " + identifier.out + ": balance retrieval failed due to wrong pin%N")
			end
		end

feature {NONE}
	insert_card (a_card_reader: separate CARD_READER)
		do
			a_card_reader.take_card (atm_card)
		end

	enter_pin (a_touchscreen: separate TOUCHSCREEN)
		do
			a_touchscreen.read_pin (pin)
		end

	select_withdrawal (a_touchscreen: separate TOUCHSCREEN; a_amount: INTEGER)
		do
			a_touchscreen.select_withdrawal (a_amount)
		end

	select_transfer (a_touchscreen: separate TOUCHSCREEN; a_amount: INTEGER; a_destination_account_number: INTEGER)
		do
			a_touchscreen.select_transfer (a_amount, a_destination_account_number)
		end

	select_balance_retrieval (a_touchscreen: separate TOUCHSCREEN)
		do
			a_touchscreen.select_balance_retrieval
		end

	has_succeeded (a_touchscreen: separate TOUCHSCREEN): BOOLEAN
		do
			Result := a_touchscreen.has_succeeded
		end

	balance (a_touchscreen: separate TOUCHSCREEN): INTEGER
		do
			Result := a_touchscreen.balance
		end

	receive_receipt (a_receipt_printer: separate RECEIPT_PRINTER)
		local
			l_receipt: INTEGER
		do
			l_receipt := a_receipt_printer.print_receipt
		end

	retrieve_card (a_card_reader: separate CARD_READER)
		local
			l_card: ATM_CARD
		do
			l_card := a_card_reader.return_card
		end

	receive_cash (a_cash_dispenser: separate CASH_DISPENSER)
		local
			l_cash: INTEGER
		do
			l_cash := a_cash_dispenser.dispense_cash
		end
end
