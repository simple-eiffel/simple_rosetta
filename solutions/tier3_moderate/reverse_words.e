note
	description: "[
		Rosetta Code: Reverse words in a string
		https://rosettacode.org/wiki/Reverse_words_in_a_string

		Reverse the order of words in a string.
	]"
	author: "Eiffel Solution"
	rosetta_task: "Reverse_words_in_a_string"

class
	REVERSE_WORDS

create
	make

feature {NONE} -- Initialization

	make
			-- Demonstrate word reversal.
		local
			test_strings: ARRAY [STRING]
			i: INTEGER
		do
			test_strings := <<"Hey you, buster!", "---------- Ice-T ----------", "New York City">>

			print ("Reversing words in strings:%N%N")

			from i := test_strings.lower until i > test_strings.upper loop
				print ("Original: %"" + test_strings [i] + "%"%N")
				print ("Reversed: %"" + reverse_words (test_strings [i]) + "%"%N%N")
				i := i + 1
			end
		end

feature -- Reversal

	reverse_words (s: STRING): STRING
			-- Return s with words in reverse order.
		local
			words: LIST [STRING]
			i: INTEGER
		do
			-- Split into words
			words := s.split (' ')

			-- Build reversed string
			create Result.make (s.count)
			from i := words.count until i < 1 loop
				Result.append (words.i_th (i))
				if i > 1 then
					Result.append_character (' ')
				end
				i := i - 1
			end
		end

end
