note
	description: "[
		Rosetta Code: Binary strings
		https://rosettacode.org/wiki/Binary_strings

		Demonstrate binary string operations.
	]"
	author: "Simple Eiffel"
	see_also: "https://github.com/simple-eiffel"
	rosetta_task: "Binary_strings"
	tier: "2"

class
	BINARY_STRINGS

create
	make

feature {NONE} -- Initialization

	make
			-- Demonstrate binary string operations.
		local
			l_s1, l_s2: STRING
		do
			-- String creation and assignment
			l_s1 := "Hello"
			l_s2 := l_s1.twin  -- Copy

			print ("String creation: " + l_s1 + "%N")
			print ("String copy: " + l_s2 + "%N")

			-- Test for empty
			print ("Is empty: " + l_s1.is_empty.out + "%N")
			print ("Empty string is_empty: " + ("").is_empty.out + "%N")

			-- Append byte
			l_s1.append_character ('!')
			print ("After append '!': " + l_s1 + "%N")

			-- Extract substring
			print ("Substring (1,3): " + l_s1.substring (1, 3) + "%N")

			-- Replace
			l_s2 := "Hello World"
			l_s2.replace_substring_all ("World", "Eiffel")
			print ("Replace 'World' with 'Eiffel': " + l_s2 + "%N")

			-- Compare
			l_s1 := "abc"
			l_s2 := "abc"
			print ("'abc' = 'abc': " + l_s1.same_string (l_s2).out + "%N")
			print ("'abc' < 'abd': " + (l_s1 < "abd").out + "%N")
		end

end
