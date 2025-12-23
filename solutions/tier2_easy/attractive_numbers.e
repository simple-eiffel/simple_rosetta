note
	description: "[
		Rosetta Code: Attractive numbers
		https://rosettacode.org/wiki/Attractive_numbers

		A number is attractive if the number of its prime factors
		(with multiplicity) is itself prime.
		Example: 20 = 2*2*5 has 3 prime factors, and 3 is prime.
	]"

class
	ATTRACTIVE_NUMBERS

feature -- Query

	is_attractive (n: INTEGER): BOOLEAN
			-- Is `n` attractive?
		require
			positive: n >= 1
		do
			if n = 1 then
				Result := False  -- 1 has 0 prime factors, 0 is not prime
			else
				Result := is_prime (prime_factor_count (n))
			end
		end

	attractive_numbers_up_to (limit: INTEGER): ARRAYED_LIST [INTEGER]
			-- All attractive numbers up to `limit`
		require
			valid_limit: limit >= 1
		local
			i: INTEGER
		do
			create Result.make (limit // 2)
			from i := 1 until i > limit loop
				if is_attractive (i) then
					Result.extend (i)
				end
				i := i + 1
			end
		ensure
			all_attractive: across Result as c all is_attractive (c) end
		end

	count_attractive (limit: INTEGER): INTEGER
			-- Count of attractive numbers up to `limit`
		require
			valid_limit: limit >= 1
		local
			i: INTEGER
		do
			from i := 1 until i > limit loop
				if is_attractive (i) then
					Result := Result + 1
				end
				i := i + 1
			end
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

	is_prime (n: INTEGER): BOOLEAN
			-- Is `n` prime?
		require
			non_negative: n >= 0
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

feature -- Demo

	demo
			-- Standard Rosetta Code demo
		local
			nums: ARRAYED_LIST [INTEGER]
			i: INTEGER
		do
			print ("Attractive numbers up to 120:%N")
			nums := attractive_numbers_up_to (120)
			from i := 1 until i > nums.count loop
				print (nums [i].out.as_string_8 + if nums [i] < 10 then "  " elseif nums [i] < 100 then " " else "" end)
				if i \\ 15 = 0 then
					print ("%N")
				else
					print (" ")
				end
				i := i + 1
			end
			print ("%N%NCount: " + nums.count.out + "%N")
		end

end
