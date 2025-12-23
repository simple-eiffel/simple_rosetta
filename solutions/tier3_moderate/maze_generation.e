note
	description: "[
		Rosetta Code: Maze generation
		https://rosettacode.org/wiki/Maze_generation

		Generate random mazes using recursive backtracking.
	]"

class
	MAZE_GENERATION

create
	make

feature -- Initialization

	make (a_width, a_height: INTEGER)
			-- Create maze of given dimensions
		require
			valid_dimensions: a_width >= 2 and a_height >= 2
		do
			width := a_width
			height := a_height
			create cells.make_filled (15, height, width)  -- All walls
			create random.make
		ensure
			width_set: width = a_width
			height_set: height = a_height
		end

feature -- Access

	width: INTEGER
	height: INTEGER
	cells: ARRAY2 [INTEGER]
			-- Each cell stores wall bits: N=1, E=2, S=4, W=8

feature -- Operations

	generate
			-- Generate maze using recursive backtracking
		do
			random.set_seed ((create {TIME}.make_now).seconds)
			carve_from (1, 1)
		end

	generate_with_seed (seed: INTEGER)
			-- Generate with specific seed for reproducibility
		do
			random.set_seed (seed)
			carve_from (1, 1)
		end

feature {NONE} -- Implementation

	random: RANDOM

	North: INTEGER = 1
	East: INTEGER = 2
	South: INTEGER = 4
	West: INTEGER = 8

	carve_from (row, col: INTEGER)
			-- Recursive backtracking from cell
		local
			directions: ARRAY [INTEGER]
			i, dir, new_row, new_col: INTEGER
		do
			directions := shuffle_directions

			from i := 1 until i > 4 loop
				dir := directions [i]
				new_row := row + dy (dir)
				new_col := col + dx (dir)

				if is_valid (new_row, new_col) and then cells [new_row, new_col] = 15 then
					-- Remove walls between cells
					cells [row, col] := cells [row, col] - dir
					cells [new_row, new_col] := cells [new_row, new_col] - opposite (dir)
					carve_from (new_row, new_col)
				end
				i := i + 1
			end
		end

	shuffle_directions: ARRAY [INTEGER]
			-- Return shuffled array of directions
		local
			result_arr: ARRAY [INTEGER]
			i, j, temp: INTEGER
		do
			result_arr := <<North, East, South, West>>
			-- Fisher-Yates shuffle
			from i := 4 until i <= 1 loop
				random.forth
				j := (random.item \\ i) + 1
				temp := result_arr [i]
				result_arr [i] := result_arr [j]
				result_arr [j] := temp
				i := i - 1
			end
			Result := result_arr
		end

	dx (dir: INTEGER): INTEGER
		do
			inspect dir
			when 2 then Result := 1   -- East
			when 8 then Result := -1  -- West
			else Result := 0
			end
		end

	dy (dir: INTEGER): INTEGER
		do
			inspect dir
			when 1 then Result := -1  -- North
			when 4 then Result := 1   -- South
			else Result := 0
			end
		end

	opposite (dir: INTEGER): INTEGER
		do
			inspect dir
			when 1 then Result := 4   -- North -> South
			when 2 then Result := 8   -- East -> West
			when 4 then Result := 1   -- South -> North
			when 8 then Result := 2   -- West -> East
			else Result := 0
			end
		end

feature -- Query

	is_valid (row, col: INTEGER): BOOLEAN
			-- Is (row, col) within maze bounds?
		do
			Result := row >= 1 and row <= height and col >= 1 and col <= width
		end

feature -- Output

	to_string: STRING
			-- ASCII representation of maze
		local
			row, col: INTEGER
			cell: INTEGER
		do
			create Result.make ((height * 2 + 1) * (width * 2 + 1))

			-- Top border
			from col := 1 until col > width loop
				Result.append ("+--")
				col := col + 1
			end
			Result.append ("+%N")

			-- Each row
			from row := 1 until row > height loop
				-- West wall and cells
				Result.append_character ('|')
				from col := 1 until col > width loop
					cell := cells [row, col]
					Result.append ("  ")
					if cell.bit_and (East) /= 0 and col < width then
						Result.append_character ('|')
					else
						Result.append_character (' ')
					end
					col := col + 1
				end
				Result.append_character ('%N')

				-- South walls
				from col := 1 until col > width loop
					Result.append_character ('+')
					cell := cells [row, col]
					if cell.bit_and (South) /= 0 and row < height then
						Result.append ("--")
					else
						Result.append ("  ")
					end
					col := col + 1
				end
				Result.append ("+%N")

				row := row + 1
			end
		end

	has_wall (row, col: INTEGER; dir: INTEGER): BOOLEAN
			-- Does cell have wall in given direction?
		require
			valid_cell: is_valid (row, col)
		do
			Result := cells [row, col].bit_and (dir) /= 0
		end

feature -- Demo

	demo
			-- Standard Rosetta Code demo
		local
			maze: MAZE_GENERATION
		do
			print ("Maze Generation Demo:%N%N")

			create maze.make (10, 8)
			maze.generate_with_seed (42)
			print ("10x8 Maze (seed 42):%N")
			print (maze.to_string)

			print ("%N5x5 Maze:%N")
			create maze.make (5, 5)
			maze.generate
			print (maze.to_string)
		end

end
