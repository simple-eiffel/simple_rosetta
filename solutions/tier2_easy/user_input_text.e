note
	description: "[
		Rosetta Code: User input/Text
		https://rosettacode.org/wiki/User_input/Text

		Read a string and a number from the user.
	]"
	author: "Eiffel Solution"
	rosetta_task: "User_input/Text"

class
	USER_INPUT_TEXT

create
	make

feature {NONE} -- Initialization

	make
			-- Demonstrate user input.
		local
			name: STRING
			age: INTEGER
		do
			-- Read a string
			print ("Enter your name: ")
			io.read_line
			name := io.last_string.twin

			-- Read an integer
			print ("Enter your age: ")
			io.read_integer
			age := io.last_integer

			-- Display results
			print ("%NHello, " + name + "!%N")
			print ("You are " + age.out + " years old.%N")

			-- Read a real number
			print ("%NEnter a decimal number: ")
			io.read_real
			print ("You entered: " + io.last_real.out + "%N")
		end

end
