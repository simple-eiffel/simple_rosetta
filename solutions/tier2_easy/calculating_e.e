note
	description: "[
		Rosetta Code: Calculating the value of e
		https://rosettacode.org/wiki/Calculating_the_value_of_e

		Calculate Euler's number e ≈ 2.71828... using various methods:
		- Taylor series: e = sum(1/n! for n=0..inf)
		- Limit: e = lim(n->inf) (1 + 1/n)^n
		- Continued fraction
	]"

class
	CALCULATING_E

feature -- Constants

	e_known: REAL_64 = 2.71828182845904523536028747135266249775724709369995
			-- Known value of e to high precision

feature -- Computation

	e_via_factorial (terms: INTEGER): REAL_64
			-- Calculate e using Taylor series: e = sum(1/n!)
		require
			positive: terms >= 1
		local
			n: INTEGER
			factorial: REAL_64
			sum: REAL_64
		do
			factorial := 1.0
			sum := 1.0  -- 1/0! = 1
			from n := 1 until n >= terms loop
				factorial := factorial * n.to_double
				sum := sum + 1.0 / factorial
				n := n + 1
			end
			Result := sum
		ensure
			positive: Result > 0
		end

	e_via_limit (n: INTEGER): REAL_64
			-- Calculate e using limit: e = lim (1 + 1/n)^n
		require
			positive: n >= 1
		do
			Result := power (1.0 + 1.0 / n.to_double, n)
		ensure
			positive: Result > 0
		end

	e_via_continued_fraction (terms: INTEGER): REAL_64
			-- Calculate e using continued fraction representation
			-- e = 2 + 1/(1 + 1/(2 + 1/(1 + 1/(1 + 1/(4 + ...)))))
		require
			positive: terms >= 1
		local
			cf: ARRAY [INTEGER]
			i: INTEGER
			result_val: REAL_64
		do
			-- Generate continued fraction coefficients for e
			-- Pattern: 2, 1, 2, 1, 1, 4, 1, 1, 6, 1, 1, 8, ...
			create cf.make_filled (0, 1, terms)
			cf [1] := 2
			from i := 2 until i > terms loop
				if i \\ 3 = 0 then
					cf [i] := 2 * (i // 3)
				else
					cf [i] := 1
				end
				i := i + 1
			end

			-- Evaluate continued fraction from bottom up
			result_val := cf [terms].to_double
			from i := terms - 1 until i < 1 loop
				result_val := cf [i].to_double + 1.0 / result_val
				i := i - 1
			end
			Result := result_val
		ensure
			positive: Result > 0
		end

feature -- Accuracy

	error (approximation: REAL_64): REAL_64
			-- Absolute error from known value
		do
			Result := (approximation - e_known).abs
		end

	digits_correct (approximation: REAL_64): INTEGER
			-- Number of correct decimal digits
		local
			err: REAL_64
		do
			err := error (approximation)
			if err = 0.0 then
				Result := 15  -- Double precision limit
			elseif err < 1.0 then
				Result := (-log10 (err)).floor.to_integer_32.max (0)
			end
		end

feature {NONE} -- Implementation

	power (base: REAL_64; exp: INTEGER): REAL_64
			-- base^exp
		require
			positive_base: base > 0
		external
			"C inline use <math.h>"
		alias
			"return pow((double)$base, (double)$exp);"
		end

	log10 (x: REAL_64): REAL_64
			-- Base-10 logarithm
		require
			positive: x > 0
		external
			"C inline use <math.h>"
		alias
			"return log10((double)$x);"
		end

feature -- Demo

	demo
			-- Standard Rosetta Code demo
		local
			approx: REAL_64
		do
			print ("Calculating e (Euler's number):%N%N")
			print ("Known value: " + e_known.out + "%N%N")

			print ("Taylor series (1/n!):%N")
			approx := e_via_factorial (5)
			print ("  5 terms:  " + approx.out + " (" + digits_correct (approx).out + " digits)%N")
			approx := e_via_factorial (10)
			print ("  10 terms: " + approx.out + " (" + digits_correct (approx).out + " digits)%N")
			approx := e_via_factorial (20)
			print ("  20 terms: " + approx.out + " (" + digits_correct (approx).out + " digits)%N")

			print ("%NLimit (1 + 1/n)^n:%N")
			approx := e_via_limit (10)
			print ("  n=10:     " + approx.out + " (" + digits_correct (approx).out + " digits)%N")
			approx := e_via_limit (1000)
			print ("  n=1000:   " + approx.out + " (" + digits_correct (approx).out + " digits)%N")
			approx := e_via_limit (1000000)
			print ("  n=10^6:   " + approx.out + " (" + digits_correct (approx).out + " digits)%N")

			print ("%NContinued fraction:%N")
			approx := e_via_continued_fraction (10)
			print ("  10 terms: " + approx.out + " (" + digits_correct (approx).out + " digits)%N")
			approx := e_via_continued_fraction (20)
			print ("  20 terms: " + approx.out + " (" + digits_correct (approx).out + " digits)%N")
		end

end
