note
	description: "[
		Rosetta Code: Sorting algorithms/Cocktail sort with shifting bounds
		https://rosettacode.org/wiki/Sorting_algorithms/Cocktail_sort_with_shifting_bounds

		Implement cocktail sort with optimization for shifting bounds.
	]"
	author: "Eiffel Solution"
	rosetta_task: "Sorting_algorithms/Cocktail_sort_with_shifting_bounds"

class
	COCKTAIL_SORT

create
	make

feature {NONE} -- Initialization

	make
			-- Demonstrate cocktail sort.
		local
			arr: ARRAY [INTEGER]
		do
			arr := <<5, 1, 4, 2, 8, 0, 2>>

			print ("Before: ")
			print_array (arr)

			cocktail_sort (arr)

			print ("After:  ")
			print_array (arr)
		end

feature -- Sorting

	cocktail_sort (arr: ARRAY [INTEGER])
			-- Sort arr using cocktail sort with shifting bounds.
		require
			arr_not_void: arr /= Void
		local
			left, right, i, last_swap: INTEGER
			swapped: BOOLEAN
			temp: INTEGER
		do
			left := arr.lower
			right := arr.upper

			from
				swapped := True
			until
				not swapped
			loop
				swapped := False

				-- Forward pass (left to right)
				last_swap := left
				from i := left until i >= right loop
					if arr [i] > arr [i + 1] then
						temp := arr [i]
						arr [i] := arr [i + 1]
						arr [i + 1] := temp
						swapped := True
						last_swap := i
					end
					i := i + 1
				end
				right := last_swap

				if swapped then
					swapped := False

					-- Backward pass (right to left)
					last_swap := right
					from i := right until i <= left loop
						if arr [i - 1] > arr [i] then
							temp := arr [i]
							arr [i] := arr [i - 1]
							arr [i - 1] := temp
							swapped := True
							last_swap := i
						end
						i := i - 1
					end
					left := last_swap
				end
			end
		ensure
			sorted: is_sorted (arr)
		end

feature {NONE} -- Helpers

	is_sorted (arr: ARRAY [INTEGER]): BOOLEAN
			-- Is arr sorted in ascending order?
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
