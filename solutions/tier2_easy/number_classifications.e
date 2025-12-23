note
	description: "[
		Rosetta Code: Abundant, deficient and perfect number classifications
		https://rosettacode.org/wiki/Abundant,_deficient_and_perfect_number_classifications

		Classify integers as abundant (sum of proper divisors > n),
		deficient (sum < n), or perfect (sum = n).
	]"

class
	NUMBER_CLASSIFICATIONS

feature -- Classification

	classify (n: INTEGER): STRING
			-- Classify `n` as "abundant", "deficient", or "perfect"
		require
			positive: n >= 1
		local
			sum: INTEGER
		do
			sum := proper_divisor_sum (n)
			if sum > n then
				Result := "abundant"
			elseif sum < n then
				Result := "deficient"
			else
				Result := "perfect"
			end
		ensure
			valid_result: Result.same_string ("abundant") or
			              Result.same_string ("deficient") or
			              Result.same_string ("perfect")
		end

	is_abundant (n: INTEGER): BOOLEAN
			-- Is `n` abundant (proper divisor sum > n)?
		require
			positive: n >= 1
		do
			Result := proper_divisor_sum (n) > n
		end

	is_deficient (n: INTEGER): BOOLEAN
			-- Is `n` deficient (proper divisor sum < n)?
		require
			positive: n >= 1
		do
			Result := proper_divisor_sum (n) < n
		end

	is_perfect (n: INTEGER): BOOLEAN
			-- Is `n` perfect (proper divisor sum = n)?
		require
			positive: n >= 1
		do
			Result := proper_divisor_sum (n) = n
		end

feature -- Counting

	count_in_range (lower, upper: INTEGER): TUPLE [abundant, deficient, perfect: INTEGER]
			-- Count each classification in range [lower, upper]
		require
			valid_range: lower >= 1 and lower <= upper
		local
			i, a, d, p: INTEGER
			sum: INTEGER
		do
			from i := lower until i > upper loop
				sum := proper_divisor_sum (i)
				if sum > i then
					a := a + 1
				elseif sum < i then
					d := d + 1
				else
					p := p + 1
				end
				i := i + 1
			end
			Result := [a, d, p]
		ensure
			total_matches: Result.abundant + Result.deficient + Result.perfect = upper - lower + 1
		end

feature -- Implementation

	proper_divisor_sum (n: INTEGER): INTEGER
			-- Sum of proper divisors of `n` (excluding n itself)
		require
			positive: n >= 1
		local
			i: INTEGER
		do
			if n = 1 then
				Result := 0
			else
				Result := 1  -- 1 is always a proper divisor for n > 1
				from i := 2 until i * i > n loop
					if n \\ i = 0 then
						Result := Result + i
						if i /= n // i then
							Result := Result + (n // i)
						end
					end
					i := i + 1
				end
			end
		end

feature -- Demo

	demo
			-- Standard Rosetta Code demo: classify 1-20000
		local
			counts: TUPLE [abundant, deficient, perfect: INTEGER]
		do
			counts := count_in_range (1, 20000)
			print ("For integers 1 to 20,000:%N")
			print ("  Abundant:  " + counts.abundant.out + "%N")
			print ("  Deficient: " + counts.deficient.out + "%N")
			print ("  Perfect:   " + counts.perfect.out + "%N")
		end

end
