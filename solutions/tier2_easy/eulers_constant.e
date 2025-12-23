note
	description: "[
		Rosetta Code: Euler's constant 0.5772...
		https://rosettacode.org/wiki/Euler%27s_constant_0.5772...

		Compute the Euler-Mascheroni constant gamma ≈ 0.5772156649...
		gamma = lim(n->inf) [sum(1/k for k=1..n) - ln(n)]
	]"

class
	EULERS_CONSTANT

feature -- Constants

	gamma_known: REAL_64 = 0.5772156649015328606065120900824024310421593359
			-- Known value of Euler's constant to high precision

feature -- Computation

	gamma_via_harmonic (n: INTEGER): REAL_64
			-- Approximate gamma using harmonic series minus ln(n)
		require
			positive: n >= 1
		local
			h: REAL_64
			k: INTEGER
		do
			-- gamma ≈ H_n - ln(n) where H_n = sum(1/k for k=1..n)
			from k := 1 until k > n loop
				h := h + 1.0 / k.to_double
				k := k + 1
			end
			Result := h - ln (n.to_double)
		end

	gamma_via_series (terms: INTEGER): REAL_64
			-- Approximate gamma using faster converging series
		require
			positive: terms >= 1
		local
			k: INTEGER
			sum, term: REAL_64
		do
			-- Sweeney (1963) series: faster convergence
			-- gamma = sum_{k=2}^inf (-1)^k * zeta(k) / k
			-- Simplified version using harmonic numbers
			from k := 1 until k > terms loop
				term := (1.0 / k.to_double) - ln ((k + 1).to_double / k.to_double)
				sum := sum + term
				k := k + 1
			end
			Result := sum
		end

	gamma_via_integral (steps: INTEGER): REAL_64
			-- Approximate gamma using numerical integration
			-- gamma = -integral_0^1 ln(ln(1/x)) dx
		require
			positive: steps >= 100
		local
			i: INTEGER
			x, dx, sum: REAL_64
		do
			dx := 1.0 / steps.to_double
			from i := 1 until i >= steps loop
				x := i.to_double * dx
				if x > 0.0001 and x < 0.9999 then
					sum := sum - ln (-ln (x))
				end
				i := i + 1
			end
			Result := sum * dx
		end

feature -- Accuracy

	error (approximation: REAL_64): REAL_64
			-- Absolute error from known value
		do
			Result := (approximation - gamma_known).abs
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

	ln (x: REAL_64): REAL_64
			-- Natural logarithm
		require
			positive: x > 0
		external
			"C inline use <math.h>"
		alias
			"return log((double)$x);"
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
			print ("Euler's constant (gamma) approximations:%N%N")
			print ("Known value:  " + gamma_known.out + "%N%N")

			approx := gamma_via_harmonic (100)
			print ("Harmonic(100):    " + approx.out + " (" + digits_correct (approx).out + " digits)%N")

			approx := gamma_via_harmonic (1000)
			print ("Harmonic(1000):   " + approx.out + " (" + digits_correct (approx).out + " digits)%N")

			approx := gamma_via_harmonic (10000)
			print ("Harmonic(10000):  " + approx.out + " (" + digits_correct (approx).out + " digits)%N")

			approx := gamma_via_series (1000)
			print ("Series(1000):     " + approx.out + " (" + digits_correct (approx).out + " digits)%N")

			approx := gamma_via_series (10000)
			print ("Series(10000):    " + approx.out + " (" + digits_correct (approx).out + " digits)%N")
		end

end
