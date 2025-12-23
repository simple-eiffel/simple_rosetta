note
	description: "[
		Rosetta Code: Combinations
		https://rosettacode.org/wiki/Combinations

		Generate all k-combinations of a set of n elements.
		C(n,k) = n! / (k! * (n-k)!)
	]"

class
	COMBINATIONS

feature -- Query

	combinations_count (n, k: INTEGER): INTEGER_64
			-- Number of k-combinations from n elements: C(n,k)
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
				-- Use smaller of k and n-k to minimize computation
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

	generate_combinations (n, k: INTEGER): ARRAYED_LIST [ARRAY [INTEGER]]
			-- All k-combinations of integers 1..n
		require
			valid_n: n >= 1
			valid_k: k >= 0 and k <= n
		local
			combo: ARRAY [INTEGER]
		do
			create Result.make (combinations_count (n, k).to_integer_32)
			if k = 0 then
				create combo.make_empty
				Result.extend (combo)
			else
				create combo.make_filled (0, 1, k)
				generate_recursive (n, k, 1, 1, combo, Result)
			end
		ensure
			correct_count: Result.count = combinations_count (n, k).to_integer_32
		end

	combinations_of_strings (items: ARRAY [STRING]; k: INTEGER): ARRAYED_LIST [ARRAY [STRING]]
			-- All k-combinations of string items
		require
			not_empty: not items.is_empty
			valid_k: k >= 0 and k <= items.count
		local
			indices: ARRAYED_LIST [ARRAY [INTEGER]]
			combo: ARRAY [STRING]
			i: INTEGER
		do
			indices := generate_combinations (items.count, k)
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
				from i := start until i > n - (k - pos) loop
					combo [pos] := i
					generate_recursive (n, k, i + 1, pos + 1, combo, results)
					i := i + 1
				end
			end
		end

feature -- Demo

	demo
			-- Standard Rosetta Code demo
		local
			combos: ARRAYED_LIST [ARRAY [INTEGER]]
		do
			print ("C(5,3) = " + combinations_count (5, 3).out + " combinations:%N")
			combos := generate_combinations (5, 3)
			across combos as c loop
				print ("  ")
				across c as elem loop
					print (elem.out + " ")
				end
				print ("%N")
			end

			print ("%NC(10,4) = " + combinations_count (10, 4).out + "%N")
			print ("C(20,10) = " + combinations_count (20, 10).out + "%N")
		end

end
