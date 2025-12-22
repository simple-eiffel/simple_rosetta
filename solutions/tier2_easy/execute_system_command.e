note
	description: "[
		Rosetta Code: Execute a system command
		https://rosettacode.org/wiki/Execute_a_system_command
		
		Execute an operating system command and capture its output.

		Uses: simple_process library (https://github.com/simple-eiffel/simple_process)
		The simple_process library provides cross-platform process execution with
		output capture. Add it to your ECF: $SIMPLE_PROCESS/simple_process.ecf

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
			proc: SIMPLE_PROCESS
		do
			print ("Executing 'dir' command:%N")
			print ("========================%N")
			
			create proc.make
			proc.run_command ("dir")
			
			if attached proc.last_output as l_out then
				print (l_out)
			end
			
			print ("%NCommand exit code: " + proc.last_exit_code.out + "%N")
		end

end