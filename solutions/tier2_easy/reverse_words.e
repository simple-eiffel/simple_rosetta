note
	description: "[
		Rosetta Code: Reverse words in a string
		https://rosettacode.org/wiki/Reverse_words_in_a_string

		Reverse the order of words in a string.
	]"
	author: "Simple Eiffel"
	see_also: "https://github.com/simple-eiffel"
	rosetta_task: "Reverse_words_in_a_string"
	tier: "2"

class
	REVERSE_WORDS

create
	make

feature {NONE} -- Initialization

	make
			-- Demonstrate word reversal.
		do
			print ("Reverse Words in a String%N")
			print ("=========================%N%N")

			demo ("Hey you, buster!")
			demo ("  the sky   is blue  ")
			demo ("rosetta code")
			demo ("Eiffel is elegant")
		end

feature -- Demo

	demo (a_str: STRING)
			-- Show reversal.
		do
			print ("Original: '" + a_str + "'%N")
			print ("Reversed: '" + reverse_words (a_str) + "'%N%N")
		end

feature -- Operations

	reverse_words (a_str: STRING): STRING
			-- Reverse the order of words in `a_str'.
		require
			str_exists: a_str /= Void
		local
			l_words: LIST [STRING]
			l_i: INTEGER
		do
			l_words := a_str.split (' ')
			create Result.make (a_str.count)
			from l_i := l_words.count until l_i < 1 loop
				if not l_words [l_i].is_empty then
					if not Result.is_empty then
						Result.append_character (' ')
					end
					Result.append (l_words [l_i])
				end
				l_i := l_i - 1
			end
		ensure
			result_exists: Result /= Void
		end

	reverse_each_word (a_str: STRING): STRING
			-- Reverse each word individually (keep word order).
		require
			str_exists: a_str /= Void
		local
			l_words: LIST [STRING]
			l_word: STRING
		do
			l_words := a_str.split (' ')
			create Result.make (a_str.count)
			across l_words as l_w loop
				if not Result.is_empty then
					Result.append_character (' ')
				end
				l_word := l_w.twin
				l_word.mirror
				Result.append (l_word)
			end
		end

end
