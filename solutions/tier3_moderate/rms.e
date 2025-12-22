note
	description: "[
		Rosetta Code: Averages/Root mean square
		https://rosettacode.org/wiki/Averages/Root_mean_square

		Calculate the root mean square of a set of numbers.
	]"
	author: "Eiffel Solution"
	rosetta_task: "Averages/Root_mean_square"

class
	RMS

create
	make

feature {NONE} -- Initialization

	make
			-- Demonstrate RMS calculation.
		local
			numbers: ARRAY [REAL_64]
		do
			-- RMS of 1 to 10
			numbers := <<1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0, 10.0>>

			print ("Numbers: 1, 2, 3, 4, 5, 6, 7, 8, 9, 10%N")
			print ("Root Mean Square: " + root_mean_square (numbers).out + "%N")

			-- Compare with arithmetic mean
			print ("%NFor comparison:%N")
			print ("Arithmetic mean: " + arithmetic_mean (numbers).out + "%N")
		end

feature -- Calculation

	root_mean_square (arr: ARRAY [REAL_64]): REAL_64
			-- Calculate RMS of arr.
		require
			not_empty: not arr.is_empty
		local
			sum_of_squares: REAL_64
			i: INTEGER
			math: DOUBLE_MATH
		do
			create math
			from i := arr.lower until i > arr.upper loop
				sum_of_squares := sum_of_squares + arr [i] * arr [i]
				i := i + 1
			end
			Result := math.sqrt (sum_of_squares / arr.count)
		end

	arithmetic_mean (arr: ARRAY [REAL_64]): REAL_64
			-- Calculate arithmetic mean of arr.
		require
			not_empty: not arr.is_empty
		local
			sum: REAL_64
			i: INTEGER
		do
			from i := arr.lower until i > arr.upper loop
				sum := sum + arr [i]
				i := i + 1
			end
			Result := sum / arr.count
		end

end
