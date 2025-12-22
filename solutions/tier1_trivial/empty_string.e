note
	description: "[
		Rosetta Code: Empty string
		https://rosettacode.org/wiki/Empty_string

		Demonstrate how to check whether a string is empty.
	]"
	author: "Eiffel Solution"
	rosetta_task: "Empty_string"

class
	EMPTY_STRING

create
	make

feature {NONE} -- Initialization

	make
			-- Demonstrate empty string checks.
		local
			s1, s2: STRING
		do
			-- Create an empty string
			create s1.make_empty

			-- Create a non-empty string
			s2 := "Hello"

			-- Check if empty using is_empty
			print ("Checking strings for emptiness:%N")
			print ("  s1 (empty): is_empty = " + s1.is_empty.out + "%N")
			print ("  s2 ('Hello'): is_empty = " + s2.is_empty.out + "%N")

			-- Alternative: check count
			print ("%NUsing count:%N")
			print ("  s1.count = " + s1.count.out + "%N")
			print ("  s2.count = " + s2.count.out + "%N")
		end

end
