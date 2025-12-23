note
	description: "[
		Rosetta Code: Emirp primes
		https://rosettacode.org/wiki/Emirp_primes

		An emirp is a prime whose reversal is a different prime.
		Example: 13 reversed is 31, both prime and different.
		Palindromic primes (like 11, 101) are NOT emirps.
	]"

class
	EMIRP_PRIMES

feature -- Query

	is_emirp (n: INTEGER): BOOLEAN
			-- Is `n` an emirp?
		require
			positive: n >= 2
		local
			rev: INTEGER
		do
			if is_prime (n) then
				rev := reverse_number (n)
				Result := rev /= n and then is_prime (rev)
			end
		end

	emirps_below (limit: INTEGER): ARRAYED_LIST [INTEGER]
			-- All emirps below `limit`
		require
			valid_limit: limit >= 2
		local
			i: INTEGER
		do
			create Result.make (limit // 10)
			from i := 13 until i >= limit loop
				if is_emirp (i) then
					Result.extend (i)
				end
				i := i + 1
			end
		ensure
			all_emirps: across Result as e all is_emirp (e) end
		end

	first_n_emirps (n: INTEGER): ARRAYED_LIST [INTEGER]
			-- First `n` emirps
		require
			positive: n >= 1
		local
			i: INTEGER
		do
			create Result.make (n)
			from i := 13 until Result.count >= n loop
				if is_emirp (i) then
					Result.extend (i)
				end
				i := i + 1
			end
		ensure
			correct_count: Result.count = n
		end

feature -- Implementation

	reverse_number (n: INTEGER): INTEGER
			-- Reverse digits of `n`
		require
			non_negative: n >= 0
		local
			remaining: INTEGER
		do
			from remaining := n until remaining = 0 loop
				Result := Result * 10 + (remaining \\ 10)
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
				-- Use i*i > n instead of sqrt
				from i := 3 until i * i > n or not Result loop
					if n \\ i = 0 then
						Result := False
					end
					i := i + 2
				end
			end
		end

feature {NONE} -- Helpers

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

feature -- Demo

	demo
			-- Standard Rosetta Code demo
		local
			emirps: ARRAYED_LIST [INTEGER]
		do
			print ("First 20 emirps:%N")
			emirps := first_n_emirps (20)
			print (list_to_csv (emirps))
			print ("%N%N")

			print ("Emirps between 7700 and 8000:%N")
			emirps := emirps_below (8000)
			across emirps as e loop
				if e >= 7700 then
					print (e.out + " ")
				end
			end
			print ("%N")
		end

end
