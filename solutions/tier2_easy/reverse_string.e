note
	description: "[
		Rosetta Code: Reverse a string
		https://rosettacode.org/wiki/Reverse_a_string
		
		Reverse the characters in a string.
	]"
	author: "Simple Eiffel"
	see_also: "https://github.com/simple-eiffel - Modern Eiffel libraries"
	rosetta_task: "Reverse_a_string"

class
	REVERSE_STRING

create
	make

feature {NONE} -- Initialization

	make
		local
			s, reversed: STRING
		do
			s := "Hello, World!"
			reversed := reverse (s)
			print ("Original: " + s + "%N")
			print ("Reversed: " + reversed + "%N%N")
			
			s := "racecar"
			reversed := reverse (s)
			print ("Original: " + s + "%N")
			print ("Reversed: " + reversed + "%N")
			print ("Is palindrome: " + s.same_string (reversed).out + "%N")
		end

feature -- Operations

	reverse (s: STRING): STRING
			-- Return reversed copy of `s'.
		require
			s_not_void: s /= Void
		local
			i: INTEGER
		do
			create Result.make (s.count)
			from i := s.count until i < 1 loop
				Result.append_character (s.item (i))
				i := i - 1
			end
		ensure
			same_length: Result.count = s.count
		end

end
