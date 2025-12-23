note
	description: "[
		Rosetta Code: Fibonacci n-step number sequences
		https://rosettacode.org/wiki/Fibonacci_n-step_number_sequences

		Generalized Fibonacci where each term is sum of previous n terms.
		n=2: Fibonacci (1,1,2,3,5,8,...)
		n=3: Tribonacci (1,1,2,4,7,13,...)
		n=4: Tetranacci (1,1,2,4,8,15,...)
	]"

class
	FIBONACCI_N_STEP

feature -- Named Sequences

	fibonacci (count: INTEGER): ARRAYED_LIST [INTEGER_64]
			-- Standard Fibonacci sequence (2-step)
		require
			positive: count >= 1
		do
			Result := n_step_fibonacci (2, count)
		end

	tribonacci (count: INTEGER): ARRAYED_LIST [INTEGER_64]
			-- Tribonacci sequence (3-step)
		require
			positive: count >= 1
		do
			Result := n_step_fibonacci (3, count)
		end

	tetranacci (count: INTEGER): ARRAYED_LIST [INTEGER_64]
			-- Tetranacci sequence (4-step)
		require
			positive: count >= 1
		do
			Result := n_step_fibonacci (4, count)
		end

	pentanacci (count: INTEGER): ARRAYED_LIST [INTEGER_64]
			-- Pentanacci sequence (5-step)
		require
			positive: count >= 1
		do
			Result := n_step_fibonacci (5, count)
		end

	hexanacci (count: INTEGER): ARRAYED_LIST [INTEGER_64]
			-- Hexanacci sequence (6-step)
		require
			positive: count >= 1
		do
			Result := n_step_fibonacci (6, count)
		end

	heptanacci (count: INTEGER): ARRAYED_LIST [INTEGER_64]
			-- Heptanacci sequence (7-step)
		require
			positive: count >= 1
		do
			Result := n_step_fibonacci (7, count)
		end

	octonacci (count: INTEGER): ARRAYED_LIST [INTEGER_64]
			-- Octonacci sequence (8-step)
		require
			positive: count >= 1
		do
			Result := n_step_fibonacci (8, count)
		end

feature -- General

	n_step_fibonacci (n, count: INTEGER): ARRAYED_LIST [INTEGER_64]
			-- n-step Fibonacci sequence with `count` terms
		require
			valid_n: n >= 2
			positive_count: count >= 1
		local
			i, j: INTEGER
			sum: INTEGER_64
		do
			create Result.make (count)

			-- Initial terms: [1, 1, 2, 4, 8, ...] (powers of 2 up to 2^(n-2))
			from i := 1 until i > count.min (n - 1) loop
				if i = 1 then
					Result.extend (1)
				else
					Result.extend (power_of_2 (i - 2))
				end
				i := i + 1
			end

			-- Add first "full" term (sum of all initial terms)
			if count >= n then
				sum := 0
				from j := 1 until j >= n loop
					sum := sum + Result [j]
					j := j + 1
				end
				Result.extend (sum)
			end

			-- Subsequent terms
			from i := n + 1 until i > count loop
				sum := 0
				from j := i - n until j < i loop
					sum := sum + Result [j]
					j := j + 1
				end
				Result.extend (sum)
				i := i + 1
			end
		ensure
			correct_count: Result.count = count
		end

	lucas (count: INTEGER): ARRAYED_LIST [INTEGER_64]
			-- Lucas numbers (like Fibonacci but starts 2, 1)
		require
			positive: count >= 1
		local
			i: INTEGER
			a, b, temp: INTEGER_64
		do
			create Result.make (count)
			a := 2
			b := 1
			if count >= 1 then Result.extend (a) end
			if count >= 2 then Result.extend (b) end
			from i := 3 until i > count loop
				temp := a + b
				a := b
				b := temp
				Result.extend (b)
				i := i + 1
			end
		end

feature {NONE} -- Helpers

	power_of_2 (exp: INTEGER): INTEGER_64
			-- 2 raised to the power of `exp`
		require
			non_negative: exp >= 0
		local
			i: INTEGER
		do
			Result := 1
			from i := 1 until i > exp loop
				Result := Result * 2
				i := i + 1
			end
		end

	array_to_string (arr: ARRAYED_LIST [INTEGER_64]): STRING
			-- Convert list to comma-separated string
		local
			i: INTEGER
		do
			create Result.make (arr.count * 8)
			from i := 1 until i > arr.count loop
				Result.append (arr [i].out)
				if i < arr.count then
					Result.append (", ")
				end
				i := i + 1
			end
		end

feature -- Demo

	demo
			-- Standard Rosetta Code demo
		local
			names: ARRAY [STRING]
			seqs: ARRAY [ARRAYED_LIST [INTEGER_64]]
			i: INTEGER
		do
			names := <<"Fibonacci", "Tribonacci", "Tetranacci", "Pentanacci", "Hexanacci", "Heptanacci", "Octonacci">>
			seqs := <<fibonacci (15), tribonacci (15), tetranacci (15), pentanacci (15), hexanacci (15), heptanacci (15), octonacci (15)>>

			print ("n-step Fibonacci sequences (first 15 terms):%N%N")
			from i := 1 until i > names.count loop
				print (names [i] + ": ")
				print (array_to_string (seqs [i]))
				print ("%N")
				i := i + 1
			end

			print ("%NLucas numbers: ")
			print (array_to_string (lucas (15)))
			print ("%N")
		end

end
