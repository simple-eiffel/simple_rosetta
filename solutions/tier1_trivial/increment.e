note
	description: "[
		Rosetta Code: Increment a numerical string
		https://rosettacode.org/wiki/Increment_a_numerical_string

		Increment a number.
	]"
	author: "Simple Eiffel"
	see_also: "https://github.com/simple-eiffel"
	rosetta_task: "Increment_a_numerical_string"
	tier: "1"

class
	INCREMENT

create
	make

feature {NONE} -- Initialization

	make
			-- Demonstrate incrementing.
		local
			s: STRING
			n: INTEGER
		do
			print ("Increment%N")
			print ("=========%N%N")

			s := "12345"
			print ("String: '" + s + "'%N")
			n := s.to_integer + 1
			print ("Incremented: " + n.out + "%N%N")

			s := "999"
			print ("String: '" + s + "'%N")
			n := s.to_integer + 1
			print ("Incremented: " + n.out + "%N")
		end

feature -- Operations

	increment_string (s: STRING): STRING
			-- Increment numeric string.
		require
			s_exists: s /= Void
			is_numeric: s.is_integer
		do
			Result := (s.to_integer + 1).out
		ensure
			result_exists: Result /= Void
		end

end