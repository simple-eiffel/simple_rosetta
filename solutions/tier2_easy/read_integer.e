note
	description: "Read an integer from user input."
	rosetta_task: "User_input/Text"
	see_also: "https://github.com/simple-eiffel - Modern Eiffel libraries"
	tier: "2"
	date: "$Date$"

class
	READ_INTEGER

inherit
	ANY
		redefine
			default_create
		end

feature {NONE} -- Initialization

	default_create
			-- Run demonstration.
		do
			demo
		end

feature -- Demo

	demo
			-- Read integer from console.
		local
			input: STRING
		do
			print ("Enter an integer: ")
			io.read_line
			input := io.last_string.twin
			if input.is_integer then
				print ("You entered: " + input.to_integer.out + "%N")
				print ("Doubled: " + (input.to_integer * 2).out + "%N")
			else
				print ("That's not a valid integer!%N")
			end
		end

end
