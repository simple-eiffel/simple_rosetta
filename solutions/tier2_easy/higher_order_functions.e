note
	description: "[
		Rosetta Code: Higher-order functions
		https://rosettacode.org/wiki/Higher-order_functions

		Functions that take functions as arguments or return functions.
		Eiffel implements this via agents (FUNCTION, PROCEDURE types).
	]"

class
	HIGHER_ORDER_FUNCTIONS

feature -- Classic Higher-Order Functions

	map (list: ARRAY [INTEGER]; f: FUNCTION [INTEGER, INTEGER]): ARRAY [INTEGER]
			-- Apply f to each element
		local
			i: INTEGER
		do
			create Result.make_filled (0, list.lower, list.upper)
			from i := list.lower until i > list.upper loop
				Result [i] := f.item ([list [i]])
				i := i + 1
			end
		end

	filter (list: ARRAY [INTEGER]; predicate: FUNCTION [INTEGER, BOOLEAN]): ARRAY [INTEGER]
			-- Keep elements where predicate is true
		local
			temp: ARRAYED_LIST [INTEGER]
			i: INTEGER
		do
			create temp.make (list.count)
			from i := list.lower until i > list.upper loop
				if predicate.item ([list [i]]) then
					temp.extend (list [i])
				end
				i := i + 1
			end
			Result := temp.to_array
		end

	fold_left (list: ARRAY [INTEGER]; initial: INTEGER; f: FUNCTION [INTEGER, INTEGER, INTEGER]): INTEGER
			-- Left fold: ((initial f a1) f a2) f a3) ...
		local
			i: INTEGER
		do
			Result := initial
			from i := list.lower until i > list.upper loop
				Result := f.item ([Result, list [i]])
				i := i + 1
			end
		end

	fold_right (list: ARRAY [INTEGER]; initial: INTEGER; f: FUNCTION [INTEGER, INTEGER, INTEGER]): INTEGER
			-- Right fold: a1 f (a2 f (a3 f initial))
		local
			i: INTEGER
		do
			Result := initial
			from i := list.upper until i < list.lower loop
				Result := f.item ([list [i], Result])
				i := i - 1
			end
		end

	any (list: ARRAY [INTEGER]; predicate: FUNCTION [INTEGER, BOOLEAN]): BOOLEAN
			-- Does any element satisfy predicate?
		local
			i: INTEGER
		do
			from i := list.lower until i > list.upper or Result loop
				Result := predicate.item ([list [i]])
				i := i + 1
			end
		end

	all_satisfy (list: ARRAY [INTEGER]; predicate: FUNCTION [INTEGER, BOOLEAN]): BOOLEAN
			-- Do all elements satisfy predicate?
		local
			i: INTEGER
		do
			Result := True
			from i := list.lower until i > list.upper or not Result loop
				Result := predicate.item ([list [i]])
				i := i + 1
			end
		end

	find_first (list: ARRAY [INTEGER]; predicate: FUNCTION [INTEGER, BOOLEAN]): INTEGER
			-- Find first element satisfying predicate (0 if none)
		local
			i: INTEGER
			found: BOOLEAN
		do
			from i := list.lower until i > list.upper or found loop
				if predicate.item ([list [i]]) then
					Result := list [i]
					found := True
				end
				i := i + 1
			end
		end

	take_while (list: ARRAY [INTEGER]; predicate: FUNCTION [INTEGER, BOOLEAN]): ARRAY [INTEGER]
			-- Take elements while predicate holds
		local
			temp: ARRAYED_LIST [INTEGER]
			i: INTEGER
			continue: BOOLEAN
		do
			create temp.make (list.count)
			continue := True
			from i := list.lower until i > list.upper or not continue loop
				if predicate.item ([list [i]]) then
					temp.extend (list [i])
				else
					continue := False
				end
				i := i + 1
			end
			Result := temp.to_array
		end

	zip_with (list1, list2: ARRAY [INTEGER]; f: FUNCTION [INTEGER, INTEGER, INTEGER]): ARRAY [INTEGER]
			-- Combine two lists using function
		local
			i, n: INTEGER
		do
			n := list1.count.min (list2.count)
			create Result.make_filled (0, 1, n)
			from i := 1 until i > n loop
				Result [i] := f.item ([list1 [list1.lower + i - 1], list2 [list2.lower + i - 1]])
				i := i + 1
			end
		end

feature -- Function returning functions

	compose (f, g: FUNCTION [INTEGER, INTEGER]): FUNCTION [INTEGER, INTEGER]
			-- Compose f ∘ g
		do
			Result := agent composed (f, g, ?)
		end

	twice (f: FUNCTION [INTEGER, INTEGER]): FUNCTION [INTEGER, INTEGER]
			-- Apply f twice
		do
			Result := compose (f, f)
		end

	n_times (f: FUNCTION [INTEGER, INTEGER]; n: INTEGER): FUNCTION [INTEGER, INTEGER]
			-- Apply f n times
		local
			i: INTEGER
		do
			Result := agent identity (?)
			from i := 1 until i > n loop
				Result := compose (f, Result)
				i := i + 1
			end
		end

feature {NONE} -- Helpers

	composed (f, g: FUNCTION [INTEGER, INTEGER]; x: INTEGER): INTEGER
		do
			Result := f.item ([g.item ([x])])
		end

	identity (x: INTEGER): INTEGER
		do
			Result := x
		end

feature -- Common Functions

	is_even: FUNCTION [INTEGER, BOOLEAN]
		once
			Result := agent (n: INTEGER): BOOLEAN do Result := n \\ 2 = 0 end
		end

	is_positive: FUNCTION [INTEGER, BOOLEAN]
		once
			Result := agent (n: INTEGER): BOOLEAN do Result := n > 0 end
		end

	square: FUNCTION [INTEGER, INTEGER]
		once
			Result := agent (n: INTEGER): INTEGER do Result := n * n end
		end

	double: FUNCTION [INTEGER, INTEGER]
		once
			Result := agent (n: INTEGER): INTEGER do Result := n * 2 end
		end

	add: FUNCTION [INTEGER, INTEGER, INTEGER]
		once
			Result := agent (a, b: INTEGER): INTEGER do Result := a + b end
		end

	multiply: FUNCTION [INTEGER, INTEGER, INTEGER]
		once
			Result := agent (a, b: INTEGER): INTEGER do Result := a * b end
		end

feature -- Demo

	demo
			-- Standard Rosetta Code demo
		local
			nums: ARRAY [INTEGER]
			f: FUNCTION [INTEGER, INTEGER]
		do
			print ("Higher-Order Functions Demo:%N%N")

			nums := <<1, 2, 3, 4, 5, 6, 7, 8, 9, 10>>
			print ("Input: " + array_to_string (nums) + "%N%N")

			print ("map(square): " + array_to_string (map (nums, square)) + "%N")
			print ("map(double): " + array_to_string (map (nums, double)) + "%N")
			print ("filter(is_even): " + array_to_string (filter (nums, is_even)) + "%N")
			print ("filter(is_positive): " + array_to_string (filter (<<-2, -1, 0, 1, 2>>, is_positive)) + "%N")

			print ("%Nfold_left(+, 0): " + fold_left (nums, 0, add).out + "%N")
			print ("fold_left(*, 1): " + fold_left (nums, 1, multiply).out + "%N")

			print ("%Nany(is_even): " + any (nums, is_even).out + "%N")
			print ("all(is_positive): " + all_satisfy (nums, is_positive).out + "%N")
			print ("find_first(>5): " + find_first (nums, agent (n: INTEGER): BOOLEAN do Result := n > 5 end).out + "%N")

			print ("%Ntake_while(<5): " + array_to_string (take_while (nums, agent (n: INTEGER): BOOLEAN do Result := n < 5 end)) + "%N")
			print ("zip_with(+): " + array_to_string (zip_with (<<1, 2, 3>>, <<10, 20, 30>>, add)) + "%N")

			print ("%NFunction composition:%N")
			f := compose (square, double)
			print ("  (square ∘ double)(5) = " + f.item ([5]).out + "%N")
			f := twice (double)
			print ("  twice(double)(5) = " + f.item ([5]).out + "%N")
			f := n_times (double, 4)
			print ("  4x(double)(1) = " + f.item ([1]).out + "%N")
		end

	array_to_string (arr: ARRAY [INTEGER]): STRING
		local
			i: INTEGER
		do
			create Result.make (arr.count * 3)
			Result.append ("[")
			from i := arr.lower until i > arr.upper loop
				if i > arr.lower then
					Result.append (", ")
				end
				Result.append_integer (arr [i])
				i := i + 1
			end
			Result.append ("]")
		end

end
