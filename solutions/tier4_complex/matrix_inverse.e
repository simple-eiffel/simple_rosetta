note
	description: "[
		Rosetta Code: Gauss-Jordan matrix inversion
		https://rosettacode.org/wiki/Gauss-Jordan_matrix_inversion

		Compute the inverse of a square matrix using Gauss-Jordan elimination.
	]"

class
	MATRIX_INVERSE

feature -- Operations

	inverse (m: ARRAY2 [REAL_64]): detachable ARRAY2 [REAL_64]
			-- Inverse of matrix m, or Void if singular
		require
			is_square: m.height = m.width
		local
			aug: ARRAY2 [REAL_64]
			n, i, j, k, pivot_row: INTEGER
			max_val, temp, factor: REAL_64
		do
			n := m.height

			-- Create augmented matrix [m | I]
			create aug.make_filled (0, n, 2 * n)
			from i := 1 until i > n loop
				from j := 1 until j > n loop
					aug [i, j] := m [i, j]
					j := j + 1
				end
				aug [i, n + i] := 1
				i := i + 1
			end

			-- Forward elimination with partial pivoting
			from k := 1 until k > n loop
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
					-- Singular matrix
					Result := Void
					k := n + 1  -- Exit
				else
					-- Swap rows if needed
					if pivot_row /= k then
						from j := 1 until j > 2 * n loop
							temp := aug [k, j]
							aug [k, j] := aug [pivot_row, j]
							aug [pivot_row, j] := temp
							j := j + 1
						end
					end

					-- Scale pivot row
					factor := aug [k, k]
					from j := 1 until j > 2 * n loop
						aug [k, j] := aug [k, j] / factor
						j := j + 1
					end

					-- Eliminate column
					from i := 1 until i > n loop
						if i /= k then
							factor := aug [i, k]
							from j := 1 until j > 2 * n loop
								aug [i, j] := aug [i, j] - factor * aug [k, j]
								j := j + 1
							end
						end
						i := i + 1
					end
					k := k + 1
				end
			end

			-- Extract inverse from augmented matrix
			if Result /= Void or k <= n then
				-- k > n means we didn't hit singular
				if k > n then
					create Result.make_filled (0, n, n)
					from i := 1 until i > n loop
						from j := 1 until j > n loop
							Result [i, j] := aug [i, n + j]
							j := j + 1
						end
						i := i + 1
					end
				end
			end
		end

	is_invertible (m: ARRAY2 [REAL_64]): BOOLEAN
			-- Is matrix invertible?
		require
			is_square: m.height = m.width
		do
			Result := inverse (m) /= Void
		end

feature -- Verification

	multiply (a, b: ARRAY2 [REAL_64]): ARRAY2 [REAL_64]
			-- Multiply two matrices
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
		end

feature -- Utility

	matrix_to_string (m: ARRAY2 [REAL_64]): STRING
			-- Convert matrix to string
		local
			i, j: INTEGER
			val: REAL_64
		do
			create Result.make (m.height * m.width * 12)
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
			m, inv, product: ARRAY2 [REAL_64]
		do
			print ("Matrix Inverse (Gauss-Jordan) Demo:%N%N")

			create m.make_filled (0, 3, 3)
			m [1, 1] := 1; m [1, 2] := 2; m [1, 3] := 3
			m [2, 1] := 0; m [2, 2] := 1; m [2, 3] := 4
			m [3, 1] := 5; m [3, 2] := 6; m [3, 3] := 0

			print ("Original matrix:%N")
			print (matrix_to_string (m))

			if attached inverse (m) as result_inv then
				inv := result_inv
				print ("Inverse:%N")
				print (matrix_to_string (inv))

				product := multiply (m, inv)
				print ("M * M^-1 (should be identity):%N")
				print (matrix_to_string (product))
			else
				print ("Matrix is singular (no inverse)%N")
			end

			-- Test singular matrix
			print ("%NSingular matrix test:%N")
			create m.make_filled (0, 2, 2)
			m [1, 1] := 1; m [1, 2] := 2
			m [2, 1] := 2; m [2, 2] := 4
			print (matrix_to_string (m))
			print ("Is invertible: " + is_invertible (m).out + "%N")
		end

end
