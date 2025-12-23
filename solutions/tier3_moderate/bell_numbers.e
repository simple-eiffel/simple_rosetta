note
	description: "[
		Rosetta Code: Bell numbers
		https://rosettacode.org/wiki/Bell_numbers

		Bell numbers count the number of ways to partition a set.
		B(0)=1, B(1)=1, B(2)=2, B(3)=5, B(4)=15, B(5)=52, ...
		Computed using Bell triangle (Aitken's array).
	]"

class
	BELL_NUMBERS

feature -- Query

	bell (n: INTEGER): NATURAL_64
			-- n-th Bell number (0-indexed)
		require
			non_negative: n >= 0
		local
			triangle: ARRAYED_LIST [ARRAY [NATURAL_64]]
			row: ARRAY [NATURAL_64]
			i, j: INTEGER
		do
			if n = 0 then
				Result := 1
			else
				-- Build Bell triangle
				create triangle.make (n + 1)

				-- First row
				create row.make_filled (0, 0, 0)
				row [0] := 1
				triangle.extend (row)

				-- Build subsequent rows
				from i := 1 until i > n loop
					create row.make_filled (0, 0, i)
					-- First element is last element of previous row
					row [0] := triangle [i] [i - 1]
					-- Each subsequent element is sum of previous in row and above
					from j := 1 until j > i loop
						row [j] := row [j - 1] + triangle [i] [j - 1]
						j := j + 1
					end
					triangle.extend (row)
					i := i + 1
				end

				Result := triangle [n + 1] [0]
			end
		end

	bell_sequence (count: INTEGER): ARRAYED_LIST [NATURAL_64]
			-- First `count` Bell numbers (0-indexed)
		require
			positive: count >= 1
		local
			i: INTEGER
		do
			create Result.make (count)
			from i := 0 until i >= count loop
				Result.extend (bell (i))
				i := i + 1
			end
		ensure
			correct_count: Result.count = count
		end

	bell_triangle_row (n: INTEGER): ARRAY [NATURAL_64]
			-- n-th row of Bell triangle
		require
			non_negative: n >= 0
		local
			prev_row: ARRAY [NATURAL_64]
			i, j: INTEGER
		do
			if n = 0 then
				create Result.make_filled (1, 0, 0)
			else
				prev_row := bell_triangle_row (n - 1)
				create Result.make_filled (0, 0, n)
				Result [0] := prev_row [n - 1]
				from j := 1 until j > n loop
					Result [j] := Result [j - 1] + prev_row [j - 1]
					j := j + 1
				end
			end
		ensure
			correct_size: Result.count = n + 1
			first_is_bell: Result [0] = bell (n)
		end

feature -- Demo

	demo
			-- Standard Rosetta Code demo
		local
			i, j: INTEGER
			row: ARRAY [NATURAL_64]
		do
			print ("First 15 Bell numbers:%N")
			from i := 0 until i >= 15 loop
				print ("B(" + i.out + ") = " + bell (i).out + "%N")
				i := i + 1
			end

			print ("%NFirst 10 rows of Bell triangle:%N")
			from i := 0 until i >= 10 loop
				row := bell_triangle_row (i)
				from j := 0 until j > i loop
					print (row [j].out)
					if j < i then print (" ") end
					j := j + 1
				end
				print ("%N")
				i := i + 1
			end
		end

end
