note
	description: "[
		Rosetta Code: Caesar cipher
		https://rosettacode.org/wiki/Caesar_cipher

		Implement a Caesar cipher for encryption and decryption.
	]"
	author: "Simple Eiffel"
	see_also: "https://github.com/simple-eiffel"
	rosetta_task: "Caesar_cipher"
	tier: "2"

class
	CAESAR_CIPHER

create
	make

feature {NONE} -- Initialization

	make
			-- Demonstrate Caesar cipher.
		local
			l_plain, l_cipher, l_decrypted: STRING
		do
			print ("Caesar Cipher%N")
			print ("=============%N%N")

			l_plain := "The quick brown fox jumps over the lazy dog"
			print ("Plain:     " + l_plain + "%N")

			l_cipher := encrypt (l_plain, 13)
			print ("Encrypted: " + l_cipher + "%N")

			l_decrypted := decrypt (l_cipher, 13)
			print ("Decrypted: " + l_decrypted + "%N%N")

			-- ROT13 is self-inverse
			print ("ROT13 of 'Hello': " + encrypt ("Hello", 13) + "%N")
			print ("ROT13 twice:      " + encrypt (encrypt ("Hello", 13), 13) + "%N")
		end

feature -- Encryption

	encrypt (a_text: STRING; a_shift: INTEGER): STRING
			-- Encrypt `a_text' with Caesar cipher using `a_shift'.
		require
			text_exists: a_text /= Void
		local
			l_i: INTEGER
			l_c: CHARACTER
			l_code, l_base: INTEGER
		do
			create Result.make (a_text.count)
			from l_i := 1 until l_i > a_text.count loop
				l_c := a_text [l_i]
				if l_c >= 'A' and l_c <= 'Z' then
					l_base := ('A').code
					l_code := ((l_c.code - l_base + a_shift) \\ 26 + 26) \\ 26 + l_base
					Result.append_character (l_code.to_character_8)
				elseif l_c >= 'a' and l_c <= 'z' then
					l_base := ('a').code
					l_code := ((l_c.code - l_base + a_shift) \\ 26 + 26) \\ 26 + l_base
					Result.append_character (l_code.to_character_8)
				else
					Result.append_character (l_c)
				end
				l_i := l_i + 1
			end
		ensure
			result_exists: Result /= Void
			same_length: Result.count = a_text.count
		end

	decrypt (a_text: STRING; a_shift: INTEGER): STRING
			-- Decrypt `a_text' with Caesar cipher using `a_shift'.
		require
			text_exists: a_text /= Void
		do
			Result := encrypt (a_text, -a_shift)
		ensure
			result_exists: Result /= Void
			same_length: Result.count = a_text.count
		end

	rot13 (a_text: STRING): STRING
			-- Apply ROT13 to `a_text'.
		require
			text_exists: a_text /= Void
		do
			Result := encrypt (a_text, 13)
		end

end
