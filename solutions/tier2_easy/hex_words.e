note
	description: "[
		Rosetta Code: Hex words
		https://rosettacode.org/wiki/Hex_words

		Find words that are valid hexadecimal numbers.
	]"
	author: "Simple Eiffel"
	see_also: "https://github.com/simple-eiffel"
	rosetta_task: "Hex_words"
	tier: "2"

class
	HEX_WORDS

create
	make

feature {NONE} -- Initialization

	make
			-- Find hex words.
		local
			l_words: ARRAY [STRING]
			l_hex_words: ARRAYED_LIST [TUPLE [word: STRING; value: NATURAL_64]]
		do
			-- Sample word list
			l_words := <<"abed", "aced", "babe", "bead", "beef", "cafe", "cede",
				"dace", "dead", "deaf", "deed", "face", "fade", "feed",
				"hello", "world", "eiffel", "abcdef">>

			create l_hex_words.make (10)

			print ("Hex Words (valid hexadecimal)%N")
			print ("=============================%N%N")

			across l_words as l_w loop
				if is_hex_word (l_w) then
					l_hex_words.extend ([l_w.twin, hex_value (l_w)])
				end
			end

			print ("Found " + l_hex_words.count.out + " hex words:%N")
			across l_hex_words as l_hw loop
				print ("  " + l_hw.word + " = 0x" + l_hw.value.to_hex_string + " (" + l_hw.value.out + ")%N")
			end
		end

feature -- Analysis

	is_hex_word (a_word: STRING): BOOLEAN
			-- Is `a_word' a valid hex number (only a-f)?
		require
			word_exists: a_word /= Void
		local
			l_i: INTEGER
			l_c: CHARACTER
		do
			Result := not a_word.is_empty
			from l_i := 1 until l_i > a_word.count or not Result loop
				l_c := a_word [l_i].as_lower
				Result := (l_c >= 'a' and l_c <= 'f')
				l_i := l_i + 1
			end
		end

	hex_value (a_word: STRING): NATURAL_64
			-- Convert hex word to numeric value.
		require
			is_hex: is_hex_word (a_word)
		local
			l_i: INTEGER
			l_c: CHARACTER
		do
			from l_i := 1 until l_i > a_word.count loop
				l_c := a_word [l_i].as_lower
				Result := Result * 16 + (l_c.code - ('a').code + 10).to_natural_64
				l_i := l_i + 1
			end
		end

end
