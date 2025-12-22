note
	description: "[
		Rosetta Code: Array length
		https://rosettacode.org/wiki/Array_length

		Determine the length of an array.
	]"
	author: "Eiffel Solution"
	rosetta_task: "Array_length"

class
	ARRAY_LENGTH

create
	make

feature {NONE} -- Initialization

	make
			-- Demonstrate array length.
		local
			arr: ARRAY [INTEGER]
			list: ARRAYED_LIST [STRING]
		do
			-- Array with manifest
			arr := <<1, 2, 3, 4, 5>>
			print ("Array: <<1, 2, 3, 4, 5>>%N")
			print ("  count: " + arr.count.out + "%N")
			print ("  lower: " + arr.lower.out + "%N")
			print ("  upper: " + arr.upper.out + "%N")

			-- ARRAYED_LIST
			create list.make (0)
			list.extend ("apple")
			list.extend ("banana")
			list.extend ("cherry")
			print ("%NARRAYED_LIST with 3 items:%N")
			print ("  count: " + list.count.out + "%N")
			print ("  is_empty: " + list.is_empty.out + "%N")

			-- Empty array
			create arr.make_empty
			print ("%NEmpty array:%N")
			print ("  count: " + arr.count.out + "%N")
			print ("  is_empty: " + arr.is_empty.out + "%N")
		end

end
