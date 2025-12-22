note
	description: "[
		Rosetta Code: Logical operations
		https://rosettacode.org/wiki/Logical_operations

		Demonstrate logical operations (AND, OR, NOT).
	]"
	author: "Eiffel Solution"
	rosetta_task: "Logical_operations"

class
	LOGICAL_OPERATIONS

create
	make

feature {NONE} -- Initialization

	make
			-- Demonstrate logical operations.
		do
			print ("Logical operations in Eiffel:%N%N")

			print ("a       b       a AND b   a OR b   NOT a%N")
			print ("------  ------  --------  -------  -------%N")

			show_operations (True, True)
			show_operations (True, False)
			show_operations (False, True)
			show_operations (False, False)

			print ("%NAdditional Eiffel operators:%N")
			print ("  a XOR b (exclusive or)%N")
			print ("  a IMPLIES b (logical implication)%N")
			print ("  a AND THEN b (short-circuit and)%N")
			print ("  a OR ELSE b (short-circuit or)%N")
		end

feature {NONE} -- Implementation

	show_operations (a, b: BOOLEAN)
			-- Display logical operations for a and b.
		do
			print (padded (a.out) + padded (b.out))
			print (padded ((a and b).out))
			print (padded ((a or b).out))
			print ((not a).out + "%N")
		end

	padded (s: STRING): STRING
			-- Pad string to 8 characters.
		do
			create Result.make_from_string (s)
			from until Result.count >= 8 loop
				Result.append_character (' ')
			end
		end

end
