note
	description: "[
		Rosetta Code: Soundex
		https://rosettacode.org/wiki/Soundex

		Implement the Soundex phonetic algorithm.
	]"
	author: "Simple Eiffel"
	see_also: "https://github.com/simple-eiffel"
	rosetta_task: "Soundex"
	tier: "2"

class
	SOUNDEX

create
	make

feature {NONE} -- Initialization

	make
			-- Demonstrate Soundex.
		do
			print ("Soundex Algorithm%N")
			print ("=================%N%N")

			demo ("Robert")
			demo ("Rupert")
			demo ("Rubin")
			demo ("Ashcraft")
			demo ("Ashcroft")
			demo ("Tymczak")
			demo ("Pfister")
		end

feature -- Demo

	demo (a_name: STRING)
			-- Show Soundex code.
		do
			print (a_name + " -> " + soundex (a_name) + "%N")
		end

feature -- Algorithm

	soundex (a_name: STRING): STRING
			-- Soundex code for name.
		require
			name_exists: a_name /= Void
			name_not_empty: not a_name.is_empty
		local
			l_i: INTEGER
			l_c, l_code, l_prev: CHARACTER
			l_upper: STRING
		do
			l_upper := a_name.as_upper
			create Result.make (4)

			-- First letter
			Result.append_character (l_upper [1])
			l_prev := encode_char (l_upper [1])

			-- Encode remaining letters
			from l_i := 2 until l_i > l_upper.count or Result.count >= 4 loop
				l_c := l_upper [l_i]
				l_code := encode_char (l_c)
				if l_code /= '0' and l_code /= l_prev then
					Result.append_character (l_code)
				end
				if l_code /= '0' then
					l_prev := l_code
				end
				l_i := l_i + 1
			end

			-- Pad with zeros
			from until Result.count >= 4 loop
				Result.append_character ('0')
			end
		ensure
			result_exists: Result /= Void
			correct_length: Result.count = 4
		end

feature {NONE} -- Helpers

	encode_char (a_char: CHARACTER): CHARACTER
			-- Soundex code for character.
		do
			inspect a_char
			when 'B', 'F', 'P', 'V' then
				Result := '1'
			when 'C', 'G', 'J', 'K', 'Q', 'S', 'X', 'Z' then
				Result := '2'
			when 'D', 'T' then
				Result := '3'
			when 'L' then
				Result := '4'
			when 'M', 'N' then
				Result := '5'
			when 'R' then
				Result := '6'
			else
				Result := '0'
			end
		end

end