note
	description: "[
		Rosetta Code: Literals/String
		https://rosettacode.org/wiki/Literals/String

		Demonstrate string literal syntax.
	]"
	author: "Simple Eiffel"
	see_also: "https://github.com/simple-eiffel"
	rosetta_task: "Literals/String"
	tier: "2"

class
	LITERALS_STRING

create
	make

feature {NONE} -- Initialization

	make
			-- Demonstrate Eiffel string literals.
		local
			l_simple: STRING
			l_with_quotes: STRING
			l_multiline: STRING
			l_with_special: STRING
		do
			-- Simple string literal
			l_simple := "Hello, World!"
			print ("Simple: " + l_simple + "%N")

			-- String with embedded quote (doubled)
			l_with_quotes := "He said %"Hello%""
			print ("With quotes: " + l_with_quotes + "%N")

			-- Multiline string (verbatim string)
			l_multiline := "[
				This is a
				multiline string
				in Eiffel
			]"
			print ("Multiline:%N" + l_multiline + "%N")

			-- Special characters using percent codes
			l_with_special := "Tab:%TNewline:%NPercent:%%"
			print ("Special chars: " + l_with_special + "%N")

			-- Unicode character
			print ("Unicode: %/937/ is Omega%N")

			-- Empty string
			print ("Empty string length: " + ("").count.out + "%N")
		end

end
