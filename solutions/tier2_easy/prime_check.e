note
	description: "[
		Rosetta Code: Primality by trial division
		https://rosettacode.org/wiki/Primality_by_trial_division

		Check if a number is prime.
	]"
	author: "Simple Eiffel"
	see_also: "https://github.com/simple-eiffel"
	rosetta_task: "Primality_by_trial_division"
	tier: "2"

class
	PRIME_CHECK

create
	make

feature {NONE} -- Initialization

	make
			-- Demonstrate primality testing.
		do
			print ("Prime Check%N")
			print ("===========%N%N")

			print ("Numbers 1-30:%N")
			across 1 |..| 30 as n loop
				if is_prime (n) then
					print (n.out + " ")
				end
			end
			print ("%N%N")

			print ("Testing specific numbers:%N")
			test (1)
			test (2)
			test (17)
			test (100)
			test (997)
		end

feature -- Testing

	test (n: INTEGER)
		do
			print (n.out + ": " + (if is_prime (n) then "prime" else "not prime" end) + "%N")
		end

feature -- Query

	is_prime (n: INTEGER): BOOLEAN
			-- Is n prime?
		local
			i, limit: INTEGER
		do
			if n < 2 then
				Result := False
			elseif n = 2 then
				Result := True
			elseif n \\ 2 = 0 then
				Result := False
			else
				Result := True
				limit := sqrt_int (n)
				from i := 3 until i > limit or not Result loop
					if n \\ i = 0 then
						Result := False
					end
					i := i + 2
				end
			end
		end

feature {NONE} -- Helpers

	sqrt_int (n: INTEGER): INTEGER
			-- Integer square root.
		do
			Result := {DOUBLE_MATH}.sqrt (n.to_double).truncated_to_integer
		end

end