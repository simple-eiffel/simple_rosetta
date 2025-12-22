note
	description: "[
		Rosetta Code: Averages/Pythagorean means
		https://rosettacode.org/wiki/Averages/Pythagorean_means

		Calculate arithmetic, geometric, and harmonic means.
		Verify A >= G >= H for positive numbers.
	]"
	author: "Eiffel Solution"
	rosetta_task: "Averages/Pythagorean_means"

class
	PYTHAGOREAN_MEANS

create
	make

feature {NONE} -- Initialization

	make
			-- Demonstrate Pythagorean means.
		local
			numbers: ARRAY [REAL_64]
			am, gm, hm: REAL_64
		do
			numbers := <<1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0, 10.0>>

			print ("Numbers: 1, 2, 3, 4, 5, 6, 7, 8, 9, 10%N%N")

			am := arithmetic_mean (numbers)
			gm := geometric_mean (numbers)
			hm := harmonic_mean (numbers)

			print ("Arithmetic Mean (A): " + am.out + "%N")
			print ("Geometric Mean (G):  " + gm.out + "%N")
			print ("Harmonic Mean (H):   " + hm.out + "%N")

			print ("%NVerification:%N")
			if am >= gm and gm >= hm then
				print ("  A >= G >= H: TRUE (as expected)%N")
			else
				print ("  A >= G >= H: FALSE (unexpected!)%N")
			end
		end

feature -- Calculations

	arithmetic_mean (arr: ARRAY [REAL_64]): REAL_64
			-- Arithmetic mean: sum of values / count.
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

	geometric_mean (arr: ARRAY [REAL_64]): REAL_64
			-- Geometric mean: nth root of product of values.
		require
			not_empty: not arr.is_empty
			all_positive: all_positive (arr)
		local
			log_sum: REAL_64
			i: INTEGER
			math: DOUBLE_MATH
		do
			create math
			-- Use log to avoid overflow: GM = exp(sum(log(x))/n)
			from i := arr.lower until i > arr.upper loop
				log_sum := log_sum + math.log (arr [i])
				i := i + 1
			end
			Result := math.exp (log_sum / arr.count)
		end

	harmonic_mean (arr: ARRAY [REAL_64]): REAL_64
			-- Harmonic mean: count / sum of reciprocals.
		require
			not_empty: not arr.is_empty
			all_positive: all_positive (arr)
		local
			reciprocal_sum: REAL_64
			i: INTEGER
		do
			from i := arr.lower until i > arr.upper loop
				reciprocal_sum := reciprocal_sum + (1.0 / arr [i])
				i := i + 1
			end
			Result := arr.count / reciprocal_sum
		end

feature -- Helpers

	all_positive (arr: ARRAY [REAL_64]): BOOLEAN
			-- Are all elements in arr positive?
		local
			i: INTEGER
		do
			Result := True
			from i := arr.lower until i > arr.upper or not Result loop
				if arr [i] <= 0.0 then
					Result := False
				end
				i := i + 1
			end
		end

end
