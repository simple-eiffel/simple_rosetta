note
	description: "[
		Rosetta Code: Combinations with repetitions
		https://rosettacode.org/wiki/Combinations_with_repetitions

		Generate all k-combinations with repetition from n elements.
		Count = C(n+k-1, k) = (n+k-1)! / (k! * (n-1)!)
	]"

class
	COMBINATIONS_WITH_REPETITIONS

feature -- Query

	count (n, k: INTEGER): INTEGER_64
			-- Number of k-combinations with repetition from n elements
		require
			valid_n: n >= 1
			valid_k: k >= 0
		do
			Result := binomial (n + k - 1, k)
		end

	generate (n, k: INTEGER): ARRAYED_LIST [ARRAY [INTEGER]]
			-- All k-combinations with repetition of integers 1..n
		require
			valid_n: n >= 1
			valid_k: k >= 0
		local
			combo: ARRAY [INTEGER]
		do
			create Result.make (count (n, k).to_integer_32.min (10000))
			if k = 0 then
				create combo.make_empty
				Result.extend (combo)
			else
				create combo.make_filled (1, 1, k)
				generate_recursive (n, k, 1, 1, combo, Result)
			end
		end

	generate_from_strings (items: ARRAY [STRING]; k: INTEGER): ARRAYED_LIST [ARRAY [STRING]]
			-- All k-combinations with repetition from string items
		require
			not_empty: not items.is_empty
			valid_k: k >= 0
		local
			indices: ARRAYED_LIST [ARRAY [INTEGER]]
			combo: ARRAY [STRING]
			i: INTEGER
		do
			indices := generate (items.count, k)
			create Result.make (indices.count)
			across indices as idx loop
				create combo.make_filled ("", 1, k)
				from i := 1 until i > k loop
					combo [i] := items [items.lower + idx [i] - 1]
					i := i + 1
				end
				Result.extend (combo)
			end
		end

feature {NONE} -- Implementation

	generate_recursive (n, k, start, pos: INTEGER; combo: ARRAY [INTEGER]; results: ARRAYED_LIST [ARRAY [INTEGER]])
			-- Generate combinations recursively
		local
			i: INTEGER
			new_combo: ARRAY [INTEGER]
		do
			if pos > k then
				create new_combo.make_from_array (combo)
				results.extend (new_combo)
			else
				from i := start until i > n loop
					combo [pos] := i
					generate_recursive (n, k, i, pos + 1, combo, results)  -- i not i+1 allows repetition
					i := i + 1
				end
			end
		end

	binomial (n, k: INTEGER): INTEGER_64
			-- Binomial coefficient C(n,k)
		require
			valid_n: n >= 0
			valid_k: k >= 0 and k <= n
		local
			i: INTEGER
			num, denom: INTEGER_64
		do
			if k = 0 or k = n then
				Result := 1
			else
				num := 1
				denom := 1
				from i := 0 until i >= k.min (n - k) loop
					num := num * (n - i).to_integer_64
					denom := denom * (i + 1).to_integer_64
					i := i + 1
				end
				Result := num // denom
			end
		end

feature {NONE} -- Helpers

	array_to_str (arr: ARRAY [INTEGER]): STRING
			-- Convert integer array to comma-separated string
		local
			i: INTEGER
		do
			create Result.make (arr.count * 3)
			from i := arr.lower until i > arr.upper loop
				Result.append (arr [i].out)
				if i < arr.upper then
					Result.append (",")
				end
				i := i + 1
			end
		end

feature -- Demo

	demo
			-- Standard Rosetta Code demo
		local
			combos: ARRAYED_LIST [ARRAY [INTEGER]]
		do
			print ("3-combinations with repetition from {1,2,3}:%N")
			print ("Count = " + count (3, 3).out + "%N")
			combos := generate (3, 3)
			across combos as c loop
				print ("  ")
				across c as elem loop
					print (elem.out + " ")
				end
				print ("%N")
			end

			print ("%N2-combinations with repetition from {1,2,3,4,5}:%N")
			print ("Count = " + count (5, 2).out + "%N")
			combos := generate (5, 2)
			across combos as c loop
				print ("  (" + array_to_str (c) + ")%N")
			end
		end

end
