note
	description: "[
		Rosetta Code: Pig Latin
		https://rosettacode.org/wiki/Pig_Latin

		Convert text to Pig Latin.
	]"
	author: "Simple Eiffel"
	see_also: "https://github.com/simple-eiffel"
	rosetta_task: "Pig_Latin"
	tier: "2"

class
	PIG_LATIN

create
	make

feature {NONE} -- Initialization

	make
			-- Demonstrate Pig Latin conversion.
		do
			print ("Pig Latin%N")
			print ("=========%N%N")

			demo ("hello")
			demo ("apple")
			demo ("question")
			demo ("string")
			demo ("The quick brown fox")
		end

feature -- Demo

	demo (a_text: STRING)
			-- Show conversion.
		do
			print ("'" + a_text + "' -> '" + to_pig_latin (a_text) + "'%N")
		end

feature -- Conversion

	to_pig_latin (a_text: STRING): STRING
			-- Convert text to Pig Latin.
		require
			text_exists: a_text /= Void
		local
			l_words: LIST [STRING]
			l_word: STRING
		do
			create Result.make (a_text.count + 20)
			l_words := a_text.split (' ')
			across l_words as l_w loop
				if not Result.is_empty then
					Result.append_character (' ')
				end
				l_word := word_to_pig (l_w)
				Result.append (l_word)
			end
		ensure
			result_exists: Result /= Void
		end

	word_to_pig (a_word: STRING): STRING
			-- Convert single word to Pig Latin.
		require
			word_exists: a_word /= Void
		local
			l_first_vowel: INTEGER
			l_lower: STRING
		do
			if a_word.is_empty then
				Result := ""
			else
				l_lower := a_word.as_lower
				l_first_vowel := first_vowel_position (l_lower)
				if l_first_vowel = 1 then
					-- Starts with vowel: add "way"
					Result := a_word + "way"
				elseif l_first_vowel > 1 then
					-- Move consonant cluster to end, add "ay"
					Result := a_word.substring (l_first_vowel, a_word.count) +
					         a_word.substring (1, l_first_vowel - 1).as_lower + "ay"
				else
					-- No vowels
					Result := a_word + "ay"
				end
			end
		ensure
			result_exists: Result /= Void
		end

feature {NONE} -- Helpers

	first_vowel_position (a_word: STRING): INTEGER
			-- Position of first vowel (0 if none).
		local
			l_i: INTEGER
		do
			from l_i := 1 until l_i > a_word.count or Result > 0 loop
				if is_vowel (a_word [l_i]) then
					Result := l_i
				end
				l_i := l_i + 1
			end
		end

	is_vowel (a_char: CHARACTER): BOOLEAN
			-- Is character a vowel?
		local
			l_c: CHARACTER
		do
			l_c := a_char.as_lower
			Result := l_c = 'a' or l_c = 'e' or l_c = 'i' or l_c = 'o' or l_c = 'u'
		end

end