note
	description: "[
		Rosetta Code: String case
		https://rosettacode.org/wiki/String_case

		Convert a string to UPPER CASE and lower case.
	]"
	author: "Eiffel Solution"
	rosetta_task: "String_case"

class
	STRING_CASE

create
	make

feature {NONE} -- Initialization

	make
			-- Demonstrate string case conversion.
		local
			s, upper, lower: STRING
		do
			s := "Hello, World!"

			print ("Original: %"" + s + "%"%N")

			-- Convert to uppercase (modifies in place)
			upper := s.twin
			upper.to_upper
			print ("Uppercase: %"" + upper + "%"%N")

			-- Convert to lowercase (modifies in place)
			lower := s.twin
			lower.to_lower
			print ("Lowercase: %"" + lower + "%"%N")

			-- Using as_upper / as_lower (returns new string)
			print ("%NUsing as_upper/as_lower (non-destructive):%N")
			print ("  s.as_upper: %"" + s.as_upper + "%"%N")
			print ("  s.as_lower: %"" + s.as_lower + "%"%N")
			print ("  Original unchanged: %"" + s + "%"%N")
		end

end
