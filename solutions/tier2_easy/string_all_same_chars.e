note
	description: "[
		Rosetta Code: Determine if a string has all the same characters
		https://rosettacode.org/wiki/Determine_if_a_string_has_all_the_same_characters

		Check if all characters in a string are identical.
	]"
	author: "Simple Eiffel"
	see_also: "https://github.com/simple-eiffel"
	rosetta_task: "Determine_if_a_string_has_all_the_same_characters"
	tier: "2"

class
	STRING_ALL_SAME_CHARS

create
	make

feature {NONE} -- Initialization

	make
			-- Test various strings.
		do
			test_string ("")
			test_string ("   ")
			test_string ("2")
			test_string ("333")
			test_string (".55")
			test_string ("tttTTT")
			test_string ("4444 444k")
		end

feature -- Analysis

	test_string (a_str: STRING)
			-- Test and report if string has all same characters.
		local
			l_result: TUPLE [all_same: BOOLEAN; diff_pos: INTEGER; diff_char: CHARACTER]
		do
			l_result := check_all_same (a_str)
			print ("String: %"" + a_str + "%" (length " + a_str.count.out + ")%N")
			if l_result.all_same then
				print ("  All characters are the same%N")
			else
				print ("  Different character '" + l_result.diff_char.out + "' at position " + l_result.diff_pos.out + "%N")
			end
			print ("%N")
		end

	check_all_same (a_str: STRING): TUPLE [all_same: BOOLEAN; diff_pos: INTEGER; diff_char: CHARACTER]
			-- Check if all characters are the same.
			-- Returns position and character of first difference if not.
		require
			str_exists: a_str /= Void
		local
			l_i: INTEGER
			l_first: CHARACTER
		do
			Result := [True, 0, '%U']
			if a_str.count > 1 then
				l_first := a_str [1]
				from l_i := 2 until l_i > a_str.count or not Result.all_same loop
					if a_str [l_i] /= l_first then
						Result := [False, l_i, a_str [l_i]]
					end
					l_i := l_i + 1
				end
			end
		ensure
			valid_result: Result /= Void
		end

end
