note
	description: "[
		Rosetta Code: Reverse a string
		https://rosettacode.org/wiki/Reverse_a_string

		Reverse a string character by character.
	]"
	author: "Simple Eiffel"
	see_also: "https://github.com/simple-eiffel"
	rosetta_task: "Reverse_a_string"
	tier: "2"

class
	STRING_REVERSE

create
	make

feature {NONE} -- Initialization

	make
			-- Demonstrate string reversal.
		do
			print ("String Reversal%N")
			print ("===============%N%N")

			demo ("Hello, World!")
			demo ("abcdef")
			demo ("racecar")
			demo ("A")
			demo ("")
		end

feature -- Demo

	demo (a_str: STRING)
			-- Show reversal.
		do
			print ("'" + a_str + "' -> '" + reverse (a_str) + "'%N")
		end

feature -- Operations

	reverse (a_str: STRING): STRING
			-- Reversed copy of string.
		require
			str_exists: a_str /= Void
		do
			Result := a_str.twin
			Result.mirror
		ensure
			result_exists: Result /= Void
			same_length: Result.count = a_str.count
		end

	reverse_manual (a_str: STRING): STRING
			-- Reverse using manual character iteration.
		require
			str_exists: a_str /= Void
		local
			l_i: INTEGER
		do
			create Result.make (a_str.count)
			from l_i := a_str.count until l_i < 1 loop
				Result.append_character (a_str [l_i])
				l_i := l_i - 1
			end
		ensure
			result_exists: Result /= Void
			same_length: Result.count = a_str.count
		end

	reverse_words (a_str: STRING): STRING
			-- Reverse word order (not characters).
		require
			str_exists: a_str /= Void
		local
			l_words: LIST [STRING]
			l_i: INTEGER
		do
			create Result.make (a_str.count)
			l_words := a_str.split (' ')
			from l_i := l_words.count until l_i < 1 loop
				if not Result.is_empty then
					Result.append_character (' ')
				end
				Result.append (l_words [l_i])
				l_i := l_i - 1
			end
		ensure
			result_exists: Result /= Void
		end

end