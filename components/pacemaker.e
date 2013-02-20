class
	PACEMAKER

create
	make

feature
	make
		do
		end

	activate (nano_seconds: INTEGER; notifyee: detachable separate PERIODIC)
		do
			(create {EXECUTION_ENVIRONMENT}).sleep (nano_seconds)
			if attached {separate PERIODIC} notifyee then
				notify (notifyee)
			end
		end

	notify (notifyee: attached separate PERIODIC)
		do
			notifyee.notify
		end
end
