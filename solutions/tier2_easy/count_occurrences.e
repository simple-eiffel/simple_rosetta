note
	description: "[
		Rosetta Code: Count occurrences of a substring
		https://rosettacode.org/wiki/Count_occurrences_of_a_substring

		Count how many times a substring appears in a string.
	]"
	author: "Simple Eiffel"
	see_also: "https://github.com/simple-eiffel"
	rosetta_task: "Count_occurrences_of_a_substring"
	tier: "2"

class
	COUNT_OCCURRENCES

create
	make

feature {NONE} -- Initialization

	make
			-- Demonstrate occurrence counting.
		do
			print ("Count Substring Occurrences%N")
			print ("===========================%N%N")

			demo ("the three truths", "th")
			demo ("ababababab", "abab")
			demo ("aaaaaa", "aa")
			demo ("hello world", "o")
			demo ("hello world", "xyz")
		end

feature -- Demo

	demo (a_str, a_sub: STRING)
			-- Show count.
		do
			print ("'" + a_str + "' contains '" + a_sub + "': ")
			print (count_occurrences (a_str, a_sub).out + " times%N")
		end

feature -- Counting

	count_occurrences (a_str, a_sub: STRING): INTEGER
			-- Count non-overlapping occurrences of `a_sub' in `a_str'.
		require
			str_exists: a_str /= Void
			sub_exists: a_sub /= Void
			sub_not_empty: not a_sub.is_empty
		local
			l_pos: INTEGER
		do
			from l_pos := 1 until l_pos = 0 or l_pos > a_str.count loop
				l_pos := a_str.substring_index (a_sub, l_pos)
				if l_pos > 0 then
					Result := Result + 1
					l_pos := l_pos + a_sub.count
				end
			end
		ensure
			non_negative: Result >= 0
		end

	count_overlapping (a_str, a_sub: STRING): INTEGER
			-- Count overlapping occurrences of `a_sub' in `a_str'.
		require
			str_exists: a_str /= Void
			sub_exists: a_sub /= Void
			sub_not_empty: not a_sub.is_empty
		local
			l_pos: INTEGER
		do
			from l_pos := 1 until l_pos = 0 or l_pos > a_str.count loop
				l_pos := a_str.substring_index (a_sub, l_pos)
				if l_pos > 0 then
					Result := Result + 1
					l_pos := l_pos + 1
				end
			end
		ensure
			non_negative: Result >= 0
		end

end