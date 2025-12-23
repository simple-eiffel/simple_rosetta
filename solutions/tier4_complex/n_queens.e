note
	description: "[
		Rosetta Code: N-queens problem
		https://rosettacode.org/wiki/N-queens_problem

		Place N queens on an NxN chessboard so no two attack each other.
	]"

class
	N_QUEENS

feature -- Operations

	solve (n: INTEGER): ARRAYED_LIST [ARRAY [INTEGER]]
			-- Find all solutions for N queens
		require
			valid_n: n >= 1
		local
			board: ARRAY [INTEGER]
		do
			create Result.make (0)
			create board.make_filled (0, 1, n)
			solve_recursive (board, 1, n, Result)
		end

	solve_one (n: INTEGER): detachable ARRAY [INTEGER]
			-- Find one solution for N queens
		require
			valid_n: n >= 1
		local
			board: ARRAY [INTEGER]
		do
			create board.make_filled (0, 1, n)
			Result := solve_first (board, 1, n)
		end

	count_solutions (n: INTEGER): INTEGER
			-- Count total number of solutions
		require
			valid_n: n >= 1
		local
			board: ARRAY [INTEGER]
		do
			create board.make_filled (0, 1, n)
			Result := count_recursive (board, 1, n)
		end

feature {NONE} -- Implementation

	solve_recursive (board: ARRAY [INTEGER]; row, n: INTEGER; solutions: ARRAYED_LIST [ARRAY [INTEGER]])
			-- Backtracking solver
		local
			col: INTEGER
		do
			if row > n then
				solutions.extend (board.twin)
			else
				from col := 1 until col > n loop
					if is_safe (board, row, col) then
						board [row] := col
						solve_recursive (board, row + 1, n, solutions)
						board [row] := 0
					end
					col := col + 1
				end
			end
		end

	solve_first (board: ARRAY [INTEGER]; row, n: INTEGER): detachable ARRAY [INTEGER]
			-- Find first solution
		local
			col: INTEGER
		do
			if row > n then
				Result := board.twin
			else
				from col := 1 until col > n or Result /= Void loop
					if is_safe (board, row, col) then
						board [row] := col
						Result := solve_first (board, row + 1, n)
						if Result = Void then
							board [row] := 0
						end
					end
					col := col + 1
				end
			end
		end

	count_recursive (board: ARRAY [INTEGER]; row, n: INTEGER): INTEGER
			-- Count solutions without storing them
		local
			col: INTEGER
		do
			if row > n then
				Result := 1
			else
				from col := 1 until col > n loop
					if is_safe (board, row, col) then
						board [row] := col
						Result := Result + count_recursive (board, row + 1, n)
						board [row] := 0
					end
					col := col + 1
				end
			end
		end

	is_safe (board: ARRAY [INTEGER]; row, col: INTEGER): BOOLEAN
			-- Can a queen be placed at (row, col)?
		local
			i: INTEGER
		do
			Result := True
			from i := 1 until i >= row or not Result loop
				if board [i] = col then
					Result := False
				elseif (board [i] - col).abs = (i - row).abs then
					Result := False
				end
				i := i + 1
			end
		end

feature -- Output

	board_to_string (solution: ARRAY [INTEGER]): STRING
			-- Visual representation of board
		local
			row, col, n: INTEGER
		do
			n := solution.count
			create Result.make (n * (n + 1))
			from row := 1 until row > n loop
				from col := 1 until col > n loop
					if solution [row] = col then
						Result.append_character ('Q')
					else
						Result.append_character ('.')
					end
				end
				Result.append_character ('%N')
				row := row + 1
			end
		end

feature -- Demo

	demo
			-- Standard Rosetta Code demo
		local
			solutions: ARRAYED_LIST [ARRAY [INTEGER]]
		do
			print ("N-Queens Problem Demo:%N%N")

			-- 8 queens
			print ("8-Queens: " + count_solutions (8).out + " solutions%N%N")

			-- Show first solution
			if attached solve_one (8) as sol then
				print ("First 8-Queens solution:%N")
				print (board_to_string (sol))
			end

			-- Small example: 4 queens
			print ("%N4-Queens: " + count_solutions (4).out + " solutions%N")
			solutions := solve (4)
			print ("All 4-Queens solutions:%N")
			across solutions as s loop
				print (board_to_string (s))
				print ("%N")
			end
		end

end
