note
	description: "[
		Rosetta Code: Hostname
		https://rosettacode.org/wiki/Hostname

		Get the hostname of the current machine.
	]"
	author: "Eiffel Solution"
	rosetta_task: "Hostname"

class
	HOSTNAME

create
	make

feature {NONE} -- Initialization

	make
			-- Display the hostname.
		local
			env: EXECUTION_ENVIRONMENT
		do
			create env

			-- Method 1: Using environment variable
			if attached env.get ("COMPUTERNAME") as name then
				print ("Hostname (COMPUTERNAME): " + name + "%N")
			elseif attached env.get ("HOSTNAME") as name then
				print ("Hostname (HOSTNAME): " + name + "%N")
			else
				print ("Hostname environment variable not found%N")
			end

			-- Note: For more robust hostname detection,
			-- use platform-specific socket APIs
		end

end
