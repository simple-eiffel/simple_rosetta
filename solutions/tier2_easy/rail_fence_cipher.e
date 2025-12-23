note
	description: "[
		Rosetta Code: Rail fence cipher
		https://rosettacode.org/wiki/Rail_fence_cipher

		Transposition cipher that writes message in zig-zag pattern
		across multiple rails, then reads off each rail.
	]"

class
	RAIL_FENCE_CIPHER

feature -- Cipher Operations

	encrypt (plaintext: STRING; rails: INTEGER): STRING
			-- Encrypt plaintext using rail fence cipher
		require
			not_empty: not plaintext.is_empty
			valid_rails: rails >= 2 and rails <= plaintext.count
		local
			fence: ARRAY [STRING]
			rail, direction, i: INTEGER
		do
			-- Initialize rails
			create fence.make_filled ("", 1, rails)
			from i := 1 until i > rails loop
				fence [i] := ""
				i := i + 1
			end

			-- Build fence
			rail := 1
			direction := 1
			from i := 1 until i > plaintext.count loop
				fence [rail].append_character (plaintext [i])
				if rail = rails then
					direction := -1
				elseif rail = 1 then
					direction := 1
				end
				rail := rail + direction
				i := i + 1
			end

			-- Read off rails
			create Result.make (plaintext.count)
			from i := 1 until i > rails loop
				Result.append (fence [i])
				i := i + 1
			end
		ensure
			same_length: Result.count = plaintext.count
		end

	decrypt (ciphertext: STRING; rails: INTEGER): STRING
			-- Decrypt ciphertext using rail fence cipher
		require
			not_empty: not ciphertext.is_empty
			valid_rails: rails >= 2 and rails <= ciphertext.count
		local
			fence: ARRAY [STRING]
			rail_lengths: ARRAY [INTEGER]
			rail, direction, i, pos: INTEGER
		do
			-- Calculate length of each rail
			create rail_lengths.make_filled (0, 1, rails)
			rail := 1
			direction := 1
			from i := 1 until i > ciphertext.count loop
				rail_lengths [rail] := rail_lengths [rail] + 1
				if rail = rails then
					direction := -1
				elseif rail = 1 then
					direction := 1
				end
				rail := rail + direction
				i := i + 1
			end

			-- Fill each rail from ciphertext
			create fence.make_filled ("", 1, rails)
			pos := 1
			from i := 1 until i > rails loop
				fence [i] := ciphertext.substring (pos, pos + rail_lengths [i] - 1)
				pos := pos + rail_lengths [i]
				i := i + 1
			end

			-- Read off in zig-zag order
			create rail_lengths.make_filled (1, 1, rails)  -- Reuse as position indices
			create Result.make (ciphertext.count)
			rail := 1
			direction := 1
			from i := 1 until i > ciphertext.count loop
				Result.append_character (fence [rail] [rail_lengths [rail]])
				rail_lengths [rail] := rail_lengths [rail] + 1
				if rail = rails then
					direction := -1
				elseif rail = 1 then
					direction := 1
				end
				rail := rail + direction
				i := i + 1
			end
		ensure
			same_length: Result.count = ciphertext.count
		end

feature -- Demo

	demo
			-- Standard Rosetta Code demo
		local
			plaintext, encrypted, decrypted: STRING
		do
			plaintext := "WEAREDISCOVEREDFLEEATONCE"

			print ("Rail Fence Cipher Demo:%N%N")
			print ("Plaintext: " + plaintext + "%N%N")

			print ("3 Rails:%N")
			encrypted := encrypt (plaintext, 3)
			print ("  Encrypted: " + encrypted + "%N")
			decrypted := decrypt (encrypted, 3)
			print ("  Decrypted: " + decrypted + "%N%N")

			print ("4 Rails:%N")
			encrypted := encrypt (plaintext, 4)
			print ("  Encrypted: " + encrypted + "%N")
			decrypted := decrypt (encrypted, 4)
			print ("  Decrypted: " + decrypted + "%N")
		end

end
