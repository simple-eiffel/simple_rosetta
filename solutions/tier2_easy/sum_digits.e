note
	description: "[
		Rosetta Code: Sum digits of an integer
		https://rosettacode.org/wiki/Sum_digits_of_an_integer

		Sum the digits of a number.
	]"
	author: "Simple Eiffel"
	see_also: "https://github.com/simple-eiffel"
	rosetta_task: "Sum_digits_of_an_integer"
	tier: "2"

class
	SUM_DIGITS

create
	make

feature {NONE} -- Initialization

	make
			-- Demonstrate digit sum.
		do
			print ("Sum of Digits%N")
			print ("=============%N%N")

			demo (1)
			demo (12345)
			demo (123045)
			demo (999)
			demo (0)
		end

feature -- Demo

	demo (n: INTEGER)
		do
			print ("sum_digits(" + n.out + ") = " + sum_digits (n).out + "%N")
		end

feature -- Calculation

	sum_digits (n: INTEGER): INTEGER
			-- Sum of decimal digits.
		local
			num: INTEGER
		do
			num := n.abs
			from until num = 0 loop
				Result := Result + (num \\ 10)
				num := num // 10
			end
		ensure
			non_negative: Result >= 0
		end

	sum_digits_base (n, base: INTEGER): INTEGER
			-- Sum of digits in given base.
		require
			valid_base: base >= 2
		local
			num: INTEGER
		do
			num := n.abs
			from until num = 0 loop
				Result := Result + (num \\ base)
				num := num // base
			end
		ensure
			non_negative: Result >= 0
		end

end
