note
	description: "[
		Rosetta Code: Generator/Exponential
		https://rosettacode.org/wiki/Generator/Exponential

		Implement generators that yield values on demand.
		Eiffel uses iteration protocols and agents for generators.
	]"

class
	GENERATOR_PATTERN

feature -- Basic Generator

	range_generator (from_val, to_val, step: INTEGER): ITERATION_CURSOR [INTEGER]
			-- Generate integers in range
		do
			create {RANGE_GENERATOR} Result.make (from_val, to_val, step)
		end

feature -- Infinite Generators

	naturals: FUNCTION [INTEGER]
			-- Generator for natural numbers
		local
			state: CELL [INTEGER]
		do
			create state.put (0)
			Result := agent next_natural (state)
		end

	powers_of (base: INTEGER): FUNCTION [INTEGER]
			-- Generator for powers of base
		local
			state: CELL [INTEGER]
		do
			create state.put (1)
			Result := agent next_power (state, base)
		end

	fibonacci_gen: FUNCTION [INTEGER]
			-- Generator for fibonacci numbers
		local
			a, b: CELL [INTEGER]
		do
			create a.put (0)
			create b.put (1)
			Result := agent next_fibonacci (a, b)
		end

feature {NONE} -- Generator Helpers

	next_natural (state: CELL [INTEGER]): INTEGER
		do
			Result := state.item
			state.put (state.item + 1)
		end

	next_power (state: CELL [INTEGER]; base: INTEGER): INTEGER
		do
			Result := state.item
			state.put (state.item * base)
		end

	next_fibonacci (a, b: CELL [INTEGER]): INTEGER
		local
			next: INTEGER
		do
			Result := a.item
			next := a.item + b.item
			a.put (b.item)
			b.put (next)
		end

feature -- Filter Generator

	filter_generator (gen: FUNCTION [INTEGER]; predicate: FUNCTION [INTEGER, BOOLEAN]): FUNCTION [INTEGER]
			-- Filter values from generator
		do
			Result := agent filtered_next (gen, predicate)
		end

feature {NONE} -- Filter Helper

	filtered_next (gen: FUNCTION [INTEGER]; predicate: FUNCTION [INTEGER, BOOLEAN]): INTEGER
		do
			from
				Result := gen.item ([])
			until
				predicate.item ([Result])
			loop
				Result := gen.item ([])
			end
		end

feature -- Rosetta Code: Generator/Exponential

	squares: FUNCTION [INTEGER]
			-- Generator for perfect squares
		local
			state: CELL [INTEGER]
		do
			create state.put (0)
			Result := agent next_square (state)
		end

	cubes: FUNCTION [INTEGER]
			-- Generator for perfect cubes
		local
			state: CELL [INTEGER]
		do
			create state.put (0)
			Result := agent next_cube (state)
		end

feature {NONE} -- Square/Cube Helpers

	next_square (state: CELL [INTEGER]): INTEGER
		local
			val: INTEGER
		do
			val := state.item
			state.put (state.item + 1)
			Result := val * val
		end

	next_cube (state: CELL [INTEGER]): INTEGER
		local
			val: INTEGER
		do
			val := state.item
			state.put (state.item + 1)
			Result := val * val * val
		end

	non_cube_squares: ARRAYED_LIST [INTEGER]
			-- Squares that are not also cubes (first 30)
		local
			sq_gen: FUNCTION [INTEGER]
			cube_set: HASH_TABLE [BOOLEAN, INTEGER]
			sq, c, i: INTEGER
		do
			create Result.make (30)
			sq_gen := squares

			-- Pre-compute cubes up to reasonable limit
			create cube_set.make (100)
			from i := 0 until i > 50 loop
				c := i * i * i
				cube_set.force (True, c)
				i := i + 1
			end

			-- Get first 30 non-cube squares
			from until Result.count >= 30 loop
				sq := sq_gen.item ([])
				if not cube_set.has (sq) then
					Result.extend (sq)
				end
			end
		end

feature -- Take/Drop Operations

	take (n: INTEGER; gen: FUNCTION [INTEGER]): ARRAY [INTEGER]
			-- Take first n values from generator
		local
			i: INTEGER
		do
			create Result.make_filled (0, 1, n)
			from i := 1 until i > n loop
				Result [i] := gen.item ([])
				i := i + 1
			end
		end

	drop (n: INTEGER; gen: FUNCTION [INTEGER])
			-- Skip first n values from generator
		local
			i: INTEGER
		do
			from i := 1 until i > n loop
				if gen.item ([]) /= gen.item ([]) then end  -- Consume value
				i := i + 1
			end
		end

feature -- Demo

	demo
			-- Standard Rosetta Code demo
		local
			nat, fib, sq: FUNCTION [INTEGER]
			non_cubes: ARRAYED_LIST [INTEGER]
			i: INTEGER
		do
			print ("Generator Pattern Demo:%N%N")

			-- Natural numbers
			print ("Natural numbers (first 10):%N  ")
			nat := naturals
			from i := 1 until i > 10 loop
				print (nat.item ([]).out + " ")
				i := i + 1
			end
			print ("%N")

			-- Powers of 2
			print ("%NPowers of 2 (first 10):%N  ")
			across take (10, powers_of (2)) as p loop
				print (p.out + " ")
			end
			print ("%N")

			-- Fibonacci
			print ("%NFibonacci (first 15):%N  ")
			fib := fibonacci_gen
			from i := 1 until i > 15 loop
				print (fib.item ([]).out + " ")
				i := i + 1
			end
			print ("%N")

			-- Squares
			print ("%NSquares (first 10):%N  ")
			sq := squares
			from i := 1 until i > 10 loop
				print (sq.item ([]).out + " ")
				i := i + 1
			end
			print ("%N")

			-- Rosetta Code task: squares not also cubes, drop first 20, show next 10
			print ("%NSquares that are not cubes (positions 21-30):%N  ")
			non_cubes := non_cube_squares
			from i := 21 until i > 30 loop
				print (non_cubes [i].out + " ")
				i := i + 1
			end
			print ("%N")
		end

end
