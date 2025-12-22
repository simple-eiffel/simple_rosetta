note
	description: "[
		Rosetta Code: Anagrams
		https://rosettacode.org/wiki/Anagrams

		Detect if two words are anagrams of each other.
	]"
	author: "Simple Eiffel"
	see_also: "https://github.com/simple-eiffel"
	rosetta_task: "Anagrams"
	tier: "2"

class
	ANAGRAM_DETECTOR

create
	make

feature {NONE} -- Initialization

	make
			-- Demonstrate anagram detection.
		do
			print ("Anagram Detection%N")
			print ("=================%N%N")

			test ("listen", "silent")
			test ("triangle", "integral")
			test ("hello", "world")
			test ("stressed", "desserts")
			test ("abc", "cab")
		end

feature -- Testing

	test (a_word1, a_word2: STRING)
			-- Test if words are anagrams.
		do
			print ("'" + a_word1 + "' and '" + a_word2 + "': ")
			if are_anagrams (a_word1, a_word2) then
				print ("ARE anagrams%N")
			else
				print ("NOT anagrams%N")
			end
		end

feature -- Detection

	are_anagrams (a_word1, a_word2: STRING): BOOLEAN
			-- Are the words anagrams of each other?
		require
			word1_exists: a_word1 /= Void
			word2_exists: a_word2 /= Void
		local
			l_sorted1, l_sorted2: STRING
		do
			l_sorted1 := sorted_chars (a_word1.as_lower)
			l_sorted2 := sorted_chars (a_word2.as_lower)
			Result := l_sorted1.same_string (l_sorted2)
		end

	sorted_chars (a_str: STRING): STRING
			-- String with characters sorted alphabetically.
		require
			str_exists: a_str /= Void
		local
			l_chars: ARRAYED_LIST [CHARACTER]
			l_i, l_j: INTEGER
			l_temp: CHARACTER
		do
			create l_chars.make (a_str.count)
			from l_i := 1 until l_i > a_str.count loop
				l_chars.extend (a_str [l_i])
				l_i := l_i + 1
			end

			-- Simple sort
			from l_i := 1 until l_i >= l_chars.count loop
				from l_j := l_i + 1 until l_j > l_chars.count loop
					if l_chars [l_j] < l_chars [l_i] then
						l_temp := l_chars [l_i]
						l_chars [l_i] := l_chars [l_j]
						l_chars [l_j] := l_temp
					end
					l_j := l_j + 1
				end
				l_i := l_i + 1
			end

			create Result.make (l_chars.count)
			across l_chars as l_c loop
				Result.append_character (l_c)
			end
		ensure
			result_exists: Result /= Void
			same_length: Result.count = a_str.count
		end

end