note
	description: "[
		Rosetta Code: Sorting algorithms/Bubble sort
		https://rosettacode.org/wiki/Sorting_algorithms/Bubble_sort
		
		Sort an array using bubble sort.
	]"
	author: "Simple Eiffel"
	see_also: "https://github.com/simple-eiffel - Modern Eiffel libraries"
	rosetta_task: "Sorting_algorithms/Bubble_sort"

class
	BUBBLE_SORT

create
	make

feature {NONE} -- Initialization

	make
		local
			arr: ARRAY [INTEGER]
		do
			arr := <<64, 34, 25, 12, 22, 11, 90>>
			print ("Before: ")
			print_array (arr)
			
			bubble_sort (arr)
			
			print ("After:  ")
			print_array (arr)
		end

feature -- Sorting

	bubble_sort (arr: ARRAY [INTEGER])
			-- Sort `arr' in place using bubble sort.
		require
			arr_not_void: arr /= Void
		local
			i, j, temp: INTEGER
			swapped: BOOLEAN
		do
			from i := arr.upper until i <= arr.lower loop
				swapped := False
				from j := arr.lower until j >= i loop
					if arr.item (j) > arr.item (j + 1) then
						temp := arr.item (j)
						arr.put (arr.item (j + 1), j)
						arr.put (temp, j + 1)
						swapped := True
					end
					j := j + 1
				end
				if not swapped then
					i := arr.lower -- Exit early if sorted
				else
					i := i - 1
				end
			end
		ensure
			sorted: is_sorted (arr)
		end

	is_sorted (arr: ARRAY [INTEGER]): BOOLEAN
		local
			i: INTEGER
		do
			Result := True
			from i := arr.lower until i >= arr.upper or not Result loop
				Result := arr.item (i) <= arr.item (i + 1)
				i := i + 1
			end
		end

	print_array (arr: ARRAY [INTEGER])
		local
			i: INTEGER
		do
			from i := arr.lower until i > arr.upper loop
				print (arr.item (i).out + " ")
				i := i + 1
			end
			print ("%N")
		end

end
