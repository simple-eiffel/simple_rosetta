note
	description: "[
		Rosetta Code: Rot-13
		https://rosettacode.org/wiki/Rot-13

		Implement the ROT13 cipher.
	]"
	author: "Simple Eiffel"
	see_also: "https://github.com/simple-eiffel"
	rosetta_task: "Rot-13"
	tier: "2"

class
	ROT13

create
	make

feature {NONE} -- Initialization

	make
			-- Demonstrate ROT13.
		local
			l_text, l_encoded, l_decoded: STRING
		do
			print ("ROT13 Cipher%N")
			print ("============%N%N")

			l_text := "The Quick Brown Fox Jumps Over The Lazy Dog"
			print ("Original: " + l_text + "%N")

			l_encoded := rot13 (l_text)
			print ("Encoded:  " + l_encoded + "%N")

			l_decoded := rot13 (l_encoded)
			print ("Decoded:  " + l_decoded + "%N%N")

			-- More examples
			print ("'Hello' -> '" + rot13 ("Hello") + "'%N")
			print ("'Uryyb' -> '" + rot13 ("Uryyb") + "'%N")
		end

feature -- Operations

	rot13 (a_text: STRING): STRING
			-- Apply ROT13 transformation.
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
					l_code := (l_c.code - l_base + 13) \\ 26 + l_base
					Result.append_character (l_code.to_character_8)
				elseif l_c >= 'a' and l_c <= 'z' then
					l_base := ('a').code
					l_code := (l_c.code - l_base + 13) \\ 26 + l_base
					Result.append_character (l_code.to_character_8)
				else
					Result.append_character (l_c)
				end
				l_i := l_i + 1
			end
		ensure
			result_exists: Result /= Void
			same_length: Result.count = a_text.count
			self_inverse: rot13 (rot13 (a_text)).same_string (a_text)
		end

end