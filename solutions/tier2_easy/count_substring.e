note
	description: "[
		Rosetta Code: Count occurrences of a substring
		https://rosettacode.org/wiki/Count_occurrences_of_a_substring
		
		Count how many times a substring appears in a string.
	]"
	author: "Simple Eiffel"
	see_also: "https://github.com/simple-eiffel - Modern Eiffel libraries"
	rosetta_task: "Count_occurrences_of_a_substring"

class
	COUNT_SUBSTRING

create
	make

feature {NONE} -- Initialization

	make
		do
			print ("Count 'the' in 'the three truths': " + 
				count_occurrences ("the three truths", "the").out + "%N")
			print ("Count 'abab' in 'ababababab': " + 
				count_occurrences ("ababababab", "abab").out + "%N")
			print ("Count 'a' in 'aaaaaa': " + 
				count_occurrences ("aaaaaa", "a").out + "%N")
		end

feature -- Counting

	count_occurrences (text, pattern: STRING): INTEGER
			-- Count non-overlapping occurrences of `pattern' in `text'.
		require
			text_not_void: text /= Void
			pattern_not_empty: pattern /= Void and then not pattern.is_empty
		local
			pos: INTEGER
		do
			from pos := 1 until pos = 0 or pos > text.count loop
				pos := text.substring_index (pattern, pos)
				if pos > 0 then
					Result := Result + 1
					pos := pos + pattern.count
				end
			end
		ensure
			non_negative: Result >= 0
		end

end
