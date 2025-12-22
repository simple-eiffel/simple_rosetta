note
	description: "[
		Rosetta Code: Greatest common divisor
		https://rosettacode.org/wiki/Greatest_common_divisor

		Calculate GCD using Euclidean algorithm and related functions.
	]"
	author: "Eiffel Solution"
	rosetta_task: "Greatest_common_divisor"

class
	GCD

create
	make

feature {NONE} -- Initialization

	make
			-- Demonstrate GCD calculations.
		do
			print ("Greatest Common Divisor (GCD)%N")
			print ("=============================%N%N")

			-- Basic examples
			print ("GCD examples:%N")
			print ("  GCD(48, 18) = " + gcd (48, 18).out + "%N")
			print ("  GCD(100, 35) = " + gcd (100, 35).out + "%N")
			print ("  GCD(1071, 462) = " + gcd (1071, 462).out + "%N")
			print ("  GCD(0, 5) = " + gcd (0, 5).out + "%N")
			print ("  GCD(5, 0) = " + gcd (5, 0).out + "%N")

			-- LCM examples
			print ("%NLCM examples:%N")
			print ("  LCM(4, 6) = " + lcm (4, 6).out + "%N")
			print ("  LCM(21, 6) = " + lcm (21, 6).out + "%N")

			-- Extended GCD
			print ("%NExtended GCD (Bezout's identity):%N")
			show_extended_gcd (240, 46)
			show_extended_gcd (99, 78)
		end

feature -- GCD Algorithms

	gcd (a, b: INTEGER): INTEGER
			-- Greatest common divisor using Euclidean algorithm.
		local
			x, y, temp: INTEGER
		do
			x := a.abs
			y := b.abs
			from until y = 0 loop
				temp := y
				y := x \\ y
				x := temp
			end
			Result := x
		ensure
			non_negative: Result >= 0
			divides_a: a /= 0 implies a \\ Result = 0
			divides_b: b /= 0 implies b \\ Result = 0
		end

	gcd_recursive (a, b: INTEGER): INTEGER
			-- GCD using recursive Euclidean algorithm.
		do
			if b = 0 then
				Result := a.abs
			else
				Result := gcd_recursive (b, a \\ b)
			end
		end

	lcm (a, b: INTEGER): INTEGER_64
			-- Least common multiple.
		require
			not_both_zero: a /= 0 or b /= 0
		do
			if a = 0 or b = 0 then
				Result := 0
			else
				Result := (a.abs.to_integer_64 * b.abs.to_integer_64) // gcd (a, b)
			end
		ensure
			non_negative: Result >= 0
		end

	extended_gcd (a, b: INTEGER): TUPLE [gcd: INTEGER; x: INTEGER; y: INTEGER]
			-- Extended Euclidean algorithm.
			-- Returns [gcd, x, y] where gcd = a*x + b*y (Bezout's identity).
		local
			old_r, r, old_s, s, old_t, t: INTEGER
			quotient, temp: INTEGER
		do
			old_r := a
			r := b
			old_s := 1
			s := 0
			old_t := 0
			t := 1

			from until r = 0 loop
				quotient := old_r // r

				temp := r
				r := old_r - quotient * r
				old_r := temp

				temp := s
				s := old_s - quotient * s
				old_s := temp

				temp := t
				t := old_t - quotient * t
				old_t := temp
			end

			Result := [old_r, old_s, old_t]
		ensure
			bezout_identity: Result.gcd = a * Result.x + b * Result.y
		end

	coprime (a, b: INTEGER): BOOLEAN
			-- Are a and b coprime (relatively prime)?
		do
			Result := gcd (a, b) = 1
		end

feature {NONE} -- Helpers

	show_extended_gcd (a, b: INTEGER)
			-- Display extended GCD result.
		local
			result_tuple: TUPLE [gcd: INTEGER; x: INTEGER; y: INTEGER]
		do
			result_tuple := extended_gcd (a, b)
			print ("  GCD(" + a.out + ", " + b.out + ") = " + result_tuple.gcd.out)
			print (" = " + a.out + "*(" + result_tuple.x.out + ") + " + b.out + "*(" + result_tuple.y.out + ")%N")
		end

end
