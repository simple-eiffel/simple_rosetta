note
	description: "[
		Rosetta Code: Eigenvalue computation
		https://rosettacode.org/wiki/Eigenvalue

		Compute eigenvalues using power iteration and QR algorithm.
	]"

class
	EIGENVALUES

feature -- Operations

	power_iteration (m: ARRAY2 [REAL_64]; max_iterations: INTEGER; tolerance: REAL_64): TUPLE [eigenvalue: REAL_64; eigenvector: ARRAY [REAL_64]]
			-- Find dominant eigenvalue and eigenvector using power iteration
		require
			is_square: m.height = m.width
		local
			n, iter: INTEGER
			v, w: ARRAY [REAL_64]
			lambda, prev_lambda: REAL_64
		do
			n := m.height

			-- Initialize with random vector
			create v.make_filled (1, 1, n)
			v := normalize (v)
			lambda := 0

			from iter := 1 until iter > max_iterations loop
				prev_lambda := lambda

				-- w = Av
				w := matrix_vector_multiply (m, v)

				-- Compute eigenvalue (Rayleigh quotient)
				lambda := dot_product (v, w)

				-- Normalize
				v := normalize (w)

				-- Check convergence
				if (lambda - prev_lambda).abs < tolerance then
					iter := max_iterations + 1
				end
				iter := iter + 1
			end

			Result := [lambda, v]
		end

	eigenvalues_2x2 (m: ARRAY2 [REAL_64]): ARRAY [REAL_64]
			-- Eigenvalues of 2x2 matrix using characteristic equation
		require
			is_2x2: m.height = 2 and m.width = 2
		local
			a, b, c, d, trace, det, discriminant, sqrt_disc: REAL_64
			math: SIMPLE_MATH
		do
			create math.make
			a := m [1, 1]
			b := m [1, 2]
			c := m [2, 1]
			d := m [2, 2]

			trace := a + d
			det := a * d - b * c
			discriminant := trace * trace - 4 * det

			create Result.make_filled (0, 1, 2)
			if discriminant >= 0 then
				sqrt_disc := math.sqrt (discriminant)
				Result [1] := (trace + sqrt_disc) / 2
				Result [2] := (trace - sqrt_disc) / 2
			else
				-- Complex eigenvalues - return real parts
				Result [1] := trace / 2
				Result [2] := trace / 2
			end
		end

	eigenvalues_qr (m: ARRAY2 [REAL_64]; max_iterations: INTEGER; tolerance: REAL_64): ARRAY [REAL_64]
			-- Eigenvalues using QR iteration (for small matrices)
		require
			is_square: m.height = m.width
		local
			a: ARRAY2 [REAL_64]
			n, i, iter: INTEGER
			converged: BOOLEAN
			prev_diag: ARRAY [REAL_64]
		do
			n := m.height
			a := matrix_copy (m)
			create prev_diag.make_filled (0, 1, n)

			from iter := 1 until iter > max_iterations or converged loop
				-- Save previous diagonal
				from i := 1 until i > n loop
					prev_diag [i] := a [i, i]
					i := i + 1
				end

				-- QR decomposition
				qr_decompose (a)

				-- A = RQ (multiply in reverse order)
				if attached r_matrix as r and attached q_matrix as q then
					a := matrix_multiply (r, q)
				end

				-- Check convergence
				converged := True
				from i := 1 until i > n loop
					if (a [i, i] - prev_diag [i]).abs > tolerance then
						converged := False
					end
					i := i + 1
				end
				iter := iter + 1
			end

			-- Extract diagonal (eigenvalues)
			create Result.make_filled (0, 1, n)
			from i := 1 until i > n loop
				Result [i] := a [i, i]
				i := i + 1
			end
		end

feature {NONE} -- Implementation

	q_matrix, r_matrix: detachable ARRAY2 [REAL_64]
			-- Temporary storage for QR decomposition

	qr_decompose (a: ARRAY2 [REAL_64])
			-- QR decomposition using Gram-Schmidt
		local
			n, i, j, k: INTEGER
			dot, norm: REAL_64
			math: SIMPLE_MATH
			q, r: ARRAY2 [REAL_64]
		do
			create math.make
			n := a.height
			create q.make_filled (0, n, n)
			create r.make_filled (0, n, n)

			from k := 1 until k > n loop
				-- Copy column k of A to Q
				from i := 1 until i > n loop
					q [i, k] := a [i, k]
					i := i + 1
				end

				-- Orthogonalize against previous columns
				from j := 1 until j >= k loop
					dot := 0
					from i := 1 until i > n loop
						dot := dot + q [i, j] * a [i, k]
						i := i + 1
					end
					r [j, k] := dot
					from i := 1 until i > n loop
						q [i, k] := q [i, k] - dot * q [i, j]
						i := i + 1
					end
					j := j + 1
				end

				-- Normalize
				norm := 0
				from i := 1 until i > n loop
					norm := norm + q [i, k] * q [i, k]
					i := i + 1
				end
				norm := math.sqrt (norm)
				r [k, k] := norm
				if norm > 1.0e-10 then
					from i := 1 until i > n loop
						q [i, k] := q [i, k] / norm
						i := i + 1
					end
				end
				k := k + 1
			end
			q_matrix := q
			r_matrix := r
		end

	matrix_vector_multiply (m: ARRAY2 [REAL_64]; v: ARRAY [REAL_64]): ARRAY [REAL_64]
		local
			i, j: INTEGER
			sum: REAL_64
		do
			create Result.make_filled (0, 1, m.height)
			from i := 1 until i > m.height loop
				sum := 0
				from j := 1 until j > m.width loop
					sum := sum + m [i, j] * v [j]
					j := j + 1
				end
				Result [i] := sum
				i := i + 1
			end
		end

	matrix_multiply (a, b: ARRAY2 [REAL_64]): ARRAY2 [REAL_64]
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

	normalize (v: ARRAY [REAL_64]): ARRAY [REAL_64]
		local
			norm: REAL_64
			i: INTEGER
			math: SIMPLE_MATH
		do
			create math.make
			norm := 0
			from i := v.lower until i > v.upper loop
				norm := norm + v [i] * v [i]
				i := i + 1
			end
			norm := math.sqrt (norm)

			create Result.make_filled (0, v.lower, v.upper)
			if norm > 1.0e-10 then
				from i := v.lower until i > v.upper loop
					Result [i] := v [i] / norm
					i := i + 1
				end
			end
		end

	dot_product (a, b: ARRAY [REAL_64]): REAL_64
		local
			i: INTEGER
		do
			from i := a.lower until i > a.upper loop
				Result := Result + a [i] * b [i]
				i := i + 1
			end
		end

feature -- Demo

	demo
			-- Standard Rosetta Code demo
		local
			m: ARRAY2 [REAL_64]
			result_tuple: TUPLE [eigenvalue: REAL_64; eigenvector: ARRAY [REAL_64]]
			eigs: ARRAY [REAL_64]
		do
			print ("Eigenvalue Computation Demo:%N%N")

			-- 2x2 matrix
			create m.make_filled (0, 2, 2)
			m [1, 1] := 4; m [1, 2] := 1
			m [2, 1] := 2; m [2, 2] := 3

			print ("2x2 Matrix:%N")
			print ("[ 4  1 ]%N[ 2  3 ]%N%N")

			eigs := eigenvalues_2x2 (m)
			print ("Eigenvalues (closed form): " + eigs [1].out + ", " + eigs [2].out + "%N")
			print ("(Expected: 5, 2)%N%N")

			-- Power iteration
			result_tuple := power_iteration (m, 100, 1.0e-6)
			print ("Power iteration:%N")
			print ("  Dominant eigenvalue: " + result_tuple.eigenvalue.out + "%N")
			print ("  Eigenvector: [" + result_tuple.eigenvector [1].out + ", " + result_tuple.eigenvector [2].out + "]%N")
		end

end
