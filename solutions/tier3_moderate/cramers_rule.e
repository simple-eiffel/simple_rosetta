note
	description: "[
		Rosetta Code: Cramer's rule
		https://rosettacode.org/wiki/Cramer%27s_rule

		Solve systems of linear equations using determinants.
	]"

class
	CRAMERS_RULE

feature -- Operations

	solve (a: ARRAY2 [REAL_64]; b: ARRAY [REAL_64]): detachable ARRAY [REAL_64]
			-- Solve Ax = b using Cramer's rule
		require
			is_square: a.height = a.width
			compatible: a.height = b.count
		local
			n, i, j: INTEGER
			det_a, det_ai: REAL_64
			a_i: ARRAY2 [REAL_64]
		do
			n := a.height
			det_a := determinant (a)

			if det_a.abs > 1.0e-10 then
				create Result.make_filled (0, 1, n)

				from i := 1 until i > n loop
					-- Create matrix with column i replaced by b
					create a_i.make_filled (0, n, n)
					from j := 1 until j > n loop
						if j = i then
							from i := 1 until i > n loop
								a_i [i, j] := b [i]
								i := i + 1
							end
							i := 1  -- Reset for outer loop
						else
							from i := 1 until i > n loop
								a_i [i, j] := a [i, j]
								i := i + 1
							end
							i := 1  -- Reset for outer loop
						end
						j := j + 1
					end

					det_ai := determinant (a_i)
					Result [i] := det_ai / det_a
					i := i + 1
				end
			end
		end

	solve_simple (a: ARRAY2 [REAL_64]; b: ARRAY [REAL_64]): detachable ARRAY [REAL_64]
			-- Solve using cleaner implementation
		require
			is_square: a.height = a.width
			compatible: a.height = b.count
		local
			n, i: INTEGER
			det_a: REAL_64
		do
			n := a.height
			det_a := determinant (a)

			if det_a.abs > 1.0e-10 then
				create Result.make_filled (0, 1, n)
				from i := 1 until i > n loop
					Result [i] := determinant (replace_column (a, b, i)) / det_a
					i := i + 1
				end
			end
		end

feature {NONE} -- Implementation

	determinant (m: ARRAY2 [REAL_64]): REAL_64
			-- Compute determinant using LU decomposition
		local
			a: ARRAY2 [REAL_64]
			n, i, j, k, pivot_row: INTEGER
			max_val, temp, factor: REAL_64
			sign: INTEGER
		do
			n := m.height
			a := matrix_copy (m)
			sign := 1
			Result := 1

			from k := 1 until k > n loop
				max_val := a [k, k].abs
				pivot_row := k
				from i := k + 1 until i > n loop
					if a [i, k].abs > max_val then
						max_val := a [i, k].abs
						pivot_row := i
					end
					i := i + 1
				end

				if max_val < 1.0e-10 then
					Result := 0
					k := n + 1
				else
					if pivot_row /= k then
						from j := 1 until j > n loop
							temp := a [k, j]
							a [k, j] := a [pivot_row, j]
							a [pivot_row, j] := temp
							j := j + 1
						end
						sign := -sign
					end

					from i := k + 1 until i > n loop
						factor := a [i, k] / a [k, k]
						from j := k until j > n loop
							a [i, j] := a [i, j] - factor * a [k, j]
							j := j + 1
						end
						i := i + 1
					end
					k := k + 1
				end
			end

			if Result /= 0 then
				from i := 1 until i > n loop
					Result := Result * a [i, i]
					i := i + 1
				end
				Result := Result * sign
			end
		end

	replace_column (m: ARRAY2 [REAL_64]; col: ARRAY [REAL_64]; col_idx: INTEGER): ARRAY2 [REAL_64]
			-- Create copy of m with column col_idx replaced by col
		local
			i, j: INTEGER
		do
			create Result.make_filled (0, m.height, m.width)
			from i := 1 until i > m.height loop
				from j := 1 until j > m.width loop
					if j = col_idx then
						Result [i, j] := col [i]
					else
						Result [i, j] := m [i, j]
					end
					j := j + 1
				end
				i := i + 1
			end
		end

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

feature -- Demo

	demo
			-- Standard Rosetta Code demo
		local
			a: ARRAY2 [REAL_64]
			b: ARRAY [REAL_64]
		do
			print ("Cramer's Rule Demo:%N%N")

			-- Rosetta Code example
			create a.make_filled (0, 4, 4)
			a [1, 1] := 2; a [1, 2] := -1; a [1, 3] := 5; a [1, 4] := 1
			a [2, 1] := 3; a [2, 2] := 2; a [2, 3] := 2; a [2, 4] := -6
			a [3, 1] := 1; a [3, 2] := 3; a [3, 3] := 3; a [3, 4] := -1
			a [4, 1] := 5; a [4, 2] := -2; a [4, 3] := -3; a [4, 4] := 3

			b := <<-3.0, -32.0, -47.0, 49.0>>

			print ("System:%N")
			print ("  2w -  x + 5y +  z = -3%N")
			print ("  3w + 2x + 2y - 6z = -32%N")
			print ("   w + 3x + 3y -  z = -47%N")
			print ("  5w - 2x - 3y + 3z = 49%N%N")

			if attached solve_simple (a, b) as solution then
				print ("Solution:%N")
				print ("  w = " + solution [1].out + "%N")
				print ("  x = " + solution [2].out + "%N")
				print ("  y = " + solution [3].out + "%N")
				print ("  z = " + solution [4].out + "%N")
				print ("%N(Expected: w = 2, x = -12, y = -4, z = 1)%N")
			else
				print ("System has no unique solution (det = 0)%N")
			end
		end

end
