note
	description: "[
		Rosetta Code: Substring
		https://rosettacode.org/wiki/Substring

		Extract substrings from a string.
	]"
	author: "Simple Eiffel"
	see_also: "https://github.com/simple-eiffel"
	rosetta_task: "Substring"
	tier: "2"

class
	SUBSTRING

create
	make

feature {NONE} -- Initialization

	make
			-- Demonstrate substring operations.
		local
			l_str: STRING
		do
			print ("Substring Operations%N")
			print ("====================%N%N")

			l_str := "Hello, World!"
			print ("String: '" + l_str + "'%N%N")

			-- Starting from n characters in and of m length
			print ("Substring(3, 5): '" + l_str.substring (3, 7) + "'%N")

			-- Starting from n characters in, up to the end
			print ("From position 8: '" + l_str.substring (8, l_str.count) + "'%N")

			-- First m characters
			print ("First 5 chars: '" + first_n (l_str, 5) + "'%N")

			-- Last m characters
			print ("Last 6 chars: '" + last_n (l_str, 6) + "'%N")
		end

feature -- Operations

	substring_from_length (a_str: STRING; a_start, a_length: INTEGER): STRING
			-- Extract substring of length from start position.
		require
			str_exists: a_str /= Void
			valid_start: a_start >= 1 and a_start <= a_str.count
			valid_length: a_length >= 0
		do
			Result := a_str.substring (a_start, (a_start + a_length - 1).min (a_str.count))
		ensure
			result_exists: Result /= Void
		end

	first_n (a_str: STRING; a_n: INTEGER): STRING
			-- First n characters.
		require
			str_exists: a_str /= Void
			positive_n: a_n >= 0
		do
			Result := a_str.substring (1, a_n.min (a_str.count))
		ensure
			result_exists: Result /= Void
		end

	last_n (a_str: STRING; a_n: INTEGER): STRING
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