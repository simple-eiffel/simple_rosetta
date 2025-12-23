note
	description: "[
		Rosetta Code: Brilliant numbers
		https://rosettacode.org/wiki/Brilliant_numbers

		A brilliant number is a semiprime (product of exactly two primes)
		where both prime factors have the same number of digits.
		Example: 21 = 3 × 7 (both 1-digit primes).
	]"

class
	BRILLIANT_NUMBERS

feature -- Query

	is_brilliant (n: INTEGER): BOOLEAN
			-- Is `n` a brilliant number?
		require
			positive: n >= 1
		local
			factors: TUPLE [p, q: INTEGER]
		do
			factors := semiprime_factors (n)
			if factors /= Void and then factors.p > 0 then
				Result := digit_count (factors.p) = digit_count (factors.q)
			end
		end

	first_n_brilliant (n: INTEGER): ARRAYED_LIST [INTEGER]
			-- First `n` brilliant numbers
		require
			positive: n >= 1
		local
			i: INTEGER
		do
			create Result.make (n)
			from i := 4 until Result.count >= n loop
				if is_brilliant (i) then
					Result.extend (i)
				end
				i := i + 1
			end
		ensure
			correct_count: Result.count = n
		end

	brilliant_numbers_below (limit: INTEGER): ARRAYED_LIST [INTEGER]
			-- All brilliant numbers below `limit`
		require
			valid_limit: limit >= 4
		local
			i: INTEGER
		do
			create Result.make (limit // 5)
			from i := 4 until i >= limit loop
				if is_brilliant (i) then
					Result.extend (i)
				end
				i := i + 1
			end
		end

	first_brilliant_above (threshold: INTEGER): INTEGER
			-- First brilliant number >= `threshold`
		require
			positive: threshold >= 1
		local
			i: INTEGER
		do
			from i := threshold until is_brilliant (i) loop
				i := i + 1
			end
			Result := i
		ensure
			is_brilliant: is_brilliant (Result)
			at_or_above: Result >= threshold
		end

feature -- Implementation

	semiprime_factors (n: INTEGER): detachable TUPLE [p, q: INTEGER]
			-- If `n` is semiprime, return its two prime factors
		require
			positive: n >= 1
		local
			i: INTEGER
		do
			from i := 2 until i * i > n loop
				if n \\ i = 0 then
					if is_prime (i) and then is_prime (n // i) then
						Result := [i, n // i]
					end
					-- Exit after finding first factorization
					if Result /= Void then
						i := n  -- Force exit
					end
				end
				i := i + 1
			end
		end

	digit_count (n: INTEGER): INTEGER
			-- Number of digits in `n`
		require
			positive: n >= 1
		local
			remaining: INTEGER
		do
			from remaining := n until remaining = 0 loop
				Result := Result + 1
				remaining := remaining // 10
			end
		end

	is_prime (n: INTEGER): BOOLEAN
			-- Is `n` prime?
		local
			i: INTEGER
		do
			if n < 2 then
				Result := False
			elseif n = 2 then
				Result := True
			elseif n \\ 2 = 0 then
				Result := False
			else
				Result := True
				from i := 3 until i * i > n or not Result loop
					if n \\ i = 0 then
						Result := False
					end
					i := i + 2
				end
			end
		end

feature -- Demo

	demo
			-- Standard Rosetta Code demo
		local
			brilliant: ARRAYED_LIST [INTEGER]
			i: INTEGER
		do
			print ("First 100 brilliant numbers:%N")
			brilliant := first_n_brilliant (100)
			from i := 1 until i > brilliant.count loop
				print (brilliant [i].out)
				if i \\ 10 = 0 then
					print ("%N")
				else
					print (" ")
				end
				i := i + 1
			end
			print ("%N")
			print ("First brilliant >= 100: " + first_brilliant_above (100).out + "%N")
			print ("First brilliant >= 1000: " + first_brilliant_above (1000).out + "%N")
			print ("First brilliant >= 10000: " + first_brilliant_above (10000).out + "%N")
		end

end
