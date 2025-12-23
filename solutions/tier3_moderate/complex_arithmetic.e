note
	description: "[
		Rosetta Code: Arithmetic/Complex
		https://rosettacode.org/wiki/Arithmetic/Complex

		Complex number arithmetic: addition, subtraction,
		multiplication, division, negation, conjugate, absolute value.
	]"

class
	COMPLEX_ARITHMETIC

create
	make, make_polar

feature {NONE} -- Initialization

	make (a_real, a_imag: REAL_64)
			-- Create complex number a_real + a_imag*i
		do
			real := a_real
			imag := a_imag
		ensure
			real_set: real = a_real
			imag_set: imag = a_imag
		end

	make_polar (r, theta: REAL_64)
			-- Create complex from polar form r*e^(i*theta)
		require
			non_negative_r: r >= 0
		do
			real := r * cosine (theta)
			imag := r * sine (theta)
		end

feature -- Access

	real: REAL_64
			-- Real part

	imag: REAL_64
			-- Imaginary part

feature -- Measurement

	magnitude: REAL_64
			-- Absolute value |z| = sqrt(real^2 + imag^2)
		do
			Result := sqrt (real * real + imag * imag)
		ensure
			non_negative: Result >= 0
		end

	argument: REAL_64
			-- Angle in radians (phase)
		require
			not_zero: not is_zero
		do
			Result := arc_tangent_2 (imag, real)
		end

	is_zero: BOOLEAN
			-- Is this the zero complex number?
		do
			Result := real = 0 and imag = 0
		end

feature -- Arithmetic

	plus alias "+" (other: COMPLEX_ARITHMETIC): COMPLEX_ARITHMETIC
			-- Sum of Current and `other`
		do
			create Result.make (real + other.real, imag + other.imag)
		ensure
			real_sum: Result.real = real + other.real
			imag_sum: Result.imag = imag + other.imag
		end

	minus alias "-" (other: COMPLEX_ARITHMETIC): COMPLEX_ARITHMETIC
			-- Difference of Current and `other`
		do
			create Result.make (real - other.real, imag - other.imag)
		end

	product alias "*" (other: COMPLEX_ARITHMETIC): COMPLEX_ARITHMETIC
			-- Product of Current and `other`
			-- (a+bi)(c+di) = (ac-bd) + (ad+bc)i
		do
			create Result.make (
				real * other.real - imag * other.imag,
				real * other.imag + imag * other.real
			)
		end

	quotient alias "/" (other: COMPLEX_ARITHMETIC): COMPLEX_ARITHMETIC
			-- Quotient of Current by `other`
		require
			divisor_not_zero: not other.is_zero
		local
			denom: REAL_64
		do
			denom := other.real * other.real + other.imag * other.imag
			create Result.make (
				(real * other.real + imag * other.imag) / denom,
				(imag * other.real - real * other.imag) / denom
			)
		end

	negation alias "-": COMPLEX_ARITHMETIC
			-- Negation of Current
		do
			create Result.make (-real, -imag)
		ensure
			real_negated: Result.real = -real
			imag_negated: Result.imag = -imag
		end

	conjugate: COMPLEX_ARITHMETIC
			-- Complex conjugate
		do
			create Result.make (real, -imag)
		ensure
			real_same: Result.real = real
			imag_negated: Result.imag = -imag
		end

	inverse: COMPLEX_ARITHMETIC
			-- Multiplicative inverse 1/z
		require
			not_zero: not is_zero
		local
			denom: REAL_64
		do
			denom := real * real + imag * imag
			create Result.make (real / denom, -imag / denom)
		ensure
			product_is_one: (Current * Result).magnitude - 1.0 < 1.0e-10
		end

feature -- Output

	to_string: STRING
			-- String representation
		do
			create Result.make (20)
			Result.append (real.out)
			if imag >= 0 then
				Result.append ("+")
			end
			Result.append (imag.out)
			Result.append ("i")
		end

feature {NONE} -- Implementation

	arc_tangent_2 (y, x: REAL_64): REAL_64
			-- Arc tangent of y/x, in correct quadrant
		external
			"C inline use <math.h>"
		alias
			"return atan2((double)$y, (double)$x);"
		end

	sine (x: REAL_64): REAL_64
			-- Sine of `x` (radians)
		external
			"C inline use <math.h>"
		alias
			"return sin((double)$x);"
		end

	cosine (x: REAL_64): REAL_64
			-- Cosine of `x` (radians)
		external
			"C inline use <math.h>"
		alias
			"return cos((double)$x);"
		end

	sqrt (x: REAL_64): REAL_64
			-- Square root of `x`
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
		local
			a, b, c: COMPLEX_ARITHMETIC
		do
			create a.make (1.0, 1.0)
			create b.make (3.14159, 1.2)

			print ("Complex Arithmetic Demo:%N")
			print ("  a = " + a.to_string + "%N")
			print ("  b = " + b.to_string + "%N")
			print ("%N")

			c := a + b
			print ("  a + b = " + c.to_string + "%N")

			c := a - b
			print ("  a - b = " + c.to_string + "%N")

			c := a * b
			print ("  a * b = " + c.to_string + "%N")

			c := a / b
			print ("  a / b = " + c.to_string + "%N")

			c := -a
			print ("  -a = " + c.to_string + "%N")

			c := a.conjugate
			print ("  conj(a) = " + c.to_string + "%N")

			print ("  |a| = " + a.magnitude.out + "%N")
		end

end
