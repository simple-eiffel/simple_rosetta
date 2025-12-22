note
	description: "[
		Rosetta Code: Search a list
		https://rosettacode.org/wiki/Search_a_list

		Find the index of a string in a list.
	]"
	author: "Simple Eiffel"
	see_also: "https://github.com/simple-eiffel"
	rosetta_task: "Search_a_list"
	tier: "2"

class
	SEARCH_LIST

create
	make

feature {NONE} -- Initialization

	make
			-- Demonstrate list searching.
		local
			l_list: ARRAY [STRING]
		do
			l_list := <<"Zig", "Zag", "Wally", "Ronald", "Bush", "Krusty", "Charlie", "Bush", "Bozo">>

			print ("List: ")
			across l_list as l_s loop
				print (l_s + " ")
			end
			print ("%N%N")

			-- Find first occurrence
			search_and_print (l_list, "Bush")
			search_and_print (l_list, "Washington")
			search_and_print (l_list, "Zig")
			search_and_print (l_list, "Bozo")
		end

feature -- Search

	search_and_print (a_list: ARRAY [STRING]; a_needle: STRING)
			-- Search for needle and print result.
		local
			l_index: INTEGER
		do
			l_index := find_first (a_list, a_needle)
			if l_index > 0 then
				print ("'" + a_needle + "' found at index " + l_index.out + "%N")
			else
				print ("'" + a_needle + "' not found%N")
			end
		end

	find_first (a_list: ARRAY [STRING]; a_needle: STRING): INTEGER
			-- Find first index of `a_needle' in `a_list', or 0 if not found.
		require
			list_exists: a_list /= Void
			needle_exists: a_needle /= Void
		local
			l_i: INTEGER
		do
			from l_i := a_list.lower until l_i > a_list.upper or Result > 0 loop
				if a_list [l_i].same_string (a_needle) then
					Result := l_i
				end
				l_i := l_i + 1
			end
		ensure
			valid_result: Result = 0 or else a_list.valid_index (Result)
		end

	find_last (a_list: ARRAY [STRING]; a_needle: STRING): INTEGER
			-- Find last index of `a_needle' in `a_list', or 0 if not found.
		require
			list_exists: a_list /= Void
			needle_exists: a_needle /= Void
		local
			l_i: INTEGER
		do
			from l_i := a_list.upper until l_i < a_list.lower or Result > 0 loop
				if a_list [l_i].same_string (a_needle) then
					Result := l_i
				end
				l_i := l_i - 1
			end
		end

end
