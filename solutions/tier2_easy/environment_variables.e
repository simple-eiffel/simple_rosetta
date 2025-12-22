note
	description: "[
		Rosetta Code: Environment variables
		https://rosettacode.org/wiki/Environment_variables

		Get and display environment variables.
	]"
	author: "Eiffel Solution"
	rosetta_task: "Environment_variables"

class
	ENVIRONMENT_VARIABLES

create
	make

feature {NONE} -- Initialization

	make
			-- Display environment variables.
		local
			env: EXECUTION_ENVIRONMENT
		do
			create env

			print ("Environment Variables:%N")
			print ("======================%N")

			-- Get specific variables
			show_var (env, "PATH")
			show_var (env, "HOME")
			show_var (env, "USERPROFILE")
			show_var (env, "USERNAME")
			show_var (env, "COMPUTERNAME")
			show_var (env, "TEMP")
			show_var (env, "ISE_EIFFEL")

			-- Set a variable (for current process only)
			env.put ("Hello from Eiffel!", "MY_EIFFEL_VAR")
			print ("%NAfter setting MY_EIFFEL_VAR:%N")
			show_var (env, "MY_EIFFEL_VAR")
		end

feature {NONE} -- Helpers

	show_var (env: EXECUTION_ENVIRONMENT; name: STRING)
			-- Display environment variable value.
		do
			if attached env.get (name) as value then
				if value.count > 60 then
					print ("  " + name + " = " + value.substring (1, 60) + "...%N")
				else
					print ("  " + name + " = " + value + "%N")
				end
			else
				print ("  " + name + " = (not set)%N")
			end
		end

end
