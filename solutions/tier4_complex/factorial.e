note
	description: "[
		Rosetta Code: Factorial
		https://rosettacode.org/wiki/Factorial

		Calculate factorial using multiple approaches.
	]"
	author: "Eiffel Solution"
	rosetta_task: "Factorial"

class
	FACTORIAL

create
	make

feature {NONE} -- Initialization

	make
			-- Demonstrate factorial calculations.
		local
			i: INTEGER
		do
			print ("Factorial Calculations%N")
			print ("======================%N%N")

			-- Show first 15 factorials
			print ("n%T n! (iterative)%T n! (recursive)%N")
			print ("-%T --------------%T --------------%N")
			from i := 0 until i > 15 loop
				print (i.out + "%T " + factorial_iterative (i).out + "%T%T " + factorial_recursive (i).out + "%N")
				i := i + 1
			end

			-- Larger factorials
			print ("%NLarger factorials:%N")
			print ("  20! = " + factorial_iterative (20).out + "%N")

			-- Trailing zeros
			print ("%NTrailing zeros in n!:%N")
			print ("  10! has " + trailing_zeros (10).out + " trailing zeros%N")
			print ("  100! has " + trailing_zeros (100).out + " trailing zeros%N")
			print ("  1000! has " + trailing_zeros (1000).out + " trailing zeros%N")
		end

feature -- Factorial Calculations

	factorial_iterative (n: INTEGER): INTEGER_64
			-- Calculate n! iteratively.
		require
			non_negative: n >= 0
			not_too_large: n <= 20  -- Avoid overflow
		local
			i: INTEGER
		do
			Result := 1
			from i := 2 until i > n loop
				Result := Result * i
				i := i + 1
			end
		ensure
			non_negative_result: Result >= 1
			zero_factorial: n = 0 implies Result = 1
			one_factorial: n = 1 implies Result = 1
		end

	factorial_recursive (n: INTEGER): INTEGER_64
			-- Calculate n! recursively.
		require
			non_negative: n >= 0
			not_too_large: n <= 20
		do
			if n <= 1 then
				Result := 1
			else
				Result := n.to_integer_64 * factorial_recursive (n - 1)
			end
		ensure
			non_negative_result: Result >= 1
		end

	double_factorial (n: INTEGER): INTEGER_64
			-- Calculate n!! (double factorial).
			-- n!! = n * (n-2) * (n-4) * ... * 1 or 2
		require
			non_negative: n >= 0
		local
			i: INTEGER
		do
			if n <= 1 then
				Result := 1
			else
				Result := 1
				from i := n until i <= 1 loop
					Result := Result * i
					i := i - 2
				end
			end
		end

	trailing_zeros (n: INTEGER): INTEGER
			-- Count trailing zeros in n!
			-- Equal to floor(n/5) + floor(n/25) + floor(n/125) + ...
		require
			non_negative: n >= 0
		local
			power_of_5: INTEGER
		do
			Result := 0
			power_of_5 := 5
			from until power_of_5 > n loop
				Result := Result + n // power_of_5
				power_of_5 := power_of_5 * 5
			end
		end

	binomial_coefficient (n, k: INTEGER): INTEGER_64
			-- Calculate C(n, k) = n! / (k! * (n-k)!)
		require
			valid_n: n >= 0
			valid_k: k >= 0 and k <= n
		local
			i: INTEGER
			num, den: INTEGER_64
		do
			-- Use min(k, n-k) for efficiency
			if k > n - k then
				Result := binomial_coefficient (n, n - k)
			else
				num := 1
				den := 1
				from i := 0 until i >= k loop
					num := num * (n - i)
					den := den * (i + 1)
					i := i + 1
				end
				Result := num // den
			end
		end

end
