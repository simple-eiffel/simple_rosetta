note
	description: "[
		Rosetta Code: Sieve of Eratosthenes
		https://rosettacode.org/wiki/Sieve_of_Eratosthenes

		Find primes using the Sieve of Eratosthenes.
	]"
	author: "Simple Eiffel"
	see_also: "https://github.com/simple-eiffel"
	rosetta_task: "Sieve_of_Eratosthenes"
	tier: "2"

class
	SIEVE_ERATOSTHENES

create
	make

feature {NONE} -- Initialization

	make
			-- Demonstrate sieve.
		local
			primes: ARRAYED_LIST [INTEGER]
		do
			print ("Sieve of Eratosthenes%N")
			print ("=====================%N%N")

			primes := sieve (100)
			print ("Primes up to 100:%N")
			across primes as p loop
				print (p.out + " ")
			end
			print ("%N%NCount: " + primes.count.out + "%N")
		end

feature -- Sieve

	sieve (limit: INTEGER): ARRAYED_LIST [INTEGER]
			-- All primes up to limit.
		require
			positive: limit > 0
		local
			is_prime: ARRAY [BOOLEAN]
			i, j: INTEGER
		do
			create Result.make (limit // 2)
			create is_prime.make_filled (True, 2, limit)

			from i := 2 until i * i > limit loop
				if is_prime [i] then
					from j := i * i until j > limit loop
						is_prime [j] := False
						j := j + i
					end
				end
				i := i + 1
			end

			from i := 2 until i > limit loop
				if is_prime [i] then
					Result.extend (i)
				end
				i := i + 1
			end
		ensure
			result_exists: Result /= Void
		end

end