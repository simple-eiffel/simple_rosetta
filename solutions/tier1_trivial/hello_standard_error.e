note
	description: "[
		Rosetta Code: Hello world/Standard error
		https://rosettacode.org/wiki/Hello_world/Standard_error

		Print 'Goodbye, World!' to standard error.
	]"
	author: "Eiffel Solution"
	rosetta_task: "Hello_world/Standard_error"

class
	HELLO_STANDARD_ERROR

create
	make

feature {NONE} -- Initialization

	make
			-- Print to standard error.
		do
			-- Use io.error to write to stderr
			io.error.put_string ("Goodbye, World!")
			io.error.put_new_line
		end

end
