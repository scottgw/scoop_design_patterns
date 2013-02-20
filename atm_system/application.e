class
	APPLICATION

inherit
	ARGUMENTS

create
	make

feature {NONE} -- Initialization
	atm_configurations: ARRAY [separate ATM_CONFIGURATION]

	make
			-- Run application.
		do
			initialize (10, 3)
		end

	initialize (no_of_customers: INTEGER; no_of_atms: INTEGER)
		local
			ratio: INTEGER
			i, j: INTEGER
			customer: separate CUSTOMER
			atm: separate ATM
			server: separate SERVER
			reply_queue_conduit: separate REPLY_QUEUE_CONDUIT [MESSAGE]
			reply_queue_callback: separate REPLY_QUEUE_CALLBACK [MESSAGE]
			pension: separate CUSTOMER
		do
			-- Initialize server.
			create reply_queue_conduit.make
			create reply_queue_callback.make
			create server.make (reply_queue_conduit, reply_queue_callback)
			start_server (server, no_of_customers)

			-- Initialize ATMs and customers.
			create atm_configurations.make (1, no_of_atms)

			from
				i := 0
				j := 0
			until
				i = no_of_atms - 1
			loop
				i := i + 1
				create atm.make_with_id (reply_queue_conduit, reply_queue_callback, i)
				start_atm (atm, i)
				if ratio > 0 then
					create customer.make
					start_customers (customer, i, ratio, ratio)
					j := j + ratio
				end
			end
			i := i + 1
			create atm.make_with_id (reply_queue_conduit, reply_queue_callback, i)
			start_atm (atm, i)
			if no_of_customers - j > 0 then
				create customer.make
				start_customers (customer, i, ratio, no_of_customers - j)
				j := j + no_of_customers - j
			end
		end

	start_server (a_server: separate SERVER; a_number_of_customers: INTEGER)
		do
			a_server.initialize (a_number_of_customers)
			a_server.start
		end

	start_atm (a_atm: separate ATM; a_number: INTEGER)
		do
			atm_configurations.put (a_atm.configuration, a_number)
			a_atm.start
		end

	start_customers (a_customer: separate CUSTOMER; a_atm_no: INTEGER; ratio: INTEGER; total: INTEGER)
		local
			i: INTEGER
		do
			from
				i := 1
			until
				i > total
			loop
				a_customer.take_identity ((a_atm_no - 1) * ratio + i, (a_atm_no - 1) * ratio + i, (a_atm_no - 1) * ratio + i)
				a_customer.retrieve_balance (atm_configurations[a_atm_no])
				a_customer.withdraw (atm_configurations[a_atm_no], 500)
				a_customer.transfer (atm_configurations[a_atm_no], 500, 0)
				a_customer.retrieve_balance (atm_configurations[a_atm_no])
				i := i + 1
			end
		end
end
