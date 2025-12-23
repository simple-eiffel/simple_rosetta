note
	description: "[
		Rosetta Code: Circular primes
		https://rosettacode.org/wiki/Circular_primes

		A circular prime is a prime where all rotations of its digits
		are also prime. Example: 197 -> 971 -> 719 (all prime).
	]"

class
	CIRCULAR_PRIMES

feature -- Query

	is_circular_prime (n: INTEGER): BOOLEAN
			-- Is `n` a circular prime?
		require
			positive: n >= 2
		local
			rotations: ARRAYED_LIST [INTEGER]
		do
			if is_prime (n) then
				rotations := all_rotations (n)
				Result := across rotations as r all is_prime (r) end
			end
		end

	circular_primes_below (limit: INTEGER): ARRAYED_LIST [INTEGER]
			-- All circular primes below `limit`
		require
			valid_limit: limit >= 2
		local
			i: INTEGER
		do
			create Result.make (50)
			from i := 2 until i >= limit loop
				if is_circular_prime (i) then
					Result.extend (i)
				end
				i := i + 1
			end
		ensure
			all_circular: across Result as c all is_circular_prime (c) end
		end

feature -- Implementation

	all_rotations (n: INTEGER): ARRAYED_LIST [INTEGER]
			-- All digit rotations of `n`
		require
			positive: n >= 1
		local
			s: STRING
			i: INTEGER
			rotated: STRING
		do
			create Result.make (10)
			s := n.out
			from i := 1 until i > s.count loop
				rotated := s.substring (i, s.count) + s.substring (1, i - 1)
				Result.extend (rotated.to_integer)
				i := i + 1
			end
		ensure
			same_count_as_digits: Result.count = n.out.count
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

	list_to_string (lst: ARRAYED_LIST [INTEGER]): STRING
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

feature -- Demo

	demo
			-- Standard Rosetta Code demo
		local
			primes: ARRAYED_LIST [INTEGER]
		do
			print ("Circular primes below 1,000,000:%N")
			primes := circular_primes_below (1000000)
			print (list_to_string (primes))
			print ("%N%NCount: " + primes.count.out + "%N")
		end

end
