note
	description: "[
		Rosetta Code: Deque
		https://rosettacode.org/wiki/Deque

		Double-ended queue allowing insertion and removal
		at both ends.
	]"

class
	DEQUE [G]

create
	make

feature {NONE} -- Initialization

	make (initial_capacity: INTEGER)
			-- Create deque with initial capacity
		require
			positive: initial_capacity > 0
		do
			create items.make (initial_capacity)
		ensure
			empty: is_empty
		end

feature -- Access

	front: G
			-- Element at front
		require
			not_empty: not is_empty
		do
			Result := items.first
		end

	back: G
			-- Element at back
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
			-- Is deque empty?
		do
			Result := items.is_empty
		end

feature -- Element change

	push_front (v: G)
			-- Add element at front
		do
			items.put_front (v)
		ensure
			one_more: count = old count + 1
			at_front: front = v
		end

	push_back (v: G)
			-- Add element at back
		do
			items.extend (v)
		ensure
			one_more: count = old count + 1
			at_back: back = v
		end

	pop_front: G
			-- Remove and return front element
		require
			not_empty: not is_empty
		do
			Result := items.first
			items.start
			items.remove
		ensure
			one_less: count = old count - 1
		end

	pop_back: G
			-- Remove and return back element
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
			-- Internal storage

feature -- Conversion

	to_array: ARRAY [G]
			-- Convert to array (front to back)
		do
			create Result.make_from_special (items.area)
		end

feature -- Demo

	demo
			-- Standard Rosetta Code demo
		local
			d: DEQUE [INTEGER]
		do
			create d.make (10)
			print ("Deque Demo (Double-Ended Queue):%N%N")

			print ("push_back: 1, 2, 3%N")
			d.push_back (1)
			d.push_back (2)
			d.push_back (3)

			print ("push_front: 0, -1%N")
			d.push_front (0)
			d.push_front (-1)

			print ("Contents: ")
			across d.to_array as elem loop
				print (elem.out + " ")
			end
			print ("%N%N")

			print ("Front: " + d.front.out + "%N")
			print ("Back: " + d.back.out + "%N%N")

			print ("pop_front: " + d.pop_front.out + "%N")
			print ("pop_back: " + d.pop_back.out + "%N")

			print ("Remaining: ")
			across d.to_array as elem loop
				print (elem.out + " ")
			end
			print ("%N")
		end

end
