expanded class
	MESSAGE

create
	make_for_pin_validation,
	make_for_withdrawal,
	make_for_transfer,
	make_for_balance_retrieval,
	make_for_balance_report,
	make_for_success_report,
	make_for_failure_report,
	make_for_card_inserted,
	make_for_pin_retrieval,
	make_for_pin_report,
	make_for_command_retrieval,
	make_for_receipt_printing,
	make_for_cash_dispensing,
	make_for_card_return,
	default_create

feature {NONE}
	card_number: INTEGER
	amount: INTEGER
	pin: INTEGER
	destination_account_number: INTEGER
	balance: INTEGER
	has_succeeded: BOOLEAN

feature {NONE}
	make_for_pin_validation (a_card_number: INTEGER; a_pin: INTEGER)
		do
			mode := validate_pin_mode
			card_number := a_card_number
			pin := a_pin
		end

	make_for_withdrawal (a_card_number: INTEGER; a_amount: INTEGER)
		do
			mode := withdraw_mode
			card_number := a_card_number
			amount := a_amount
		end

	make_for_transfer (a_card_number: INTEGER; a_amount: INTEGER; a_destination_account_number: INTEGER)
		do
			mode := transfer_mode
			card_number := a_card_number
			amount := a_amount
			destination_account_number := a_destination_account_number
		end

	make_for_balance_retrieval (a_card_number: INTEGER)
		do
			mode := balance_retrieval_mode
			card_number := a_card_number
		end

	make_for_balance_report (a_balance: INTEGER)
		do
			mode := balance_report_mode
			balance := a_balance
		end

	make_for_success_report
		do
			mode := report_mode
			has_succeeded := True
		end

	make_for_failure_report
		do
			mode := report_mode
			has_succeeded := False
		end

	make_for_card_inserted (a_card_number: INTEGER)
		do
			mode := card_inserted_mode
			card_number := a_card_number
		end

	make_for_pin_retrieval
		do
			mode := pin_retrieval_mode
		end

	make_for_pin_report (a_pin: INTEGER)
		do
			mode := pin_report_mode
			pin := a_pin
		end

	make_for_command_retrieval
		do
			mode := command_retrieval_mode
		end

	make_for_receipt_printing
		do
			mode := print_receipt_mode
		end

	make_for_cash_dispensing (a_amount: INTEGER)
		do
			mode := dispense_cash_mode
			amount := a_amount
		end

	make_for_card_return
		do
			mode := return_card_mode
		end

feature {NONE}
	mode: INTEGER
	empty_mode: INTEGER = 0
	validate_pin_mode: INTEGER = 1
	withdraw_mode: INTEGER = 2
	transfer_mode: INTEGER = 3
	balance_retrieval_mode: INTEGER = 4
	balance_report_mode: INTEGER = 5
	report_mode: INTEGER = 6
	card_inserted_mode: INTEGER = 7
	pin_retrieval_mode: INTEGER = 8
	pin_report_mode: INTEGER = 9
	command_retrieval_mode: INTEGER = 10
	print_receipt_mode: INTEGER = 11
	dispense_cash_mode: INTEGER = 12
	return_card_mode: INTEGER = 13

feature
	is_pin_validation_message: BOOLEAN
		do
			Result := mode = validate_pin_mode
		end

	pin_validation_message: TUPLE[card_number: INTEGER; pin: INTEGER]
		require
			is_pin_validation_message
		do
			Result := [card_number, pin]
		end

	is_withdrawal_message: BOOLEAN
		do
			Result := mode = withdraw_mode
		end

	withdrawal_message: TUPLE[card_number: INTEGER; amount: INTEGER]
		require
			is_withdrawal_message
		do
			Result := [card_number, amount]
		end

	is_transfer_message: BOOLEAN
		do
			Result := mode = transfer_mode
		end

	transfer_message: TUPLE[card_number: INTEGER; amount: INTEGER; destination_account_number: INTEGER]
		require
			is_transfer_message
		do
			Result := [card_number, amount, destination_account_number]
		end

	is_balance_retrieval_message: BOOLEAN
		do
			Result := mode = balance_retrieval_mode
		end

	balance_retrieval_message: TUPLE[card_number: INTEGER]
		require
			is_balance_retrieval_message
		do
			Result := [card_number]
		end

	is_balance_report_message: BOOLEAN
		do
			Result := mode = balance_report_mode
		end

	balance_report_message: TUPLE[balance: INTEGER]
		require
			is_balance_report_message
		do
			Result := [balance]
		end

	is_report_message: BOOLEAN
		do
			Result := mode = report_mode
		end

	report_message: TUPLE[has_succeeded: BOOLEAN]
		require
			is_report_message
		do
			Result := [has_succeeded]
		end

	is_card_inserted_message: BOOLEAN
		do
			Result := mode = card_inserted_mode
		end

	card_inserted_message: TUPLE[card_number: INTEGER]
		require
			is_card_inserted_message
		do
			Result := [card_number]
		end

	is_pin_retrieval_message: BOOLEAN
		do
			Result := mode = pin_retrieval_mode
		end

	pin_retrieval_message: TUPLE[]
		require
			is_pin_retrieval_message
		do
			Result := []
		end

	is_pin_report_message: BOOLEAN
		do
			Result := mode = pin_report_mode
		end

	pin_report_message: TUPLE[pin: INTEGER]
		require
			is_pin_report_message
		do
			Result := [pin]
		end

	is_command_retrieval_message: BOOLEAN
		do
			Result := mode = command_retrieval_mode
		end

	command_retrieval_message: TUPLE[]
		require
			is_command_retrieval_message
		do
			Result := []
		end

	is_receipt_printing_message: BOOLEAN
		do
			Result := mode = print_receipt_mode
		end

	receipt_printing_message: TUPLE[]
		require
			is_receipt_printing_message
		do
			Result := []
		end

	is_cash_dispensing_message: BOOLEAN
		do
			Result := mode = dispense_cash_mode
		end

	cash_dispensing_message: TUPLE[amount: INTEGER]
		require
			is_cash_dispensing_message
		do
			Result := [amount]
		end

	is_card_return_message: BOOLEAN

	card_return_message: TUPLE[]
		require
			is_card_return_message
		do
			Result := []
		end

invariant
	mode = empty_mode or
	mode = validate_pin_mode or
	mode = withdraw_mode or
	mode = transfer_mode or
	mode = balance_retrieval_mode or
	mode = balance_report_mode or
	mode = report_mode or
	mode = card_inserted_mode or
	mode = pin_retrieval_mode or
	mode = pin_report_mode or
	mode = command_retrieval_mode or
	mode = print_receipt_mode or
	mode = dispense_cash_mode or
	mode = return_card_mode
end
