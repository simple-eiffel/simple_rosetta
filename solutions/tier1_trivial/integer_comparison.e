note
	description: "[
		Rosetta Code: Integer comparison
		https://rosettacode.org/wiki/Integer_comparison
		
		Compare two integers for equality and ordering.
	]"
	author: "Simple Eiffel"
	see_also: "https://github.com/simple-eiffel - Modern Eiffel libraries"
	rosetta_task: "Integer_comparison"

class
	INTEGER_COMPARISON

create
	make

feature {NONE} -- Initialization

	make
		do
			compare (5, 10)
			compare (10, 5)
			compare (5, 5)
		end

feature -- Comparison

	compare (a, b: INTEGER)
		do
			print (a.out + " vs " + b.out + ": ")
			if a < b then
				print (a.out + " is less than " + b.out + "%N")
			elseif a > b then
				print (a.out + " is greater than " + b.out + "%N")
			else
				print (a.out + " equals " + b.out + "%N")
			end
		end

end
