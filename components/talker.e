class
	TALKER

inherit
	PERIODIC_ALGORITHM
		redefine
			initialize,
			step
		end

create
	make

feature
	initialize
		do
			counter := 0
		end

	step
		do
			io.put_string ("Activated%N")
			counter := counter + 1
			if counter = 10 then
				is_done := True
			end
		end

	counter: INTEGER
end
