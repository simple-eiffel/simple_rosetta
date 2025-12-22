note
	description: "[
		Rosetta Code: First and last characters
		https://rosettacode.org/wiki/First_and_last_characters

		Extract first and last characters from a string.
	]"
	author: "Simple Eiffel"
	see_also: "https://github.com/simple-eiffel"
	rosetta_task: "First_and_last_characters"
	tier: "2"

class
	FIRST_LAST_CHARS

create
	make

feature {NONE} -- Initialization

	make
			-- Demonstrate first/last character extraction.
		do
			print ("First and Last Characters%N")
			print ("=========================%N%N")

			demo ("Hello")
			demo ("A")
			demo ("Eiffel")
			demo ("Programming")
		end

feature -- Demo

	demo (a_str: STRING)
			-- Show first and last chars.
		do
			print ("'" + a_str + "': ")
			print ("first='" + first_char (a_str).out + "', ")
			print ("last='" + last_char (a_str).out + "'%N")
		end

feature -- Operations

	first_char (a_str: STRING): CHARACTER
			-- First character of string.
		require
			str_exists: a_str /= Void
			not_empty: not a_str.is_empty
		do
			Result := a_str [1]
		end

	last_char (a_str: STRING): CHARACTER
			-- Last character of string.
		require
			str_exists: a_str /= Void
			not_empty: not a_str.is_empty
		do
			Result := a_str [a_str.count]
		end

	first_n_chars (a_str: STRING; a_n: INTEGER): STRING
			-- First n characters.
		require
			str_exists: a_str /= Void
			positive_n: a_n >= 0
		do
			Result := a_str.substring (1, a_n.min (a_str.count))
		ensure
			result_exists: Result /= Void
		end

	last_n_chars (a_str: STRING; a_n: INTEGER): STRING
			-- Last n characters.
		require
			str_exists: a_str /= Void
			positive_n: a_n >= 0
		local
			l_start: INTEGER
		do
			l_start := (a_str.count - a_n + 1).max (1)
			Result := a_str.substring (l_start, a_str.count)
		ensure
			result_exists: Result /= Void
		end

end