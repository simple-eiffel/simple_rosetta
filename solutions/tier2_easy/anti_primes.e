note
	description: "[
		Rosetta Code: Anti-primes (Highly composite numbers)
		https://rosettacode.org/wiki/Anti-primes

		Anti-primes are positive integers that have more divisors
		than any smaller positive integer. Also called highly composite numbers.
		Sequence: 1, 2, 4, 6, 12, 24, 36, 48, 60, 120, ...
	]"

class
	ANTI_PRIMES

feature -- Query

	is_anti_prime (n: INTEGER): BOOLEAN
			-- Is `n` an anti-prime (highly composite)?
		require
			positive: n >= 1
		local
			n_divisors, i: INTEGER
		do
			n_divisors := divisor_count (n)
			Result := True
			from i := 1 until i >= n or not Result loop
				if divisor_count (i) >= n_divisors then
					Result := False
				end
				i := i + 1
			end
		end

	anti_primes (count: INTEGER): ARRAYED_LIST [INTEGER]
			-- First `count` anti-primes
		require
			positive: count >= 1
		local
			n, max_divisors, d: INTEGER
		do
			create Result.make (count)
			max_divisors := 0
			from n := 1 until Result.count >= count loop
				d := divisor_count (n)
				if d > max_divisors then
					max_divisors := d
					Result.extend (n)
				end
				n := n + 1
			end
		ensure
			correct_count: Result.count = count
		end

	anti_primes_up_to (limit: INTEGER): ARRAYED_LIST [INTEGER]
			-- All anti-primes up to `limit`
		require
			positive: limit >= 1
		local
			n, max_divisors, d: INTEGER
		do
			create Result.make (20)
			max_divisors := 0
			from n := 1 until n > limit loop
				d := divisor_count (n)
				if d > max_divisors then
					max_divisors := d
					Result.extend (n)
				end
				n := n + 1
			end
		end

feature -- Implementation

	divisor_count (n: INTEGER): INTEGER
			-- Number of divisors of `n`
		require
			positive: n >= 1
		local
			i: INTEGER
		do
			from i := 1 until i * i > n loop
				if n \\ i = 0 then
					Result := Result + 1
					if i /= n // i then
						Result := Result + 1
					end
				end
				i := i + 1
			end
		end

feature -- Demo

	demo
			-- Standard Rosetta Code demo
		local
			primes: ARRAYED_LIST [INTEGER]
		do
			print ("First 20 anti-primes:%N")
			primes := anti_primes (20)
			print (list_to_csv (primes))
			print ("%N")
		end

	list_to_csv (lst: ARRAYED_LIST [INTEGER]): STRING
			-- Convert list to comma-separated string
		local
			i: INTEGER
		do
			create Result.make (lst.count * 5)
			from i := 1 until i > lst.count loop
				Result.append (lst [i].out)
				if i < lst.count then
					Result.append (", ")
				end
				i := i + 1
			end
		end

end
