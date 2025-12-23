note
	description: "[
		Rosetta Code: 15 puzzle game
		https://rosettacode.org/wiki/15_puzzle_game

		Classic sliding puzzle with A* solver.
	]"

class
	FIFTEEN_PUZZLE

create
	make, make_from_array

feature -- Initialization

	make
			-- Create solved puzzle
		do
			create board.make_filled (0, 4, 4)
			reset
		end

	make_from_array (arr: ARRAY [INTEGER])
			-- Create from flat array (0 = empty)
		require
			valid_size: arr.count = 16
		local
			i, row, col: INTEGER
		do
			create board.make_filled (0, 4, 4)
			from i := 1 until i > 16 loop
				row := (i - 1) // 4 + 1
				col := (i - 1) \\ 4 + 1
				board [row, col] := arr [i]
				if arr [i] = 0 then
					empty_row := row
					empty_col := col
				end
				i := i + 1
			end
		end

feature -- Access

	board: ARRAY2 [INTEGER]
	empty_row, empty_col: INTEGER

	is_solved: BOOLEAN
			-- Is puzzle in solved state?
		local
			i, row, col, expected: INTEGER
		do
			Result := True
			from i := 1 until i > 15 or not Result loop
				row := (i - 1) // 4 + 1
				col := (i - 1) \\ 4 + 1
				expected := i
				if board [row, col] /= expected then
					Result := False
				end
				i := i + 1
			end
			if Result then
				Result := board [4, 4] = 0
			end
		end

	is_solvable: BOOLEAN
			-- Can this configuration be solved?
		local
			flat: ARRAY [INTEGER]
			inversions, i, j, pos: INTEGER
		do
			create flat.make_filled (0, 1, 16)
			pos := 1
			from i := 1 until i > 4 loop
				from j := 1 until j > 4 loop
					flat [pos] := board [i, j]
					pos := pos + 1
					j := j + 1
				end
				i := i + 1
			end

			-- Count inversions
			from i := 1 until i > 16 loop
				from j := i + 1 until j > 16 loop
					if flat [i] /= 0 and flat [j] /= 0 and flat [i] > flat [j] then
						inversions := inversions + 1
					end
					j := j + 1
				end
				i := i + 1
			end

			-- Solvability rule for 4x4
			if (empty_row \\ 2 = 0) then
				Result := inversions \\ 2 = 1
			else
				Result := inversions \\ 2 = 0
			end
		end

feature -- Operations

	reset
			-- Reset to solved state
		local
			i, row, col: INTEGER
		do
			from i := 1 until i > 15 loop
				row := (i - 1) // 4 + 1
				col := (i - 1) \\ 4 + 1
				board [row, col] := i
				i := i + 1
			end
			board [4, 4] := 0
			empty_row := 4
			empty_col := 4
		end

	move (dir: CHARACTER): BOOLEAN
			-- Move tile in direction (U/D/L/R), return True if valid
		local
			new_row, new_col: INTEGER
		do
			inspect dir
			when 'U', 'u' then new_row := empty_row + 1; new_col := empty_col
			when 'D', 'd' then new_row := empty_row - 1; new_col := empty_col
			when 'L', 'l' then new_row := empty_row; new_col := empty_col + 1
			when 'R', 'r' then new_row := empty_row; new_col := empty_col - 1
			else new_row := 0; new_col := 0
			end

			if new_row >= 1 and new_row <= 4 and new_col >= 1 and new_col <= 4 then
				board [empty_row, empty_col] := board [new_row, new_col]
				board [new_row, new_col] := 0
				empty_row := new_row
				empty_col := new_col
				Result := True
			end
		end

	shuffle (moves: INTEGER)
			-- Randomly shuffle by making moves
		local
			directions: STRING
			i: INTEGER
			r: RANDOM
		do
			directions := "UDLR"
			create r.make
			r.set_seed ((create {TIME}.make_now).seconds)
			from i := 1 until i > moves loop
				r.forth
				if move (directions [r.item \\ 4 + 1]) then
					-- Move succeeded
				end
				i := i + 1
			end
		end

feature -- Solving

	solve: detachable STRING
			-- Solve using IDA* with Manhattan distance heuristic
		local
			limit, new_limit, result_val: INTEGER
			path: STRING
		do
			if is_solved then
				Result := ""
			elseif is_solvable then
				limit := manhattan_distance
				create path.make (100)

				from until Result /= Void loop
					result_val := ida_star (path, 0, limit, 'X')
					if result_val = -1 then
						Result := path
					elseif result_val = {INTEGER}.max_value then
						-- No solution (shouldn't happen for solvable puzzle)
						Result := Void
					else
						limit := result_val
						path.wipe_out
					end
				end
			end
		end

feature {NONE} -- Solving Implementation

	ida_star (path: STRING; g, limit: INTEGER; last_dir: CHARACTER): INTEGER
			-- IDA* search, returns -1 if found, otherwise new limit
		local
			f, min, result_val: INTEGER
			directions: STRING
			i: INTEGER
			dir, opposite: CHARACTER
		do
			f := g + manhattan_distance
			if f > limit then
				Result := f
			elseif is_solved then
				Result := -1
			else
				min := {INTEGER}.max_value
				directions := "UDLR"

				from i := 1 until i > 4 or Result = -1 loop
					dir := directions [i]
					opposite := opposite_dir (dir)
					if dir /= last_dir then  -- Don't undo last move
						if move (dir) then
							path.append_character (dir)
							result_val := ida_star (path, g + 1, limit, opposite)
							if result_val = -1 then
								Result := -1
							else
								if result_val < min then
									min := result_val
								end
								path.remove_tail (1)
								if not move (opposite) then end  -- Undo
							end
						end
					end
					i := i + 1
				end
				if Result /= -1 then
					Result := min
				end
			end
		end

	manhattan_distance: INTEGER
			-- Sum of Manhattan distances from goal
		local
			row, col, val, goal_row, goal_col: INTEGER
		do
			from row := 1 until row > 4 loop
				from col := 1 until col > 4 loop
					val := board [row, col]
					if val /= 0 then
						goal_row := (val - 1) // 4 + 1
						goal_col := (val - 1) \\ 4 + 1
						Result := Result + (row - goal_row).abs + (col - goal_col).abs
					end
					col := col + 1
				end
				row := row + 1
			end
		end

	opposite_dir (dir: CHARACTER): CHARACTER
		do
			inspect dir
			when 'U' then Result := 'D'
			when 'D' then Result := 'U'
			when 'L' then Result := 'R'
			when 'R' then Result := 'L'
			else Result := 'X'
			end
		end

feature -- Output

	to_string: STRING
			-- Visual representation
		local
			row, col, val: INTEGER
		do
			create Result.make (80)
			Result.append ("+----+----+----+----+%N")
			from row := 1 until row > 4 loop
				from col := 1 until col > 4 loop
					Result.append ("| ")
					val := board [row, col]
					if val = 0 then
						Result.append ("  ")
					elseif val < 10 then
						Result.append_integer (val)
						Result.append_character (' ')
					else
						Result.append_integer (val)
					end
					col := col + 1
				end
				Result.append ("|%N")
				Result.append ("+----+----+----+----+%N")
				row := row + 1
			end
		end

feature -- Demo

	demo
			-- Standard Rosetta Code demo
		local
			puzzle: FIFTEEN_PUZZLE
		do
			print ("15 Puzzle Demo:%N%N")

			create puzzle.make
			print ("Solved state:%N")
			print (puzzle.to_string)

			-- Create a solvable configuration
			puzzle.make_from_array (<<1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 0, 15>>)
			print ("Puzzle (one move from solved):%N")
			print (puzzle.to_string)
			print ("Solvable: " + puzzle.is_solvable.out + "%N")

			if attached puzzle.solve as solution then
				print ("Solution: " + solution + " (" + solution.count.out + " moves)%N%N")
			end

			-- Shuffle and solve
			create puzzle.make
			puzzle.shuffle (20)
			print ("Shuffled puzzle:%N")
			print (puzzle.to_string)
			print ("Solvable: " + puzzle.is_solvable.out + "%N")

			if puzzle.is_solvable then
				if attached puzzle.solve as solution then
					print ("Solution: " + solution + " (" + solution.count.out + " moves)%N")
				end
			end
		end

end
