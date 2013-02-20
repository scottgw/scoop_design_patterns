class
	COMPONENTS_TEST

inherit
	ARGUMENTS

create
	make

feature {NONE} -- Initialization

	make
			-- Run application.
		local
			a: separate TALKER
			b: separate TALKER
		do
			create a.make (2 * 1000 * 1000 * 1000)
			create b.make (2 * 1000 * 1000 * 1000)
			start (a, b)
		end

	start (a, b: separate TALKER)
		do
			a.start;
			(create {EXECUTION_ENVIRONMENT}).sleep (1 * 1000 * 1000 * 1000)
			b.start
		end

end
