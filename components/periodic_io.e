class
	PERIODIC_IO

inherit
	IO
	PERIODIC
		redefine
			step,
			is_done
		end

create
	make

feature {NONE}
	make (a_interval: INTEGER)
		do
			initialize_iteration (a_interval)
		end

feature
	frozen start
		do
			is_done := False
			initialize
			start_iteration
		end

feature {NONE}
	initialize
		do
		end

	step
		do
		end

	is_done: BOOLEAN
end

