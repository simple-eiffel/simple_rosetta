note
	description: "[
		Rosetta Code: Title case
		https://rosettacode.org/wiki/Title_case

		Convert string to title case.
	]"
	author: "Simple Eiffel"
	see_also: "https://github.com/simple-eiffel"
	rosetta_task: "Title_case"
	tier: "2"

class
	TITLE_CASE

create
	make

feature {NONE} -- Initialization

	make
			-- Demonstrate title case conversion.
		do
			print ("Title Case%N")
			print ("==========%N%N")

			demo ("the quick brown fox")
			demo ("THE QUICK BROWN FOX")
			demo ("a tale of two cities")
			demo ("war and peace")
			demo ("the lord of the rings")
		end

feature -- Demo

	demo (a_str: STRING)
			-- Show conversion.
		do
			print ("'" + a_str + "'%N  -> '" + to_title_case (a_str) + "'%N%N")
		end

feature -- Conversion

	to_title_case (a_str: STRING): STRING
			-- Convert to title case (capitalize first letter of each word).
		require
			str_exists: a_str /= Void
		local
			l_i: INTEGER
			l_cap_next: BOOLEAN
			l_c: CHARACTER
		do
			Result := a_str.as_lower
			l_cap_next := True
			from l_i := 1 until l_i > Result.count loop
				l_c := Result [l_i]
				if l_c = ' ' or l_c = '%T' or l_c = '%N' then
					l_cap_next := True
				elseif l_cap_next then
					Result [l_i] := l_c.as_upper
					l_cap_next := False
				end
				l_i := l_i + 1
			end
		ensure
			result_exists: Result /= Void
		end

	to_title_case_smart (a_str: STRING): STRING
			-- Title case but keep small words lowercase (except first).
		require
			str_exists: a_str /= Void
		local
			l_words: LIST [STRING]
			l_word: STRING
			l_i: INTEGER
		do
			create Result.make (a_str.count)
			l_words := a_str.as_lower.split (' ')
			l_i := 0
			across l_words as l_w loop
				if l_i > 0 then
					Result.append_character (' ')
				end
				l_word := l_w.twin
				if l_i = 0 or not is_small_word (l_word) then
					if not l_word.is_empty then
						l_word [1] := l_word [1].as_upper
					end
				end
				Result.append (l_word)
				l_i := l_i + 1
			end
		ensure
			result_exists: Result /= Void
		end

feature {NONE} -- Helpers

	is_small_word (a_word: STRING): BOOLEAN
			-- Is this a small word that shouldn't be capitalized?
		local
			l_small: ARRAY [STRING]
		do
			l_small := <<"a", "an", "the", "and", "or", "but", "of", "in", "on", "at", "to">>
			Result := across l_small as l_s some l_s.is_case_insensitive_equal (a_word) end
		end

end