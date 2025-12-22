note
	description: "[
		Rosetta Code: Exponentiation operator
		https://rosettacode.org/wiki/Exponentiation_operator

		Calculate power of a number.
	]"
	author: "Simple Eiffel"
	see_also: "https://github.com/simple-eiffel"
	rosetta_task: "Exponentiation_operator"
	tier: "2"

class
	POWER

create
	make

feature {NONE} -- Initialization

	make
			-- Demonstrate exponentiation.
		do
			print ("Exponentiation%N")
			print ("==============%N%N")

			demo (2, 10)
			demo (3, 4)
			demo (5, 3)
			demo (10, 0)
			demo (2, -3)
		end

feature -- Demo

	demo (base, exp: INTEGER)
		do
			print (base.out + "^" + exp.out + " = " + power (base, exp).out + "%N")
		end

feature -- Calculation

	power (base, exp: INTEGER): REAL_64
			-- base raised to exp.
		local
			i: INTEGER
		do
			if exp = 0 then
				Result := 1.0
			elseif exp > 0 then
				Result := 1.0
				from i := 1 until i > exp loop
					Result := Result * base
					i := i + 1
				end
			else
				Result := 1.0 / power (base, -exp)
			end
		end

	power_int (base, exp: INTEGER): INTEGER_64
			-- Integer power (for non-negative exp).
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
			base_zero_is_zero: base = 0 and exp > 0 implies Result = 0
			exp_zero_is_one: exp = 0 implies Result = 1
		end

end