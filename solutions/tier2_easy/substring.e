note
	description: "[
		Rosetta Code: Substring
		https://rosettacode.org/wiki/Substring
		
		Extract a substring from a string.
	]"
	author: "Simple Eiffel"
	see_also: "https://github.com/simple-eiffel - Modern Eiffel libraries"
	rosetta_task: "Substring"

class
	SUBSTRING

create
	make

feature {NONE} -- Initialization

	make
		local
			s: STRING
		do
			s := "Hello, World!"
			print ("String: " + s + "%N%N")
			
			-- Starting from n characters in and of m length
			print ("Substring (8, 5): " + s.substring (8, 12) + "%N")
			
			-- Starting from n characters in, up to the end
			print ("From position 8: " + s.substring (8, s.count) + "%N")
			
			-- Whole string minus last character
			print ("Without last char: " + s.substring (1, s.count - 1) + "%N")
			
			-- Starting from a known character
			print ("From 'W': " + s.substring (s.index_of ('W', 1), s.count) + "%N")
		end

end
