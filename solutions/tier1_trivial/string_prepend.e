note
	description: "[
		Rosetta Code: String prepend
		https://rosettacode.org/wiki/String_prepend

		Demonstrate prepending to a string.
	]"
	author: "Eiffel Solution"
	rosetta_task: "String_prepend"

class
	STRING_PREPEND

create
	make

feature {NONE} -- Initialization

	make
			-- Demonstrate string prepending.
		local
			s: STRING
		do
			-- Create initial string
			s := "World!"
			print ("Initial: %"" + s + "%"%N")

			-- Prepend using prepend
			s.prepend ("Hello, ")
			print ("After prepend: %"" + s + "%"%N")

			-- Alternative: prepend_character
			s.prepend_character ('#')
			print ("After prepend_character: %"" + s + "%"%N")
		end

end
