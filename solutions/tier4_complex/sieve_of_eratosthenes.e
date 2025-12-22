note
	description: "[
		Rosetta Code: Sieve of Eratosthenes
		https://rosettacode.org/wiki/Sieve_of_Eratosthenes

		Find all prime numbers up to a given limit using the sieve algorithm.
	]"
	author: "Eiffel Solution"
	rosetta_task: "Sieve_of_Eratosthenes"

class
	SIEVE_OF_ERATOSTHENES

create
	make

feature {NONE} -- Initialization

	make
			-- Demonstrate sieve of Eratosthenes.
		local
			primes: ARRAYED_LIST [INTEGER]
			i: INTEGER
		do
			print ("Sieve of Eratosthenes%N")
			print ("=====================%N%N")

			-- Find primes up to 100
			primes := sieve (100)
			print ("Primes up to 100 (" + primes.count.out + " primes):%N")
			from i := 1 until i > primes.count loop
				print (primes.i_th (i).out)
				if i < primes.count then print (", ") end
				if i \\ 15 = 0 then print ("%N") end
				i := i + 1
			end
			print ("%N")

			-- Count primes up to larger limits
			print ("%NPrime counts:%N")
			print ("  Up to 1,000: " + sieve (1000).count.out + " primes%N")
			print ("  Up to 10,000: " + sieve (10000).count.out + " primes%N")
		end

feature -- Prime Generation

	sieve (limit: INTEGER): ARRAYED_LIST [INTEGER]
			-- All prime numbers from 2 to limit using Sieve of Eratosthenes.
		require
			positive_limit: limit >= 2
		local
			is_prime: ARRAY [BOOLEAN]
			i, j: INTEGER
		do
			-- Initialize all as prime
			create is_prime.make_filled (True, 2, limit)

			-- Sieve: mark multiples of each prime as composite
			from i := 2 until i * i > limit loop
				if is_prime [i] then
					from j := i * i until j > limit loop
						is_prime [j] := False
						j := j + i
					end
				end
				i := i + 1
			end

			-- Collect primes
			create Result.make (limit // 10)
			from i := 2 until i > limit loop
				if is_prime [i] then
					Result.extend (i)
				end
				i := i + 1
			end
		ensure
			all_prime: across Result as p all is_prime_number (p.item) end
		end

	is_prime_number (n: INTEGER): BOOLEAN
			-- Is n a prime number?
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

end
