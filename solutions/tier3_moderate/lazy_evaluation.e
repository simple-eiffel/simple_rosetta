note
	description: "[
		Rosetta Code: Lazy evaluation
		https://rosettacode.org/wiki/Lazy_evaluation

		Defer computation until value is actually needed.
		Eiffel uses agents and once functions for lazy evaluation.
	]"

class
	LAZY_EVALUATION

feature -- Lazy Value (Thunk)

	create_lazy (computation: FUNCTION [INTEGER]): TUPLE [value: FUNCTION [INTEGER]; is_computed: FUNCTION [BOOLEAN]]
			-- Create lazy value that computes on first access
		local
			cached: CELL [INTEGER]
			computed: CELL [BOOLEAN]
		do
			create cached.put (0)
			create computed.put (False)
			Result := [
				agent lazy_get (computation, cached, computed),
				agent lazy_is_computed (computed)
			]
		end

feature {NONE} -- Lazy Helpers

	lazy_get (computation: FUNCTION [INTEGER]; cached: CELL [INTEGER]; computed: CELL [BOOLEAN]): INTEGER
		do
			if not computed.item then
				cached.put (computation.item ([]))
				computed.put (True)
			end
			Result := cached.item
		end

	lazy_is_computed (computed: CELL [BOOLEAN]): BOOLEAN
		do
			Result := computed.item
		end

feature -- Lazy List (Generator)

	natural_numbers: FUNCTION [INTEGER, INTEGER]
			-- Infinite sequence of natural numbers
		do
			Result := agent (n: INTEGER): INTEGER do Result := n end
		end

	fibonacci_at: FUNCTION [INTEGER, INTEGER]
			-- Lazy fibonacci number at index
		do
			Result := agent compute_fib (?)
		end

	primes_up_to (limit: INTEGER): ARRAY [INTEGER]
			-- Lazy prime sieve
		local
			sieve: ARRAY [BOOLEAN]
			i, j: INTEGER
			result_list: ARRAYED_LIST [INTEGER]
		do
			create sieve.make_filled (True, 2, limit)
			create result_list.make (limit // 2)

			from i := 2 until i * i > limit loop
				if sieve [i] then
					from j := i * i until j > limit loop
						sieve [j] := False
						j := j + i
					end
				end
				i := i + 1
			end

			from i := 2 until i > limit loop
				if sieve [i] then
					result_list.extend (i)
				end
				i := i + 1
			end

			Result := result_list.to_array
		end

feature {NONE} -- Computation Helpers

	compute_fib (n: INTEGER): INTEGER
			-- Compute fibonacci with memoization
		do
			if n <= 1 then
				Result := n
			else
				Result := compute_fib (n - 1) + compute_fib (n - 2)
			end
		end

feature -- Lazy Iterator

	create_range_iterator (from_val, to_val: INTEGER): TUPLE [has_next: FUNCTION [BOOLEAN]; next: FUNCTION [INTEGER]]
			-- Create lazy range iterator
		local
			curr_cell: CELL [INTEGER]
		do
			create curr_cell.put (from_val)
			Result := [
				agent range_has_next (curr_cell, to_val),
				agent range_next (curr_cell)
			]
		end

feature {NONE} -- Iterator Helpers

	range_has_next (curr_cell: CELL [INTEGER]; to_val: INTEGER): BOOLEAN
		do
			Result := curr_cell.item <= to_val
		end

	range_next (curr_cell: CELL [INTEGER]): INTEGER
		do
			Result := curr_cell.item
			curr_cell.put (curr_cell.item + 1)
		end

feature -- Short-circuit Evaluation

	lazy_or (a: BOOLEAN; b_thunk: FUNCTION [BOOLEAN]): BOOLEAN
			-- Lazy OR: only evaluate b if a is False
		do
			if a then
				Result := True
			else
				Result := b_thunk.item ([])
			end
		end

	lazy_and (a: BOOLEAN; b_thunk: FUNCTION [BOOLEAN]): BOOLEAN
			-- Lazy AND: only evaluate b if a is True
		do
			if not a then
				Result := False
			else
				Result := b_thunk.item ([])
			end
		end

	lazy_if (condition: BOOLEAN; then_thunk, else_thunk: FUNCTION [INTEGER]): INTEGER
			-- Lazy if-then-else
		do
			if condition then
				Result := then_thunk.item ([])
			else
				Result := else_thunk.item ([])
			end
		end

feature -- Demo

	demo
			-- Standard Rosetta Code demo
		local
			lazy_val: TUPLE [value: FUNCTION [INTEGER]; is_computed: FUNCTION [BOOLEAN]]
			expensive_computation: FUNCTION [INTEGER]
			iter: TUPLE [has_next: FUNCTION [BOOLEAN]; next: FUNCTION [INTEGER]]
			i: INTEGER
		do
			print ("Lazy Evaluation Demo:%N%N")

			-- Lazy value (thunk)
			print ("Lazy value:%N")
			expensive_computation := agent: INTEGER
				do
					print ("  [Computing expensive value...]%N")
					Result := 42
				end
			lazy_val := create_lazy (expensive_computation)
			print ("  Created lazy value%N")
			print ("  Is computed: " + lazy_val.is_computed.item ([]).out + "%N")
			print ("  Accessing value: " + lazy_val.value.item ([]).out + "%N")
			print ("  Is computed: " + lazy_val.is_computed.item ([]).out + "%N")
			print ("  Accessing again: " + lazy_val.value.item ([]).out + " (no recomputation)%N")

			-- Lazy iterator
			print ("%NLazy range iterator (1 to 5):%N")
			iter := create_range_iterator (1, 5)
			from until not iter.has_next.item ([]) loop
				print ("  " + iter.next.item ([]).out + "%N")
			end

			-- Infinite sequence sampling
			print ("%NNatural numbers (first 10):%N")
			from i := 1 until i > 10 loop
				print ("  " + natural_numbers.item ([i]).out)
				i := i + 1
			end
			print ("%N")

			-- Lazy fibonacci
			print ("%NFibonacci (first 10):%N")
			from i := 0 until i > 9 loop
				print ("  fib(" + i.out + ") = " + fibonacci_at.item ([i]).out + "%N")
				i := i + 1
			end

			-- Lazy primes
			print ("%NPrimes up to 50:%N  ")
			across primes_up_to (50) as p loop
				print (p.out + " ")
			end
			print ("%N")

			-- Short-circuit evaluation
			print ("%NShort-circuit evaluation:%N")
			print ("  lazy_or(True, [expensive]): " + lazy_or (True, agent: BOOLEAN do print ("[evaluated!]"); Result := True end).out + "%N")
			print ("  lazy_or(False, [expensive]): " + lazy_or (False, agent: BOOLEAN do print ("[evaluated!]"); Result := True end).out + "%N")
		end

end
