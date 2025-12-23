note
	description: "[
		Rosetta Code: Descending primes
		https://rosettacode.org/wiki/Descending_primes

		Primes where each digit is strictly less than the previous.
		Example: 9521 (9>5>2>1 and is prime).
	]"

class
	DESCENDING_PRIMES

feature -- Query

	is_descending_prime (n: INTEGER): BOOLEAN
			-- Is `n` a descending prime?
		require
			positive: n >= 2
		do
			Result := has_descending_digits (n) and then is_prime (n)
		end

	has_descending_digits (n: INTEGER): BOOLEAN
			-- Do digits of `n` strictly descend left to right?
		require
			positive: n >= 1
		local
			s: STRING
			i: INTEGER
		do
			s := n.out
			if s.count = 1 then
				Result := True
			else
				Result := True
				from i := 1 until i >= s.count or not Result loop
					if s [i] <= s [i + 1] then
						Result := False
					end
					i := i + 1
				end
			end
		end

	all_descending_primes: ARRAYED_LIST [INTEGER]
			-- All descending primes (finite set)
		local
			candidates: ARRAYED_LIST [INTEGER]
		do
			create Result.make (100)
			candidates := generate_descending_numbers
			across candidates as c loop
				if is_prime (c) then
					Result.extend (c)
				end
			end
		ensure
			all_descending: across Result as p all is_descending_prime (p) end
		end

feature -- Implementation

	generate_descending_numbers: ARRAYED_LIST [INTEGER]
			-- All numbers with strictly descending digits
		local
			i, j, k, l, m: INTEGER
		do
			create Result.make (500)
			-- 1-digit
			from i := 1 until i > 9 loop
				Result.extend (i)
				i := i + 1
			end
			-- 2-digit
			from i := 2 until i > 9 loop
				from j := 1 until j >= i loop
					Result.extend (i * 10 + j)
					j := j + 1
				end
				i := i + 1
			end
			-- 3-digit
			from i := 3 until i > 9 loop
				from j := 2 until j >= i loop
					from k := 1 until k >= j loop
						Result.extend (i * 100 + j * 10 + k)
						k := k + 1
					end
					j := j + 1
				end
				i := i + 1
			end
			-- 4-digit and beyond via recursion would be cleaner but this covers most
			from i := 4 until i > 9 loop
				from j := 3 until j >= i loop
					from k := 2 until k >= j loop
						from l := 1 until l >= k loop
							Result.extend (i * 1000 + j * 100 + k * 10 + l)
							l := l + 1
						end
						k := k + 1
					end
					j := j + 1
				end
				i := i + 1
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
			primes: ARRAYED_LIST [INTEGER]
			i: INTEGER
		do
			print ("All descending primes:%N")
			primes := all_descending_primes
			from i := 1 until i > primes.count loop
				print (primes [i].out)
				if i \\ 10 = 0 then
					print ("%N")
				else
					print (" ")
				end
				i := i + 1
			end
			print ("%N%NTotal: " + primes.count.out + "%N")
		end

end
