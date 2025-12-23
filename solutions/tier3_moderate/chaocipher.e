note
	description: "[
		Rosetta Code: Chaocipher
		https://rosettacode.org/wiki/Chaocipher

		Cipher invented by J.F. Byrne using two rotating alphabets.
		Each character encryption permutes both alphabets.
	]"

class
	CHAOCIPHER

feature -- Cipher Operations

	encrypt (plaintext: STRING; left_alpha, right_alpha: STRING): STRING
			-- Encrypt plaintext using Chaocipher
		require
			not_empty: not plaintext.is_empty
			valid_left: is_valid_alphabet (left_alpha)
			valid_right: is_valid_alphabet (right_alpha)
		local
			left, right: STRING
			i, pos: INTEGER
			c: CHARACTER
		do
			left := left_alpha.twin
			right := right_alpha.twin
			create Result.make (plaintext.count)

			from i := 1 until i > plaintext.count loop
				c := plaintext [i].as_upper
				if c >= 'A' and c <= 'Z' then
					pos := right.index_of (c, 1)
					Result.append_character (left [pos])
					permute_left (left, pos)
					permute_right (right, pos)
				end
				i := i + 1
			end
		end

	decrypt (ciphertext: STRING; left_alpha, right_alpha: STRING): STRING
			-- Decrypt ciphertext using Chaocipher
		require
			not_empty: not ciphertext.is_empty
			valid_left: is_valid_alphabet (left_alpha)
			valid_right: is_valid_alphabet (right_alpha)
		local
			left, right: STRING
			i, pos: INTEGER
			c: CHARACTER
		do
			left := left_alpha.twin
			right := right_alpha.twin
			create Result.make (ciphertext.count)

			from i := 1 until i > ciphertext.count loop
				c := ciphertext [i].as_upper
				if c >= 'A' and c <= 'Z' then
					pos := left.index_of (c, 1)
					Result.append_character (right [pos])
					permute_left (left, pos)
					permute_right (right, pos)
				end
				i := i + 1
			end
		end

feature -- Validation

	is_valid_alphabet (alpha: STRING): BOOLEAN
			-- Is alpha a valid 26-letter permutation?
		local
			used: ARRAY [BOOLEAN]
			c: CHARACTER
		do
			if alpha /= Void and then alpha.count = 26 then
				create used.make_filled (False, 0, 25)
				Result := True
				across alpha as ch loop
					c := ch.as_upper
					if c >= 'A' and c <= 'Z' then
						if used [c.code - ('A').code] then
							Result := False
						else
							used [c.code - ('A').code] := True
						end
					else
						Result := False
					end
				end
			end
		end

feature {NONE} -- Implementation

	permute_left (alpha: STRING; pos: INTEGER)
			-- Permute left alphabet after encryption at pos
		local
			i: INTEGER
			temp, extract: CHARACTER
		do
			-- Rotate so pos is at position 1
			from i := 1 until i >= pos loop
				temp := alpha [1]
				alpha.remove (1)
				alpha.append_character (temp)
				i := i + 1
			end
			-- Extract position 2, insert after position 13
			extract := alpha [2]
			alpha.remove (2)
			alpha.insert_character (extract, 14)
		end

	permute_right (alpha: STRING; pos: INTEGER)
			-- Permute right alphabet after encryption at pos
		local
			i: INTEGER
			temp, extract: CHARACTER
		do
			-- Rotate so pos is at position 1, then shift once more
			from i := 1 until i > pos loop
				temp := alpha [1]
				alpha.remove (1)
				alpha.append_character (temp)
				i := i + 1
			end
			-- Extract position 3, insert after position 13
			extract := alpha [3]
			alpha.remove (3)
			alpha.insert_character (extract, 14)
		end

feature -- Demo

	demo
			-- Standard Rosetta Code demo
		local
			left, right, plaintext, encrypted, decrypted: STRING
		do
			-- Standard test alphabets
			left := "HXUCZVAMDSLKPEFJRIGTWOBNYQ"
			right := "PTLNBQDEOYSFAVZKGJRIHWXUMC"
			plaintext := "WELLDONEISBETTERTHANWELLSAID"

			print ("Chaocipher Demo:%N%N")
			print ("Left alphabet:  " + left + "%N")
			print ("Right alphabet: " + right + "%N")
			print ("Plaintext:  " + plaintext + "%N")

			encrypted := encrypt (plaintext, left, right)
			print ("Ciphertext: " + encrypted + "%N")

			decrypted := decrypt (encrypted, left, right)
			print ("Decrypted:  " + decrypted + "%N")
		end

end
