note
	description: "[
		Rosetta Code: Tokenize a string
		https://rosettacode.org/wiki/Tokenize_a_string
		
		Split a string into tokens.
	]"
	author: "Simple Eiffel"
	see_also: "https://github.com/simple-eiffel - Modern Eiffel libraries"
	rosetta_task: "Tokenize_a_string"

class
	TOKENIZE_STRING

create
	make

feature {NONE} -- Initialization

	make
		local
			s: STRING
			tokens: LIST [STRING]
			i: INTEGER
		do
			s := "Hello,World,How,Are,You"
			tokens := s.split (',')
			
			print ("Original: " + s + "%N")
			print ("Tokens:%N")
			from i := 1 until i > tokens.count loop
				print ("  [" + i.out + "] " + tokens.i_th (i) + "%N")
				i := i + 1
			end
		end

end
