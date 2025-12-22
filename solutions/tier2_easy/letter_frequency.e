note
	description: "[
		Rosetta Code: Letter frequency
		https://rosettacode.org/wiki/Letter_frequency

		Count frequency of each letter in text.
	]"
	author: "Simple Eiffel"
	see_also: "https://github.com/simple-eiffel"
	rosetta_task: "Letter_frequency"
	tier: "2"

class
	LETTER_FREQUENCY

create
	make

feature {NONE} -- Initialization

	make
			-- Demonstrate letter frequency.
		local
			l_text: STRING
			l_freq: HASH_TABLE [INTEGER, CHARACTER]
		do
			print ("Letter Frequency%N")
			print ("================%N%N")

			l_text := "The quick brown fox jumps over the lazy dog"
			print ("Text: " + l_text + "%N%N")

			l_freq := count_letters (l_text)
			print ("Letter frequencies:%N")
			print_frequencies (l_freq)
		end

feature -- Counting

	count_letters (a_text: STRING): HASH_TABLE [INTEGER, CHARACTER]
			-- Count frequency of each letter.
		require
			text_exists: a_text /= Void
		local
			l_i: INTEGER
			l_c: CHARACTER
		do
			create Result.make (26)
			from l_i := 1 until l_i > a_text.count loop
				l_c := a_text [l_i].as_lower
				if l_c >= 'a' and l_c <= 'z' then
					if Result.has (l_c) then
						Result [l_c] := Result [l_c] + 1
					else
						Result [l_c] := 1
					end
				end
				l_i := l_i + 1
			end
		ensure
			result_exists: Result /= Void
		end

	count_all_chars (a_text: STRING): HASH_TABLE [INTEGER, CHARACTER]
			-- Count frequency of all characters.
		require
			text_exists: a_text /= Void
		local
			l_i: INTEGER
			l_c: CHARACTER
		do
			create Result.make (100)
			from l_i := 1 until l_i > a_text.count loop
				l_c := a_text [l_i]
				if Result.has (l_c) then
					Result [l_c] := Result [l_c] + 1
				else
					Result [l_c] := 1
				end
				l_i := l_i + 1
			end
		ensure
			result_exists: Result /= Void
		end

feature {NONE} -- Display

	print_frequencies (a_freq: HASH_TABLE [INTEGER, CHARACTER])
			-- Print frequencies in order.
		local
			l_c: CHARACTER
		do
			from l_c := 'a' until l_c > 'z' loop
				if a_freq.has (l_c) then
					print ("  " + l_c.out + ": " + a_freq [l_c].out + "%N")
				end
				l_c := (l_c.code + 1).to_character_8
			end
		end

end