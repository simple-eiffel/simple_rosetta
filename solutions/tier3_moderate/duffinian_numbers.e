note
	description: "[
		Rosetta Code: Duffinian numbers
		https://rosettacode.org/wiki/Duffinian_numbers

		A Duffinian number is a composite number n where
		gcd(n, sigma(n)) = 1 (n and its divisor sum are coprime).
		Example: 4 has sigma(4) = 1+2+4 = 7, gcd(4,7) = 1.
	]"

class
	DUFFINIAN_NUMBERS

feature -- Query

	is_duffinian (n: INTEGER): BOOLEAN
			-- Is `n` a Duffinian number?
		require
			positive: n >= 1
		local
			sigma_n: INTEGER
		do
			if is_composite (n) then
				sigma_n := divisor_sum (n)
				Result := gcd (n, sigma_n) = 1
			end
		end

	first_n_duffinian (n: INTEGER): ARRAYED_LIST [INTEGER]
			-- First `n` Duffinian numbers
		require
			positive: n >= 1
		local
			i: INTEGER
		do
			create Result.make (n)
			from i := 4 until Result.count >= n loop
				if is_duffinian (i) then
					Result.extend (i)
				end
				i := i + 1
			end
		ensure
			correct_count: Result.count = n
		end

	duffinian_below (limit: INTEGER): ARRAYED_LIST [INTEGER]
			-- All Duffinian numbers below `limit`
		require
			valid_limit: limit >= 4
		local
			i: INTEGER
		do
			create Result.make (limit // 5)
			from i := 4 until i >= limit loop
				if is_duffinian (i) then
					Result.extend (i)
				end
				i := i + 1
			end
		end

	duffinian_triples (count: INTEGER): ARRAYED_LIST [TUPLE [a, b, c: INTEGER]]
			-- First `count` Duffinian triples (3 consecutive Duffinian numbers)
		require
			positive: count >= 1
		local
			i: INTEGER
		do
			create Result.make (count)
			from i := 4 until Result.count >= count loop
				if is_duffinian (i) and then is_duffinian (i + 1) and then is_duffinian (i + 2) then
					Result.extend ([i, i + 1, i + 2])
				end
				i := i + 1
			end
		end

feature -- Implementation

	divisor_sum (n: INTEGER): INTEGER
			-- Sum of all divisors of `n` (including 1 and n)
		require
			positive: n >= 1
		local
			i: INTEGER
		do
			Result := 1
			if n > 1 then
				from i := 2 until i * i > n loop
					if n \\ i = 0 then
						Result := Result + i
						if i /= n // i then
							Result := Result + (n // i)
						end
					end
					i := i + 1
				end
				Result := Result + n
			end
		end

	is_composite (n: INTEGER): BOOLEAN
			-- Is `n` composite (not prime and > 1)?
		require
			positive: n >= 1
		do
			Result := n > 1 and then not is_prime (n)
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

	gcd (a, b: INTEGER): INTEGER
			-- Greatest common divisor
		require
			non_negative: a >= 0 and b >= 0
		do
			if b = 0 then
				Result := a
			else
				Result := gcd (b, a \\ b)
			end
		ensure
			non_negative: Result >= 0
		end

feature -- Demo

	demo
			-- Standard Rosetta Code demo
		local
			duffs: ARRAYED_LIST [INTEGER]
			triples: ARRAYED_LIST [TUPLE [a, b, c: INTEGER]]
			i: INTEGER
		do
			print ("First 50 Duffinian numbers:%N")
			duffs := first_n_duffinian (50)
			from i := 1 until i > duffs.count loop
				print (duffs [i].out)
				if i \\ 10 = 0 then
					print ("%N")
				else
					print (" ")
				end
				i := i + 1
			end

			print ("%NFirst 10 Duffinian triples:%N")
			triples := duffinian_triples (10)
			across triples as t loop
				print ("(" + t.a.out + ", " + t.b.out + ", " + t.c.out + ")%N")
			end
		end

end
