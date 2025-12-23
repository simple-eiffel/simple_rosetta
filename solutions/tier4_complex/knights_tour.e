note
	description: "[
		Rosetta Code: Knight's tour
		https://rosettacode.org/wiki/Knight%27s_tour

		Find a path for a knight to visit every square exactly once.
	]"

class
	KNIGHTS_TOUR

feature -- Operations

	solve (n: INTEGER; start_row, start_col: INTEGER): detachable ARRAY2 [INTEGER]
			-- Find knight's tour starting from given position
		require
			valid_size: n >= 5
			valid_start: start_row >= 1 and start_row <= n and start_col >= 1 and start_col <= n
		local
			board: ARRAY2 [INTEGER]
		do
			create board.make_filled (0, n, n)
			board [start_row, start_col] := 1
			if solve_warnsdorff (board, start_row, start_col, 2) then
				Result := board
			end
		end

	solve_closed (n: INTEGER): detachable ARRAY2 [INTEGER]
			-- Find closed tour (returns to start)
		require
			valid_size: n >= 6 and n \\ 2 = 0
		local
			board: ARRAY2 [INTEGER]
		do
			create board.make_filled (0, n, n)
			board [1, 1] := 1
			if solve_closed_recursive (board, 1, 1, 2) then
				Result := board
			end
		end

feature {NONE} -- Implementation

	row_moves: ARRAY [INTEGER]
		once
			Result := <<-2, -1, 1, 2, 2, 1, -1, -2>>
		end

	col_moves: ARRAY [INTEGER]
		once
			Result := <<1, 2, 2, 1, -1, -2, -2, -1>>
		end

	solve_warnsdorff (board: ARRAY2 [INTEGER]; row, col, move_num: INTEGER): BOOLEAN
			-- Warnsdorff's heuristic: choose move with fewest onward moves
		local
			n, i, next_row, next_col: INTEGER
			min_degree, degree: INTEGER
			best_row, best_col: INTEGER
			candidates: ARRAYED_LIST [TUPLE [r, c, d: INTEGER]]
		do
			n := board.height
			if move_num > n * n then
				Result := True
			else
				create candidates.make (8)

				-- Collect all valid moves with their degrees
				from i := 1 until i > 8 loop
					next_row := row + row_moves [i]
					next_col := col + col_moves [i]
					if is_valid_move (board, next_row, next_col) then
						degree := count_onward_moves (board, next_row, next_col)
						candidates.extend ([next_row, next_col, degree])
					end
					i := i + 1
				end

				-- Sort by degree (Warnsdorff's rule)
				sort_by_degree (candidates)

				-- Try moves in order of increasing degree
				across candidates as c until Result loop
					board [c.r, c.c] := move_num
					if solve_warnsdorff (board, c.r, c.c, move_num + 1) then
						Result := True
					else
						board [c.r, c.c] := 0
					end
				end
			end
		end

	solve_closed_recursive (board: ARRAY2 [INTEGER]; row, col, move_num: INTEGER): BOOLEAN
			-- Find closed tour
		local
			n, i, next_row, next_col: INTEGER
		do
			n := board.height
			if move_num > n * n then
				-- Check if we can return to start
				from i := 1 until i > 8 or Result loop
					next_row := row + row_moves [i]
					next_col := col + col_moves [i]
					if next_row = 1 and next_col = 1 then
						Result := True
					end
					i := i + 1
				end
			else
				from i := 1 until i > 8 or Result loop
					next_row := row + row_moves [i]
					next_col := col + col_moves [i]
					if is_valid_move (board, next_row, next_col) then
						board [next_row, next_col] := move_num
						if solve_closed_recursive (board, next_row, next_col, move_num + 1) then
							Result := True
						else
							board [next_row, next_col] := 0
						end
					end
					i := i + 1
				end
			end
		end

	is_valid_move (board: ARRAY2 [INTEGER]; row, col: INTEGER): BOOLEAN
			-- Is this a valid unvisited square?
		do
			Result := row >= 1 and row <= board.height and
					  col >= 1 and col <= board.width and then
					  board [row, col] = 0
		end

	count_onward_moves (board: ARRAY2 [INTEGER]; row, col: INTEGER): INTEGER
			-- Count valid moves from this position
		local
			i, next_row, next_col: INTEGER
		do
			from i := 1 until i > 8 loop
				next_row := row + row_moves [i]
				next_col := col + col_moves [i]
				if is_valid_move (board, next_row, next_col) then
					Result := Result + 1
				end
				i := i + 1
			end
		end

	sort_by_degree (list: ARRAYED_LIST [TUPLE [r, c, d: INTEGER]])
			-- Simple insertion sort by degree
		local
			i, j: INTEGER
			temp: TUPLE [r, c, d: INTEGER]
		do
			from i := 2 until i > list.count loop
				temp := list [i]
				from j := i until j <= 1 or else list [j - 1].d <= temp.d loop
					list [j] := list [j - 1]
					j := j - 1
				end
				list [j] := temp
				i := i + 1
			end
		end

feature -- Output

	board_to_string (board: ARRAY2 [INTEGER]): STRING
			-- Pretty print board
		local
			row, col, n: INTEGER
		do
			n := board.height
			create Result.make (n * n * 4)
			from row := 1 until row > n loop
				from col := 1 until col > n loop
					if board [row, col] < 10 then
						Result.append_character (' ')
					end
					Result.append_integer (board [row, col])
					Result.append_character (' ')
					col := col + 1
				end
				Result.append_character ('%N')
				row := row + 1
			end
		end

feature -- Demo

	demo
			-- Standard Rosetta Code demo
		do
			print ("Knight's Tour Demo:%N%N")

			if attached solve (8, 1, 1) as tour then
				print ("8x8 Knight's Tour starting at (1,1):%N")
				print (board_to_string (tour))
			else
				print ("No solution found%N")
			end

			print ("%N5x5 Tour starting at (1,1):%N")
			if attached solve (5, 1, 1) as tour5 then
				print (board_to_string (tour5))
			else
				print ("No solution found%N")
			end
		end

end
