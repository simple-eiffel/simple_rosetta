note
	description: "[
		Rosetta Code: Additive primes
		https://rosettacode.org/wiki/Additive_primes

		An additive prime is a prime whose digit sum is also prime.
		Example: 29 is prime and 2+9=11 is also prime.
	]"

class
	ADDITIVE_PRIMES

feature -- Query

	is_additive_prime (n: INTEGER): BOOLEAN
			-- Is `n` an additive prime?
		require
			positive: n >= 2
		do
			Result := is_prime (n) and then is_prime (digit_sum (n))
		end

	additive_primes_up_to (limit: INTEGER): ARRAYED_LIST [INTEGER]
			-- All additive primes up to `limit`
		require
			valid_limit: limit >= 2
		local
			i: INTEGER
		do
			create Result.make (limit // 4)  -- Rough estimate
			from i := 2 until i > limit loop
				if is_additive_prime (i) then
					Result.extend (i)
				end
				i := i + 1
			end
		ensure
			all_additive: across Result as c all is_additive_prime (c) end
		end

	count_additive_primes (limit: INTEGER): INTEGER
			-- Count of additive primes up to `limit`
		require
			valid_limit: limit >= 2
		local
			i: INTEGER
		do
			from i := 2 until i > limit loop
				if is_additive_prime (i) then
					Result := Result + 1
				end
				i := i + 1
			end
		end

feature -- Implementation

	is_prime (n: INTEGER): BOOLEAN
			-- Is `n` prime?
		require
			positive: n >= 1
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
				-- Use i*i > n instead of sqrt
				from i := 3 until i * i > n or not Result loop
					if n \\ i = 0 then
						Result := False
					end
					i := i + 2
				end
			end
		end

	digit_sum (n: INTEGER): INTEGER
			-- Sum of digits of `n`
		require
			non_negative: n >= 0
		local
			remaining: INTEGER
		do
			from remaining := n until remaining = 0 loop
				Result := Result + (remaining \\ 10)
				remaining := remaining // 10
			end
		end

feature -- Demo

	demo
			-- Standard Rosetta Code demo
		local
			primes: ARRAYED_LIST [INTEGER]
			i: INTEGER
		do
			print ("Additive primes less than 500:%N")
			primes := additive_primes_up_to (500)
			from i := 1 until i > primes.count loop
				print (primes [i].out)
				if i \\ 10 = 0 then
					print ("%N")
				else
					print (" ")
				end
				i := i + 1
			end
			print ("%N%NCount: " + primes.count.out + "%N")
		end

end
