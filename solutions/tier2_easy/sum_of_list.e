note
	description: "[
		Rosetta Code: Sum of a list
		https://rosettacode.org/wiki/Sum_and_product_of_an_array
		
		Calculate the sum of elements in a list.
	]"
	author: "Simple Eiffel"
	see_also: "https://github.com/simple-eiffel - Modern Eiffel libraries"
	rosetta_task: "Sum_and_product_of_an_array"

class
	SUM_OF_LIST

create
	make

feature {NONE} -- Initialization

	make
		local
			arr: ARRAY [INTEGER]
		do
			arr := <<1, 2, 3, 4, 5, 6, 7, 8, 9, 10>>
			print ("Array: ")
			print_array (arr)
			print ("Sum: " + sum (arr).out + "%N")
			print ("Product: " + product (arr).out + "%N")
		end

feature -- Computation

	sum (arr: ARRAY [INTEGER]): INTEGER_64
			-- Return the sum of all elements in `arr'.
		local
			i: INTEGER
		do
			from i := arr.lower until i > arr.upper loop
				Result := Result + arr.item (i)
				i := i + 1
			end
		end

	product (arr: ARRAY [INTEGER]): INTEGER_64
			-- Return the product of all elements in `arr'.
		require
			not_empty: arr.count > 0
		local
			i: INTEGER
		do
			Result := 1
			from i := arr.lower until i > arr.upper loop
				Result := Result * arr.item (i)
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
