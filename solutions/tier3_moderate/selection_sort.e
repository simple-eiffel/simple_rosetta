note
	description: "[
		Rosetta Code: Sorting algorithms/Selection sort
		https://rosettacode.org/wiki/Sorting_algorithms/Selection_sort
		
		Sort an array using selection sort.
	]"
	author: "Simple Eiffel"
	see_also: "https://github.com/simple-eiffel - Modern Eiffel libraries"
	rosetta_task: "Sorting_algorithms/Selection_sort"

class
	SELECTION_SORT

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
			
			selection_sort (arr)
			
			print ("After:  ")
			print_array (arr)
		end

feature -- Sorting

	selection_sort (arr: ARRAY [INTEGER])
			-- Sort `arr' in place using selection sort.
		require
			arr_not_void: arr /= Void
		local
			i, j, min_idx, temp: INTEGER
		do
			from i := arr.lower until i >= arr.upper loop
				min_idx := i
				from j := i + 1 until j > arr.upper loop
					if arr.item (j) < arr.item (min_idx) then
						min_idx := j
					end
					j := j + 1
				end
				if min_idx /= i then
					temp := arr.item (i)
					arr.put (arr.item (min_idx), i)
					arr.put (temp, min_idx)
				end
				i := i + 1
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
