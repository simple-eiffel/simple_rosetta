note
	description: "[
		Rosetta Code: LU decomposition
		https://rosettacode.org/wiki/LU_decomposition

		Factor matrix A into lower (L) and upper (U) triangular matrices.
		With pivoting: PA = LU
	]"

class
	LU_DECOMPOSITION

feature -- Decomposition

	decompose (a: ARRAY2 [REAL_64]): TUPLE [l, u, p: ARRAY2 [REAL_64]]
			-- LU decomposition with partial pivoting
		require
			is_square: a.height = a.width
		local
			n, i, j, k, pivot_row: INTEGER
			l, u, p: ARRAY2 [REAL_64]
			working: ARRAY2 [REAL_64]
			max_val, temp: REAL_64
		do
			n := a.height

			-- Initialize
			create l.make_filled (0, n, n)
			create u.make_filled (0, n, n)
			create p.make_filled (0, n, n)
			working := matrix_copy (a)

			-- Initialize P as identity
			from i := 1 until i > n loop
				p [i, i] := 1
				i := i + 1
			end

			from k := 1 until k > n loop
				-- Find pivot
				max_val := working [k, k].abs
				pivot_row := k
				from i := k + 1 until i > n loop
					if working [i, k].abs > max_val then
						max_val := working [i, k].abs
						pivot_row := i
					end
					i := i + 1
				end

				-- Swap rows in working, P, and L
				if pivot_row /= k then
					from j := 1 until j > n loop
						temp := working [k, j]
						working [k, j] := working [pivot_row, j]
						working [pivot_row, j] := temp

						temp := p [k, j]
						p [k, j] := p [pivot_row, j]
						p [pivot_row, j] := temp

						if j < k then
							temp := l [k, j]
							l [k, j] := l [pivot_row, j]
							l [pivot_row, j] := temp
						end
						j := j + 1
					end
				end

				-- Compute L and U for this column
				l [k, k] := 1
				from j := k until j > n loop
					u [k, j] := working [k, j]
					j := j + 1
				end

				from i := k + 1 until i > n loop
					if u [k, k].abs > 1.0e-10 then
						l [i, k] := working [i, k] / u [k, k]
						from j := k until j > n loop
							working [i, j] := working [i, j] - l [i, k] * u [k, j]
							j := j + 1
						end
					end
					i := i + 1
				end
				k := k + 1
			end

			Result := [l, u, p]
		end

	solve (a: ARRAY2 [REAL_64]; b: ARRAY [REAL_64]): ARRAY [REAL_64]
			-- Solve Ax = b using LU decomposition
		require
			is_square: a.height = a.width
			compatible: a.height = b.count
		local
			lu_result: TUPLE [l, u, p: ARRAY2 [REAL_64]]
			l, u, p: ARRAY2 [REAL_64]
			pb, y: ARRAY [REAL_64]
			n, i, j: INTEGER
			sum: REAL_64
		do
			n := a.height
			lu_result := decompose (a)
			l := lu_result.l
			u := lu_result.u
			p := lu_result.p

			-- Compute Pb
			create pb.make_filled (0, 1, n)
			from i := 1 until i > n loop
				from j := 1 until j > n loop
					pb [i] := pb [i] + p [i, j] * b [j]
					j := j + 1
				end
				i := i + 1
			end

			-- Forward substitution: Ly = Pb
			create y.make_filled (0, 1, n)
			from i := 1 until i > n loop
				sum := pb [i]
				from j := 1 until j >= i loop
					sum := sum - l [i, j] * y [j]
					j := j + 1
				end
				y [i] := sum / l [i, i]
				i := i + 1
			end

			-- Back substitution: Ux = y
			create Result.make_filled (0, 1, n)
			from i := n until i < 1 loop
				sum := y [i]
				from j := i + 1 until j > n loop
					sum := sum - u [i, j] * Result [j]
					j := j + 1
				end
				if u [i, i].abs > 1.0e-10 then
					Result [i] := sum / u [i, i]
				end
				i := i - 1
			end
		end

feature {NONE} -- Implementation

	matrix_copy (m: ARRAY2 [REAL_64]): ARRAY2 [REAL_64]
			-- Create copy of matrix
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
			-- Convert matrix to string
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
			lu_result: TUPLE [l, u, p: ARRAY2 [REAL_64]]
		do
			print ("LU Decomposition Demo:%N%N")

			create a.make_filled (0, 3, 3)
			a [1, 1] := 1; a [1, 2] := 3; a [1, 3] := 5
			a [2, 1] := 2; a [2, 2] := 4; a [2, 3] := 7
			a [3, 1] := 1; a [3, 2] := 1; a [3, 3] := 0

			print ("Matrix A:%N")
			print (matrix_to_string (a))

			lu_result := decompose (a)

			print ("L (lower triangular):%N")
			print (matrix_to_string (lu_result.l))

			print ("U (upper triangular):%N")
			print (matrix_to_string (lu_result.u))

			print ("P (permutation):%N")
			print (matrix_to_string (lu_result.p))

			-- Solve system
			print ("%NSolving Ax = b where b = [1, 2, 3]:%N")
			b := <<1.0, 2.0, 3.0>>
			x := solve (a, b)
			print ("x = [")
			across x as xi loop
				print (xi.truncated_to_real.out)
				if not (@ xi.target_index = x.upper) then
					print (", ")
				end
			end
			print ("]%N")
		end

end
