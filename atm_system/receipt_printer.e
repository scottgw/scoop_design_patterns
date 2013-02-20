class
	RECEIPT_PRINTER

inherit
	BUFFER_RECEIVER [MESSAGE]
	ASYNC_IO
	
create
	make

feature
	print_receipt: INTEGER
		local
			l_message: MESSAGE
		do
			l_message := receive
			Result := 0
		end
end

