note
	description: "[
		Rosetta Code: Cartesian product of two or more lists
		https://rosettacode.org/wiki/Cartesian_product_of_two_or_more_lists

		Generate the Cartesian product of lists.
		{1,2} × {3,4} = {(1,3), (1,4), (2,3), (2,4)}
	]"

class
	CARTESIAN_PRODUCT

feature -- Binary Product

	product_integers (a, b: ARRAY [INTEGER]): ARRAYED_LIST [TUPLE [first, second: INTEGER]]
			-- Cartesian product of two integer arrays
		require
			not_empty_a: not a.is_empty
			not_empty_b: not b.is_empty
		do
			create Result.make (a.count * b.count)
			across a as x loop
				across b as y loop
					Result.extend ([x, y])
				end
			end
		ensure
			correct_count: Result.count = a.count * b.count
		end

	product_strings (a, b: ARRAY [STRING]): ARRAYED_LIST [TUPLE [first, second: STRING]]
			-- Cartesian product of two string arrays
		require
			not_empty_a: not a.is_empty
			not_empty_b: not b.is_empty
		do
			create Result.make (a.count * b.count)
			across a as x loop
				across b as y loop
					Result.extend ([x, y])
				end
			end
		ensure
			correct_count: Result.count = a.count * b.count
		end

feature -- N-ary Product

	product_n (lists: ARRAY [ARRAY [INTEGER]]): ARRAYED_LIST [ARRAY [INTEGER]]
			-- Cartesian product of multiple integer arrays
		require
			not_empty: not lists.is_empty
			all_not_empty: across lists as l all not l.is_empty end
		local
			total, i: INTEGER
			indices: ARRAY [INTEGER]
		do
			-- Calculate total product size
			total := 1
			across lists as l loop
				total := total * l.count
			end

			create Result.make ((total).min (10000))  -- Limit for memory
			create indices.make_filled (1, 1, lists.count)

			from until Result.count >= total loop
				Result.extend (current_tuple (lists, indices))
				increment_indices (lists, indices)
			end
		end

feature {NONE} -- Implementation

	current_tuple (lists: ARRAY [ARRAY [INTEGER]]; indices: ARRAY [INTEGER]): ARRAY [INTEGER]
			-- Current tuple based on indices
		local
			i: INTEGER
		do
			create Result.make_filled (0, 1, lists.count)
			from i := 1 until i > lists.count loop
				Result [i] := lists [i] [indices [i]]
				i := i + 1
			end
		end

	increment_indices (lists: ARRAY [ARRAY [INTEGER]]; indices: ARRAY [INTEGER])
			-- Increment indices like an odometer
		local
			i: INTEGER
			carry: BOOLEAN
		do
			carry := True
			from i := lists.count until i < 1 or not carry loop
				indices [i] := indices [i] + 1
				if indices [i] > lists [i].count then
					indices [i] := 1
					carry := True
				else
					carry := False
				end
				i := i - 1
			end
		end

	tuple_to_string (arr: ARRAY [INTEGER]): STRING
			-- Convert integer array to comma-separated string
		local
			i: INTEGER
		do
			create Result.make (20)
			from i := arr.lower until i > arr.upper loop
				Result.append (arr [i].out)
				if i < arr.upper then
					Result.append (", ")
				end
				i := i + 1
			end
		end

feature -- Demo

	demo
			-- Standard Rosetta Code demo
		local
			a, b, c: ARRAY [INTEGER]
			result2: ARRAYED_LIST [TUPLE [first, second: INTEGER]]
			result_n: ARRAYED_LIST [ARRAY [INTEGER]]
			lists: ARRAY [ARRAY [INTEGER]]
		do
			a := <<1, 2>>
			b := <<3, 4>>

			print ("{1,2} × {3,4}:%N")
			result2 := product_integers (a, b)
			across result2 as t loop
				print ("  (" + t.first.out + ", " + t.second.out + ")%N")
			end

			print ("%N{1,2} × {3,4,5} × {6}:%N")
			c := <<6>>
			b := <<3, 4, 5>>
			lists := <<a, b, c>>
			result_n := product_n (lists)
			across result_n as tuple loop
				print ("  (" + tuple_to_string (tuple) + ")%N")
			end

			print ("%N{} × {1,2} (empty set):%N")
			print ("  (empty - Cartesian product with empty set is empty)%N")
		end

end
