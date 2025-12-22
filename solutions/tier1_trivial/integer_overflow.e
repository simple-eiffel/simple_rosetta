note
	description: "[
		Rosetta Code: Integer overflow
		https://rosettacode.org/wiki/Integer_overflow
		
		Demonstrate integer overflow behavior.
	]"
	author: "Simple Eiffel"
	see_also: "https://github.com/simple-eiffel - Modern Eiffel libraries"
	rosetta_task: "Integer_overflow"

class
	INTEGER_OVERFLOW

create
	make

feature {NONE} -- Initialization

	make
		local
			i32: INTEGER_32
			i64: INTEGER_64
		do
			print ("INTEGER_32 max: " + {INTEGER_32}.max_value.out + "%N")
			print ("INTEGER_64 max: " + {INTEGER_64}.max_value.out + "%N%N")
			
			-- Demonstrate near overflow
			i32 := {INTEGER_32}.max_value
			print ("Max INT32: " + i32.out + "%N")
			print ("Max INT32 + 1 would overflow%N%N")
			
			-- Safe computation with larger type
			i64 := i32.to_integer_64 + 1
			print ("Using INT64: " + i32.out + " + 1 = " + i64.out + "%N")
		end

end
