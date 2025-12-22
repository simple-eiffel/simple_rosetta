note
	description: "[
		Rosetta Code: Determine if a string has all unique characters
		https://rosettacode.org/wiki/Determine_if_a_string_has_all_unique_characters

		Check if all characters in a string are unique (no duplicates).
	]"
	author: "Simple Eiffel"
	see_also: "https://github.com/simple-eiffel"
	rosetta_task: "Determine_if_a_string_has_all_unique_characters"
	tier: "2"

class
	STRING_UNIQUE_CHARS

create
	make

feature {NONE} -- Initialization

	make
			-- Test various strings.
		do
			test_string ("")
			test_string (".")
			test_string ("abcABC")
			test_string ("XYZ ZYX")
			test_string ("1234567890ABCDEFGHIJKLMN0PQRSTUVWXYZ")
		end

feature -- Analysis

	test_string (a_str: STRING)
			-- Test and report if string has all unique characters.
		local
			l_result: TUPLE [is_unique: BOOLEAN; dup_char: CHARACTER; pos1: INTEGER; pos2: INTEGER]
		do
			l_result := check_unique (a_str)
			print ("String: %"" + a_str + "%" (length " + a_str.count.out + ")%N")
			if l_result.is_unique then
				print ("  All characters are unique%N")
			else
				print ("  Duplicate '" + l_result.dup_char.out + "' at positions " + l_result.pos1.out + " and " + l_result.pos2.out + "%N")
			end
			print ("%N")
		end

	check_unique (a_str: STRING): TUPLE [is_unique: BOOLEAN; dup_char: CHARACTER; pos1: INTEGER; pos2: INTEGER]
			-- Check if all characters are unique.
			-- Returns first duplicate character and its positions if not.
		require
			str_exists: a_str /= Void
		local
			l_i, l_j: INTEGER
		do
			Result := [True, '%U', 0, 0]
			from l_i := 1 until l_i >= a_str.count or not Result.is_unique loop
				from l_j := l_i + 1 until l_j > a_str.count or not Result.is_unique loop
					if a_str [l_i] = a_str [l_j] then
						Result := [False, a_str [l_i], l_i, l_j]
					end
					l_j := l_j + 1
				end
				l_i := l_i + 1
			end
		ensure
			valid_result: Result /= Void
		end

end
