note
	description: "[
		Rosetta Code: Sleep
		https://rosettacode.org/wiki/Sleep
		
		Pause program execution for a specified time.
	]"
	author: "Simple Eiffel"
	see_also: "https://github.com/simple-eiffel - Modern Eiffel libraries"
	rosetta_task: "Sleep"

class
	SLEEP

create
	make

feature {NONE} -- Initialization

	make
		local
			env: EXECUTION_ENVIRONMENT
		do
			create env
			print ("Sleeping for 2 seconds...%N")
			env.sleep (2_000_000_000) -- nanoseconds
			print ("Awake!%N")
		end

end
