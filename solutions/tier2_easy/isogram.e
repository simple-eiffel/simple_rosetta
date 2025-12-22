note
	description: "[
		Rosetta Code: Isogram
		https://rosettacode.org/wiki/Determine_if_a_string_has_all_unique_characters

		Determine if a string has all unique characters (isogram).
	]"
	author: "Simple Eiffel"
	see_also: "https://github.com/simple-eiffel"
	rosetta_task: "Determine_if_a_string_has_all_unique_characters"
	tier: "2"

class
	ISOGRAM

create
	make

feature {NONE} -- Initialization

	make
			-- Demonstrate isogram detection.
		do
			print ("Isogram Detection%N")
			print ("=================%N%N")

			test ("abcdefghijklmnop")
			test ("subdermatoglyphic")
			test ("hello")
			test ("programming")
			test ("")
			test ("a")
		end

feature -- Testing

	test (a_str: STRING)
			-- Test if string is isogram.
		local
			l_dup: CHARACTER
			l_pos: INTEGER
		do
			print ("'" + a_str + "' (length " + a_str.count.out + "): ")
			if is_isogram (a_str) then
				print ("is an isogram%N")
			else
				l_dup := first_duplicate (a_str)
				l_pos := duplicate_position (a_str)
				print ("NOT an isogram - '" + l_dup.out + "' at position " + l_pos.out + "%N")
			end
		end

feature -- Query

	is_isogram (a_str: STRING): BOOLEAN
			-- Does `a_str' have all unique characters?
		require
			str_exists: a_str /= Void
		local
			l_seen: ARRAYED_LIST [CHARACTER]
			l_i: INTEGER
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

	first_duplicate (a_str: STRING): CHARACTER
			-- First duplicate character (or null if none).
		require
			str_exists: a_str /= Void
		local
			l_seen: ARRAYED_LIST [CHARACTER]
			l_i: INTEGER
			l_found: BOOLEAN
		do
			create l_seen.make (a_str.count)
			from l_i := 1 until l_i > a_str.count or l_found loop
				if l_seen.has (a_str [l_i]) then
					Result := a_str [l_i]
					l_found := True
				else
					l_seen.extend (a_str [l_i])
				end
				l_i := l_i + 1
			end
		end

	duplicate_position (a_str: STRING): INTEGER
			-- Position of first duplicate character.
		require
			str_exists: a_str /= Void
		local
			l_char: CHARACTER
			l_i: INTEGER
		do
			l_char := first_duplicate (a_str)
			if l_char /= '%U' then
				from l_i := 1 until l_i > a_str.count loop
					if a_str [l_i] = l_char then
						Result := l_i
						l_i := a_str.count + 1
					end
					l_i := l_i + 1
				end
			end
		end

end