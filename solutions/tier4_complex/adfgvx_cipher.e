note
	description: "[
		Rosetta Code: ADFGVX cipher
		https://rosettacode.org/wiki/ADFGVX_cipher

		WWI German cipher combining substitution (Polybius square)
		with columnar transposition. Uses ADFGVX as cipher alphabet.
	]"

class
	ADFGVX_CIPHER

feature -- Constants

	Cipher_chars: STRING = "ADFGVX"
			-- The 6 characters used in ADFGVX cipher

feature -- Cipher Operations

	encrypt (plaintext, polybius_key, transposition_key: STRING): STRING
			-- Encrypt plaintext using ADFGVX cipher
		require
			not_empty: not plaintext.is_empty
			valid_polybius: is_valid_polybius_key (polybius_key)
			valid_transposition: not transposition_key.is_empty
		local
			square: STRING
			fractionated: STRING
			columns: ARRAY [STRING]
			sorted_key: STRING
			i, j, pos, col_index: INTEGER
			c: CHARACTER
		do
			-- Build 6x6 Polybius square
			square := build_square (polybius_key)

			-- Fractionation: convert each plaintext char to two ADFGVX chars
			create fractionated.make (plaintext.count * 2)
			from i := 1 until i > plaintext.count loop
				c := plaintext [i].as_upper
				if (c >= 'A' and c <= 'Z') or (c >= '0' and c <= '9') then
					pos := square.index_of (c, 1)
					if pos > 0 then
						fractionated.append_character (Cipher_chars [(pos - 1) // 6 + 1])
						fractionated.append_character (Cipher_chars [(pos - 1) \\ 6 + 1])
					end
				end
				i := i + 1
			end

			-- Columnar transposition
			create columns.make_filled ("", 1, transposition_key.count)
			from i := 1 until i > transposition_key.count loop
				columns [i] := ""
				i := i + 1
			end

			-- Fill columns
			from i := 1 until i > fractionated.count loop
				col_index := ((i - 1) \\ transposition_key.count) + 1
				columns [col_index].append_character (fractionated [i])
				i := i + 1
			end

			-- Read columns in key order
			sorted_key := sorted_key_order (transposition_key)
			create Result.make (fractionated.count)
			from i := 1 until i > sorted_key.count loop
				j := transposition_key.index_of (sorted_key [i], 1)
				Result.append (columns [j])
				i := i + 1
			end
		end

	decrypt (ciphertext, polybius_key, transposition_key: STRING): STRING
			-- Decrypt ciphertext using ADFGVX cipher
		require
			not_empty: not ciphertext.is_empty
			valid_polybius: is_valid_polybius_key (polybius_key)
			valid_transposition: not transposition_key.is_empty
		local
			square: STRING
			columns: ARRAY [STRING]
			sorted_key: STRING
			col_lengths: ARRAY [INTEGER]
			base_len, extra, i, j, pos, idx, r, c_idx: INTEGER
			fractionated: STRING
		do
			square := build_square (polybius_key)

			-- Calculate column lengths
			base_len := ciphertext.count // transposition_key.count
			extra := ciphertext.count \\ transposition_key.count
			create col_lengths.make_filled (base_len, 1, transposition_key.count)

			-- Distribute extra characters
			sorted_key := sorted_key_order (transposition_key)
			from i := 1 until i > extra loop
				j := transposition_key.index_of (sorted_key [i], 1)
				col_lengths [j] := col_lengths [j] + 1
				i := i + 1
			end

			-- Extract columns from ciphertext
			create columns.make_filled ("", 1, transposition_key.count)
			pos := 1
			from i := 1 until i > sorted_key.count loop
				j := transposition_key.index_of (sorted_key [i], 1)
				columns [j] := ciphertext.substring (pos, pos + col_lengths [j] - 1)
				pos := pos + col_lengths [j]
				i := i + 1
			end

			-- Read in row order to get fractionated text
			create fractionated.make (ciphertext.count)
			create col_lengths.make_filled (1, 1, transposition_key.count)  -- Reuse as indices
			from i := 1 until i > ciphertext.count loop
				j := ((i - 1) \\ transposition_key.count) + 1
				idx := col_lengths [j]
				if idx <= columns [j].count then
					fractionated.append_character (columns [j] [idx])
					col_lengths [j] := idx + 1
				end
				i := i + 1
			end

			-- Defractionation: convert pairs back to plaintext
			create Result.make (fractionated.count // 2)
			from i := 1 until i > fractionated.count - 1 loop
				r := Cipher_chars.index_of (fractionated [i], 1) - 1
				c_idx := Cipher_chars.index_of (fractionated [i + 1], 1) - 1
				if r >= 0 and c_idx >= 0 then
					Result.append_character (square [r * 6 + c_idx + 1])
				end
				i := i + 2
			end
		end

feature -- Validation

	is_valid_polybius_key (key: STRING): BOOLEAN
			-- Is key valid for 6x6 Polybius square?
		do
			Result := key /= Void and then not key.is_empty
		end

feature {NONE} -- Implementation

	build_square (key: STRING): STRING
			-- Build 6x6 Polybius square (A-Z, 0-9)
		local
			used: ARRAY [BOOLEAN]
			c: CHARACTER
			i: INTEGER
		do
			create Result.make (36)
			create used.make_filled (False, 0, 35)

			-- Add key characters
			across key.as_upper as ch loop
				c := ch
				i := char_to_index (c)
				if i >= 0 and not used [i] then
					Result.append_character (c)
					used [i] := True
				end
			end

			-- Add remaining alphabet
			from c := 'A' until c > 'Z' loop
				i := c.code - ('A').code
				if not used [i] then
					Result.append_character (c)
				end
				c := (c.code + 1).to_character_8
			end

			-- Add remaining digits
			from c := '0' until c > '9' loop
				i := c.code - ('0').code + 26
				if not used [i] then
					Result.append_character (c)
				end
				c := (c.code + 1).to_character_8
			end
		ensure
			correct_size: Result.count = 36
		end

	char_to_index (c: CHARACTER): INTEGER
			-- Convert character to 0-35 index
		do
			if c >= 'A' and c <= 'Z' then
				Result := c.code - ('A').code
			elseif c >= '0' and c <= '9' then
				Result := c.code - ('0').code + 26
			else
				Result := -1
			end
		end

	sorted_key_order (key: STRING): STRING
			-- Return key characters sorted alphabetically
		local
			chars: ARRAYED_LIST [CHARACTER]
			i, j: INTEGER
			temp: CHARACTER
		do
			create chars.make (key.count)
			across key.as_upper as c loop
				chars.extend (c)
			end

			-- Simple bubble sort
			from i := 1 until i >= chars.count loop
				from j := 1 until j > chars.count - i loop
					if chars [j] > chars [j + 1] then
						temp := chars [j]
						chars [j] := chars [j + 1]
						chars [j + 1] := temp
					end
					j := j + 1
				end
				i := i + 1
			end

			create Result.make (chars.count)
			across chars as c loop
				Result.append_character (c)
			end
		end

feature -- Demo

	demo
			-- Standard Rosetta Code demo
		local
			polybius_key, trans_key, plaintext, encrypted, decrypted: STRING
		do
			polybius_key := "BTALPDHOZKQFVSNGICUXMREWY"
			trans_key := "CARGO"
			plaintext := "ATTACKAT1200AM"

			print ("ADFGVX Cipher Demo:%N%N")
			print ("Polybius key: " + polybius_key + "%N")
			print ("Transposition key: " + trans_key + "%N")
			print ("Plaintext: " + plaintext + "%N")

			encrypted := encrypt (plaintext, polybius_key, trans_key)
			print ("Encrypted: " + encrypted + "%N")

			decrypted := decrypt (encrypted, polybius_key, trans_key)
			print ("Decrypted: " + decrypted + "%N")
		end

end
