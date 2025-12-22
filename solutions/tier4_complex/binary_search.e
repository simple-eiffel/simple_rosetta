note
	description: "[
		Rosetta Code: Binary search
		https://rosettacode.org/wiki/Binary_search

		Search for a value in a sorted array using binary search.
	]"
	author: "Eiffel Solution"
	rosetta_task: "Binary_search"

class
	BINARY_SEARCH

create
	make

feature {NONE} -- Initialization

	make
			-- Demonstrate binary search.
		local
			arr: ARRAY [INTEGER]
			idx: INTEGER
		do
			print ("Binary Search Algorithm%N")
			print ("=======================%N%N")

			arr := <<2, 5, 8, 12, 16, 23, 38, 56, 72, 91>>

			print ("Array: ")
			print_array (arr)
			print ("%N")

			-- Search for various values
			search_and_print (arr, 23)
			search_and_print (arr, 2)
			search_and_print (arr, 91)
			search_and_print (arr, 50)
			search_and_print (arr, 0)

			-- Recursive version
			print ("%NUsing recursive binary search:%N")
			idx := binary_search_recursive (arr, 38, arr.lower, arr.upper)
			if idx > 0 then
				print ("  Found 38 at index " + idx.out + "%N")
			end
		end

feature -- Search

	binary_search (arr: ARRAY [INTEGER]; target: INTEGER): INTEGER
			-- Find index of target in sorted arr, or -1 if not found.
			-- Iterative implementation.
		require
			sorted: is_sorted (arr)
		local
			low, high, mid: INTEGER
		do
			Result := -1
			low := arr.lower
			high := arr.upper

			from until low > high or Result > 0 loop
				mid := (low + high) // 2
				if arr [mid] = target then
					Result := mid
				elseif arr [mid] < target then
					low := mid + 1
				else
					high := mid - 1
				end
			end
		ensure
			found_correct: Result > 0 implies arr [Result] = target
			not_found_absent: Result < 0 implies not arr.has (target)
		end

	binary_search_recursive (arr: ARRAY [INTEGER]; target, low, high: INTEGER): INTEGER
			-- Find index of target in sorted arr[low..high], or -1 if not found.
			-- Recursive implementation.
		require
			sorted: is_sorted (arr)
			valid_bounds: low >= arr.lower and high <= arr.upper
		local
			mid: INTEGER
		do
			if low > high then
				Result := -1
			else
				mid := (low + high) // 2
				if arr [mid] = target then
					Result := mid
				elseif arr [mid] < target then
					Result := binary_search_recursive (arr, target, mid + 1, high)
				else
					Result := binary_search_recursive (arr, target, low, mid - 1)
				end
			end
		end

	lower_bound (arr: ARRAY [INTEGER]; target: INTEGER): INTEGER
			-- Index of first element >= target, or upper + 1 if all elements < target.
		require
			sorted: is_sorted (arr)
		local
			low, high, mid: INTEGER
		do
			low := arr.lower
			high := arr.upper + 1

			from until low >= high loop
				mid := (low + high) // 2
				if arr [mid] < target then
					low := mid + 1
				else
					high := mid
				end
			end
			Result := low
		end

feature -- Helpers

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

	search_and_print (arr: ARRAY [INTEGER]; target: INTEGER)
		local
			idx: INTEGER
		do
			idx := binary_search (arr, target)
			print ("Search for " + target.out + ": ")
			if idx > 0 then
				print ("Found at index " + idx.out + "%N")
			else
				print ("Not found%N")
			end
		end

	print_array (arr: ARRAY [INTEGER])
		local
			i: INTEGER
		do
			from i := arr.lower until i > arr.upper loop
				print (arr [i].out)
				if i < arr.upper then print (", ") end
				i := i + 1
			end
		end

end
