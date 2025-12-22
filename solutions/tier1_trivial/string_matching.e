note
	description: "[
		Rosetta Code: String matching
		https://rosettacode.org/wiki/String_matching

		Determine if a string starts with, contains, or ends with another string.
	]"
	author: "Eiffel Solution"
	rosetta_task: "String_matching"

class
	STRING_MATCHING

create
	make

feature {NONE} -- Initialization

	make
			-- Demonstrate string matching.
		local
			s, pattern: STRING
		do
			s := "The quick brown fox jumps over the lazy dog"
			print ("String: %"" + s + "%"%N%N")

			-- Starts with
			pattern := "The"
			print ("Starts with %"" + pattern + "%": " + s.starts_with (pattern).out + "%N")

			pattern := "the"
			print ("Starts with %"" + pattern + "%": " + s.starts_with (pattern).out + "%N")

			-- Ends with
			pattern := "dog"
			print ("%NEnds with %"" + pattern + "%": " + s.ends_with (pattern).out + "%N")

			pattern := "cat"
			print ("Ends with %"" + pattern + "%": " + s.ends_with (pattern).out + "%N")

			-- Contains (using has_substring)
			pattern := "brown"
			print ("%NContains %"" + pattern + "%": " + s.has_substring (pattern).out + "%N")

			pattern := "purple"
			print ("Contains %"" + pattern + "%": " + s.has_substring (pattern).out + "%N")

			-- Find position (substring_index)
			pattern := "fox"
			print ("%NPosition of %"" + pattern + "%": " + s.substring_index (pattern, 1).out + "%N")
		end

end
