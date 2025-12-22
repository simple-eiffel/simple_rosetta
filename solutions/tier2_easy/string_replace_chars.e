note
	description: "[
		Rosetta Code: Selectively replace multiple instances of a character within a string
		https://rosettacode.org/wiki/Selectively_replace_multiple_instances_of_a_character_within_a_string

		Replace specific occurrences of a character.
	]"
	author: "Simple Eiffel"
	see_also: "https://github.com/simple-eiffel"
	rosetta_task: "Selectively_replace_multiple_instances_of_a_character_within_a_string"
	tier: "2"

class
	STRING_REPLACE_CHARS

create
	make

feature {NONE} -- Initialization

	make
			-- Demonstrate selective character replacement.
		local
			l_str: STRING
		do
			l_str := "abracadabra"

			print ("Original: " + l_str + "%N%N")

			-- Replace 1st 'a' with 'A'
			print ("Replace 1st 'a' with 'A': " + replace_nth (l_str, 'a', 'A', 1) + "%N")

			-- Replace 2nd 'a' with 'A'
			print ("Replace 2nd 'a' with 'A': " + replace_nth (l_str, 'a', 'A', 2) + "%N")

			-- Replace 3rd 'a' with 'A'
			print ("Replace 3rd 'a' with 'A': " + replace_nth (l_str, 'a', 'A', 3) + "%N")

			-- Replace all 'a' with 'A'
			print ("Replace all 'a' with 'A': " + replace_all_char (l_str, 'a', 'A') + "%N")

			-- Replace 1st and last 'a'
			print ("%NReplace 1st and last 'a':%N")
			l_str := replace_nth (l_str, 'a', 'A', 1)
			l_str := replace_nth (l_str, 'a', 'A', count_char (l_str, 'a'))
			print ("  " + l_str + "%N")
		end

feature -- Replacement

	replace_nth (a_str: STRING; a_old, a_new: CHARACTER; a_n: INTEGER): STRING
			-- Replace the nth occurrence of `a_old' with `a_new'.
		require
			str_exists: a_str /= Void
			positive_n: a_n > 0
		local
			l_count, l_i: INTEGER
		do
			Result := a_str.twin
			from l_i := 1 until l_i > Result.count or l_count = a_n loop
				if Result [l_i] = a_old then
					l_count := l_count + 1
					if l_count = a_n then
						Result [l_i] := a_new
					end
				end
				l_i := l_i + 1
			end
		ensure
			result_exists: Result /= Void
		end

	replace_all_char (a_str: STRING; a_old, a_new: CHARACTER): STRING
			-- Replace all occurrences of `a_old' with `a_new'.
		require
			str_exists: a_str /= Void
		local
			l_i: INTEGER
		do
			Result := a_str.twin
			from l_i := 1 until l_i > Result.count loop
				if Result [l_i] = a_old then
					Result [l_i] := a_new
				end
				l_i := l_i + 1
			end
		end

	count_char (a_str: STRING; a_char: CHARACTER): INTEGER
			-- Count occurrences of `a_char' in `a_str'.
		local
			l_i: INTEGER
		do
			from l_i := 1 until l_i > a_str.count loop
				if a_str [l_i] = a_char then
					Result := Result + 1
				end
				l_i := l_i + 1
			end
		end

end
