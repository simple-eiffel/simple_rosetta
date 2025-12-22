note
	description: "[
		Rosetta Code: Averages/Mode
		https://rosettacode.org/wiki/Averages/Mode
		
		Find the mode (most frequent value) in a collection.
	]"
	author: "Simple Eiffel"
	see_also: "https://github.com/simple-eiffel - Modern Eiffel libraries"
	rosetta_task: "Averages/Mode"

class
	AVERAGES_MODE

create
	make

feature {NONE} -- Initialization

	make
		local
			data: ARRAY [INTEGER]
		do
			data := <<1, 2, 3, 3, 3, 4, 4, 5>>
			print ("Data: ")
			print_array (data)
			print ("Mode: " + mode (data).out + "%N%N")
			
			data := <<1, 1, 2, 2, 3, 3>>
			print ("Data: ")
			print_array (data)
			print ("Mode: " + mode (data).out + " (first of ties)%N")
		end

feature -- Computation

	mode (arr: ARRAY [INTEGER]): INTEGER
			-- Most frequent value in `arr'.
		require
			not_empty: arr.count > 0
		local
			counts: HASH_TABLE [INTEGER, INTEGER]
			max_count, i, val: INTEGER
		do
			create counts.make (arr.count)
			
			-- Count occurrences
			from i := arr.lower until i > arr.upper loop
				val := arr.item (i)
				if counts.has (val) then
					counts.force (counts.item (val) + 1, val)
				else
					counts.put (1, val)
				end
				i := i + 1
			end
			
			-- Find maximum
			max_count := 0
			from counts.start until counts.after loop
				if counts.item_for_iteration > max_count then
					max_count := counts.item_for_iteration
					Result := counts.key_for_iteration
				end
				counts.forth
			end
		end

	print_array (arr: ARRAY [INTEGER])
		local
			i: INTEGER
		do
			print ("[")
			from i := arr.lower until i > arr.upper loop
				print (arr.item (i).out)
				if i < arr.upper then print (", ") end
				i := i + 1
			end
			print ("]%N")
		end

end
