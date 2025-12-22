note
	description: "[
		Rosetta Code: String comparison
		https://rosettacode.org/wiki/String_comparison

		Demonstrate string comparison operations.
	]"
	author: "Eiffel Solution"
	rosetta_task: "String_comparison"

class
	STRING_COMPARISON

create
	make

feature {NONE} -- Initialization

	make
			-- Demonstrate string comparison.
		local
			s1, s2, s3: STRING
		do
			s1 := "hello"
			s2 := "hello"
			s3 := "Hello"

			print ("Comparing strings:%N")
			print ("  s1 = %"hello%"%N")
			print ("  s2 = %"hello%"%N")
			print ("  s3 = %"Hello%"%N%N")

			-- Equality (case-sensitive)
			print ("Case-sensitive equality (~):%N")
			print ("  s1 ~ s2: " + (s1 ~ s2).out + "%N")
			print ("  s1 ~ s3: " + (s1 ~ s3).out + "%N")

			-- same_string (alias for ~)
			print ("%Nsame_string:%N")
			print ("  s1.same_string (s2): " + s1.same_string (s2).out + "%N")
			print ("  s1.same_string (s3): " + s1.same_string (s3).out + "%N")

			-- Case-insensitive
			print ("%Nis_case_insensitive_equal:%N")
			print ("  s1.is_case_insensitive_equal (s3): " + s1.is_case_insensitive_equal (s3).out + "%N")

			-- Lexical comparison
			print ("%NLexical comparison (<):%N")
			print ("  %"apple%" < %"banana%": " + ("apple" < "banana").out + "%N")
			print ("  %"banana%" < %"apple%": " + ("banana" < "apple").out + "%N")
		end

end
