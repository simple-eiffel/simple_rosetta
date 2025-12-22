note
	description: "[
		Rosetta Code: Least element of a list
		https://rosettacode.org/wiki/Least_element_of_a_list
		
		Find the minimum element in a list.
	]"
	author: "Simple Eiffel"
	see_also: "https://github.com/simple-eiffel - Modern Eiffel libraries"
	rosetta_task: "Least_element_of_a_list"

class
	MINIMUM

create
	make

feature {NONE} -- Initialization

	make
		local
			arr: ARRAY [INTEGER]
		do
			arr := <<3, 1, 4, 1, 5, 9, 2, 6, 5>>
			print ("Array: ")
			print_array (arr)
			print ("Minimum: " + minimum (arr).out + "%N")
		end

feature -- Computation

	minimum (arr: ARRAY [INTEGER]): INTEGER
			-- Return the minimum value in `arr'.
		require
			not_empty: arr.count > 0
		local
			i: INTEGER
		do
			Result := arr.item (arr.lower)
			from i := arr.lower + 1 until i > arr.upper loop
				if arr.item (i) < Result then
					Result := arr.item (i)
				end
				i := i + 1
			end
		ensure
			is_minimum: across arr as elem all elem.item >= Result end
			in_array: across arr as elem some elem.item = Result end
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
