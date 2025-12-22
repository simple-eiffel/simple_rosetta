note
	description: "[
		Rosetta Code: Lyndon word
		https://rosettacode.org/wiki/Lyndon_word

		Generate Lyndon words of given length over alphabet.
	]"
	author: "Simple Eiffel"
	see_also: "https://github.com/simple-eiffel"
	rosetta_task: "Lyndon_word"
	tier: "3"

class
	LYNDON_WORD

create
	make

feature {NONE} -- Initialization

	make
			-- Generate Lyndon words.
		do
			print ("Lyndon Words%N")
			print ("============%N%N")

			print ("Binary Lyndon words of length <= 4:%N")
			generate_lyndon ("01", 4)

			print ("%NABC Lyndon words of length <= 3:%N")
			generate_lyndon ("abc", 3)
		end

feature -- Generation

	generate_lyndon (a_alphabet: STRING; a_max_length: INTEGER)
			-- Generate all Lyndon words up to `a_max_length' over `a_alphabet'.
		require
			alphabet_exists: a_alphabet /= Void
			valid_length: a_max_length > 0
		local
			l_words: ARRAYED_LIST [STRING]
		do
			l_words := duval (a_alphabet, a_max_length)
			across l_words as l_w loop
				print ("  " + l_w + "%N")
			end
			print ("Count: " + l_words.count.out + "%N")
		end

	duval (a_alphabet: STRING; a_max_length: INTEGER): ARRAYED_LIST [STRING]
			-- Duval algorithm for generating Lyndon words.
		local
			l_w: ARRAYED_LIST [INTEGER]
			l_i, l_j, l_m: INTEGER
			l_word: STRING
		do
			create Result.make (100)
			create l_w.make (a_max_length + 1)
			l_w.extend (-1)

			from until l_w.count = 1 loop
				-- Repeat last character
				l_i := l_w.last
				from until l_w.count > a_max_length loop
					l_w.extend (l_i)
				end

				-- Remove trailing max characters and increment
				from until l_w.is_empty or else l_w.last < a_alphabet.count - 1 loop
					l_w.finish
					l_w.remove
				end

				if not l_w.is_empty then
					l_w [l_w.count] := l_w.last + 1
				end

				-- Output Lyndon word if valid
				if l_w.count > 1 then
					create l_word.make (l_w.count - 1)
					from l_j := 2 until l_j > l_w.count loop
						l_word.append_character (a_alphabet [l_w [l_j] + 1])
						l_j := l_j + 1
					end
					if is_lyndon (l_word) then
						Result.extend (l_word)
					end
				end
			end
		end

	is_lyndon (a_word: STRING): BOOLEAN
			-- Is `a_word' a Lyndon word (strictly smallest rotation)?
		local
			l_rotation: STRING
			l_i: INTEGER
		do
			Result := True
			from l_i := 2 until l_i > a_word.count or not Result loop
				l_rotation := a_word.substring (l_i, a_word.count) + a_word.substring (1, l_i - 1)
				if l_rotation <= a_word then
					Result := False
				end
				l_i := l_i + 1
			end
		end

end
