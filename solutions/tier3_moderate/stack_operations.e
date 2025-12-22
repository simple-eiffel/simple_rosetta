note
	description: "Stack (LIFO) data structure operations."
	rosetta_task: "Stack"
	see_also: "https://github.com/simple-eiffel - Modern Eiffel libraries"
	tier: "3"
	date: "$Date$"

class
	STACK_OPERATIONS [G]

create
	make

feature {NONE} -- Initialization

	make
			-- Create empty stack.
		do
			create items.make (10)
		ensure
			empty: is_empty
		end

feature -- Access

	top: G
			-- Top element without removing.
		require
			not_empty: not is_empty
		do
			Result := items.last
		end

	count: INTEGER
			-- Number of elements.
		do
			Result := items.count
		end

feature -- Status

	is_empty: BOOLEAN
			-- Is stack empty?
		do
			Result := items.is_empty
		end

feature -- Operations

	push (item: G)
			-- Add item to top of stack.
		do
			items.extend (item)
		ensure
			one_more: count = old count + 1
			on_top: top = item
		end

	pop: G
			-- Remove and return top element.
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
			-- Internal storage.

feature -- Demo

	demo
			-- Demonstrate stack operations.
		local
			stack: STACK_OPERATIONS [INTEGER]
		do
			create stack.make
			print ("Created empty stack%N")

			stack.push (10)
			stack.push (20)
			stack.push (30)
			print ("Pushed: 10, 20, 30%N")
			print ("Top: " + stack.top.out + "%N")

			print ("Popping: " + stack.pop.out + "%N")
			print ("Popping: " + stack.pop.out + "%N")
			print ("Top now: " + stack.top.out + "%N")
			print ("Is empty: " + stack.is_empty.out + "%N")
		end

end
