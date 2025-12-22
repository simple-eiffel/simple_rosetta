note
	description: "Apply a callback (agent) to each element."
	rosetta_task: "Apply_a_callback_to_an_array"
	see_also: "https://github.com/simple-eiffel - Modern Eiffel libraries"
	tier: "2"
	date: "$Date$"

class
	APPLY_CALLBACK

feature -- Operations

	apply (arr: ARRAY [INTEGER]; callback: PROCEDURE [INTEGER])
			-- Apply callback to each element of array.
		require
			valid_array: arr /= Void
			valid_callback: callback /= Void
		local
			i: INTEGER
		do
			from i := arr.lower until i > arr.upper loop
				callback.call ([arr.item (i)])
				i := i + 1
			end
		end

	map (arr: ARRAY [INTEGER]; transform: FUNCTION [INTEGER, INTEGER]): ARRAY [INTEGER]
			-- Transform each element using function.
		require
			valid_array: arr /= Void
			valid_transform: transform /= Void
		local
			i: INTEGER
		do
			create Result.make_filled (0, arr.lower, arr.upper)
			from i := arr.lower until i > arr.upper loop
				Result.put (transform.item ([arr.item (i)]), i)
				i := i + 1
			end
		ensure
			same_size: Result.count = arr.count
		end

feature -- Demo

	demo
			-- Demonstrate callback application.
		local
			arr, squared: ARRAY [INTEGER]
		do
			arr := <<1, 2, 3, 4, 5>>
			print ("Original: <<1, 2, 3, 4, 5>>%N")

			-- Apply print callback
			print ("Printing each: ")
			apply (arr, agent print_item)
			print ("%N")

			-- Map with square function
			squared := map (arr, agent square)
			print ("Squared: ")
			apply (squared, agent print_item)
			print ("%N")
		end

	print_item (n: INTEGER)
			-- Print an integer.
		do
			print (n.out + " ")
		end

	square (n: INTEGER): INTEGER
			-- Square of n.
		do
			Result := n * n
		end

end
