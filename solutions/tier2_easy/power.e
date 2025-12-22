note
	description: "[
		Rosetta Code: Exponentiation operator
		https://rosettacode.org/wiki/Exponentiation_operator
		
		Implement integer exponentiation.
	]"
	author: "Simple Eiffel"
	see_also: "https://github.com/simple-eiffel - Modern Eiffel libraries"
	rosetta_task: "Exponentiation_operator"

class
	POWER

create
	make

feature {NONE} -- Initialization

	make
		do
			print ("2^10 = " + power (2, 10).out + "%N")
			print ("3^5 = " + power (3, 5).out + "%N")
			print ("5^0 = " + power (5, 0).out + "%N")
			print ("7^1 = " + power (7, 1).out + "%N")
		end

feature -- Computation

	power (base, exp: INTEGER): INTEGER_64
			-- Return `base' raised to the power of `exp'.
		require
			non_negative_exp: exp >= 0
		local
			i: INTEGER
		do
			Result := 1
			from i := 1 until i > exp loop
				Result := Result * base
				i := i + 1
			end
		ensure
			zero_exp: exp = 0 implies Result = 1
			one_exp: exp = 1 implies Result = base
		end

end
