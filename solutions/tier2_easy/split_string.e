note
	description: "[
		Rosetta Code: Split a character string based on change of character
		https://rosettacode.org/wiki/Split_a_character_string_based_on_change_of_character

		Split string when character changes.
	]"
	author: "Simple Eiffel"
	see_also: "https://github.com/simple-eiffel"
	rosetta_task: "Split_a_character_string_based_on_change_of_character"
	tier: "2"

class
	SPLIT_STRING

create
	make

feature {NONE} -- Initialization

	make
			-- Demonstrate character-change splitting.
		do
			print ("Split on Character Change%N")
			print ("=========================%N%N")

			demo ("gHHH5YY++///\\")
			demo ("aabbccdd")
			demo ("abc")
			demo ("aaaa")
		end

feature -- Demo

	demo (a_str: STRING)
			-- Show split result.
		local
			l_parts: ARRAYED_LIST [STRING]
		do
			l_parts := split_on_change (a_str)
			print ("'" + a_str + "' -> ")
			across l_parts as l_p loop
				if @l_p.cursor_index > 1 then
					print (", ")
				end
				print ("'" + l_p + "'")
			end
			print ("%N")
		end

feature -- Operations

	split_on_change (a_str: STRING): ARRAYED_LIST [STRING]
			-- Split string when character changes.
		require
			str_exists: a_str /= Void
		local
			l_i: INTEGER
			l_current: STRING
			l_prev: CHARACTER
		do
			create Result.make (a_str.count)
			if not a_str.is_empty then
				create l_current.make (10)
				l_prev := a_str [1]
				from l_i := 1 until l_i > a_str.count loop
					if a_str [l_i] = l_prev then
						l_current.append_character (a_str [l_i])
					else
						Result.extend (l_current)
						create l_current.make (10)
						l_current.append_character (a_str [l_i])
						l_prev := a_str [l_i]
					end
					l_i := l_i + 1
				end
				if not l_current.is_empty then
					Result.extend (l_current)
				end
			end
		ensure
			result_exists: Result /= Void
		end

end