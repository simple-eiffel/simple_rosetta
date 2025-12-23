note
	description: "[
		Rosetta Code: Conway's Game of Life
		https://rosettacode.org/wiki/Conway%27s_Game_of_Life

		Cellular automaton with birth/survival rules B3/S23.
	]"

class
	GAME_OF_LIFE

create
	make

feature -- Initialization

	make (a_width, a_height: INTEGER)
			-- Create empty grid
		require
			valid_dimensions: a_width > 0 and a_height > 0
		do
			width := a_width
			height := a_height
			create grid.make_filled (False, height, width)
		ensure
			width_set: width = a_width
			height_set: height = a_height
		end

feature -- Access

	width: INTEGER
	height: INTEGER
	grid: ARRAY2 [BOOLEAN]

	is_alive (row, col: INTEGER): BOOLEAN
			-- Is cell at (row, col) alive?
		require
			valid_row: row >= 1 and row <= height
			valid_col: col >= 1 and col <= width
		do
			Result := grid [row, col]
		end

	generation: INTEGER
			-- Current generation number

feature -- Operations

	set_cell (row, col: INTEGER; alive: BOOLEAN)
			-- Set cell state
		require
			valid_row: row >= 1 and row <= height
			valid_col: col >= 1 and col <= width
		do
			grid [row, col] := alive
		ensure
			cell_set: is_alive (row, col) = alive
		end

	step
			-- Advance one generation
		local
			new_grid: ARRAY2 [BOOLEAN]
			row, col, neighbors: INTEGER
		do
			create new_grid.make_filled (False, height, width)

			from row := 1 until row > height loop
				from col := 1 until col > width loop
					neighbors := count_neighbors (row, col)
					if grid [row, col] then
						-- Survival: 2 or 3 neighbors
						new_grid [row, col] := neighbors = 2 or neighbors = 3
					else
						-- Birth: exactly 3 neighbors
						new_grid [row, col] := neighbors = 3
					end
					col := col + 1
				end
				row := row + 1
			end

			grid := new_grid
			generation := generation + 1
		end

	run (steps: INTEGER)
			-- Run for given number of steps
		require
			positive_steps: steps > 0
		local
			i: INTEGER
		do
			from i := 1 until i > steps loop
				step
				i := i + 1
			end
		end

feature {NONE} -- Implementation

	count_neighbors (row, col: INTEGER): INTEGER
			-- Count live neighbors (toroidal wrap)
		local
			dr, dc, nr, nc: INTEGER
		do
			from dr := -1 until dr > 1 loop
				from dc := -1 until dc > 1 loop
					if dr /= 0 or dc /= 0 then
						nr := ((row - 1 + dr + height) \\ height) + 1
						nc := ((col - 1 + dc + width) \\ width) + 1
						if grid [nr, nc] then
							Result := Result + 1
						end
					end
					dc := dc + 1
				end
				dr := dr + 1
			end
		end

feature -- Patterns

	add_glider (row, col: INTEGER)
			-- Add glider pattern at position
		require
			fits: row >= 1 and row + 2 <= height and col >= 1 and col + 2 <= width
		do
			set_cell (row, col + 1, True)
			set_cell (row + 1, col + 2, True)
			set_cell (row + 2, col, True)
			set_cell (row + 2, col + 1, True)
			set_cell (row + 2, col + 2, True)
		end

	add_blinker (row, col: INTEGER)
			-- Add blinker (period 2) at position
		require
			fits: row >= 1 and row <= height and col >= 1 and col + 2 <= width
		do
			set_cell (row, col, True)
			set_cell (row, col + 1, True)
			set_cell (row, col + 2, True)
		end

	add_block (row, col: INTEGER)
			-- Add block (still life) at position
		require
			fits: row >= 1 and row + 1 <= height and col >= 1 and col + 1 <= width
		do
			set_cell (row, col, True)
			set_cell (row, col + 1, True)
			set_cell (row + 1, col, True)
			set_cell (row + 1, col + 1, True)
		end

feature -- Output

	to_string: STRING
			-- Grid as string
		local
			row, col: INTEGER
		do
			create Result.make (height * (width + 1))
			from row := 1 until row > height loop
				from col := 1 until col > width loop
					if grid [row, col] then
						Result.append_character ('#')
					else
						Result.append_character ('.')
					end
					col := col + 1
				end
				Result.append_character ('%N')
				row := row + 1
			end
		end

	population: INTEGER
			-- Count of live cells
		local
			row, col: INTEGER
		do
			from row := 1 until row > height loop
				from col := 1 until col > width loop
					if grid [row, col] then
						Result := Result + 1
					end
					col := col + 1
				end
				row := row + 1
			end
		end

feature -- Demo

	demo
			-- Standard Rosetta Code demo
		local
			life: GAME_OF_LIFE
			i: INTEGER
		do
			print ("Conway's Game of Life Demo:%N%N")

			-- Blinker oscillator
			create life.make (5, 5)
			life.add_blinker (3, 2)
			print ("Blinker (period 2):%N")
			from i := 0 until i > 2 loop
				print ("Generation " + life.generation.out + ":%N")
				print (life.to_string)
				print ("%N")
				life.step
				i := i + 1
			end

			-- Glider
			create life.make (10, 10)
			life.add_glider (1, 1)
			print ("Glider:%N")
			from i := 0 until i > 4 loop
				print ("Generation " + life.generation.out + ":%N")
				print (life.to_string)
				print ("%N")
				life.run (4)
				i := i + 1
			end
		end

end
