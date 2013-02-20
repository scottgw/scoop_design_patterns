class
	PERIODIC

feature {NONE}
	frozen initialize_iteration (a_interval: INTEGER)
		do
			create pacemaker.make
			interval := a_interval
		end

	frozen start_iteration
		do
			step
			activate_pacemaker (interval, pacemaker)
		end

feature {NONE}
	step
		do

		end

	is_done: BOOLEAN

feature {NONE}
	activate_pacemaker (a_interval: INTEGER; a_pacemaker: separate PACEMAKER)
		do
			a_pacemaker.activate (a_interval, Current)
		end

	pacemaker: separate PACEMAKER

	interval: INTEGER

feature {PACEMAKER}
	notify
		do
			step
			if not is_done then
				activate_pacemaker (interval, pacemaker)
			end
		end

end
