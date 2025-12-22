note
	description: "[
		Rosetta Code: Boyer-Moore string search
		https://rosettacode.org/wiki/Boyer-Moore_string_search

		Efficient string search using Boyer-Moore algorithm.
	]"
	author: "Simple Eiffel"
	see_also: "https://github.com/simple-eiffel"
	rosetta_task: "Boyer-Moore_string_search"
	tier: "3"

class
	BOYER_MOORE_SEARCH

create
	make

feature {NONE} -- Initialization

	make
			-- Demonstrate Boyer-Moore search.
		do
			print ("Boyer-Moore String Search%N")
			print ("=========================%N%N")

			test_search ("HERE IS A SIMPLE EXAMPLE", "EXAMPLE")
			test_search ("ABAAABCD", "ABC")
			test_search ("GCATCGCAGAGAGTATACAGTACG", "GCAGAGAG")
			test_search ("hello world", "xyz")
		end

feature -- Search

	test_search (a_text, a_pattern: STRING)
			-- Search and display result.
		local
			l_pos: INTEGER
		do
			l_pos := boyer_moore (a_text, a_pattern)
			print ("Text: %"" + a_text + "%"%N")
			print ("Pattern: %"" + a_pattern + "%"%N")
			if l_pos > 0 then
				print ("Found at position: " + l_pos.out + "%N")
			else
				print ("Not found%N")
			end
			print ("%N")
		end

	boyer_moore (a_text, a_pattern: STRING): INTEGER
			-- Find first occurrence of `a_pattern' in `a_text'.
			-- Returns position (1-based) or 0 if not found.
		require
			text_exists: a_text /= Void
			pattern_exists: a_pattern /= Void
		local
			l_bad_char: ARRAY [INTEGER]
			l_i, l_j, l_shift: INTEGER
		do
			if a_pattern.count = 0 then
				Result := 1
			elseif a_pattern.count <= a_text.count then
				l_bad_char := make_bad_char_table (a_pattern)

				from l_i := a_pattern.count until l_i > a_text.count or Result > 0 loop
					l_j := a_pattern.count

					from until l_j < 1 or a_text [l_i - a_pattern.count + l_j] /= a_pattern [l_j] loop
						l_j := l_j - 1
					end

					if l_j < 1 then
						Result := l_i - a_pattern.count + 1
					else
						l_shift := l_bad_char [a_text [l_i - a_pattern.count + l_j].code + 1]
						if l_shift < 1 then l_shift := 1 end
						l_i := l_i + l_shift.max (l_j - l_bad_char [a_text [l_i].code + 1])
					end
				end
			end
		ensure
			valid_result: Result >= 0
		end

feature {NONE} -- Helpers

	make_bad_char_table (a_pattern: STRING): ARRAY [INTEGER]
			-- Build bad character shift table.
		local
			l_i: INTEGER
		do
			create Result.make_filled (a_pattern.count, 1, 256)
			from l_i := 1 until l_i > a_pattern.count loop
				Result [a_pattern [l_i].code + 1] := a_pattern.count - l_i
				l_i := l_i + 1
			end
		end

end
