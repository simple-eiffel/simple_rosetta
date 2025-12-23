note
	description: "[
		Rosetta Code: Pascal's triangle
		https://rosettacode.org/wiki/Pascal%27s_triangle

		Pascal's triangle where each number is sum of two above.
		Row 0: 1
		Row 1: 1 1
		Row 2: 1 2 1
		Row 3: 1 3 3 1
		Entry (n,k) = C(n,k) = n! / (k! * (n-k)!)
	]"

class
	PASCALS_TRIANGLE

feature -- Generation

	generate (rows: INTEGER): ARRAYED_LIST [ARRAY [INTEGER_64]]
			-- Generate Pascal's triangle with `rows` rows (0-indexed)
		require
			non_negative: rows >= 0
		local
			i, j: INTEGER
			row, prev_row: ARRAY [INTEGER_64]
		do
			create Result.make (rows + 1)
			from i := 0 until i > rows loop
				create row.make_filled (0, 0, i)
				row [0] := 1
				row [i] := 1
				if i > 1 then
					prev_row := Result [i]
					from j := 1 until j >= i loop
						row [j] := prev_row [j - 1] + prev_row [j]
						j := j + 1
					end
				end
				Result.extend (row)
				i := i + 1
			end
		ensure
			correct_rows: Result.count = rows + 1
		end

	row_n (n: INTEGER): ARRAY [INTEGER_64]
			-- n-th row of Pascal's triangle (0-indexed)
		require
			non_negative: n >= 0
		local
			j: INTEGER
		do
			create Result.make_filled (1, 0, n)
			from j := 1 until j >= n loop
				Result [j] := binomial (n, j)
				j := j + 1
			end
		ensure
			correct_length: Result.count = n + 1
			symmetric: Result [0] = Result [n]
		end

	binomial (n, k: INTEGER): INTEGER_64
			-- Binomial coefficient C(n,k)
		require
			valid_n: n >= 0
			valid_k: k >= 0 and k <= n
		local
			i: INTEGER
			num, denom: INTEGER_64
		do
			if k = 0 or k = n then
				Result := 1
			else
				num := 1
				denom := 1
				from i := 0 until i >= k.min (n - k) loop
					num := num * (n - i).to_integer_64
					denom := denom * (i + 1).to_integer_64
					i := i + 1
				end
				Result := num // denom
			end
		end

feature -- Display

	formatted_triangle (rows: INTEGER): STRING
			-- Pretty-printed centered triangle
		require
			non_negative: rows >= 0
		local
			triangle: ARRAYED_LIST [ARRAY [INTEGER_64]]
			max_width, i, j, padding: INTEGER
			row_str: STRING
		do
			triangle := generate (rows)
			-- Estimate width of bottom row
			max_width := 0
			across triangle.last as elem loop
				max_width := max_width + elem.out.count + 1
			end

			create Result.make (rows * max_width)
			from i := 0 until i > rows loop
				-- Build row string
				create row_str.make (50)
				from j := 0 until j > i loop
					row_str.append (triangle [i + 1] [j].out)
					if j < i then row_str.append (" ") end
					j := j + 1
				end
				-- Center it
				padding := (max_width - row_str.count) // 2
				from j := 1 until j > padding loop
					Result.append (" ")
					j := j + 1
				end
				Result.append (row_str)
				Result.append ("%N")
				i := i + 1
			end
		end

feature -- Demo

	demo
			-- Standard Rosetta Code demo
		do
			print ("Pascal's Triangle (rows 0-9):%N")
			print (formatted_triangle (9))
			print ("%N")

			print ("Binomial coefficients:%N")
			print ("C(10,5) = " + binomial (10, 5).out + "%N")
			print ("C(20,10) = " + binomial (20, 10).out + "%N")
			print ("C(30,15) = " + binomial (30, 15).out + "%N")
		end

end
