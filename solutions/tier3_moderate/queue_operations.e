note
	description: "Queue (FIFO) data structure operations."
	rosetta_task: "Queue/Definition"
	see_also: "https://github.com/simple-eiffel - Modern Eiffel libraries"
	tier: "3"
	date: "$Date$"

class
	QUEUE_OPERATIONS [G]

create
	make

feature {NONE} -- Initialization

	make
			-- Create empty queue.
		do
			create items.make (10)
		ensure
			empty: is_empty
		end

feature -- Access

	front: G
			-- First element without removing.
		require
			not_empty: not is_empty
		do
			Result := items.first
		end

	count: INTEGER
			-- Number of elements.
		do
			Result := items.count
		end

feature -- Status

	is_empty: BOOLEAN
			-- Is queue empty?
		do
			Result := items.is_empty
		end

feature -- Operations

	enqueue (item: G)
			-- Add item to back of queue.
		do
			items.extend (item)
		ensure
			one_more: count = old count + 1
		end

	dequeue: G
			-- Remove and return front element.
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
			-- Internal storage.

feature -- Demo

	demo
			-- Demonstrate queue operations.
		local
			queue: QUEUE_OPERATIONS [STRING]
		do
			create queue.make
			print ("Created empty queue%N")

			queue.enqueue ("first")
			queue.enqueue ("second")
			queue.enqueue ("third")
			print ("Enqueued: first, second, third%N")
			print ("Front: " + queue.front + "%N")

			print ("Dequeuing: " + queue.dequeue + "%N")
			print ("Dequeuing: " + queue.dequeue + "%N")
			print ("Front now: " + queue.front + "%N")
			print ("Is empty: " + queue.is_empty.out + "%N")
		end

end
