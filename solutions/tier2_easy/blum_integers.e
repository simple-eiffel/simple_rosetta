note
	description: "[
		Rosetta Code: Blum integer
		https://rosettacode.org/wiki/Blum_integer

		A Blum integer is a semiprime (product of two distinct primes)
		where both primes are congruent to 3 (mod 4).
		Example: 21 = 3 × 7, both 3 ≡ 3 (mod 4) and 7 ≡ 3 (mod 4).
	]"

class
	BLUM_INTEGERS

feature -- Query

	is_blum_integer (n: INTEGER): BOOLEAN
			-- Is `n` a Blum integer?
		require
			positive: n >= 1
		local
			p, q: INTEGER
		do
			-- Find two distinct prime factors p and q where p * q = n
			-- and both p ≡ 3 (mod 4) and q ≡ 3 (mod 4)
			p := smallest_prime_factor (n)
			if p > 0 and then n \\ p = 0 then
				q := n // p
				if p /= q and then is_prime (q) then
					Result := (p \\ 4 = 3) and (q \\ 4 = 3)
				end
			end
		end

	is_blum_prime (p: INTEGER): BOOLEAN
			-- Is `p` a Blum prime (prime ≡ 3 mod 4)?
		require
			positive: p >= 2
		do
			Result := is_prime (p) and then (p \\ 4 = 3)
		end

	first_n_blum_integers (n: INTEGER): ARRAYED_LIST [INTEGER]
			-- First `n` Blum integers
		require
			positive: n >= 1
		local
			i: INTEGER
		do
			create Result.make (n)
			from i := 21 until Result.count >= n loop  -- 21 is first Blum integer
				if is_blum_integer (i) then
					Result.extend (i)
				end
				i := i + 1
			end
		ensure
			correct_count: Result.count = n
		end

	blum_integers_below (limit: INTEGER): ARRAYED_LIST [INTEGER]
			-- All Blum integers below `limit`
		require
			valid_limit: limit >= 21
		local
			i: INTEGER
		do
			create Result.make (limit // 10)
			from i := 21 until i >= limit loop
				if is_blum_integer (i) then
					Result.extend (i)
				end
				i := i + 1
			end
		end

feature -- Implementation

	smallest_prime_factor (n: INTEGER): INTEGER
			-- Smallest prime factor of `n`, or 0 if n < 2
		require
			positive: n >= 1
		local
			i: INTEGER
		do
			if n >= 2 then
				if n \\ 2 = 0 then
					Result := 2
				else
					from i := 3 until i * i > n or Result > 0 loop
						if n \\ i = 0 then
							Result := i
						end
						i := i + 2
					end
					if Result = 0 then
						Result := n  -- n is prime
					end
				end
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
				-- Use i*i > n instead of sqrt
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
			blums: ARRAYED_LIST [INTEGER]
			i: INTEGER
		do
			print ("First 50 Blum integers:%N")
			blums := first_n_blum_integers (50)
			from i := 1 until i > blums.count loop
				print (blums [i].out)
				if i \\ 10 = 0 then
					print ("%N")
				else
					print (" ")
				end
				i := i + 1
			end
			print ("%N")
		end

end
