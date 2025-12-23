note
	description: "[
		Rosetta Code: Floyd's triangle
		https://rosettacode.org/wiki/Floyd%27s_triangle

		Floyd's triangle has n rows with consecutive integers.
		Row 1: 1
		Row 2: 2 3
		Row 3: 4 5 6
		Row n: contains n numbers
	]"

class
	FLOYDS_TRIANGLE

feature -- Generation

	generate (rows: INTEGER): ARRAYED_LIST [ARRAY [INTEGER]]
			-- Generate Floyd's triangle with `rows` rows
		require
			positive: rows >= 1
		local
			i, j, num: INTEGER
			row: ARRAY [INTEGER]
		do
			create Result.make (rows)
			num := 1
			from i := 1 until i > rows loop
				create row.make_filled (0, 1, i)
				from j := 1 until j > i loop
					row [j] := num
					num := num + 1
					j := j + 1
				end
				Result.extend (row)
				i := i + 1
			end
		ensure
			correct_rows: Result.count = rows
		end

	row_n (n: INTEGER): ARRAY [INTEGER]
			-- n-th row of Floyd's triangle
		require
			positive: n >= 1
		local
			start_num, i: INTEGER
		do
			-- First number in row n is 1 + 2 + ... + (n-1) + 1 = n*(n-1)/2 + 1
			start_num := (n * (n - 1)) // 2 + 1
			create Result.make_filled (0, 1, n)
			from i := 1 until i > n loop
				Result [i] := start_num + i - 1
				i := i + 1
			end
		ensure
			correct_length: Result.count = n
		end

	last_number (rows: INTEGER): INTEGER
			-- Last number in a triangle with `rows` rows
		require
			positive: rows >= 1
		do
			Result := (rows * (rows + 1)) // 2
		end

feature -- Display

	formatted_triangle (rows: INTEGER): STRING
			-- Pretty-printed triangle
		require
			positive: rows >= 1
		local
			triangle: ARRAYED_LIST [ARRAY [INTEGER]]
			max_width, i, j: INTEGER
			num_str: STRING
		do
			triangle := generate (rows)
			max_width := last_number (rows).out.count

			create Result.make (rows * rows * 3)
			from i := 1 until i > rows loop
				from j := 1 until j > i loop
					num_str := triangle [i] [j].out
					-- Right-align to max_width
					from until num_str.count >= max_width loop
						num_str.prepend (" ")
					end
					Result.append (num_str)
					if j < i then
						Result.append (" ")
					end
					j := j + 1
				end
				Result.append ("%N")
				i := i + 1
			end
		end

feature -- Demo

	demo
			-- Standard Rosetta Code demo
		do
			print ("Floyd's Triangle (5 rows):%N")
			print (formatted_triangle (5))
			print ("%N")

			print ("Floyd's Triangle (14 rows):%N")
			print (formatted_triangle (14))
		end

end
