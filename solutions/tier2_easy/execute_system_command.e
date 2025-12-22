note
	description: "[
		Rosetta Code: Execute a system command
		https://rosettacode.org/wiki/Execute_a_system_command
		
		Execute an operating system command.

		SECURITY WARNING: This is demo code only. Never pass untrusted
		user input directly to shell commands. Use parameterized commands
		or input validation to prevent command injection attacks.
	]"
	author: "Simple Eiffel"
	see_also: "https://github.com/simple-eiffel - Modern Eiffel libraries"
	rosetta_task: "Execute_a_system_command"

class
	EXECUTE_SYSTEM_COMMAND

create
	make

feature {NONE} -- Initialization

	make
		local
			process: PROCESS
		do
			print ("Executing 'dir' command:%N")
			print ("========================%N")
			
			-- Using simple_process library
			create process.make_with_command ("dir")
			process.run
			
			if process.has_output then
				print (process.output)
			end
			
			print ("%NCommand exit code: " + process.exit_code.out + "%N")
		end

end
