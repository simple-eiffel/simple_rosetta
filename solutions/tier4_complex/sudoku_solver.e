note
	description: "[
		Rosetta Code: Sudoku
		https://rosettacode.org/wiki/Sudoku

		Solve a standard 9x9 Sudoku puzzle using backtracking.
	]"

class
	SUDOKU_SOLVER

feature -- Operations

	solve (grid: ARRAY2 [INTEGER]): BOOLEAN
			-- Solve sudoku in place, return True if solvable
		require
			valid_size: grid.height = 9 and grid.width = 9
		do
			Result := solve_recursive (grid)
		end

	is_valid (grid: ARRAY2 [INTEGER]): BOOLEAN
			-- Is the current grid state valid?
		require
			valid_size: grid.height = 9 and grid.width = 9
		local
			row, col: INTEGER
		do
			Result := True
			from row := 1 until row > 9 or not Result loop
				from col := 1 until col > 9 or not Result loop
					if grid [row, col] /= 0 then
						Result := is_valid_placement (grid, row, col, grid [row, col], True)
					end
					col := col + 1
				end
				row := row + 1
			end
		end

feature {NONE} -- Implementation

	solve_recursive (grid: ARRAY2 [INTEGER]): BOOLEAN
			-- Backtracking solver
		local
			row, col, num: INTEGER
			empty_found: BOOLEAN
			empty_row, empty_col: INTEGER
		do
			-- Find empty cell
			from row := 1 until row > 9 or empty_found loop
				from col := 1 until col > 9 or empty_found loop
					if grid [row, col] = 0 then
						empty_found := True
						empty_row := row
						empty_col := col
					end
					col := col + 1
				end
				row := row + 1
			end

			if not empty_found then
				-- All cells filled
				Result := True
			else
				-- Try each number
				from num := 1 until num > 9 or Result loop
					if is_valid_placement (grid, empty_row, empty_col, num, False) then
						grid [empty_row, empty_col] := num
						if solve_recursive (grid) then
							Result := True
						else
							grid [empty_row, empty_col] := 0
						end
					end
					num := num + 1
				end
			end
		end

	is_valid_placement (grid: ARRAY2 [INTEGER]; row, col, num: INTEGER; skip_self: BOOLEAN): BOOLEAN
			-- Can num be placed at (row, col)?
		local
			i, j, box_row, box_col: INTEGER
		do
			Result := True

			-- Check row
			from i := 1 until i > 9 or not Result loop
				if i /= col or not skip_self then
					if grid [row, i] = num and (i /= col or not skip_self) then
						Result := False
					end
				end
				i := i + 1
			end

			-- Check column
			if Result then
				from i := 1 until i > 9 or not Result loop
					if i /= row or not skip_self then
						if grid [i, col] = num and (i /= row or not skip_self) then
							Result := False
						end
					end
					i := i + 1
				end
			end

			-- Check 3x3 box
			if Result then
				box_row := ((row - 1) // 3) * 3 + 1
				box_col := ((col - 1) // 3) * 3 + 1
				from i := box_row until i > box_row + 2 or not Result loop
					from j := box_col until j > box_col + 2 or not Result loop
						if (i /= row or j /= col) or not skip_self then
							if grid [i, j] = num and ((i /= row or j /= col) or not skip_self) then
								Result := False
							end
						end
						j := j + 1
					end
					i := i + 1
				end
			end
		end

feature -- Output

	grid_to_string (grid: ARRAY2 [INTEGER]): STRING
			-- Pretty print grid
		local
			row, col: INTEGER
		do
			create Result.make (200)
			from row := 1 until row > 9 loop
				if row = 4 or row = 7 then
					Result.append ("------+-------+------%N")
				end
				from col := 1 until col > 9 loop
					if col = 4 or col = 7 then
						Result.append (" | ")
					elseif col > 1 then
						Result.append_character (' ')
					end
					if grid [row, col] = 0 then
						Result.append_character ('.')
					else
						Result.append_integer (grid [row, col])
					end
					col := col + 1
				end
				Result.append_character ('%N')
				row := row + 1
			end
		end

feature -- Demo

	demo
			-- Standard Rosetta Code demo
		local
			grid: ARRAY2 [INTEGER]
		do
			print ("Sudoku Solver Demo:%N%N")

			-- Classic puzzle
			grid := string_to_grid ("530070000600195000098000060800060003400803001700020006060000280000419005000080079")

			print ("Puzzle:%N")
			print (grid_to_string (grid))

			if solve (grid) then
				print ("%NSolution:%N")
				print (grid_to_string (grid))
			else
				print ("No solution exists%N")
			end
		end

	string_to_grid (s: STRING): ARRAY2 [INTEGER]
			-- Parse 81-character string to grid
		require
			valid_length: s.count = 81
		local
			i, row, col: INTEGER
		do
			create Result.make_filled (0, 9, 9)
			from i := 1 until i > 81 loop
				row := (i - 1) // 9 + 1
				col := (i - 1) \\ 9 + 1
				if s [i] >= '1' and s [i] <= '9' then
					Result [row, col] := s [i].code - ('0').code
				end
				i := i + 1
			end
		end

end
