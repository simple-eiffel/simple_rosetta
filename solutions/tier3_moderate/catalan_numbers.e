note
	description: "[
		Rosetta Code: Catalan numbers/Pascal's triangle
		https://rosettacode.org/wiki/Catalan_numbers/Pascal%27s_triangle

		Catalan numbers using Pascal's triangle.
		C(n) = C(2n,n)/(n+1) = (2n)!/((n+1)!*n!)
		Sequence: 1, 1, 2, 5, 14, 42, 132, 429, 1430, 4862, ...
	]"

class
	CATALAN_NUMBERS

feature -- Query

	catalan (n: INTEGER): NATURAL_64
			-- n-th Catalan number (0-indexed)
		require
			non_negative: n >= 0
		do
			Result := binomial (2 * n, n) // (n + 1).to_natural_64
		ensure
			definition: Result = binomial (2 * n, n) // (n + 1).to_natural_64
		end

	catalan_sequence (count: INTEGER): ARRAYED_LIST [NATURAL_64]
			-- First `count` Catalan numbers (0-indexed)
		require
			positive: count >= 1
		local
			i: INTEGER
		do
			create Result.make (count)
			from i := 0 until i >= count loop
				Result.extend (catalan (i))
				i := i + 1
			end
		ensure
			correct_count: Result.count = count
		end

	catalan_via_pascal (n: INTEGER): NATURAL_64
			-- n-th Catalan using Pascal's triangle method
		require
			non_negative: n >= 0
		local
			row: ARRAY [NATURAL_64]
			i, j: INTEGER
		do
			-- Build row 2n of Pascal's triangle
			create row.make_filled (0, 0, 2 * n)
			row [0] := 1
			from i := 1 until i > 2 * n loop
				from j := i until j < 1 loop
					row [j] := row [j] + row [j - 1]
					j := j - 1
				end
				i := i + 1
			end
			-- C(n) = C(2n,n) - C(2n,n-1) for n > 0
			if n = 0 then
				Result := 1
			else
				Result := row [n] - row [n - 1]
			end
		ensure
			same_as_formula: Result = catalan (n)
		end

feature -- Implementation

	binomial (n, k: INTEGER): NATURAL_64
			-- Binomial coefficient C(n,k)
		require
			valid_n: n >= 0
			valid_k: k >= 0 and k <= n
		local
			i: INTEGER
			num, denom: NATURAL_64
		do
			if k = 0 or k = n then
				Result := 1
			else
				-- Use smaller k to reduce computation
				num := 1
				denom := 1
				from i := 0 until i >= k.min (n - k) loop
					num := num * (n - i).to_natural_64
					denom := denom * (i + 1).to_natural_64
					i := i + 1
				end
				Result := num // denom
			end
		end

feature -- Demo

	demo
			-- Standard Rosetta Code demo
		local
			i: INTEGER
		do
			print ("First 15 Catalan numbers (via Pascal's triangle):%N")
			from i := 0 until i >= 15 loop
				print ("C(" + i.out + ") = " + catalan_via_pascal (i).out + "%N")
				i := i + 1
			end
		end

end
