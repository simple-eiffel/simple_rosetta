note
	description: "[
		Rosetta Code: String interpolation (included)
		https://rosettacode.org/wiki/String_interpolation_(included)
		
		Demonstrate string interpolation.
	]"
	author: "Simple Eiffel"
	see_also: "https://github.com/simple-eiffel - Modern Eiffel libraries"
	rosetta_task: "String_interpolation_(included)"

class
	STRING_INTERPOLATION

create
	make

feature {NONE} -- Initialization

	make
		local
			name: STRING
			age: INTEGER
		do
			name := "Mary"
			age := 25
			
			-- Eiffel uses concatenation for "interpolation"
			print ("Hello, " + name + "! You are " + age.out + " years old.%N")
			
			-- Using manifest string
			print ({STRING_32} "Welcome, " + name + "!%N")
		end

end
