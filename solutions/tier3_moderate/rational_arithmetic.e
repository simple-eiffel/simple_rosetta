note
	description: "[
		Rosetta Code: Arithmetic/Rational
		https://rosettacode.org/wiki/Arithmetic/Rational

		Rational number arithmetic with automatic reduction to lowest terms.
		Supports addition, subtraction, multiplication, division.
	]"

class
	RATIONAL_ARITHMETIC

inherit
	COMPARABLE
		redefine
			out
		end

create
	make, make_integer

feature {NONE} -- Initialization

	make (a_num, a_denom: INTEGER_64)
			-- Create rational a_num/a_denom in lowest terms
		require
			non_zero_denom: a_denom /= 0
		local
			g: INTEGER_64
			n, d: INTEGER_64
		do
			n := a_num
			d := a_denom
			-- Normalize sign
			if d < 0 then
				n := -n
				d := -d
			end
			-- Reduce to lowest terms
			g := gcd (n.abs, d)
			numerator := n // g
			denominator := d // g
		ensure
			reduced: gcd (numerator.abs, denominator) = 1
			positive_denom: denominator > 0
		end

	make_integer (n: INTEGER_64)
			-- Create rational from integer n/1
		do
			numerator := n
			denominator := 1
		ensure
			is_integer: denominator = 1
		end

feature -- Access

	numerator: INTEGER_64
			-- Numerator

	denominator: INTEGER_64
			-- Denominator (always positive)

feature -- Query

	is_zero: BOOLEAN
			-- Is this zero?
		do
			Result := numerator = 0
		end

	is_integer: BOOLEAN
			-- Is this an integer?
		do
			Result := denominator = 1
		end

	to_real: REAL_64
			-- Convert to real number
		do
			Result := numerator.to_double / denominator.to_double
		end

feature -- Arithmetic

	plus alias "+" (other: RATIONAL_ARITHMETIC): RATIONAL_ARITHMETIC
			-- Sum of Current and `other`
		do
			create Result.make (
				numerator * other.denominator + other.numerator * denominator,
				denominator * other.denominator
			)
		end

	minus alias "-" (other: RATIONAL_ARITHMETIC): RATIONAL_ARITHMETIC
			-- Difference of Current and `other`
		do
			create Result.make (
				numerator * other.denominator - other.numerator * denominator,
				denominator * other.denominator
			)
		end

	product alias "*" (other: RATIONAL_ARITHMETIC): RATIONAL_ARITHMETIC
			-- Product of Current and `other`
		do
			create Result.make (
				numerator * other.numerator,
				denominator * other.denominator
			)
		end

	quotient alias "/" (other: RATIONAL_ARITHMETIC): RATIONAL_ARITHMETIC
			-- Quotient of Current by `other`
		require
			divisor_not_zero: not other.is_zero
		do
			create Result.make (
				numerator * other.denominator,
				denominator * other.numerator
			)
		end

	negation alias "-": RATIONAL_ARITHMETIC
			-- Negation of Current
		do
			create Result.make (-numerator, denominator)
		end

	absolute: RATIONAL_ARITHMETIC
			-- Absolute value
		do
			create Result.make (numerator.abs, denominator)
		end

	inverse: RATIONAL_ARITHMETIC
			-- Multiplicative inverse
		require
			not_zero: not is_zero
		do
			create Result.make (denominator, numerator)
		end

feature -- Comparison

	is_less alias "<" (other: RATIONAL_ARITHMETIC): BOOLEAN
			-- Is Current less than `other`?
		do
			Result := numerator * other.denominator < other.numerator * denominator
		end

feature -- Output

	out: STRING
			-- String representation
		do
			if denominator = 1 then
				Result := numerator.out
			else
				Result := numerator.out + "/" + denominator.out
			end
		end

feature {NONE} -- Implementation

	gcd (a, b: INTEGER_64): INTEGER_64
			-- Greatest common divisor
		require
			non_negative: a >= 0 and b >= 0
		do
			if b = 0 then
				Result := a.max (1)
			else
				Result := gcd (b, a \\ b)
			end
		ensure
			positive: Result >= 1
		end

feature -- Demo

	demo
			-- Standard Rosetta Code demo: sum of 1/k^2 for k=1..1000
			-- Should approximate pi^2/6 = 1.6449...
		local
			sum, term: RATIONAL_ARITHMETIC
			k: INTEGER
		do
			create sum.make_integer (0)
			from k := 1 until k > 1000 loop
				create term.make (1, (k * k).to_integer_64)
				sum := sum + term
				k := k + 1
			end

			print ("Rational Arithmetic Demo:%N")
			print ("Sum of 1/k^2 for k=1..1000:%N")
			print ("  As fraction: " + sum.out + "%N")
			print ("  As decimal:  " + sum.to_real.out + "%N")
			print ("  pi^2/6 =     1.6449340668...%N")
			print ("%N")

			-- Basic operations demo
			print ("Basic operations:%N")
			create sum.make (1, 2)
			create term.make (1, 3)
			print ("  1/2 + 1/3 = " + (sum + term).out + "%N")
			print ("  1/2 - 1/3 = " + (sum - term).out + "%N")
			print ("  1/2 * 1/3 = " + (sum * term).out + "%N")
			print ("  1/2 / 1/3 = " + (sum / term).out + "%N")
		end

end
