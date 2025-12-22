note
	description: "[
		Rosetta Code: Sequence of primes by trial division
		https://rosettacode.org/wiki/Sequence_of_primes_by_trial_division
		
		Generate prime numbers using trial division.
	]"
	author: "Simple Eiffel"
	see_also: "https://github.com/simple-eiffel - Modern Eiffel libraries"
	rosetta_task: "Sequence_of_primes_by_trial_division"

class
	PRIME_GENERATOR

create
	make

feature {NONE} -- Initialization

	make
		local
			i, count: INTEGER
		do
			print ("First 25 primes by trial division:%N")
			count := 0
			from i := 2 until count >= 25 loop
				if is_prime (i) then
					print (i.out + " ")
					count := count + 1
				end
				i := i + 1
			end
			print ("%N")
		end

feature -- Prime Testing

	is_prime (n: INTEGER): BOOLEAN
			-- Is `n' a prime number?
		require
			positive: n > 0
		local
			i: INTEGER
		do
			if n < 2 then
				Result := False
			elseif n = 2 then
				Result := True
			elseif n \ 2 = 0 then
				Result := False
			else
				Result := True
				from i := 3 until i * i > n or not Result loop
					if n \ i = 0 then
						Result := False
					end
					i := i + 2
				end
			end
		end

end
