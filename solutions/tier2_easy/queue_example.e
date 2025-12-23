note
	description: "[
		Rosetta Code: Queue/Definition
		https://rosettacode.org/wiki/Queue/Definition

		FIFO (First In First Out) data structure.
		Basic operations: enqueue, dequeue, front, is_empty.
	]"

class
	QUEUE_EXAMPLE [G]

create
	make

feature {NONE} -- Initialization

	make (initial_capacity: INTEGER)
			-- Create queue with initial capacity
		require
			positive: initial_capacity > 0
		do
			create items.make (initial_capacity)
		ensure
			empty: is_empty
		end

feature -- Access

	front: G
			-- Element at front of queue
		require
			not_empty: not is_empty
		do
			Result := items.first
		end

	count: INTEGER
			-- Number of elements
		do
			Result := items.count
		end

feature -- Status

	is_empty: BOOLEAN
			-- Is queue empty?
		do
			Result := items.is_empty
		end

feature -- Element change

	enqueue (v: G)
			-- Add element to back of queue
		do
			items.extend (v)
		ensure
			one_more: count = old count + 1
		end

	dequeue: G
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

feature {NONE} -- Implementation

	items: ARRAYED_LIST [G]
			-- Storage list

feature -- Conversion

	to_array: ARRAY [G]
			-- Convert to array (front first)
		local
			i: INTEGER
		do
			create Result.make_empty
			from i := 1 until i > items.count loop
				Result.force (items.i_th (i), i)
				i := i + 1
			end
		end

feature -- Demo

	demo
			-- Standard Rosetta Code demo
		local
			q: QUEUE_EXAMPLE [INTEGER]
		do
			create q.make (10)
			print ("Queue Demo (FIFO):%N%N")

			print ("Enqueueing: 1, 2, 3, 4, 5%N")
			q.enqueue (1)
			q.enqueue (2)
			q.enqueue (3)
			q.enqueue (4)
			q.enqueue (5)

			print ("Front: " + q.front.out + "%N")
			print ("Count: " + q.count.out + "%N%N")

			print ("Dequeueing all elements:%N")
			from until q.is_empty loop
				print ("  Dequeue: " + q.dequeue.out + "%N")
			end

			print ("%NQueue is empty: " + q.is_empty.out + "%N")
		end

end
