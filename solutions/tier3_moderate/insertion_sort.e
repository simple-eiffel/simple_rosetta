note
	description: "[
		Rosetta Code: Sorting algorithms/Insertion sort
		https://rosettacode.org/wiki/Sorting_algorithms/Insertion_sort
		
		Sort an array using insertion sort.
	]"
	author: "Simple Eiffel"
	see_also: "https://github.com/simple-eiffel - Modern Eiffel libraries"
	rosetta_task: "Sorting_algorithms/Insertion_sort"

class
	INSERTION_SORT

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
			
			insertion_sort (arr)
			
			print ("After:  ")
			print_array (arr)
		end

feature -- Sorting

	insertion_sort (arr: ARRAY [INTEGER])
			-- Sort `arr' in place using insertion sort.
		require
			arr_not_void: arr /= Void
		local
			i, j, key: INTEGER
		do
			from i := arr.lower + 1 until i > arr.upper loop
				key := arr.item (i)
				j := i - 1
				from until j < arr.lower or else arr.item (j) <= key loop
					arr.put (arr.item (j), j + 1)
					j := j - 1
				end
				arr.put (key, j + 1)
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
