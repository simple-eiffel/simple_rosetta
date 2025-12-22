note
	description: "[
		Rosetta Code: Sorting algorithms/Strand sort
		https://rosettacode.org/wiki/Sorting_algorithms/Strand_sort

		Implement strand sort by repeatedly pulling sorted sublists.
	]"
	author: "Eiffel Solution"
	rosetta_task: "Sorting_algorithms/Strand_sort"

class
	STRAND_SORT

create
	make

feature {NONE} -- Initialization

	make
			-- Demonstrate strand sort.
		local
			arr: ARRAY [INTEGER]
		do
			arr := <<5, 1, 4, 2, 8, 0, 9, 3>>

			print ("Before: ")
			print_array (arr)

			strand_sort (arr)

			print ("After:  ")
			print_array (arr)
		end

feature -- Sorting

	strand_sort (arr: ARRAY [INTEGER])
			-- Sort arr using strand sort algorithm.
		require
			arr_not_void: arr /= Void
		local
			input, output, sublist: ARRAYED_LIST [INTEGER]
			i: INTEGER
		do
			-- Copy to input list
			create input.make (arr.count)
			from i := arr.lower until i > arr.upper loop
				input.extend (arr [i])
				i := i + 1
			end

			create output.make (arr.count)

			-- Extract strands until input empty
			from until input.is_empty loop
				sublist := extract_strand (input)
				merge_into (sublist, output)
			end

			-- Copy back to array
			from i := arr.lower until i > arr.upper loop
				arr [i] := output.i_th (i - arr.lower + 1)
				i := i + 1
			end
		ensure
			sorted: is_sorted (arr)
		end

feature {NONE} -- Implementation

	extract_strand (input: ARRAYED_LIST [INTEGER]): ARRAYED_LIST [INTEGER]
			-- Extract a sorted sublist from input, removing elements.
		local
			i: INTEGER
			last_val: INTEGER
		do
			create Result.make (input.count)

			-- First element always goes in strand
			Result.extend (input.first)
			last_val := input.first
			input.start
			input.remove

			-- Find elements that continue the sorted sequence
			from
				i := 1
			until
				i > input.count
			loop
				if input.i_th (i) >= last_val then
					Result.extend (input.i_th (i))
					last_val := input.i_th (i)
					input.go_i_th (i)
					input.remove
				else
					i := i + 1
				end
			end
		end

	merge_into (sublist: ARRAYED_LIST [INTEGER]; output: ARRAYED_LIST [INTEGER])
			-- Merge sorted sublist into sorted output.
		local
			merged: ARRAYED_LIST [INTEGER]
			i, j: INTEGER
		do
			create merged.make (output.count + sublist.count)
			i := 1
			j := 1

			from until i > output.count and j > sublist.count loop
				if i > output.count then
					merged.extend (sublist.i_th (j))
					j := j + 1
				elseif j > sublist.count then
					merged.extend (output.i_th (i))
					i := i + 1
				elseif output.i_th (i) <= sublist.i_th (j) then
					merged.extend (output.i_th (i))
					i := i + 1
				else
					merged.extend (sublist.i_th (j))
					j := j + 1
				end
			end

			-- Replace output contents
			output.wipe_out
			from i := 1 until i > merged.count loop
				output.extend (merged.i_th (i))
				i := i + 1
			end
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
