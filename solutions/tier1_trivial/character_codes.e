note
	description: "[
		Rosetta Code: Character codes
		https://rosettacode.org/wiki/Character_codes
		
		Convert character to code and vice versa.
	]"
	author: "Simple Eiffel"
	see_also: "https://github.com/simple-eiffel - Modern Eiffel libraries"
	rosetta_task: "Character_codes"

class
	CHARACTER_CODES

create
	make

feature {NONE} -- Initialization

	make
		local
			c: CHARACTER
			code: INTEGER
		do
			-- Character to code
			c := 'A'
			code := c.code
			print ("Character '" + c.out + "' has code: " + code.out + "%N")
			
			-- Code to character
			code := 97
			c := code.to_character_8
			print ("Code " + code.out + " is character: '" + c.out + "'%N")
			
			-- More examples
			print ("%NASCII examples:%N")
			print ("  '0' = " + ('0').code.out + "%N")
			print ("  'Z' = " + ('Z').code.out + "%N")
			print ("  ' ' = " + (' ').code.out + "%N")
		end

end
