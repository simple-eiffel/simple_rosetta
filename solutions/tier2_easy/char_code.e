note
	description: "[
		Rosetta Code: Character codes
		https://rosettacode.org/wiki/Character_codes

		Convert between characters and their numeric codes.
	]"
	author: "Simple Eiffel"
	see_also: "https://github.com/simple-eiffel"
	rosetta_task: "Character_codes"
	tier: "2"

class
	CHAR_CODE

create
	make

feature {NONE} -- Initialization

	make
			-- Demonstrate character codes.
		do
			print ("Character Codes%N")
			print ("===============%N%N")

			print ("Character to code:%N")
			show_code ('A')
			show_code ('a')
			show_code ('0')
			show_code (' ')
			show_code ('!')

			print ("%NCode to character:%N")
			show_char (65)
			show_char (97)
			show_char (48)
			show_char (32)
			show_char (33)
		end

feature -- Display

	show_code (a_char: CHARACTER)
			-- Show character's code.
		do
			print ("  '" + a_char.out + "' -> " + char_to_code (a_char).out + "%N")
		end

	show_char (a_code: INTEGER)
			-- Show code's character.
		do
			print ("  " + a_code.out + " -> '" + code_to_char (a_code).out + "'%N")
		end

feature -- Conversion

	char_to_code (a_char: CHARACTER): INTEGER
			-- ASCII code of character.
		do
			Result := a_char.code
		ensure
			valid_code: Result >= 0 and Result <= 255
		end

	code_to_char (a_code: INTEGER): CHARACTER
			-- Character from ASCII code.
		require
			valid_code: a_code >= 0 and a_code <= 255
		do
			Result := a_code.to_character_8
		end

end