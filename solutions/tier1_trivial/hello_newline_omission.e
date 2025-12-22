note
	description: "[
		Rosetta Code: Hello world/Newline omission
		https://rosettacode.org/wiki/Hello_world/Newline_omission

		Print 'Goodbye, World!' without a trailing newline.
	]"
	author: "Eiffel Solution"
	rosetta_task: "Hello_world/Newline_omission"

class
	HELLO_NEWLINE_OMISSION

create
	make

feature {NONE} -- Initialization

	make
			-- Print without trailing newline.
		do
			-- Use io.put_string instead of print to avoid newline
			io.put_string ("Goodbye, World!")

			-- Note: In Eiffel, print() adds a newline
			-- put_string() does not add a newline
		end

end
