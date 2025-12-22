note
	description: "[
		Rosetta Code: Longest common substring
		https://rosettacode.org/wiki/Longest_common_substring

		Find the longest substring common to two strings.
	]"
	author: "Simple Eiffel"
	see_also: "https://github.com/simple-eiffel"
	rosetta_task: "Longest_common_substring"
	tier: "3"

class
	LONGEST_COMMON_SUBSTRING

create
	make

feature {NONE} -- Initialization

	make
			-- Demonstrate longest common substring.
		do
			test_pair ("testing123testing", "thisisatest")
			test_pair ("ABABC", "BABCA")
			test_pair ("abcdef", "xyz")
			test_pair ("Eiffel", "Waffles")
		end

feature -- Algorithm

	test_pair (a_s1, a_s2: STRING)
			-- Find and display longest common substring.
		local
			l_result: STRING
		do
			l_result := longest_common (a_s1, a_s2)
			print ("String 1: %"" + a_s1 + "%"%N")
			print ("String 2: %"" + a_s2 + "%"%N")
			print ("LCS: %"" + l_result + "%" (length " + l_result.count.out + ")%N%N")
		end

	longest_common (a_s1, a_s2: STRING): STRING
			-- Find longest common substring using dynamic programming.
		require
			s1_exists: a_s1 /= Void
			s2_exists: a_s2 /= Void
		local
			l_table: ARRAY2 [INTEGER]
			l_i, l_j: INTEGER
			l_max_len, l_end_pos: INTEGER
		do
			create l_table.make_filled (0, a_s1.count + 1, a_s2.count + 1)
			l_max_len := 0
			l_end_pos := 0

			from l_i := 1 until l_i > a_s1.count loop
				from l_j := 1 until l_j > a_s2.count loop
					if a_s1 [l_i] = a_s2 [l_j] then
						l_table [l_i, l_j] := l_table [l_i - 1, l_j - 1] + 1
						if l_table [l_i, l_j] > l_max_len then
							l_max_len := l_table [l_i, l_j]
							l_end_pos := l_i
						end
					end
					l_j := l_j + 1
				end
				l_i := l_i + 1
			end

			if l_max_len > 0 then
				Result := a_s1.substring (l_end_pos - l_max_len + 1, l_end_pos)
			else
				create Result.make_empty
			end
		ensure
			result_exists: Result /= Void
		end

end
