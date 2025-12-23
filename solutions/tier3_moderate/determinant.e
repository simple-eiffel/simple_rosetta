note
	description: "[
		Rosetta Code: Determinant and permanent
		https://rosettacode.org/wiki/Determinant_and_permanent

		Calculate determinant of a square matrix using
		LU decomposition for efficiency.
	]"

class
	DETERMINANT

feature -- Operations

	determinant (m: ARRAY2 [REAL_64]): REAL_64
			-- Determinant of square matrix m
		require
			is_square: m.height = m.width
		do
			if m.height = 1 then
				Result := m [1, 1]
			elseif m.height = 2 then
				Result := m [1, 1] * m [2, 2] - m [1, 2] * m [2, 1]
			elseif m.height = 3 then
				Result := determinant_3x3 (m)
			else
				Result := determinant_lu (m)
			end
		end

	permanent (m: ARRAY2 [REAL_64]): REAL_64
			-- Permanent of square matrix (like determinant but all + signs)
		require
			is_square: m.height = m.width
		do
			Result := permanent_recursive (m, 1, create {ARRAY [BOOLEAN]}.make_filled (False, 1, m.width))
		end

feature {NONE} -- Implementation

	determinant_3x3 (m: ARRAY2 [REAL_64]): REAL_64
			-- Determinant of 3x3 matrix using Sarrus' rule
		do
			Result := m [1, 1] * m [2, 2] * m [3, 3]
				+ m [1, 2] * m [2, 3] * m [3, 1]
				+ m [1, 3] * m [2, 1] * m [3, 2]
				- m [1, 3] * m [2, 2] * m [3, 1]
				- m [1, 1] * m [2, 3] * m [3, 2]
				- m [1, 2] * m [2, 1] * m [3, 3]
		end

	determinant_lu (m: ARRAY2 [REAL_64]): REAL_64
			-- Determinant using LU decomposition with partial pivoting
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
				-- Find pivot
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
					k := n + 1  -- Exit
				else
					-- Swap rows if needed
					if pivot_row /= k then
						from j := 1 until j > n loop
							temp := a [k, j]
							a [k, j] := a [pivot_row, j]
							a [pivot_row, j] := temp
							j := j + 1
						end
						sign := -sign
					end

					-- Eliminate
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

			-- Product of diagonal
			if Result /= 0 then
				from i := 1 until i > n loop
					Result := Result * a [i, i]
					i := i + 1
				end
				Result := Result * sign
			end
		end

	permanent_recursive (m: ARRAY2 [REAL_64]; row: INTEGER; used: ARRAY [BOOLEAN]): REAL_64
			-- Recursive permanent calculation
		local
			col: INTEGER
		do
			if row > m.height then
				Result := 1
			else
				from col := 1 until col > m.width loop
					if not used [col] then
						used [col] := True
						Result := Result + m [row, col] * permanent_recursive (m, row + 1, used)
						used [col] := False
					end
					col := col + 1
				end
			end
		end

	matrix_copy (m: ARRAY2 [REAL_64]): ARRAY2 [REAL_64]
			-- Create a copy of matrix m
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
			m: ARRAY2 [REAL_64]
		do
			print ("Determinant Demo:%N%N")

			-- 2x2 matrix
			create m.make_filled (0, 2, 2)
			m [1, 1] := 1; m [1, 2] := 2
			m [2, 1] := 3; m [2, 2] := 4
			print ("2x2 Matrix: det = " + determinant (m).out + " (expected: -2)%N")

			-- 3x3 matrix
			create m.make_filled (0, 3, 3)
			m [1, 1] := 1; m [1, 2] := 2; m [1, 3] := 3
			m [2, 1] := 4; m [2, 2] := 5; m [2, 3] := 6
			m [3, 1] := 7; m [3, 2] := 8; m [3, 3] := 9
			print ("3x3 Matrix: det = " + determinant (m).out + " (expected: 0)%N")

			-- 4x4 matrix
			create m.make_filled (0, 4, 4)
			m [1, 1] := 1; m [1, 2] := 2; m [1, 3] := 3; m [1, 4] := 4
			m [2, 1] := 5; m [2, 2] := 6; m [2, 3] := 7; m [2, 4] := 8
			m [3, 1] := 2; m [3, 2] := 6; m [3, 3] := 4; m [3, 4] := 8
			m [4, 1] := 3; m [4, 2] := 1; m [4, 3] := 1; m [4, 4] := 2
			print ("4x4 Matrix: det = " + determinant (m).out + "%N")

			-- Permanent
			create m.make_filled (0, 3, 3)
			m [1, 1] := 1; m [1, 2] := 2; m [1, 3] := 3
			m [2, 1] := 4; m [2, 2] := 5; m [2, 3] := 6
			m [3, 1] := 7; m [3, 2] := 8; m [3, 3] := 9
			print ("%N3x3 Matrix permanent = " + permanent (m).out + " (expected: 450)%N")
		end

end
