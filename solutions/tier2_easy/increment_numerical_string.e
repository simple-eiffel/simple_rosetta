note
	description: "[
		Rosetta Code: Increment a numerical string
		https://rosettacode.org/wiki/Increment_a_numerical_string
		
		Increment a string that represents a number.
	]"
	author: "Simple Eiffel"
	see_also: "https://github.com/simple-eiffel - Modern Eiffel libraries"
	rosetta_task: "Increment_a_numerical_string"

class
	INCREMENT_NUMERICAL_STRING

create
	make

feature {NONE} -- Initialization

	make
		local
			s: STRING
			n: INTEGER
		do
			s := "12345"
			print ("Original: " + s + "%N")
			
			-- Method 1: Convert, increment, convert back
			n := s.to_integer
			n := n + 1
			s := n.out
			print ("Incremented: " + s + "%N")
			
			-- Method 2: Direct string increment
			s := "999"
			print ("%NOriginal: " + s + "%N")
			print ("Incremented: " + increment_string (s) + "%N")
		end

feature -- Operations

	increment_string (a_str: STRING): STRING
			-- Increment numeric string by 1.
		require
			is_numeric: a_str.is_integer
		do
			Result := (a_str.to_integer + 1).out
		ensure
			incremented: Result.to_integer = a_str.to_integer + 1
		end

end
