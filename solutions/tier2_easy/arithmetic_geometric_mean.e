note
	description: "[
		Rosetta Code: Arithmetic-geometric mean
		https://rosettacode.org/wiki/Arithmetic-geometric_mean

		The AGM of two numbers a and b is computed by iterating:
		  a_next = (a + b) / 2  (arithmetic mean)
		  b_next = sqrt(a * b)  (geometric mean)
		until a and b converge.
	]"

class
	ARITHMETIC_GEOMETRIC_MEAN

feature -- Computation

	agm (a, b: REAL_64): REAL_64
			-- Arithmetic-geometric mean of `a` and `b`
		require
			positive_a: a > 0
			positive_b: b > 0
		do
			Result := agm_with_tolerance (a, b, Default_tolerance)
		end

	agm_with_tolerance (a, b, tolerance: REAL_64): REAL_64
			-- AGM with specified `tolerance`
		require
			positive_a: a > 0
			positive_b: b > 0
			positive_tolerance: tolerance > 0
		local
			a_curr, b_curr, a_next, b_next: REAL_64
		do
			a_curr := a
			b_curr := b
			from until (a_curr - b_curr).abs < tolerance loop
				a_next := (a_curr + b_curr) / 2.0
				b_next := sqrt (a_curr * b_curr)
				a_curr := a_next
				b_curr := b_next
			end
			Result := a_curr
		ensure
			positive: Result > 0
			bounded: Result >= a.min (b) and Result <= a.max (b)
		end

	agm_iterations (a, b, tolerance: REAL_64): INTEGER
			-- Number of iterations to converge
		require
			positive_a: a > 0
			positive_b: b > 0
			positive_tolerance: tolerance > 0
		local
			a_curr, b_curr, a_next, b_next: REAL_64
		do
			a_curr := a
			b_curr := b
			from until (a_curr - b_curr).abs < tolerance loop
				a_next := (a_curr + b_curr) / 2.0
				b_next := sqrt (a_curr * b_curr)
				a_curr := a_next
				b_curr := b_next
				Result := Result + 1
			end
		end

feature -- Constants

	Default_tolerance: REAL_64 = 1.0e-15
			-- Default tolerance for convergence

feature -- Applications

	pi_via_agm: REAL_64
			-- Compute pi using AGM (Gauss-Legendre inspired)
			-- pi ≈ 4 * agm(1, 1/sqrt(2))^2 / (1 - sum of corrections)
			-- This is a simplified approximation
		local
			a, g, t, p: REAL_64
			a_next: REAL_64
			i: INTEGER
		do
			a := 1.0
			g := 1.0 / sqrt (2.0)
			t := 0.25
			p := 1.0
			from i := 1 until i > 10 loop
				a_next := (a + g) / 2.0
				g := sqrt (a * g)
				t := t - p * (a - a_next) * (a - a_next)
				a := a_next
				p := p * 2.0
				i := i + 1
			end
			Result := (a + g) * (a + g) / (4.0 * t)
		end

feature {NONE} -- Math Helpers

	sqrt (x: REAL_64): REAL_64
			-- Square root
		require
			non_negative: x >= 0
		external
			"C inline use <math.h>"
		alias
			"return sqrt((double)$x);"
		end

feature -- Demo

	demo
			-- Standard Rosetta Code demo
		do
			print ("Arithmetic-Geometric Mean:%N")
			print ("  AGM(1, 2)        = " + agm (1.0, 2.0).out + "%N")
			print ("  AGM(1, sqrt(2))  = " + agm (1.0, sqrt (2.0)).out + "%N")
			print ("  AGM(24, 6)       = " + agm (24.0, 6.0).out + "%N")
			print ("%N")
			print ("Iterations to converge (tolerance 1e-15):%N")
			print ("  AGM(1, 2):   " + agm_iterations (1.0, 2.0, 1.0e-15).out + " iterations%N")
			print ("  AGM(24, 6):  " + agm_iterations (24.0, 6.0, 1.0e-15).out + " iterations%N")
			print ("%N")
			print ("Pi via AGM:  " + pi_via_agm.out + "%N")
			print ("Actual pi:   3.141592653589793%N")
		end

end
