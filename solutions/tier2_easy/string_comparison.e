note
	description: "[
		Rosetta Code: String comparison
		https://rosettacode.org/wiki/String_comparison

		Compare two strings for equality and ordering.
	]"
	author: "Simple Eiffel"
	see_also: "https://github.com/simple-eiffel"
	rosetta_task: "String_comparison"
	tier: "2"

class
	STRING_COMPARISON

create
	make

feature {NONE} -- Initialization

	make
			-- Demonstrate string comparison.
		do
			print ("String Comparison%N")
			print ("=================%N%N")

			compare ("abc", "abc")
			compare ("abc", "ABC")
			compare ("abc", "abd")
			compare ("abc", "ab")
			compare ("", "")
		end

feature -- Demo

	compare (a_s1, a_s2: STRING)
			-- Compare two strings.
		do
			print ("'" + a_s1 + "' vs '" + a_s2 + "':%N")
			print ("  Equal: " + a_s1.same_string (a_s2).out + "%N")
			print ("  Case-insensitive equal: " + a_s1.is_case_insensitive_equal (a_s2).out + "%N")
			print ("  Less than: " + (a_s1 < a_s2).out + "%N")
			print ("  Greater than: " + (a_s1 > a_s2).out + "%N%N")
		end

feature -- Comparison

	are_equal (a_s1, a_s2: STRING): BOOLEAN
			-- Are strings equal (case-sensitive)?
		require
			s1_exists: a_s1 /= Void
			s2_exists: a_s2 /= Void
		do
			Result := a_s1.same_string (a_s2)
		end

	are_equal_ignore_case (a_s1, a_s2: STRING): BOOLEAN
			-- Are strings equal (case-insensitive)?
		require
			s1_exists: a_s1 /= Void
			s2_exists: a_s2 /= Void
		do
			Result := a_s1.is_case_insensitive_equal (a_s2)
		end

	compare_strings (a_s1, a_s2: STRING): INTEGER
			-- Compare strings: -1 if s1 < s2, 0 if equal, 1 if s1 > s2.
		require
			s1_exists: a_s1 /= Void
			s2_exists: a_s2 /= Void
		do
			if a_s1 < a_s2 then
				Result := -1
			elseif a_s1 > a_s2 then
				Result := 1
			else
				Result := 0
			end
		ensure
			valid_result: Result >= -1 and Result <= 1
		end

end