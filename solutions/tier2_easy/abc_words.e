note
	description: "[
		Rosetta Code: ABC words
		https://rosettacode.org/wiki/ABC_words

		Find words that can be spelled with ABC blocks.
	]"
	author: "Simple Eiffel"
	see_also: "https://github.com/simple-eiffel"
	rosetta_task: "ABC_words"
	tier: "2"

class
	ABC_WORDS

create
	make

feature {NONE} -- Initialization

	make
			-- Test ABC block words.
		do
			print ("ABC Block Word Checker%N")
			print ("======================%N%N")

			print ("Blocks: BO, XK, DQ, CP, NA, GT, RE, TG, QD, FS,%N")
			print ("        JW, HU, VI, AN, OB, ER, FS, LY, PC, ZM%N%N")

			test_word ("A")
			test_word ("BARK")
			test_word ("BOOK")
			test_word ("TREAT")
			test_word ("COMMON")
			test_word ("SQUAD")
			test_word ("CONFUSE")
		end

feature -- Testing

	test_word (a_word: STRING)
			-- Test if word can be spelled with blocks.
		do
			print ("Can spell '" + a_word + "': " + can_make_word (a_word).out + "%N")
		end

	can_make_word (a_word: STRING): BOOLEAN
			-- Can `a_word' be spelled using ABC blocks?
		local
			l_blocks: ARRAYED_LIST [STRING]
			l_used: ARRAY [BOOLEAN]
			l_i, l_j: INTEGER
			l_char: CHARACTER
			l_found: BOOLEAN
		do
			l_blocks := blocks.twin
			create l_used.make_filled (False, 1, l_blocks.count)
			Result := True

			from l_i := 1 until l_i > a_word.count or not Result loop
				l_char := a_word [l_i].as_upper
				l_found := False

				from l_j := 1 until l_j > l_blocks.count or l_found loop
					if not l_used [l_j] then
						if l_blocks [l_j].has (l_char) then
							l_used [l_j] := True
							l_found := True
						end
					end
					l_j := l_j + 1
				end

				if not l_found then
					Result := False
				end
				l_i := l_i + 1
			end
		end

feature {NONE} -- Data

	blocks: ARRAYED_LIST [STRING]
			-- The 20 ABC blocks.
		once
			create Result.make (20)
			Result.extend ("BO")
			Result.extend ("XK")
			Result.extend ("DQ")
			Result.extend ("CP")
			Result.extend ("NA")
			Result.extend ("GT")
			Result.extend ("RE")
			Result.extend ("TG")
			Result.extend ("QD")
			Result.extend ("FS")
			Result.extend ("JW")
			Result.extend ("HU")
			Result.extend ("VI")
			Result.extend ("AN")
			Result.extend ("OB")
			Result.extend ("ER")
			Result.extend ("FS")
			Result.extend ("LY")
			Result.extend ("PC")
			Result.extend ("ZM")
		end

end
