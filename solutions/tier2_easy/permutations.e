note
	description: "[
		Rosetta Code: Permutations
		https://rosettacode.org/wiki/Permutations

		Generate all permutations of a set.
		n! permutations for n elements.
	]"

class
	PERMUTATIONS

feature -- Query

	factorial (n: INTEGER): INTEGER_64
			-- n factorial
		require
			non_negative: n >= 0
		local
			i: INTEGER
		do
			Result := 1
			from i := 2 until i > n loop
				Result := Result * i.to_integer_64
				i := i + 1
			end
		end

	permutation_count (n: INTEGER): INTEGER_64
			-- Number of permutations of n elements
		require
			non_negative: n >= 0
		do
			Result := factorial (n)
		end

	generate_permutations (n: INTEGER): ARRAYED_LIST [ARRAY [INTEGER]]
			-- All permutations of integers 1..n
		require
			valid_n: n >= 0
		local
			arr: ARRAY [INTEGER]
			i: INTEGER
		do
			create Result.make (factorial (n).to_integer_32.min (40320))  -- Max 8!
			if n = 0 then
				create arr.make_empty
				Result.extend (arr)
			else
				create arr.make_filled (0, 1, n)
				from i := 1 until i > n loop
					arr [i] := i
					i := i + 1
				end
				heap_permute (n, arr, Result)
			end
		end

	permutations_of_strings (items: ARRAY [STRING]): ARRAYED_LIST [ARRAY [STRING]]
			-- All permutations of string items
		require
			not_empty: not items.is_empty
		local
			indices: ARRAYED_LIST [ARRAY [INTEGER]]
			perm: ARRAY [STRING]
			i: INTEGER
		do
			indices := generate_permutations (items.count)
			create Result.make (indices.count)
			across indices as idx loop
				create perm.make_filled ("", 1, items.count)
				from i := 1 until i > items.count loop
					perm [i] := items [items.lower + idx [i] - 1]
					i := i + 1
				end
				Result.extend (perm)
			end
		end

feature {NONE} -- Implementation

	heap_permute (n: INTEGER; arr: ARRAY [INTEGER]; results: ARRAYED_LIST [ARRAY [INTEGER]])
			-- Heap's algorithm for generating permutations
		local
			i: INTEGER
			new_arr: ARRAY [INTEGER]
		do
			if n = 1 then
				create new_arr.make_from_array (arr)
				results.extend (new_arr)
			else
				from i := 1 until i > n loop
					heap_permute (n - 1, arr, results)
					if n \\ 2 = 0 then
						swap (arr, i, n)
					else
						swap (arr, 1, n)
					end
					i := i + 1
				end
			end
		end

	swap (arr: ARRAY [INTEGER]; i, j: INTEGER)
			-- Swap elements at positions i and j
		require
			valid_i: arr.valid_index (i)
			valid_j: arr.valid_index (j)
		local
			temp: INTEGER
		do
			temp := arr [i]
			arr [i] := arr [j]
			arr [j] := temp
		end

feature -- Demo

	demo
			-- Standard Rosetta Code demo
		local
			perms: ARRAYED_LIST [ARRAY [INTEGER]]
		do
			print ("Permutations of {1, 2, 3}:%N")
			print ("Count = " + permutation_count (3).out + "%N")
			perms := generate_permutations (3)
			across perms as p loop
				print ("  ")
				across p as elem loop
					print (elem.out + " ")
				end
				print ("%N")
			end

			print ("%N4! = " + factorial (4).out + "%N")
			print ("5! = " + factorial (5).out + "%N")
			print ("10! = " + factorial (10).out + "%N")
		end

end
