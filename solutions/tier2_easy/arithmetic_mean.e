note
	description: "[
		Rosetta Code: Averages/Arithmetic mean
		https://rosettacode.org/wiki/Averages/Arithmetic_mean

		Calculate the arithmetic mean of a set of numbers.
	]"
	author: "Eiffel Solution"
	rosetta_task: "Averages/Arithmetic_mean"

class
	ARITHMETIC_MEAN

create
	make

feature {NONE} -- Initialization

	make
			-- Demonstrate arithmetic mean calculation.
		local
			numbers: ARRAY [REAL_64]
		do
			numbers := <<1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0, 10.0>>

			print ("Numbers: ")
			print_array (numbers)
			print ("Arithmetic mean: " + mean (numbers).out + "%N")

			-- Empty array case
			print ("%NEmpty array mean: " + mean (<<>>).out + " (returns 0 for empty)%N")
		end

feature -- Calculation

	mean (arr: ARRAY [REAL_64]): REAL_64
			-- Calculate arithmetic mean of arr.
		require
			not_void: arr /= Void
		local
			sum: REAL_64
			i: INTEGER
		do
			if arr.is_empty then
				Result := 0.0
			else
				from i := arr.lower until i > arr.upper loop
					sum := sum + arr [i]
					i := i + 1
				end
				Result := sum / arr.count
			end
		end

feature {NONE} -- Helpers

	print_array (arr: ARRAY [REAL_64])
		local
			i: INTEGER
		do
			from i := arr.lower until i > arr.upper loop
				print (arr [i].out)
				if i < arr.upper then print (", ") end
				i := i + 1
			end
			print ("%N")
		end

end
