note
	description: "[
		Rosetta Code: Averages/Median
		https://rosettacode.org/wiki/Averages/Median

		Calculate the median of a set of numbers.
	]"
	author: "Eiffel Solution"
	rosetta_task: "Averages/Median"

class
	MEDIAN

create
	make

feature {NONE} -- Initialization

	make
			-- Demonstrate median calculation.
		local
			odd_count, even_count: ARRAY [REAL_64]
		do
			-- Odd number of elements
			odd_count := <<1.0, 5.0, 2.0, 8.0, 7.0>>
			print ("Odd count: ")
			print_array (odd_count)
			print ("Median: " + median (odd_count).out + "%N")

			-- Even number of elements
			even_count := <<1.0, 5.0, 2.0, 8.0, 7.0, 9.0>>
			print ("%NEven count: ")
			print_array (even_count)
			print ("Median: " + median (even_count).out + "%N")
		end

feature -- Calculation

	median (arr: ARRAY [REAL_64]): REAL_64
			-- Calculate median of arr.
		require
			not_empty: not arr.is_empty
		local
			sorted: ARRAYED_LIST [REAL_64]
			mid: INTEGER
			i: INTEGER
		do
			-- Copy to sortable list
			create sorted.make (arr.count)
			from i := arr.lower until i > arr.upper loop
				sorted.extend (arr [i])
				i := i + 1
			end

			-- Sort using insertion sort
			sort (sorted)

			-- Find median
			mid := sorted.count // 2
			if sorted.count \\ 2 = 1 then
				-- Odd count: middle element
				Result := sorted [mid + 1]
			else
				-- Even count: average of two middle elements
				Result := (sorted [mid] + sorted [mid + 1]) / 2.0
			end
		end

feature {NONE} -- Sorting

	sort (list: ARRAYED_LIST [REAL_64])
			-- Sort list in place using insertion sort.
		local
			i, j: INTEGER
			key: REAL_64
		do
			from i := 2 until i > list.count loop
				key := list [i]
				from j := i - 1 until j < 1 or else list [j] <= key loop
					list [j + 1] := list [j]
					j := j - 1
				end
				list [j + 1] := key
				i := i + 1
			end
		end

feature {NONE} -- Helpers

	print_array (arr: ARRAY [REAL_64])
		local
			i: INTEGER
		do
			from i := arr.lower until i > arr.upper loop
				print (arr [i].out)
				if i < arr.upper then print (", ") end
				i := i + 1
			end
			print ("%N")
		end

end
