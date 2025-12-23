note
	description: "[
		Rosetta Code: Gaussian elimination
		https://rosettacode.org/wiki/Gaussian_elimination

		Solve systems of linear equations using Gauss-Jordan elimination.
	]"

class
	GAUSS_JORDAN

feature -- Operations

	solve (a: ARRAY2 [REAL_64]; b: ARRAY [REAL_64]): detachable ARRAY [REAL_64]
			-- Solve Ax = b using Gauss-Jordan elimination
		require
			is_square: a.height = a.width
			compatible: a.height = b.count
		local
			aug: ARRAY2 [REAL_64]
			n, i, j, k, pivot_row: INTEGER
			max_val, temp, factor: REAL_64
			singular: BOOLEAN
		do
			n := a.height

			-- Create augmented matrix [A | b]
			create aug.make_filled (0, n, n + 1)
			from i := 1 until i > n loop
				from j := 1 until j > n loop
					aug [i, j] := a [i, j]
					j := j + 1
				end
				aug [i, n + 1] := b [i]
				i := i + 1
			end

			-- Forward elimination with partial pivoting
			from k := 1 until k > n or singular loop
				-- Find pivot
				max_val := aug [k, k].abs
				pivot_row := k
				from i := k + 1 until i > n loop
					if aug [i, k].abs > max_val then
						max_val := aug [i, k].abs
						pivot_row := i
					end
					i := i + 1
				end

				if max_val < 1.0e-10 then
					singular := True
				else
					-- Swap rows if needed
					if pivot_row /= k then
						from j := k until j > n + 1 loop
							temp := aug [k, j]
							aug [k, j] := aug [pivot_row, j]
							aug [pivot_row, j] := temp
							j := j + 1
						end
					end

					-- Scale pivot row
					factor := aug [k, k]
					from j := k until j > n + 1 loop
						aug [k, j] := aug [k, j] / factor
						j := j + 1
					end

					-- Eliminate column (both above and below)
					from i := 1 until i > n loop
						if i /= k then
							factor := aug [i, k]
							from j := k until j > n + 1 loop
								aug [i, j] := aug [i, j] - factor * aug [k, j]
								j := j + 1
							end
						end
						i := i + 1
					end
				end
				k := k + 1
			end

			if not singular then
				-- Extract solution
				create Result.make_filled (0, 1, n)
				from i := 1 until i > n loop
					Result [i] := aug [i, n + 1]
					i := i + 1
				end
			end
		end

	reduced_row_echelon (m: ARRAY2 [REAL_64]): ARRAY2 [REAL_64]
			-- Convert matrix to reduced row echelon form
		local
			n_rows, n_cols, i, j, k, pivot_row, lead: INTEGER
			max_val, temp, factor: REAL_64
		do
			n_rows := m.height
			n_cols := m.width
			Result := matrix_copy (m)
			lead := 1

			from i := 1 until i > n_rows loop
				if lead <= n_cols then
					-- Find pivot
					pivot_row := i
					from k := i until k > n_rows loop
						if Result [k, lead].abs > Result [pivot_row, lead].abs then
							pivot_row := k
						end
						k := k + 1
					end

					if Result [pivot_row, lead].abs < 1.0e-10 then
						lead := lead + 1
					else
						-- Swap rows
						if pivot_row /= i then
							from j := 1 until j > n_cols loop
								temp := Result [i, j]
								Result [i, j] := Result [pivot_row, j]
								Result [pivot_row, j] := temp
								j := j + 1
							end
						end

						-- Scale pivot row
						factor := Result [i, lead]
						from j := 1 until j > n_cols loop
							Result [i, j] := Result [i, j] / factor
							j := j + 1
						end

						-- Eliminate column
						from k := 1 until k > n_rows loop
							if k /= i then
								factor := Result [k, lead]
								from j := 1 until j > n_cols loop
									Result [k, j] := Result [k, j] - factor * Result [i, j]
									j := j + 1
								end
							end
							k := k + 1
						end
						lead := lead + 1
						i := i + 1
					end
				else
					i := n_rows + 1  -- Exit
				end
			end
		end

feature {NONE} -- Implementation

	matrix_copy (m: ARRAY2 [REAL_64]): ARRAY2 [REAL_64]
		local
			i, j: INTEGER
		do
			create Result.make_filled (0, m.height, m.width)
			from i := 1 until i > m.height loop
				from j := 1 until j > m.width loop
					Result [i, j] := m [i, j]
					j := j + 1
				end
				i := i + 1
			end
		end

feature -- Utility

	matrix_to_string (m: ARRAY2 [REAL_64]): STRING
		local
			i, j: INTEGER
			val: REAL_64
		do
			create Result.make (m.height * m.width * 10)
			from i := 1 until i > m.height loop
				Result.append ("[ ")
				from j := 1 until j > m.width loop
					val := m [i, j]
					if val.abs < 1.0e-10 then
						Result.append ("0")
					else
						Result.append (val.truncated_to_real.out)
					end
					if j < m.width then
						Result.append (" ")
					end
					j := j + 1
				end
				Result.append (" ]%N")
				i := i + 1
			end
		end

feature -- Demo

	demo
			-- Standard Rosetta Code demo
		local
			a: ARRAY2 [REAL_64]
			b, x: ARRAY [REAL_64]
		do
			print ("Gauss-Jordan Elimination Demo:%N%N")

			-- Solve system: 2x + y - z = 8
			--               -3x - y + 2z = -11
			--               -2x + y + 2z = -3
			create a.make_filled (0, 3, 3)
			a [1, 1] := 2;  a [1, 2] := 1;  a [1, 3] := -1
			a [2, 1] := -3; a [2, 2] := -1; a [2, 3] := 2
			a [3, 1] := -2; a [3, 2] := 1;  a [3, 3] := 2

			b := <<8.0, -11.0, -3.0>>

			print ("System of equations:%N")
			print ("  2x +  y -  z =  8%N")
			print (" -3x -  y + 2z = -11%N")
			print (" -2x +  y + 2z = -3%N%N")

			if attached solve (a, b) as solution then
				x := solution
				print ("Solution: x = " + x [1].out + ", y = " + x [2].out + ", z = " + x [3].out + "%N")
				print ("(Expected: x = 2, y = 3, z = -1)%N")
			else
				print ("System has no unique solution%N")
			end
		end

end
