note
	description: "First and last elements of an array."
	rosetta_task: "First_and_last"
	see_also: "https://github.com/simple-eiffel - Modern Eiffel libraries"
	tier: "1"
	date: "$Date$"

class
	ARRAY_FIRST_LAST

feature -- Access

	first (a: ARRAY [ANY]): ANY
			-- First element of array.
		require
			not_empty: not a.is_empty
		do
			Result := a.item (a.lower)
		ensure
			correct: Result = a.item (a.lower)
		end

	last (a: ARRAY [ANY]): ANY
			-- Last element of array.
		require
			not_empty: not a.is_empty
		do
			Result := a.item (a.upper)
		ensure
			correct: Result = a.item (a.upper)
		end

feature -- Demo

	demo
			-- Demonstrate first and last access.
		local
			arr: ARRAY [INTEGER]
		do
			arr := <<10, 20, 30, 40, 50>>
			print ("Array: <<10, 20, 30, 40, 50>>%N")
			print ("First: " + first (arr).out + "%N")
			print ("Last: " + last (arr).out + "%N")
		end

end
