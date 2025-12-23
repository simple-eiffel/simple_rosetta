note
	description: "[
		Rosetta Code: Cuban primes
		https://rosettacode.org/wiki/Cuban_primes

		Cuban primes are primes of the form p = (x³ - y³)/(x - y)
		where y = x - 1, giving p = 3x² - 3x + 1.
		Sequence: 7, 19, 37, 61, 127, 271, ...
	]"

class
	CUBAN_PRIMES

feature -- Query

	is_cuban_prime (p: INTEGER_64): BOOLEAN
			-- Is `p` a cuban prime?
		require
			positive: p >= 2
		local
			x: INTEGER_64
			candidate: INTEGER_64
		do
			if is_prime (p) then
				-- Check if p = 3x² - 3x + 1 for some x
				-- Solve: 3x² - 3x + (1-p) = 0
				-- x = (3 + sqrt(9 - 12(1-p))) / 6 = (3 + sqrt(12p - 3)) / 6
				from x := 2 until candidate > p loop
					candidate := 3 * x * x - 3 * x + 1
					if candidate = p then
						Result := True
					end
					x := x + 1
				end
			end
		end

	cuban_prime_at (x: INTEGER_64): INTEGER_64
			-- Cuban prime candidate at position `x`: 3x² - 3x + 1
		require
			valid_x: x >= 2
		do
			Result := 3 * x * x - 3 * x + 1
		ensure
			positive: Result > 0
		end

	first_n_cuban_primes (n: INTEGER): ARRAYED_LIST [INTEGER_64]
			-- First `n` cuban primes
		require
			positive: n >= 1
		local
			x: INTEGER_64
			candidate: INTEGER_64
		do
			create Result.make (n)
			from x := 2 until Result.count >= n loop
				candidate := cuban_prime_at (x)
				if is_prime (candidate) then
					Result.extend (candidate)
				end
				x := x + 1
			end
		ensure
			correct_count: Result.count = n
		end

	cuban_primes_below (limit: INTEGER_64): ARRAYED_LIST [INTEGER_64]
			-- All cuban primes below `limit`
		require
			positive: limit >= 7
		local
			x: INTEGER_64
			candidate: INTEGER_64
		do
			create Result.make (100)
			from x := 2 until cuban_prime_at (x) >= limit loop
				candidate := cuban_prime_at (x)
				if is_prime (candidate) then
					Result.extend (candidate)
				end
				x := x + 1
			end
		end

feature -- Implementation

	is_prime (n: INTEGER_64): BOOLEAN
			-- Is `n` prime?
		local
			i: INTEGER_64
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
			primes: ARRAYED_LIST [INTEGER_64]
			i: INTEGER
		do
			print ("First 50 cuban primes:%N")
			primes := first_n_cuban_primes (50)
			from i := 1 until i > primes.count loop
				print (primes [i].out)
				if i \\ 10 = 0 then
					print ("%N")
				else
					print (" ")
				end
				i := i + 1
			end
		end

end
