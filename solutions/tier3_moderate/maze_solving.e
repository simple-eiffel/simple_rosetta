note
	description: "[
		Rosetta Code: Maze solving
		https://rosettacode.org/wiki/Maze_solving

		Solve mazes using BFS (shortest path) and DFS.
	]"

class
	MAZE_SOLVING

feature -- Operations

	solve_bfs (maze: ARRAY2 [CHARACTER]; start_row, start_col, end_row, end_col: INTEGER): detachable ARRAYED_LIST [TUPLE [row, col: INTEGER]]
			-- Find shortest path using BFS
		require
			valid_maze: maze.height > 0 and maze.width > 0
			valid_start: is_open (maze, start_row, start_col)
			valid_end: is_open (maze, end_row, end_col)
		local
			queue: ARRAYED_LIST [TUPLE [row, col: INTEGER]]
			visited: ARRAY2 [BOOLEAN]
			parent: ARRAY2 [TUPLE [row, col: INTEGER]]
			curr: TUPLE [row, col: INTEGER]
			row, col, new_row, new_col, i: INTEGER
		do
			create visited.make_filled (False, maze.height, maze.width)
			create parent.make_filled ([0, 0], maze.height, maze.width)
			create queue.make (100)

			queue.extend ([start_row, start_col])
			visited [start_row, start_col] := True

			from until queue.is_empty or Result /= Void loop
				curr := queue.first
				queue.start
				queue.remove
				row := curr.row
				col := curr.col

				if row = end_row and col = end_col then
					Result := reconstruct_path (parent, start_row, start_col, end_row, end_col)
				else
					from i := 1 until i > 4 loop
						new_row := row + dy (i)
						new_col := col + dx (i)
						if is_open (maze, new_row, new_col) and then not visited [new_row, new_col] then
							visited [new_row, new_col] := True
							parent [new_row, new_col] := [row, col]
							queue.extend ([new_row, new_col])
						end
						i := i + 1
					end
				end
			end
		end

	solve_dfs (maze: ARRAY2 [CHARACTER]; start_row, start_col, end_row, end_col: INTEGER): detachable ARRAYED_LIST [TUPLE [row, col: INTEGER]]
			-- Find path using DFS (not necessarily shortest)
		require
			valid_maze: maze.height > 0 and maze.width > 0
			valid_start: is_open (maze, start_row, start_col)
			valid_end: is_open (maze, end_row, end_col)
		local
			visited: ARRAY2 [BOOLEAN]
			path: ARRAYED_LIST [TUPLE [row, col: INTEGER]]
		do
			create visited.make_filled (False, maze.height, maze.width)
			create path.make (100)
			if dfs_recursive (maze, visited, path, start_row, start_col, end_row, end_col) then
				Result := path
			end
		end

feature {NONE} -- Implementation

	dx (dir: INTEGER): INTEGER
		do
			inspect dir
			when 1 then Result := 0   -- Up
			when 2 then Result := 1   -- Right
			when 3 then Result := 0   -- Down
			when 4 then Result := -1  -- Left
			else Result := 0
			end
		end

	dy (dir: INTEGER): INTEGER
		do
			inspect dir
			when 1 then Result := -1  -- Up
			when 2 then Result := 0   -- Right
			when 3 then Result := 1   -- Down
			when 4 then Result := 0   -- Left
			else Result := 0
			end
		end

feature -- Query

	is_open (maze: ARRAY2 [CHARACTER]; row, col: INTEGER): BOOLEAN
			-- Is cell open (not a wall)?
		do
			if row >= 1 and row <= maze.height and col >= 1 and col <= maze.width then
				Result := maze [row, col] /= '#'
			end
		end

feature {NONE} -- Path Reconstruction

	reconstruct_path (parent: ARRAY2 [TUPLE [row, col: INTEGER]]; start_row, start_col, end_row, end_col: INTEGER): ARRAYED_LIST [TUPLE [row, col: INTEGER]]
			-- Build path from parent pointers
		local
			row, col, prev_row, prev_col: INTEGER
			p: TUPLE [row, col: INTEGER]
		do
			create Result.make (50)
			row := end_row
			col := end_col

			from until row = start_row and col = start_col loop
				Result.put_front ([row, col])
				p := parent [row, col]
				prev_row := p.row
				prev_col := p.col
				row := prev_row
				col := prev_col
			end
			Result.put_front ([start_row, start_col])
		end

	dfs_recursive (maze: ARRAY2 [CHARACTER]; visited: ARRAY2 [BOOLEAN]; path: ARRAYED_LIST [TUPLE [row, col: INTEGER]]; row, col, end_row, end_col: INTEGER): BOOLEAN
			-- DFS helper
		local
			i, new_row, new_col: INTEGER
		do
			visited [row, col] := True
			path.extend ([row, col])

			if row = end_row and col = end_col then
				Result := True
			else
				from i := 1 until i > 4 or Result loop
					new_row := row + dy (i)
					new_col := col + dx (i)
					if is_open (maze, new_row, new_col) and then not visited [new_row, new_col] then
						Result := dfs_recursive (maze, visited, path, new_row, new_col, end_row, end_col)
					end
					i := i + 1
				end
				if not Result then
					path.finish
					path.remove
				end
			end
		end

feature -- Utility

	mark_path (maze: ARRAY2 [CHARACTER]; path: ARRAYED_LIST [TUPLE [row, col: INTEGER]]): ARRAY2 [CHARACTER]
			-- Return maze copy with path marked
		local
			row, col, i, j: INTEGER
		do
			create Result.make_filled (' ', maze.height, maze.width)
			from i := 1 until i > maze.height loop
				from j := 1 until j > maze.width loop
					Result [i, j] := maze [i, j]
					j := j + 1
				end
				i := i + 1
			end
			across path as p loop
				row := p.row
				col := p.col
				if Result [row, col] = ' ' then
					Result [row, col] := '*'
				end
			end
		end

	maze_to_string (maze: ARRAY2 [CHARACTER]): STRING
			-- Convert maze to string
		local
			row, col: INTEGER
		do
			create Result.make (maze.height * (maze.width + 1))
			from row := 1 until row > maze.height loop
				from col := 1 until col > maze.width loop
					Result.append_character (maze [row, col])
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
			maze: ARRAY2 [CHARACTER]
			solver: MAZE_SOLVING
			lines: ARRAY [STRING]
			i, j: INTEGER
		do
			print ("Maze Solving Demo:%N%N")

			lines := <<"#########",
						"#S  #   #",
						"### # # #",
						"#   # # #",
						"# ### # #",
						"#     # #",
						"# ##### #",
						"#      E#",
						"#########">>

			create maze.make_filled ('#', 9, 9)
			from i := 1 until i > 9 loop
				from j := 1 until j > 9 loop
					maze [i, j] := lines [i] [j]
					j := j + 1
				end
				i := i + 1
			end

			print ("Maze:%N")
			create solver
			print (solver.maze_to_string (maze))

			if attached solver.solve_bfs (maze, 2, 2, 8, 8) as path then
				print ("%NBFS Solution (shortest path, length " + path.count.out + "):%N")
				print (solver.maze_to_string (solver.mark_path (maze, path)))
			else
				print ("No solution found%N")
			end
		end

end
