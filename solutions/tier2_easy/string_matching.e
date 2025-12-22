note
	description: "[
		Rosetta Code: String matching
		https://rosettacode.org/wiki/String_matching

		Determine if a string matches another at start, end, or anywhere.
	]"
	author: "Simple Eiffel"
	see_also: "https://github.com/simple-eiffel"
	rosetta_task: "String_matching"
	tier: "2"

class
	STRING_MATCHING

create
	make

feature {NONE} -- Initialization

	make
			-- Demonstrate string matching.
		local
			l_str: STRING
		do
			print ("String Matching%N")
			print ("===============%N%N")

			l_str := "The quick brown fox jumps over the lazy dog"
			print ("String: '" + l_str + "'%N%N")

			-- Starts with
			print ("Starts with 'The': " + starts_with (l_str, "The").out + "%N")
			print ("Starts with 'the': " + starts_with (l_str, "the").out + "%N")

			-- Ends with
			print ("Ends with 'dog': " + ends_with (l_str, "dog").out + "%N")
			print ("Ends with 'cat': " + ends_with (l_str, "cat").out + "%N")

			-- Contains
			print ("Contains 'brown': " + contains (l_str, "brown").out + "%N")
			print ("Contains 'green': " + contains (l_str, "green").out + "%N")

			-- Position
			print ("%NPosition of 'fox': " + index_of (l_str, "fox").out + "%N")
			print ("Position of 'the': " + index_of (l_str, "the").out + "%N")
			print ("Position of 'xyz': " + index_of (l_str, "xyz").out + "%N")
		end

feature -- Matching

	starts_with (a_str, a_prefix: STRING): BOOLEAN
			-- Does `a_str' start with `a_prefix'?
		require
			str_exists: a_str /= Void
			prefix_exists: a_prefix /= Void
		do
			Result := a_str.starts_with (a_prefix)
		end

	ends_with (a_str, a_suffix: STRING): BOOLEAN
			-- Does `a_str' end with `a_suffix'?
		require
			str_exists: a_str /= Void
			suffix_exists: a_suffix /= Void
		do
			Result := a_str.ends_with (a_suffix)
		end

	contains (a_str, a_pattern: STRING): BOOLEAN
			-- Does `a_str' contain `a_pattern'?
		require
			str_exists: a_str /= Void
			pattern_exists: a_pattern /= Void
		do
			Result := a_str.has_substring (a_pattern)
		end

	index_of (a_str, a_pattern: STRING): INTEGER
			-- First position of `a_pattern' in `a_str' (0 if not found).
		require
			str_exists: a_str /= Void
			pattern_exists: a_pattern /= Void
		do
			Result := a_str.substring_index (a_pattern, 1)
		ensure
			valid_result: Result >= 0
		end

	count_occurrences (a_str, a_pattern: STRING): INTEGER
			-- Count non-overlapping occurrences of `a_pattern' in `a_str'.
		require
			str_exists: a_str /= Void
			pattern_exists: a_pattern /= Void
			pattern_not_empty: not a_pattern.is_empty
		local
			l_pos: INTEGER
		do
			from l_pos := 1 until l_pos = 0 or l_pos > a_str.count loop
				l_pos := a_str.substring_index (a_pattern, l_pos)
				if l_pos > 0 then
					Result := Result + 1
					l_pos := l_pos + a_pattern.count
				end
			end
		ensure
			non_negative: Result >= 0
		end

end
