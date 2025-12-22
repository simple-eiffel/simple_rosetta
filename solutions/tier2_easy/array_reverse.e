note
	description: "[
		Rosetta Code: Reverse a list
		https://rosettacode.org/wiki/Reverse_a_list
		
		Reverse the elements of a list.
	]"
	author: "Simple Eiffel"
	see_also: "https://github.com/simple-eiffel - Modern Eiffel libraries"
	rosetta_task: "Reverse_a_list"

class
	ARRAY_REVERSE

create
	make

feature {NONE} -- Initialization

	make
		local
			arr: ARRAYED_LIST [INTEGER]
		do
			create arr.make_from_array (<<1, 2, 3, 4, 5>>)
			print ("Original: ")
			print_list (arr)
			
			reverse_list (arr)
			
			print ("Reversed: ")
			print_list (arr)
		end

feature -- Operations

	reverse_list (list: ARRAYED_LIST [INTEGER])
			-- Reverse `list' in place.
		local
			i, j, temp: INTEGER
		do
			i := 1
			j := list.count
			from until i >= j loop
				temp := list.i_th (i)
				list.put_i_th (list.i_th (j), i)
				list.put_i_th (temp, j)
				i := i + 1
				j := j - 1
			end
		end

	print_list (list: ARRAYED_LIST [INTEGER])
		local
			i: INTEGER
		do
			from i := 1 until i > list.count loop
				print (list.i_th (i).out + " ")
				i := i + 1
			end
			print ("%N")
		end

end
