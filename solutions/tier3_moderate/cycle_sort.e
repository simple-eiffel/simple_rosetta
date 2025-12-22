note
	description: "[
		Rosetta Code: Sorting algorithms/Cycle sort
		https://rosettacode.org/wiki/Sorting_algorithms/Cycle_sort

		Implement cycle sort - an in-place, unstable sorting algorithm.
	]"
	author: "Eiffel Solution"
	rosetta_task: "Sorting_algorithms/Cycle_sort"

class
	CYCLE_SORT

create
	make

feature {NONE} -- Initialization

	make
			-- Demonstrate cycle sort.
		local
			arr: ARRAY [INTEGER]
			writes: INTEGER
		do
			arr := <<5, 1, 4, 2, 8, 0, 2>>

			print ("Before: ")
			print_array (arr)

			writes := cycle_sort (arr)

			print ("After:  ")
			print_array (arr)
			print ("Writes: " + writes.out + "%N")
		end

feature -- Sorting

	cycle_sort (arr: ARRAY [INTEGER]): INTEGER
			-- Sort arr using cycle sort. Return number of writes.
		require
			arr_not_void: arr /= Void
		local
			cycle_start, pos, i: INTEGER
			item, temp: INTEGER
		do
			-- Loop through array to find cycles
			from cycle_start := arr.lower until cycle_start > arr.upper - 1 loop
				item := arr [cycle_start]

				-- Find where to put the item
				pos := cycle_start
				from i := cycle_start + 1 until i > arr.upper loop
					if arr [i] < item then
						pos := pos + 1
					end
					i := i + 1
				end

				-- If item is already there, not a cycle
				if pos /= cycle_start then
					-- Skip duplicates
					from until arr [pos] /= item loop
						pos := pos + 1
					end

					-- Put item to its right position
					temp := arr [pos]
					arr [pos] := item
					item := temp
					Result := Result + 1

					-- Rotate the rest of the cycle
					from until pos = cycle_start loop
						pos := cycle_start
						from i := cycle_start + 1 until i > arr.upper loop
							if arr [i] < item then
								pos := pos + 1
							end
							i := i + 1
						end

						from until arr [pos] /= item loop
							pos := pos + 1
						end

						temp := arr [pos]
						arr [pos] := item
						item := temp
						Result := Result + 1
					end
				end

				cycle_start := cycle_start + 1
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
