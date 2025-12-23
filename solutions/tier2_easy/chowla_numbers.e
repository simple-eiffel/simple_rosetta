note
	description: "[
		Rosetta Code: Chowla numbers
		https://rosettacode.org/wiki/Chowla_numbers

		Chowla(n) = sum of divisors of n, excluding 1 and n itself.
		Chowla(1) = 0, Chowla(prime) = 0, Chowla(perfect) = n.
	]"

class
	CHOWLA_NUMBERS

feature -- Query

	chowla (n: INTEGER): INTEGER
			-- Chowla function: sum of proper divisors excluding 1 and n
		require
			positive: n >= 1
		local
			i: INTEGER
		do
			if n > 2 then
				from i := 2 until i * i > n loop
					if n \\ i = 0 then
						Result := Result + i
						if i /= n // i then
							Result := Result + (n // i)
						end
					end
					i := i + 1
				end
			end
		ensure
			non_negative: Result >= 0
			zero_for_one: n = 1 implies Result = 0
		end

	is_prime_via_chowla (n: INTEGER): BOOLEAN
			-- Is `n` prime? (Chowla(prime) = 0 for n > 1)
		require
			positive: n >= 1
		do
			Result := n > 1 and then chowla (n) = 0
		end

	is_perfect_via_chowla (n: INTEGER): BOOLEAN
			-- Is `n` perfect? (Chowla(perfect) + 1 = n)
		require
			positive: n >= 1
		do
			Result := n > 1 and then chowla (n) + 1 = n
		end

	chowla_sequence (count: INTEGER): ARRAYED_LIST [INTEGER]
			-- First `count` Chowla numbers
		require
			positive: count >= 1
		local
			i: INTEGER
		do
			create Result.make (count)
			from i := 1 until i > count loop
				Result.extend (chowla (i))
				i := i + 1
			end
		ensure
			correct_count: Result.count = count
		end

	count_primes_below (limit: INTEGER): INTEGER
			-- Count primes below `limit` using Chowla
		require
			valid_limit: limit >= 2
		local
			i: INTEGER
		do
			from i := 2 until i >= limit loop
				if chowla (i) = 0 then
					Result := Result + 1
				end
				i := i + 1
			end
		end

feature -- Demo

	demo
			-- Standard Rosetta Code demo
		local
			i: INTEGER
			perfect_count: INTEGER
		do
			print ("Chowla(1) to Chowla(37):%N")
			from i := 1 until i > 37 loop
				print ("Chowla(" + i.out + ") = " + chowla (i).out + "%N")
				i := i + 1
			end

			print ("%NPrimes below 100 (via Chowla): " + count_primes_below (100).out + "%N")
			print ("Primes below 1000: " + count_primes_below (1000).out + "%N")
			print ("Primes below 10000: " + count_primes_below (10000).out + "%N")

			print ("%NPerfect numbers below 1,000,000:%N")
			from i := 2 until i >= 1000000 loop
				if is_perfect_via_chowla (i) then
					print (i.out + " ")
					perfect_count := perfect_count + 1
				end
				i := i + 1
			end
			print ("%NCount: " + perfect_count.out + "%N")
		end

end
