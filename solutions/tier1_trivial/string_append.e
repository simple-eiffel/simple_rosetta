note
	description: "[
		Rosetta Code: String append
		https://rosettacode.org/wiki/String_append

		Demonstrate appending to a string.
	]"
	author: "Eiffel Solution"
	rosetta_task: "String_append"

class
	STRING_APPEND

create
	make

feature {NONE} -- Initialization

	make
			-- Demonstrate string appending.
		local
			s: STRING
		do
			-- Create initial string
			s := "Hello"
			print ("Initial: %"" + s + "%"%N")

			-- Append using append
			s.append (", World")
			print ("After append: %"" + s + "%"%N")

			-- Append single character
			s.append_character ('!')
			print ("After append_character: %"" + s + "%"%N")

			-- Append using + operator (creates new string)
			s := s + " Welcome!"
			print ("After + operator: %"" + s + "%"%N")
		end

end
