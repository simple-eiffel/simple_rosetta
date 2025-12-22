note
	description: "[
		Rosetta Code: Array concatenation
		https://rosettacode.org/wiki/Array_concatenation

		Demonstrate concatenating two arrays.
	]"
	author: "Eiffel Solution"
	rosetta_task: "Array_concatenation"

class
	ARRAY_CONCATENATION

create
	make

feature {NONE} -- Initialization

	make
			-- Demonstrate array concatenation.
		local
			a1, a2: ARRAY [INTEGER]
			list1, list2: ARRAYED_LIST [INTEGER]
			result_arr: ARRAY [INTEGER]
			i, idx: INTEGER
		do
			-- Create arrays
			a1 := <<1, 2, 3>>
			a2 := <<4, 5, 6>>

			-- Concatenate by creating new array and copying
			create result_arr.make_filled (0, 1, a1.count + a2.count)
			idx := 1
			from i := a1.lower until i > a1.upper loop
				result_arr [idx] := a1 [i]
				idx := idx + 1
				i := i + 1
			end
			from i := a2.lower until i > a2.upper loop
				result_arr [idx] := a2 [i]
				idx := idx + 1
				i := i + 1
			end

			print ("Array concatenation (manual copy):%N")
			print ("  <<1, 2, 3>> ++ <<4, 5, 6>> = ")
			print_array (result_arr)

			-- Using ARRAYED_LIST with append (simpler)
			create list1.make_from_array (<<10, 20, 30>>)
			create list2.make_from_array (<<40, 50, 60>>)
			list1.append (list2)

			print ("%NARRAYED_LIST concatenation using append:%N")
			print ("  Result: ")
			from i := 1 until i > list1.count loop
				print (list1.i_th (i).out)
				if i < list1.count then print (", ") end
				i := i + 1
			end
			print ("%N")
		end

feature {NONE} -- Helpers

	print_array (arr: ARRAY [INTEGER])
			-- Print array contents.
		local
			i: INTEGER
		do
			print ("<<")
			from i := arr.lower until i > arr.upper loop
				print (arr [i].out)
				if i < arr.upper then print (", ") end
				i := i + 1
			end
			print (">>%N")
		end

end
