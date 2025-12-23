note
	description: "[
		Rosetta Code: Stack
		https://rosettacode.org/wiki/Stack

		LIFO (Last In First Out) data structure.
		Basic operations: push, pop, peek, is_empty.
	]"

class
	STACK_EXAMPLE [G]

create
	make

feature {NONE} -- Initialization

	make (initial_capacity: INTEGER)
			-- Create stack with initial capacity
		require
			positive: initial_capacity > 0
		do
			create items.make (initial_capacity)
		ensure
			empty: is_empty
		end

feature -- Access

	top: G
			-- Element at top of stack
		require
			not_empty: not is_empty
		do
			Result := items.last
		end

	count: INTEGER
			-- Number of elements
		do
			Result := items.count
		end

feature -- Status

	is_empty: BOOLEAN
			-- Is stack empty?
		do
			Result := items.is_empty
		end

feature -- Element change

	push (v: G)
			-- Push element onto stack
		do
			items.extend (v)
		ensure
			one_more: count = old count + 1
			on_top: top = v
		end

	pop: G
			-- Remove and return top element
		require
			not_empty: not is_empty
		do
			Result := items.last
			items.finish
			items.remove
		ensure
			one_less: count = old count - 1
		end

feature {NONE} -- Implementation

	items: ARRAYED_LIST [G]
			-- Storage list

feature -- Conversion

	to_array: ARRAY [G]
			-- Convert to array (top first)
		local
			i: INTEGER
		do
			create Result.make_empty
			from i := items.count until i < 1 loop
				Result.force (items.i_th (i), items.count - i + 1)
				i := i - 1
			end
		end

feature -- Demo

	demo
			-- Standard Rosetta Code demo
		local
			s: STACK_EXAMPLE [INTEGER]
		do
			create s.make (10)
			print ("Stack Demo (LIFO):%N%N")

			print ("Pushing: 1, 2, 3, 4, 5%N")
			s.push (1)
			s.push (2)
			s.push (3)
			s.push (4)
			s.push (5)

			print ("Top: " + s.top.out + "%N")
			print ("Count: " + s.count.out + "%N%N")

			print ("Popping all elements:%N")
			from until s.is_empty loop
				print ("  Pop: " + s.pop.out + "%N")
			end

			print ("%NStack is empty: " + s.is_empty.out + "%N")
		end

end
