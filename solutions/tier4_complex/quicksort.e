note
	description: "[
		Rosetta Code: Sorting algorithms/Quicksort
		https://rosettacode.org/wiki/Sorting_algorithms/Quicksort

		Implement quicksort with different pivot strategies.
	]"
	author: "Eiffel Solution"
	rosetta_task: "Sorting_algorithms/Quicksort"

class
	QUICKSORT

create
	make

feature {NONE} -- Initialization

	make
			-- Demonstrate quicksort.
		local
			arr: ARRAY [INTEGER]
		do
			print ("Quicksort Algorithm%N")
			print ("==================%N%N")

			arr := <<64, 34, 25, 12, 22, 11, 90, 5, 77, 30>>

			print ("Before: ")
			print_array (arr)

			quicksort (arr, arr.lower, arr.upper)

			print ("After:  ")
			print_array (arr)

			-- Test with another array
			arr := <<5, 1, 4, 2, 8, 0, 2, 9, 3, 7, 6>>
			print ("%NBefore: ")
			print_array (arr)

			quicksort (arr, arr.lower, arr.upper)

			print ("After:  ")
			print_array (arr)
		end

feature -- Sorting

	quicksort (arr: ARRAY [INTEGER]; low, high: INTEGER)
			-- Sort arr[low..high] using quicksort.
		require
			valid_bounds: low <= high implies (arr.valid_index (low) and arr.valid_index (high))
		local
			pivot_index: INTEGER
		do
			if low < high then
				pivot_index := partition (arr, low, high)
				quicksort (arr, low, pivot_index - 1)
				quicksort (arr, pivot_index + 1, high)
			end
		ensure
			sorted: low < high implies is_sorted_range (arr, low, high)
		end

feature {NONE} -- Implementation

	partition (arr: ARRAY [INTEGER]; low, high: INTEGER): INTEGER
			-- Partition arr around pivot, return pivot's final position.
			-- Uses last element as pivot (Lomuto partition scheme).
		local
			pivot: INTEGER
			i, j: INTEGER
		do
			pivot := arr [high]
			i := low - 1

			from j := low until j >= high loop
				if arr [j] <= pivot then
					i := i + 1
					swap (arr, i, j)
				end
				j := j + 1
			end

			swap (arr, i + 1, high)
			Result := i + 1
		end

	swap (arr: ARRAY [INTEGER]; i, j: INTEGER)
			-- Swap elements at positions i and j.
		require
			valid_i: arr.valid_index (i)
			valid_j: arr.valid_index (j)
		local
			temp: INTEGER
		do
			temp := arr [i]
			arr [i] := arr [j]
			arr [j] := temp
		ensure
			swapped_i: arr [i] = old arr [j]
			swapped_j: arr [j] = old arr [i]
		end

feature {NONE} -- Validation

	is_sorted_range (arr: ARRAY [INTEGER]; low, high: INTEGER): BOOLEAN
			-- Is arr sorted in range [low, high]?
		local
			i: INTEGER
		do
			Result := True
			from i := low until i >= high or not Result loop
				if arr [i] > arr [i + 1] then
					Result := False
				end
				i := i + 1
			end
		end

feature {NONE} -- Output

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
