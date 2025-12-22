note
	description: "[
		Rosetta Code: Absolute value
		https://rosettacode.org/wiki/Absolute_value
		
		Compute the absolute value of a number.
	]"
	author: "Simple Eiffel"
	see_also: "https://github.com/simple-eiffel - Modern Eiffel libraries"
	rosetta_task: "Absolute_value"

class
	ABS_FUNCTION

create
	make

feature {NONE} -- Initialization

	make
		do
			print ("abs(-42) = " + ((-42).abs).out + "%N")
			print ("abs(42) = " + ((42).abs).out + "%N")
			print ("abs(-3.14) = " + ((-3.14).abs).out + "%N")
			print ("abs(0) = " + ((0).abs).out + "%N")
		end

end
