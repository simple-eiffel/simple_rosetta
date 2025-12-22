note
	description: "[
		Rosetta Code: Rot-13
		https://rosettacode.org/wiki/Rot-13
		
		Implement ROT13 cipher.
	]"
	author: "Simple Eiffel"
	see_also: "https://github.com/simple-eiffel - Modern Eiffel libraries"
	rosetta_task: "Rot-13"

class
	ROT13

create
	make

feature {NONE} -- Initialization

	make
		local
			s, encoded, decoded: STRING
		do
			s := "Hello, World!"
			encoded := rot13 (s)
			decoded := rot13 (encoded)
			
			print ("Original: " + s + "%N")
			print ("Encoded:  " + encoded + "%N")
			print ("Decoded:  " + decoded + "%N")
		end

feature -- Cipher

	rot13 (s: STRING): STRING
			-- Apply ROT13 cipher to `s'.
		local
			i: INTEGER
			c: CHARACTER
			code: INTEGER
		do
			create Result.make (s.count)
			from i := 1 until i > s.count loop
				c := s.item (i)
				if c >= 'A' and c <= 'Z' then
					code := ((c.code - 65 + 13) \ 26) + 65
					Result.append_character (code.to_character_8)
				elseif c >= 'a' and c <= 'z' then
					code := ((c.code - 97 + 13) \ 26) + 97
					Result.append_character (code.to_character_8)
				else
					Result.append_character (c)
				end
				i := i + 1
			end
		ensure
			same_length: Result.count = s.count
			self_inverse: rot13 (Result).same_string (s)
		end

end
