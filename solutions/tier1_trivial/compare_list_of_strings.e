note
	description: "[
		Rosetta Code: Compare a list of strings
		https://rosettacode.org/wiki/Compare_a_list_of_strings

		Compare a list of strings for equality and ordering.
	]"
	author: "Simple Eiffel"
	see_also: "https://github.com/simple-eiffel"
	rosetta_task: "Compare_a_list_of_strings"
	tier: "1"

class
	COMPARE_LIST_OF_STRINGS

create
	make

feature {NONE} -- Initialization

	make
			-- Demonstrate string list comparison.
		do
			test_list (<<"AA", "AA", "AA">>)
			test_list (<<"AA", "BB", "CC">>)
			test_list (<<"AA", "CC", "BB">>)
			test_list (<<"singleton">>)
			test_list (<<>>)
		end

feature -- Comparison

	test_list (a_list: ARRAY [STRING])
			-- Test if list is equal and/or ascending.
		do
			print ("List: " + list_to_string (a_list) + "%N")
			print ("  All equal: " + all_equal (a_list).out + "%N")
			print ("  Ascending: " + is_ascending (a_list).out + "%N")
			print ("%N")
		end

	all_equal (a_list: ARRAY [STRING]): BOOLEAN
			-- Are all strings in list equal?
		local
			l_i: INTEGER
		do
			Result := True
			if a_list.count > 1 then
				from l_i := a_list.lower + 1 until l_i > a_list.upper or not Result loop
					Result := a_list [l_i].same_string (a_list [a_list.lower])
					l_i := l_i + 1
				end
			end
		end

	is_ascending (a_list: ARRAY [STRING]): BOOLEAN
			-- Are strings in strictly ascending order?
		local
			l_i: INTEGER
		do
			Result := True
			if a_list.count > 1 then
				from l_i := a_list.lower + 1 until l_i > a_list.upper or not Result loop
					Result := a_list [l_i - 1] < a_list [l_i]
					l_i := l_i + 1
				end
			end
		end

	list_to_string (a_list: ARRAY [STRING]): STRING
			-- Convert list to printable string.
		local
			l_i: INTEGER
		do
			create Result.make (50)
			Result.append ("[")
			from l_i := a_list.lower until l_i > a_list.upper loop
				if l_i > a_list.lower then Result.append (", ") end
				Result.append ("%"" + a_list [l_i] + "%"")
				l_i := l_i + 1
			end
			Result.append ("]")
		end

end
