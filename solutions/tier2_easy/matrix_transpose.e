note
	description: "[
		Rosetta Code: Matrix transposition
		https://rosettacode.org/wiki/Matrix_transposition

		Transpose a matrix (swap rows and columns).
	]"

class
	MATRIX_TRANSPOSE

feature -- Operations

	transpose (m: ARRAY2 [REAL_64]): ARRAY2 [REAL_64]
			-- Transpose of matrix m
		local
			i, j: INTEGER
		do
			create Result.make_filled (0, m.width, m.height)
			from i := 1 until i > m.height loop
				from j := 1 until j > m.width loop
					Result [j, i] := m [i, j]
					j := j + 1
				end
				i := i + 1
			end
		ensure
			height_swapped: Result.height = m.width
			width_swapped: Result.width = m.height
		end

	transpose_in_place (m: ARRAY2 [REAL_64])
			-- Transpose square matrix in place
		require
			is_square: m.height = m.width
		local
			i, j: INTEGER
			temp: REAL_64
		do
			from i := 1 until i > m.height loop
				from j := i + 1 until j > m.width loop
					temp := m [i, j]
					m [i, j] := m [j, i]
					m [j, i] := temp
					j := j + 1
				end
				i := i + 1
			end
		end

feature -- Query

	is_symmetric (m: ARRAY2 [REAL_64]): BOOLEAN
			-- Is matrix symmetric (equal to its transpose)?
		require
			is_square: m.height = m.width
		local
			i, j: INTEGER
		do
			Result := True
			from i := 1 until i > m.height or not Result loop
				from j := i + 1 until j > m.width loop
					if m [i, j] /= m [j, i] then
						Result := False
					end
					j := j + 1
				end
				i := i + 1
			end
		end

	is_skew_symmetric (m: ARRAY2 [REAL_64]): BOOLEAN
			-- Is matrix skew-symmetric (A^T = -A)?
		require
			is_square: m.height = m.width
		local
			i, j: INTEGER
		do
			Result := True
			from i := 1 until i > m.height or not Result loop
				from j := 1 until j > m.width loop
					if i = j then
						if m [i, j] /= 0 then
							Result := False
						end
					elseif m [i, j] /= -m [j, i] then
						Result := False
					end
					j := j + 1
				end
				i := i + 1
			end
		end

feature -- Utility

	matrix_to_string (m: ARRAY2 [REAL_64]): STRING
			-- Convert matrix to string representation
		local
			i, j: INTEGER
		do
			create Result.make (m.height * m.width * 10)
			from i := 1 until i > m.height loop
				Result.append ("[ ")
				from j := 1 until j > m.width loop
					Result.append (m [i, j].out)
					if j < m.width then
						Result.append (", ")
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
			m, t: ARRAY2 [REAL_64]
		do
			print ("Matrix Transposition Demo:%N%N")

			create m.make_filled (0, 2, 3)
			m [1, 1] := 1; m [1, 2] := 2; m [1, 3] := 3
			m [2, 1] := 4; m [2, 2] := 5; m [2, 3] := 6

			print ("Original (2x3):%N")
			print (matrix_to_string (m))

			t := transpose (m)
			print ("Transposed (3x2):%N")
			print (matrix_to_string (t))

			-- Symmetric matrix test
			create m.make_filled (0, 3, 3)
			m [1, 1] := 1; m [1, 2] := 2; m [1, 3] := 3
			m [2, 1] := 2; m [2, 2] := 4; m [2, 3] := 5
			m [3, 1] := 3; m [3, 2] := 5; m [3, 3] := 6

			print ("Symmetric matrix:%N")
			print (matrix_to_string (m))
			print ("Is symmetric: " + is_symmetric (m).out + "%N")
		end

end
