note
	description: "[
		Rosetta Code: Playfair cipher
		https://rosettacode.org/wiki/Playfair_cipher

		Classical digraph substitution cipher using a 5x5 key square.
		Encrypts pairs of letters using position-based rules.
	]"

class
	PLAYFAIR_CIPHER

feature -- Cipher Operations

	encrypt (plaintext, key: STRING): STRING
			-- Encrypt plaintext using Playfair cipher
		require
			not_empty: not plaintext.is_empty
			valid_key: is_valid_key (key)
		local
			square: ARRAY [CHARACTER]
			digraphs: ARRAYED_LIST [TUPLE [c1, c2: CHARACTER]]
			r1, c1, r2, c2: INTEGER
		do
			square := create_square (key)
			digraphs := prepare_digraphs (plaintext)

			create Result.make (digraphs.count * 2)
			across digraphs as dg loop
				find_position (dg.c1, square, $r1, $c1)
				find_position (dg.c2, square, $r2, $c2)

				if r1 = r2 then
					-- Same row: shift right
					Result.append_character (square [r1 * 5 + ((c1 + 1) \\ 5) + 1])
					Result.append_character (square [r2 * 5 + ((c2 + 1) \\ 5) + 1])
				elseif c1 = c2 then
					-- Same column: shift down
					Result.append_character (square [((r1 + 1) \\ 5) * 5 + c1 + 1])
					Result.append_character (square [((r2 + 1) \\ 5) * 5 + c2 + 1])
				else
					-- Rectangle: swap columns
					Result.append_character (square [r1 * 5 + c2 + 1])
					Result.append_character (square [r2 * 5 + c1 + 1])
				end
			end
		end

	decrypt (ciphertext, key: STRING): STRING
			-- Decrypt ciphertext using Playfair cipher
		require
			not_empty: not ciphertext.is_empty
			valid_key: is_valid_key (key)
		local
			square: ARRAY [CHARACTER]
			i, r1, c1, r2, c2: INTEGER
			text: STRING
			ch1, ch2: CHARACTER
		do
			square := create_square (key)
			text := prepare_text (ciphertext)

			create Result.make (text.count)
			from i := 1 until i > text.count - 1 loop
				ch1 := text [i]
				ch2 := text [i + 1]
				find_position (ch1, square, $r1, $c1)
				find_position (ch2, square, $r2, $c2)

				if r1 = r2 then
					-- Same row: shift left
					Result.append_character (square [r1 * 5 + ((c1 + 4) \\ 5) + 1])
					Result.append_character (square [r2 * 5 + ((c2 + 4) \\ 5) + 1])
				elseif c1 = c2 then
					-- Same column: shift up
					Result.append_character (square [((r1 + 4) \\ 5) * 5 + c1 + 1])
					Result.append_character (square [((r2 + 4) \\ 5) * 5 + c2 + 1])
				else
					-- Rectangle: swap columns
					Result.append_character (square [r1 * 5 + c2 + 1])
					Result.append_character (square [r2 * 5 + c1 + 1])
				end
				i := i + 2
			end
		end

feature -- Key/Square

	create_square (key: STRING): ARRAY [CHARACTER]
			-- Create 5x5 Polybius square from key (I/J combined)
		local
			used: ARRAY [BOOLEAN]
			i: INTEGER
			c: CHARACTER
			prepared_key: STRING
		do
			create Result.make_filled ('%U', 1, 25)
			create used.make_filled (False, 0, 25)
			prepared_key := key.as_upper

			i := 1
			across prepared_key as ch loop
				c := ch
				if c = 'J' then c := 'I' end
				if c >= 'A' and c <= 'Z' and not used [c.code - ('A').code] then
					Result [i] := c
					used [c.code - ('A').code] := True
					i := i + 1
				end
			end

			from c := 'A' until c > 'Z' loop
				if c /= 'J' and not used [c.code - ('A').code] then
					Result [i] := c
					i := i + 1
				end
				c := (c.code + 1).to_character_8
			end
		ensure
			correct_size: Result.count = 25
		end

	is_valid_key (key: STRING): BOOLEAN
			-- Is key valid for Playfair cipher?
		do
			Result := key /= Void and then not key.is_empty
		end

feature {NONE} -- Implementation

	prepare_text (text: STRING): STRING
			-- Convert to uppercase, replace J with I, remove non-letters
		local
			c: CHARACTER
		do
			create Result.make (text.count)
			across text as ch loop
				c := ch.as_upper
				if c = 'J' then c := 'I' end
				if c >= 'A' and c <= 'Z' then
					Result.append_character (c)
				end
			end
		end

	prepare_digraphs (text: STRING): ARRAYED_LIST [TUPLE [c1, c2: CHARACTER]]
			-- Prepare text as digraphs, inserting X between doubles
		local
			prepared: STRING
			i: INTEGER
			c1, c2: CHARACTER
		do
			prepared := prepare_text (text)
			create Result.make (prepared.count)

			from i := 1 until i > prepared.count loop
				c1 := prepared [i]
				if i < prepared.count then
					c2 := prepared [i + 1]
					if c1 = c2 then
						Result.extend ([c1, 'X'])
						i := i + 1
					else
						Result.extend ([c1, c2])
						i := i + 2
					end
				else
					Result.extend ([c1, 'X'])
					i := i + 1
				end
			end
		end

	find_position (c: CHARACTER; square: ARRAY [CHARACTER]; row, col: POINTER)
			-- Find row and column of character in square
		require
			valid_char: c >= 'A' and c <= 'Z' and c /= 'J'
		local
			i: INTEGER
			r, co: INTEGER
		do
			from i := 1 until i > 25 loop
				if square [i] = c then
					r := (i - 1) // 5
					co := (i - 1) \\ 5
					i := 26
				end
				i := i + 1
			end
			($row).memory_copy ($r, {PLATFORM}.integer_32_bytes)
			($col).memory_copy ($co, {PLATFORM}.integer_32_bytes)
		end

feature -- Demo

	demo
			-- Standard Rosetta Code demo
		local
			key, plaintext, encrypted, decrypted: STRING
		do
			key := "PLAYFAIR EXAMPLE"
			plaintext := "HIDE THE GOLD IN THE TREE STUMP"

			print ("Playfair Cipher Demo:%N%N")
			print ("Key: " + key + "%N")
			print ("Plaintext: " + plaintext + "%N")

			encrypted := encrypt (plaintext, key)
			print ("Encrypted: " + encrypted + "%N")

			decrypted := decrypt (encrypted, key)
			print ("Decrypted: " + decrypted + "%N")
		end

end
