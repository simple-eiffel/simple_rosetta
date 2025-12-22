note
	description: "[
		Rosetta Code: Vigenere cipher
		https://rosettacode.org/wiki/Vigenere_cipher

		Implement the VigenÃ¨re cipher.
	]"
	author: "Simple Eiffel"
	see_also: "https://github.com/simple-eiffel"
	rosetta_task: "Vigenere_cipher"
	tier: "2"

class
	VIGENERE_CIPHER

create
	make

feature {NONE} -- Initialization

	make
			-- Demonstrate VigenÃ¨re cipher.
		local
			l_plain, l_key, l_cipher, l_decrypted: STRING
		do
			print ("VigenÃ¨re Cipher%N")
			print ("===============%N%N")

			l_plain := "ATTACKATDAWN"
			l_key := "LEMON"

			print ("Plain:     " + l_plain + "%N")
			print ("Key:       " + l_key + "%N")

			l_cipher := encrypt (l_plain, l_key)
			print ("Encrypted: " + l_cipher + "%N")

			l_decrypted := decrypt (l_cipher, l_key)
			print ("Decrypted: " + l_decrypted + "%N")
		end

feature -- Operations

	encrypt (a_plain, a_key: STRING): STRING
			-- Encrypt `a_plain' with `a_key'.
		require
			plain_exists: a_plain /= Void
			key_exists: a_key /= Void
			key_not_empty: not a_key.is_empty
		local
			l_i, l_j: INTEGER
			l_p, l_k: INTEGER
		do
			create Result.make (a_plain.count)
			l_j := 1
			from l_i := 1 until l_i > a_plain.count loop
				l_p := a_plain [l_i].as_upper.code - ('A').code
				l_k := a_key [l_j].as_upper.code - ('A').code
				Result.append_character (((l_p + l_k) \ 26 + ('A').code).to_character_8)
				l_j := l_j \ a_key.count + 1
				l_i := l_i + 1
			end
		ensure
			result_exists: Result /= Void
			same_length: Result.count = a_plain.count
		end

	decrypt (a_cipher, a_key: STRING): STRING
			-- Decrypt `a_cipher' with `a_key'.
		require
			cipher_exists: a_cipher /= Void
			key_exists: a_key /= Void
			key_not_empty: not a_key.is_empty
		local
			l_i, l_j: INTEGER
			l_c, l_k: INTEGER
		do
			create Result.make (a_cipher.count)
			l_j := 1
			from l_i := 1 until l_i > a_cipher.count loop
				l_c := a_cipher [l_i].as_upper.code - ('A').code
				l_k := a_key [l_j].as_upper.code - ('A').code
				Result.append_character ((((l_c - l_k) + 26) \ 26 + ('A').code).to_character_8)
				l_j := l_j \ a_key.count + 1
				l_i := l_i + 1
			end
		ensure
			result_exists: Result /= Void
			same_length: Result.count = a_cipher.count
		end

end