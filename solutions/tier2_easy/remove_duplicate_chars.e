note
	description: "[
		Rosetta Code: Remove duplicate elements
		https://rosettacode.org/wiki/Remove_duplicate_elements

		Remove duplicate characters from a string.
	]"
	author: "Simple Eiffel"
	see_also: "https://github.com/simple-eiffel"
	rosetta_task: "Remove_duplicate_elements"
	tier: "2"

class
	REMOVE_DUPLICATE_CHARS

create
	make

feature {NONE} -- Initialization

	make
			-- Demonstrate duplicate removal.
		do
			print ("Remove Duplicate Characters%N")
			print ("===========================%N%N")

			demo ("mississippi")
			demo ("aabbccdd")
			demo ("hello world")
			demo ("abcdefg")
		end

feature -- Demo

	demo (a_str: STRING)
			-- Show result.
		do
			print ("'" + a_str + "' -> '" + remove_duplicates (a_str) + "'%N")
		end

feature -- Operations

	remove_duplicates (a_str: STRING): STRING
			-- String with duplicate characters removed.
		require
			str_exists: a_str /= Void
		local
			l_i: INTEGER
			l_seen: ARRAYED_LIST [CHARACTER]
		do
			create Result.make (a_str.count)
			create l_seen.make (a_str.count)
			from l_i := 1 until l_i > a_str.count loop
				if not l_seen.has (a_str [l_i]) then
					Result.append_character (a_str [l_i])
					l_seen.extend (a_str [l_i])
				end
				l_i := l_i + 1
			end
		ensure
			result_exists: Result /= Void
			no_duplicates: is_unique (Result)
		end

	is_unique (a_str: STRING): BOOLEAN
			-- Does string have all unique characters?
		require
			str_exists: a_str /= Void
		local
			l_i: INTEGER
			l_seen: ARRAYED_LIST [CHARACTER]
		do
			Result := True
			create l_seen.make (a_str.count)
			from l_i := 1 until l_i > a_str.count or not Result loop
				if l_seen.has (a_str [l_i]) then
					Result := False
				else
					l_seen.extend (a_str [l_i])
				end
				l_i := l_i + 1
			end
		end

end