note
	description: "[
		Rosetta Code: Almost prime
		https://rosettacode.org/wiki/Almost_prime

		A k-almost prime is a natural number with exactly k prime factors,
		counted with multiplicity. 1-almost primes are primes.
		2-almost primes are semiprimes (4, 6, 9, 10, 14, 15, ...).
	]"

class
	ALMOST_PRIME

feature -- Query

	is_k_almost_prime (n, k: INTEGER): BOOLEAN
			-- Does `n` have exactly `k` prime factors (with multiplicity)?
		require
			n_positive: n >= 1
			k_positive: k >= 1
		do
			Result := prime_factor_count (n) = k
		end

	is_semiprime (n: INTEGER): BOOLEAN
			-- Is `n` a 2-almost prime (semiprime)?
		require
			positive: n >= 1
		do
			Result := prime_factor_count (n) = 2
		end

	k_almost_primes (k, count: INTEGER): ARRAYED_LIST [INTEGER]
			-- First `count` k-almost primes
		require
			k_positive: k >= 1
			count_positive: count >= 1
		local
			n: INTEGER
		do
			create Result.make (count)
			from n := 2 until Result.count >= count loop
				if prime_factor_count (n) = k then
					Result.extend (n)
				end
				n := n + 1
			end
		ensure
			correct_count: Result.count = count
			all_k_almost: across Result as c all is_k_almost_prime (c, k) end
		end

	semiprimes (count: INTEGER): ARRAYED_LIST [INTEGER]
			-- First `count` semiprimes
		require
			positive: count >= 1
		do
			Result := k_almost_primes (2, count)
		end

feature -- Implementation

	prime_factor_count (n: INTEGER): INTEGER
			-- Count of prime factors of `n` (with multiplicity)
		require
			positive: n >= 1
		local
			remaining, divisor: INTEGER
		do
			if n = 1 then
				Result := 0
			else
				remaining := n
				divisor := 2
				from until remaining = 1 loop
					from until remaining \\ divisor /= 0 loop
						Result := Result + 1
						remaining := remaining // divisor
					end
					divisor := divisor + 1
				end
			end
		end

feature -- Demo

	demo
			-- Standard Rosetta Code demo: first 10 k-almost primes for k=1..5
		local
			k: INTEGER
			primes: ARRAYED_LIST [INTEGER]
		do
			from k := 1 until k > 5 loop
				print ("k=" + k.out + ": ")
				primes := k_almost_primes (k, 10)
				print (list_to_csv (primes))
				print ("%N")
				k := k + 1
			end
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
