note
	description: "[
		Rosetta Code: Bifid cipher
		https://rosettacode.org/wiki/Bifid_cipher

		Classical cipher using a Polybius square and fractionation.
		Combines substitution and transposition.
	]"

class
	BIFID_CIPHER

feature -- Cipher Operations

	encrypt (plaintext, key: STRING): STRING
			-- Encrypt plaintext using Bifid cipher with given key
		require
			not_empty: not plaintext.is_empty
			valid_key: is_valid_key (key)
		local
			square: ARRAY [CHARACTER]
			text: STRING
			rows, cols: ARRAYED_LIST [INTEGER]
			combined: ARRAYED_LIST [INTEGER]
			i, r, c: INTEGER
		do
			square := create_square (key)
			text := prepare_text (plaintext)

			create rows.make (text.count)
			create cols.make (text.count)

			-- Get row and column for each character
			from i := 1 until i > text.count loop
				find_position (text [i], square, $r, $c)
				rows.extend (r)
				cols.extend (c)
				i := i + 1
			end

			-- Combine: all rows then all columns
			create combined.make (text.count * 2)
			across rows as row loop combined.extend (row) end
			across cols as col loop combined.extend (col) end

			-- Convert pairs back to characters
			create Result.make (text.count)
			from i := 1 until i > text.count loop
				r := combined [i]
				c := combined [i + text.count]
				Result.append_character (square [r * 5 + c + 1])
				i := i + 1
			end
		end

	decrypt (ciphertext, key: STRING): STRING
			-- Decrypt ciphertext using Bifid cipher
		require
			not_empty: not ciphertext.is_empty
			valid_key: is_valid_key (key)
		local
			square: ARRAY [CHARACTER]
			text: STRING
			combined: ARRAYED_LIST [INTEGER]
			i, r, c, mid: INTEGER
		do
			square := create_square (key)
			text := prepare_text (ciphertext)

			-- Get row/col values for each ciphertext character
			create combined.make (text.count * 2)
			from i := 1 until i > text.count loop
				find_position (text [i], square, $r, $c)
				combined.extend (r)
				combined.extend (c)
				i := i + 1
			end

			-- Deinterleave: first half is rows, second half is columns
			mid := text.count
			create Result.make (text.count)
			from i := 1 until i > text.count loop
				r := combined [i]
				c := combined [i + mid]
				Result.append_character (square [r * 5 + c + 1])
				i := i + 1
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
			-- Add key characters
			across prepared_key as ch loop
				c := ch
				if c = 'J' then c := 'I' end
				if c >= 'A' and c <= 'Z' and not used [c.code - ('A').code] then
					Result [i] := c
					used [c.code - ('A').code] := True
					i := i + 1
				end
			end

			-- Add remaining alphabet
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
			-- Is key valid for Bifid cipher?
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
					i := 26  -- Exit
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
			plaintext := "HELLO WORLD"

			print ("Bifid Cipher Demo:%N%N")
			print ("Key: " + key + "%N")
			print ("Plaintext: " + plaintext + "%N")

			encrypted := encrypt (plaintext, key)
			print ("Encrypted: " + encrypted + "%N")

			decrypted := decrypt (encrypted, key)
			print ("Decrypted: " + decrypted + "%N")
		end

end
