class
	TIMER

inherit
	CONTROL
	PERIODIC
		rename
			step as trigger
		redefine
			trigger,
			is_done
		end

create
	make

feature
	frozen make (a_interval: INTEGER)
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

	trigger
		do
		end

	is_done: BOOLEAN
end
