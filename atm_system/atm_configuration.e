class
	ATM_CONFIGURATION

create
	make

feature
	make (a_card_reader: separate CARD_READER; a_touchscreen: separate TOUCHSCREEN; a_receipt_printer: separate RECEIPT_PRINTER; a_cash_dispenser: separate CASH_DISPENSER)
		do
			card_reader := a_card_reader
			touchscreen := a_touchscreen
			receipt_printer := a_receipt_printer
			cash_dispenser := a_cash_dispenser
		end

	card_reader: separate CARD_READER
	touchscreen: separate TOUCHSCREEN
	receipt_printer: separate RECEIPT_PRINTER
	cash_dispenser: separate CASH_DISPENSER
end
