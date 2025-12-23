note
	description: "[
		Rosetta Code: Closures/Value capture
		https://rosettacode.org/wiki/Closures/Value_capture

		Demonstrate lexical closures that capture values.
		Eiffel uses agents (function objects) for closures.
	]"

class
	CLOSURES

feature -- Operations

	create_closures: ARRAY [FUNCTION [INTEGER]]
			-- Create array of closures that capture loop variable
		local
			i: INTEGER
			funcs: ARRAYED_LIST [FUNCTION [INTEGER]]
		do
			create funcs.make (10)

			-- Each agent captures the current value of i
			from i := 1 until i > 10 loop
				funcs.extend (agent captured_value (i))
				i := i + 1
			end

			create Result.make_from_array (funcs.to_array)
		ensure
			ten_closures: Result.count = 10
		end

	create_counter: TUPLE [increment: PROCEDURE; decrement: PROCEDURE; get_value: FUNCTION [INTEGER]]
			-- Create a counter with closures over private state
		local
			counter: CELL [INTEGER]
		do
			create counter.put (0)
			Result := [
				agent increment_cell (counter),
				agent decrement_cell (counter),
				agent get_cell_value (counter)
			]
		end

	create_adder (n: INTEGER): FUNCTION [INTEGER, INTEGER]
			-- Create a function that adds n to its argument
		do
			Result := agent add_n (n, ?)
		end

	create_multiplier (n: INTEGER): FUNCTION [INTEGER, INTEGER]
			-- Create a function that multiplies by n
		do
			Result := agent multiply_n (n, ?)
		end

feature {NONE} -- Closure Helpers

	captured_value (val: INTEGER): INTEGER
			-- Return captured value
		do
			Result := val
		end

	add_n (n, x: INTEGER): INTEGER
			-- Add n to x
		do
			Result := n + x
		end

	multiply_n (n, x: INTEGER): INTEGER
			-- Multiply x by n
		do
			Result := n * x
		end

	increment_cell (c: CELL [INTEGER])
		do
			c.put (c.item + 1)
		end

	decrement_cell (c: CELL [INTEGER])
		do
			c.put (c.item - 1)
		end

	get_cell_value (c: CELL [INTEGER]): INTEGER
		do
			Result := c.item
		end

feature -- Composition

	compose (f, g: FUNCTION [INTEGER, INTEGER]): FUNCTION [INTEGER, INTEGER]
			-- Compose two functions: f ∘ g
		do
			Result := agent composed (f, g, ?)
		end

feature {NONE} -- Composition Helper

	composed (f, g: FUNCTION [INTEGER, INTEGER]; x: INTEGER): INTEGER
		do
			Result := f.item ([g.item ([x])])
		end

feature -- Demo

	demo
			-- Standard Rosetta Code demo
		local
			closures_arr: ARRAY [FUNCTION [INTEGER]]
			counter: TUPLE [increment: PROCEDURE; decrement: PROCEDURE; get_value: FUNCTION [INTEGER]]
			add5, times3, composed_func: FUNCTION [INTEGER, INTEGER]
			i: INTEGER
		do
			print ("Closures Demo:%N%N")

			-- Value capture
			print ("Value capture:%N")
			closures_arr := create_closures
			from i := 1 until i > 10 loop
				print ("  Closure " + i.out + " returns: " + closures_arr [i].item ([]).out + "%N")
				i := i + 1
			end

			-- Counter with private state
			print ("%NCounter with closures:%N")
			counter := create_counter
			print ("  Initial: " + counter.get_value.item ([]).out + "%N")
			counter.increment.call ([])
			counter.increment.call ([])
			counter.increment.call ([])
			print ("  After 3 increments: " + counter.get_value.item ([]).out + "%N")
			counter.decrement.call ([])
			print ("  After 1 decrement: " + counter.get_value.item ([]).out + "%N")

			-- Function factories
			print ("%NFunction factories:%N")
			add5 := create_adder (5)
			times3 := create_multiplier (3)
			print ("  add5(10) = " + add5.item ([10]).out + "%N")
			print ("  times3(10) = " + times3.item ([10]).out + "%N")

			-- Function composition
			print ("%NFunction composition:%N")
			composed_func := compose (add5, times3)
			print ("  (add5 ∘ times3)(10) = add5(times3(10)) = " + composed_func.item ([10]).out + "%N")
		end

end
