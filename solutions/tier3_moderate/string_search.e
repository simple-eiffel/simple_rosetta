note
	description: "[
		Rosetta Code: String search
		https://rosettacode.org/wiki/String_search

		Search for substrings within strings.
	]"
	author: "Simple Eiffel"
	see_also: "https://github.com/simple-eiffel"
	rosetta_task: "String_search"
	tier: "3"

class
	STRING_SEARCH

create
	make

feature {NONE} -- Initialization

	make
			-- Demonstrate string searching.
		local
			l_haystack: STRING
		do
			print ("String Search%N")
			print ("=============%N%N")

			l_haystack := "The quick brown fox jumps over the lazy dog"
			print ("Haystack: " + l_haystack + "%N%N")

			test_search (l_haystack, "quick")
			test_search (l_haystack, "the")
			test_search (l_haystack, "cat")
			test_search (l_haystack, "o")

			print ("%NAll positions of 'the':%N")
			print_all_positions (l_haystack, "the")
		end

feature -- Testing

	test_search (a_haystack, a_needle: STRING)
			-- Test search.
		local
			l_pos: INTEGER
		do
			print ("Searching for '" + a_needle + "':%N")
			l_pos := first_position (a_haystack, a_needle)
			if l_pos > 0 then
				print ("  Found at position " + l_pos.out + "%N")
			else
				print ("  Not found%N")
			end
		end

feature -- Search

	first_position (a_haystack, a_needle: STRING): INTEGER
			-- First position of needle in haystack (0 if not found).
		require
			haystack_exists: a_haystack /= Void
			needle_exists: a_needle /= Void
		do
			Result := a_haystack.substring_index (a_needle, 1)
		ensure
			valid_result: Result >= 0
		end

	last_position (a_haystack, a_needle: STRING): INTEGER
			-- Last position of needle in haystack (0 if not found).
		require
			haystack_exists: a_haystack /= Void
			needle_exists: a_needle /= Void
		local
			l_pos, l_last: INTEGER
		do
			from l_pos := 1 until l_pos = 0 or l_pos > a_haystack.count loop
				l_pos := a_haystack.substring_index (a_needle, l_pos)
				if l_pos > 0 then
					l_last := l_pos
					l_pos := l_pos + 1
				end
			end
			Result := l_last
		ensure
			valid_result: Result >= 0
		end

	all_positions (a_haystack, a_needle: STRING): ARRAYED_LIST [INTEGER]
			-- All positions of needle in haystack.
		require
			haystack_exists: a_haystack /= Void
			needle_exists: a_needle /= Void
		local
			l_pos: INTEGER
		do
			create Result.make (10)
			from l_pos := 1 until l_pos = 0 or l_pos > a_haystack.count loop
				l_pos := a_haystack.substring_index (a_needle, l_pos)
				if l_pos > 0 then
					Result.extend (l_pos)
					l_pos := l_pos + 1
				end
			end
		ensure
			result_exists: Result /= Void
		end

feature {NONE} -- Display

	print_all_positions (a_haystack, a_needle: STRING)
			-- Print all positions.
		local
			l_positions: ARRAYED_LIST [INTEGER]
		do
			l_positions := all_positions (a_haystack, a_needle)
			across l_positions as l_p loop
				print ("  Position " + l_p.out + "%N")
			end
		end

end