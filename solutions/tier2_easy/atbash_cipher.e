note
	description: "[
		Rosetta Code: Atbash cipher
		https://rosettacode.org/wiki/Atbash_cipher

		Implement the Atbash cipher (reverse alphabet substitution).
	]"
	author: "Simple Eiffel"
	see_also: "https://github.com/simple-eiffel"
	rosetta_task: "Atbash_cipher"
	tier: "2"

class
	ATBASH_CIPHER

create
	make

feature {NONE} -- Initialization

	make
			-- Demonstrate Atbash cipher.
		local
			l_text, l_encoded: STRING
		do
			print ("Atbash Cipher%N")
			print ("=============%N%N")

			l_text := "The quick brown fox jumps over the lazy dog"
			print ("Original: " + l_text + "%N")
			
			l_encoded := atbash (l_text)
			print ("Encoded:  " + l_encoded + "%N")
			print ("Decoded:  " + atbash (l_encoded) + "%N%N")

			-- More examples
			demo ("HELLO")
			demo ("ZYXWV")
			demo ("abcde")
		end

feature -- Demo

	demo (a_str: STRING)
			-- Show encoding.
		do
			print (a_str + " -> " + atbash (a_str) + "%N")
		end

feature -- Operations

	atbash (a_text: STRING): STRING
			-- Apply Atbash cipher (self-inverse).
		require
			text_exists: a_text /= Void
		local
			l_i: INTEGER
			l_c: CHARACTER
		do
			create Result.make (a_text.count)
			from l_i := 1 until l_i > a_text.count loop
				l_c := a_text [l_i]
				if l_c >= 'A' and l_c <= 'Z' then
					Result.append_character ((('Z').code - l_c.code + ('A').code).to_character_8)
				elseif l_c >= 'a' and l_c <= 'z' then
					Result.append_character ((('z').code - l_c.code + ('a').code).to_character_8)
				else
					Result.append_character (l_c)
				end
				l_i := l_i + 1
			end
		ensure
			result_exists: Result /= Void
			same_length: Result.count = a_text.count
			self_inverse: atbash (atbash (a_text)).same_string (a_text)
		end

end