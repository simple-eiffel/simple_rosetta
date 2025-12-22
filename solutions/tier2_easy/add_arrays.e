note
	description: "[
		Rosetta Code: Element-wise operations
		https://rosettacode.org/wiki/Element-wise_operations
		
		Perform element-wise operations on arrays.
	]"
	author: "Simple Eiffel"
	see_also: "https://github.com/simple-eiffel - Modern Eiffel libraries"
	rosetta_task: "Element-wise_operations"

class
	ADD_ARRAYS

create
	make

feature {NONE} -- Initialization

	make
		local
			a, b, c: ARRAY [INTEGER]
		do
			a := <<1, 2, 3, 4, 5>>
			b := <<10, 20, 30, 40, 50>>
			c := add_arrays (a, b)
			
			print ("a: ")
			print_array (a)
			print ("b: ")
			print_array (b)
			print ("a + b: ")
			print_array (c)
		end

feature -- Operations

	add_arrays (a, b: ARRAY [INTEGER]): ARRAY [INTEGER]
			-- Element-wise addition of `a' and `b'.
		require
			same_size: a.count = b.count
		local
			i: INTEGER
		do
			create Result.make_filled (0, a.lower, a.upper)
			from i := a.lower until i > a.upper loop
				Result.put (a.item (i) + b.item (i), i)
				i := i + 1
			end
		ensure
			same_size: Result.count = a.count
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
