note
	description: "[
		Rosetta Code: Sum digits of an integer
		https://rosettacode.org/wiki/Sum_digits_of_an_integer

		Calculate the sum of all digits in an integer.
	]"
	author: "Eiffel Solution"
	rosetta_task: "Sum_digits_of_an_integer"

class
	SUM_DIGITS

create
	make

feature {NONE} -- Initialization

	make
			-- Demonstrate digit sum calculation.
		do
			print ("Sum of digits:%N")
			print ("  1 -> " + sum_digits (1).out + "%N")
			print ("  12345 -> " + sum_digits (12345).out + "%N")
			print ("  123045 -> " + sum_digits (123045).out + "%N")
			print ("  9999999 -> " + sum_digits (9999999).out + "%N")

			-- Different bases
			print ("%NSum of digits in different bases:%N")
			print ("  254 in base 10 -> " + sum_digits_base (254, 10).out + "%N")
			print ("  254 in base 16 -> " + sum_digits_base (254, 16).out + " (FE in hex)%N")
			print ("  254 in base 2 -> " + sum_digits_base (254, 2).out + " (11111110 in binary)%N")
		end

feature -- Calculation

	sum_digits (n: INTEGER): INTEGER
			-- Sum of digits of n in base 10.
		do
			Result := sum_digits_base (n, 10)
		end

	sum_digits_base (n, base: INTEGER): INTEGER
			-- Sum of digits of n in given base.
		require
			non_negative: n >= 0
			valid_base: base >= 2
		local
			remaining: INTEGER
		do
			from remaining := n until remaining = 0 loop
				Result := Result + (remaining \\ base)
				remaining := remaining // base
			end
		end

end
