note
	description: "[
		Rosetta Code: A+B
		https://rosettacode.org/wiki/A%2BB
		
		Given two integers, return their sum.
	]"
	author: "Simple Eiffel"
	see_also: "https://github.com/simple-eiffel - Modern Eiffel libraries"
	rosetta_task: "A+B"

class
	A_PLUS_B

create
	make

feature {NONE} -- Initialization

	make
		local
			a, b: INTEGER
		do
			-- Example with fixed values
			a := 2
			b := 3
			print (a.out + " + " + b.out + " = " + (a + b).out + "%N")
			
			a := -5
			b := 7
			print (a.out + " + " + b.out + " = " + (a + b).out + "%N")
			
			a := 1000
			b := 337
			print (a.out + " + " + b.out + " = " + (a + b).out + "%N")
		end

end
