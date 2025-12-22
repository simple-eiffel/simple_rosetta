note
	description: "[
		Rosetta Code: String concatenation
		https://rosettacode.org/wiki/String_concatenation

		Demonstrate concatenation of two strings.
	]"
	author: "Eiffel Solution"
	rosetta_task: "String_concatenation"

class
	STRING_CONCATENATION

create
	make

feature {NONE} -- Initialization

	make
			-- Demonstrate string concatenation.
		local
			s1, s2, result_str: STRING
		do
			s1 := "Hello, "
			s2 := "World!"

			-- Method 1: + operator (creates new string)
			result_str := s1 + s2
			print ("Using + operator:%N")
			print ("  %"Hello, %" + %"World!%" = %"" + result_str + "%"%N")

			-- Method 2: append (modifies in place)
			s1 := "Hello, "  -- Reset
			s1.append (s2)
			print ("%NUsing append (modifies s1):%N")
			print ("  s1.append (s2) -> %"" + s1 + "%"%N")

			-- Method 3: append_string (same as append)
			s1 := "Hello, "  -- Reset
			s1.append_string (s2)
			print ("%NUsing append_string:%N")
			print ("  s1.append_string (s2) -> %"" + s1 + "%"%N")
		end

end
