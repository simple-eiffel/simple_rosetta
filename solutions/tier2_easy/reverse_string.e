note
	description: "[
		Rosetta Code: Reverse a string
		https://rosettacode.org/wiki/Reverse_a_string

		Reverse a string.
	]"
	author: "Simple Eiffel"
	see_also: "https://github.com/simple-eiffel"
	rosetta_task: "Reverse_a_string"
	tier: "2"

class
	REVERSE_STRING

create
	make

feature {NONE} -- Initialization

	make
			-- Demonstrate string reversal.
		do
			print ("Reverse a String%N")
			print ("================%N%N")

			demo ("Hello")
			demo ("racecar")
			demo ("A")
			demo ("")
			demo ("12345")
		end

feature -- Demo

	demo (a_str: STRING)
			-- Show reversal.
		do
			print ("'" + a_str + "' -> '" + reverse (a_str) + "'%N")
		end

feature -- Operations

	reverse (a_str: STRING): STRING
			-- Return reversed copy of string.
		require
			str_exists: a_str /= Void
		do
			Result := a_str.twin
			Result.mirror
		ensure
			result_exists: Result /= Void
			same_length: Result.count = a_str.count
		end

	reverse_in_place (a_str: STRING)
			-- Reverse string in place.
		require
			str_exists: a_str /= Void
		do
			a_str.mirror
		end

end