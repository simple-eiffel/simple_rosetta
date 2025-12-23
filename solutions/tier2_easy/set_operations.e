note
	description: "[
		Rosetta Code: Set
		https://rosettacode.org/wiki/Set

		Demonstrate set operations: union, intersection, difference,
		symmetric difference, subset test.
	]"

class
	SET_OPERATIONS

feature -- Set Creation

	from_array (arr: ARRAY [INTEGER]): ARRAYED_SET [INTEGER]
			-- Create set from array
		do
			create Result.make (arr.count)
			across arr as elem loop
				Result.extend (elem)
			end
		end

feature -- Set Operations

	union (a, b: ARRAYED_SET [INTEGER]): ARRAYED_SET [INTEGER]
			-- Elements in a OR b
		do
			create Result.make (a.count + b.count)
			across a as elem loop
				Result.extend (elem)
			end
			across b as elem loop
				Result.extend (elem)
			end
		ensure
			contains_a: across a as elem all Result.has (elem) end
			contains_b: across b as elem all Result.has (elem) end
		end

	intersection (a, b: ARRAYED_SET [INTEGER]): ARRAYED_SET [INTEGER]
			-- Elements in a AND b
		do
			create Result.make (a.count.min (b.count))
			across a as elem loop
				if b.has (elem) then
					Result.extend (elem)
				end
			end
		ensure
			in_both: across Result as elem all a.has (elem) and b.has (elem) end
		end

	difference (a, b: ARRAYED_SET [INTEGER]): ARRAYED_SET [INTEGER]
			-- Elements in a but NOT in b
		do
			create Result.make (a.count)
			across a as elem loop
				if not b.has (elem) then
					Result.extend (elem)
				end
			end
		ensure
			in_a_not_b: across Result as elem all a.has (elem) and not b.has (elem) end
		end

	symmetric_difference (a, b: ARRAYED_SET [INTEGER]): ARRAYED_SET [INTEGER]
			-- Elements in a XOR b (in one but not both)
		do
			create Result.make (a.count + b.count)
			across a as elem loop
				if not b.has (elem) then
					Result.extend (elem)
				end
			end
			across b as elem loop
				if not a.has (elem) then
					Result.extend (elem)
				end
			end
		end

feature -- Set Tests

	is_subset (a, b: ARRAYED_SET [INTEGER]): BOOLEAN
			-- Is a a subset of b?
		do
			Result := across a as elem all b.has (elem) end
		end

	is_superset (a, b: ARRAYED_SET [INTEGER]): BOOLEAN
			-- Is a a superset of b?
		do
			Result := is_subset (b, a)
		end

	is_equal_set (a, b: ARRAYED_SET [INTEGER]): BOOLEAN
			-- Do a and b contain the same elements?
		do
			Result := a.count = b.count and then is_subset (a, b)
		end

	is_disjoint (a, b: ARRAYED_SET [INTEGER]): BOOLEAN
			-- Do a and b have no common elements?
		do
			Result := intersection (a, b).is_empty
		end

feature -- Utility

	set_to_string (s: ARRAYED_SET [INTEGER]): STRING
			-- Convert set to string representation
		do
			create Result.make (s.count * 4)
			Result.append ("{")
			across s as elem loop
				if Result.count > 1 then
					Result.append (", ")
				end
				Result.append (elem.out)
			end
			Result.append ("}")
		end

feature -- Demo

	demo
			-- Standard Rosetta Code demo
		local
			a, b, result_set: ARRAYED_SET [INTEGER]
		do
			print ("Set Operations Demo:%N%N")

			a := from_array (<<1, 2, 3, 4, 5>>)
			b := from_array (<<3, 4, 5, 6, 7>>)

			print ("Set A: " + set_to_string (a) + "%N")
			print ("Set B: " + set_to_string (b) + "%N%N")

			result_set := union (a, b)
			print ("A ∪ B (union):                " + set_to_string (result_set) + "%N")

			result_set := intersection (a, b)
			print ("A ∩ B (intersection):         " + set_to_string (result_set) + "%N")

			result_set := difference (a, b)
			print ("A - B (difference):           " + set_to_string (result_set) + "%N")

			result_set := difference (b, a)
			print ("B - A (difference):           " + set_to_string (result_set) + "%N")

			result_set := symmetric_difference (a, b)
			print ("A △ B (symmetric difference): " + set_to_string (result_set) + "%N%N")

			print ("Subset/Superset tests:%N")
			print ("A ⊆ B: " + is_subset (a, b).out + "%N")

			a := from_array (<<3, 4, 5>>)
			print ("%NWith A = {3, 4, 5}:%N")
			print ("A ⊆ B: " + is_subset (a, b).out + "%N")
			print ("B ⊇ A: " + is_superset (b, a).out + "%N")

			a := from_array (<<1, 2>>)
			b := from_array (<<3, 4>>)
			print ("%NWith A = {1, 2} and B = {3, 4}:%N")
			print ("Disjoint: " + is_disjoint (a, b).out + "%N")
		end

end
