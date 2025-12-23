note
	description: "[
		Rosetta Code: Bernoulli numbers
		https://rosettacode.org/wiki/Bernoulli_numbers

		Bernoulli numbers B_n using the Akiyama-Tanigawa algorithm.
		B_0 = 1, B_1 = -1/2, B_2 = 1/6, B_4 = -1/30, ...
		Odd Bernoulli numbers (except B_1) are zero.
	]"

class
	BERNOULLI_NUMBERS

feature -- Query

	bernoulli (n: INTEGER): TUPLE [num, denom: INTEGER_64]
			-- n-th Bernoulli number as fraction [numerator, denominator]
		require
			non_negative: n >= 0
		local
			a: ARRAY [TUPLE [num, denom: INTEGER_64]]
			m, j: INTEGER
			temp: TUPLE [num, denom: INTEGER_64]
		do
			-- Akiyama-Tanigawa algorithm
			create a.make_filled ([{INTEGER_64} 0, {INTEGER_64} 1], 0, n)

			from m := 0 until m > n loop
				a [m] := [{INTEGER_64} 1, (m + 1).to_integer_64]
				from j := m until j < 1 loop
					temp := subtract_fractions (a [j - 1], a [j])
					a [j - 1] := multiply_fraction (temp, [j.to_integer_64, {INTEGER_64} 1])
					j := j - 1
				end
				m := m + 1
			end

			Result := reduce_fraction (a [0])
		end

	bernoulli_sequence (count: INTEGER): ARRAYED_LIST [TUPLE [num, denom: INTEGER_64]]
			-- First `count` Bernoulli numbers
		require
			positive: count >= 1
		local
			i: INTEGER
		do
			create Result.make (count)
			from i := 0 until i >= count loop
				Result.extend (bernoulli (i))
				i := i + 1
			end
		ensure
			correct_count: Result.count = count
		end

feature -- Fraction arithmetic

	subtract_fractions (a, b: TUPLE [num, denom: INTEGER_64]): TUPLE [num, denom: INTEGER_64]
			-- a - b as reduced fraction
		local
			num, denom: INTEGER_64
		do
			denom := a.denom * b.denom
			num := a.num * b.denom - b.num * a.denom
			Result := reduce_fraction ([num, denom])
		end

	multiply_fraction (a: TUPLE [num, denom: INTEGER_64]; b: TUPLE [num, denom: INTEGER_64]): TUPLE [num, denom: INTEGER_64]
			-- a * b as reduced fraction
		local
			num, denom: INTEGER_64
		do
			num := a.num * b.num
			denom := a.denom * b.denom
			Result := reduce_fraction ([num, denom])
		end

	reduce_fraction (f: TUPLE [num, denom: INTEGER_64]): TUPLE [num, denom: INTEGER_64]
			-- Reduce fraction to lowest terms
		local
			g, n, d: INTEGER_64
		do
			n := f.num
			d := f.denom
			if d < 0 then
				n := -n
				d := -d
			end
			g := gcd (n.abs, d)
			Result := [n // g, d // g]
		ensure
			reduced: gcd (Result.num.abs, Result.denom) = 1
		end

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
		end

feature -- Output

	fraction_to_string (f: TUPLE [num, denom: INTEGER_64]): STRING
			-- String representation of fraction
		do
			if f.denom = 1 then
				Result := f.num.out
			else
				Result := f.num.out + "/" + f.denom.out
			end
		end

feature -- Demo

	demo
			-- Standard Rosetta Code demo
		local
			b: TUPLE [num, denom: INTEGER_64]
			i: INTEGER
		do
			print ("Bernoulli numbers B_0 to B_15:%N%N")
			from i := 0 until i > 15 loop
				b := bernoulli (i)
				if b.num /= 0 then
					print ("B_" + i.out)
					if i < 10 then print (" ") end
					print (" = " + fraction_to_string (b) + "%N")
				end
				i := i + 1
			end
		end

end
