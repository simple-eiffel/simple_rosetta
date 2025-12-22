note
	description: "[
		Rosetta Code: String length
		https://rosettacode.org/wiki/String_length

		Determine the character and byte length of a string.
	]"
	author: "Eiffel Solution"
	rosetta_task: "String_length"

class
	STRING_LENGTH

create
	make

feature {NONE} -- Initialization

	make
			-- Demonstrate string length.
		local
			s: STRING
			s32: STRING_32
		do
			-- ASCII string
			s := "Hello, World!"
			print ("String: %"" + s + "%"%N")
			print ("  Character length: " + s.count.out + "%N")

			-- Unicode string (STRING_32)
			s32 := {STRING_32} "Hello, 世界!"
			print ("%NUnicode string: 'Hello, 世界!'%N")
			print ("  Character length: " + s32.count.out + "%N")

			-- Note: In Eiffel, STRING is an alias for STRING_8
			-- STRING_32 handles Unicode properly
		end

end
