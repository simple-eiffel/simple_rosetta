note
	description: "[
		Rosetta Code: Matrix multiplication
		https://rosettacode.org/wiki/Matrix_multiplication

		Multiply two matrices using standard O(n^3) algorithm.
	]"

class
	MATRIX_MULTIPLICATION

feature -- Operations

	multiply (a, b: ARRAY2 [REAL_64]): ARRAY2 [REAL_64]
			-- Multiply matrix a by matrix b
		require
			compatible: a.width = b.height
		local
			i, j, k: INTEGER
			sum: REAL_64
		do
			create Result.make_filled (0, a.height, b.width)

			from i := 1 until i > a.height loop
				from j := 1 until j > b.width loop
					sum := 0
					from k := 1 until k > a.width loop
						sum := sum + a [i, k] * b [k, j]
						k := k + 1
					end
					Result [i, j] := sum
					j := j + 1
				end
				i := i + 1
			end
		ensure
			correct_height: Result.height = a.height
			correct_width: Result.width = b.width
		end

	multiply_vector (matrix: ARRAY2 [REAL_64]; vector: ARRAY [REAL_64]): ARRAY [REAL_64]
			-- Multiply matrix by column vector
		require
			compatible: matrix.width = vector.count
		local
			i, j: INTEGER
			sum: REAL_64
		do
			create Result.make_filled (0, 1, matrix.height)

			from i := 1 until i > matrix.height loop
				sum := 0
				from j := 1 until j > matrix.width loop
					sum := sum + matrix [i, j] * vector [j]
					j := j + 1
				end
				Result [i] := sum
				i := i + 1
			end
		ensure
			correct_size: Result.count = matrix.height
		end

	scalar_multiply (matrix: ARRAY2 [REAL_64]; scalar: REAL_64): ARRAY2 [REAL_64]
			-- Multiply matrix by scalar
		local
			i, j: INTEGER
		do
			create Result.make_filled (0, matrix.height, matrix.width)
			from i := 1 until i > matrix.height loop
				from j := 1 until j > matrix.width loop
					Result [i, j] := matrix [i, j] * scalar
					j := j + 1
				end
				i := i + 1
			end
		end

feature -- Utility

	identity_matrix (n: INTEGER): ARRAY2 [REAL_64]
			-- n x n identity matrix
		require
			positive: n > 0
		local
			i: INTEGER
		do
			create Result.make_filled (0, n, n)
			from i := 1 until i > n loop
				Result [i, i] := 1
				i := i + 1
			end
		end

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
			a, b, c: ARRAY2 [REAL_64]
		do
			print ("Matrix Multiplication Demo:%N%N")

			create a.make_filled (0, 2, 3)
			a [1, 1] := 1; a [1, 2] := 2; a [1, 3] := 3
			a [2, 1] := 4; a [2, 2] := 5; a [2, 3] := 6

			create b.make_filled (0, 3, 2)
			b [1, 1] := 7; b [1, 2] := 8
			b [2, 1] := 9; b [2, 2] := 10
			b [3, 1] := 11; b [3, 2] := 12

			print ("Matrix A (2x3):%N")
			print (matrix_to_string (a))

			print ("%NMatrix B (3x2):%N")
			print (matrix_to_string (b))

			c := multiply (a, b)
			print ("%NA * B (2x2):%N")
			print (matrix_to_string (c))
		end

end
