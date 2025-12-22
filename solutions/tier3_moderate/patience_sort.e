note
	description: "[
		Rosetta Code: Sorting algorithms/Patience sort
		https://rosettacode.org/wiki/Sorting_algorithms/Patience_sort

		Implement patience sort using piles like the card game.
	]"
	author: "Eiffel Solution"
	rosetta_task: "Sorting_algorithms/Patience_sort"

class
	PATIENCE_SORT

create
	make

feature {NONE} -- Initialization

	make
			-- Demonstrate patience sort.
		local
			arr: ARRAY [INTEGER]
		do
			arr := <<4, 65, 2, -31, 0, 99, 83, 782, 1>>

			print ("Before: ")
			print_array (arr)

			patience_sort (arr)

			print ("After:  ")
			print_array (arr)
		end

feature -- Sorting

	patience_sort (arr: ARRAY [INTEGER])
			-- Sort arr using patience sort algorithm.
		require
			arr_not_void: arr /= Void
		local
			piles: ARRAYED_LIST [ARRAYED_LIST [INTEGER]]
			pile: ARRAYED_LIST [INTEGER]
			new_pile: ARRAYED_LIST [INTEGER]
			i, j, val, min_idx, min_val: INTEGER
			placed: BOOLEAN
		do
			if arr.count <= 1 then
				-- Already sorted
			else
				-- Create piles
				create piles.make (arr.count)

				-- Place each element on appropriate pile
				from i := arr.lower until i > arr.upper loop
					val := arr [i]
					placed := False

					-- Find leftmost pile with top >= val
					from j := 1 until j > piles.count or placed loop
						pile := piles.i_th (j)
						if pile.last >= val then
							pile.extend (val)
							placed := True
						end
						j := j + 1
					end

					-- No suitable pile found, create new one
					if not placed then
						create new_pile.make (10)
						new_pile.extend (val)
						piles.extend (new_pile)
					end

					i := i + 1
				end

				-- Merge piles back (take minimum from pile tops)
				from i := arr.lower until i > arr.upper loop
					min_val := {INTEGER}.max_value
					min_idx := 0

					-- Find pile with smallest top
					from j := 1 until j > piles.count loop
						pile := piles.i_th (j)
						if not pile.is_empty and then pile.last < min_val then
							min_val := pile.last
							min_idx := j
						end
						j := j + 1
					end

					-- Take from that pile
					if min_idx > 0 then
						arr [i] := min_val
						piles.i_th (min_idx).finish
						piles.i_th (min_idx).remove
					end

					i := i + 1
				end
			end
		ensure
			sorted: is_sorted (arr)
		end

feature {NONE} -- Helpers

	is_sorted (arr: ARRAY [INTEGER]): BOOLEAN
		local
			i: INTEGER
		do
			Result := True
			from i := arr.lower until i >= arr.upper or not Result loop
				if arr [i] > arr [i + 1] then
					Result := False
				end
				i := i + 1
			end
		end

	print_array (arr: ARRAY [INTEGER])
		local
			i: INTEGER
		do
			from i := arr.lower until i > arr.upper loop
				print (arr [i].out)
				if i < arr.upper then print (" ") end
				i := i + 1
			end
			print ("%N")
		end

end
