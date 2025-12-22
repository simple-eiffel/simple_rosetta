note
	description: "[
		Rosetta Code: Sorting algorithms/Merge sort
		https://rosettacode.org/wiki/Sorting_algorithms/Merge_sort

		Implement merge sort - a stable, divide-and-conquer sorting algorithm.
	]"
	author: "Eiffel Solution"
	rosetta_task: "Sorting_algorithms/Merge_sort"

class
	MERGESORT

create
	make

feature {NONE} -- Initialization

	make
			-- Demonstrate merge sort.
		local
			arr: ARRAY [INTEGER]
		do
			print ("Merge Sort Algorithm%N")
			print ("====================%N%N")

			arr := <<38, 27, 43, 3, 9, 82, 10>>

			print ("Before: ")
			print_array (arr)

			merge_sort (arr)

			print ("After:  ")
			print_array (arr)

			-- Test stability with another array
			arr := <<5, 2, 4, 6, 1, 3, 2, 6>>
			print ("%NBefore: ")
			print_array (arr)

			merge_sort (arr)

			print ("After:  ")
			print_array (arr)
		end

feature -- Sorting

	merge_sort (arr: ARRAY [INTEGER])
			-- Sort arr using merge sort algorithm.
		require
			arr_not_void: arr /= Void
		local
			temp: ARRAY [INTEGER]
		do
			if arr.count > 1 then
				create temp.make_filled (0, arr.lower, arr.upper)
				merge_sort_recursive (arr, temp, arr.lower, arr.upper)
			end
		ensure
			sorted: is_sorted (arr)
		end

feature {NONE} -- Implementation

	merge_sort_recursive (arr, temp: ARRAY [INTEGER]; left, right: INTEGER)
			-- Recursively sort arr[left..right].
		local
			mid: INTEGER
		do
			if left < right then
				mid := (left + right) // 2
				merge_sort_recursive (arr, temp, left, mid)
				merge_sort_recursive (arr, temp, mid + 1, right)
				merge (arr, temp, left, mid, right)
			end
		end

	merge (arr, temp: ARRAY [INTEGER]; left, mid, right: INTEGER)
			-- Merge two sorted subarrays arr[left..mid] and arr[mid+1..right].
		local
			i, j, k: INTEGER
		do
			-- Copy to temp
			from i := left until i > right loop
				temp [i] := arr [i]
				i := i + 1
			end

			-- Merge back
			i := left
			j := mid + 1
			k := left

			from until i > mid or j > right loop
				if temp [i] <= temp [j] then
					arr [k] := temp [i]
					i := i + 1
				else
					arr [k] := temp [j]
					j := j + 1
				end
				k := k + 1
			end

			-- Copy remaining from left half
			from until i > mid loop
				arr [k] := temp [i]
				i := i + 1
				k := k + 1
			end

			-- Right half remaining elements are already in place
		end

feature {NONE} -- Validation

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
