note
	description: "[
		Rosetta Code: Priority queue
		https://rosettacode.org/wiki/Priority_queue

		A queue where elements are dequeued by priority order.
		Implemented using a binary min-heap.
	]"

class
	PRIORITY_QUEUE_EXAMPLE [G -> COMPARABLE]

create
	make

feature {NONE} -- Initialization

	make (initial_capacity: INTEGER)
			-- Create priority queue with initial capacity
		require
			positive: initial_capacity > 0
		do
			create heap.make (initial_capacity)
		ensure
			empty: is_empty
		end

feature -- Access

	minimum: G
			-- Element with minimum priority (highest priority)
		require
			not_empty: not is_empty
		do
			Result := heap.first
		end

	count: INTEGER
			-- Number of elements
		do
			Result := heap.count
		end

feature -- Status

	is_empty: BOOLEAN
			-- Is queue empty?
		do
			Result := heap.is_empty
		end

feature -- Element change

	insert (v: G)
			-- Insert element maintaining heap property
		do
			heap.extend (v)
			bubble_up (heap.count)
		ensure
			one_more: count = old count + 1
		end

	remove_minimum: G
			-- Remove and return minimum element
		require
			not_empty: not is_empty
		do
			Result := heap.first
			heap.put_i_th (heap.last, 1)
			heap.finish
			heap.remove
			if heap.count > 0 then
				bubble_down (1)
			end
		ensure
			one_less: count = old count - 1
		end

feature {NONE} -- Implementation

	heap: ARRAYED_LIST [G]
			-- Binary heap storage (1-indexed)

	bubble_up (index: INTEGER)
			-- Restore heap property upward from index
		local
			i, parent: INTEGER
			temp: G
		do
			i := index
			from until i <= 1 loop
				parent := i // 2
				if heap.i_th (i) < heap.i_th (parent) then
					temp := heap.i_th (parent)
					heap.put_i_th (heap.i_th (i), parent)
					heap.put_i_th (temp, i)
					i := parent
				else
					i := 0  -- Exit
				end
			end
		end

	bubble_down (index: INTEGER)
			-- Restore heap property downward from index
		local
			i, child, right: INTEGER
			temp: G
		do
			i := index
			from until i * 2 > heap.count loop
				child := i * 2
				right := child + 1
				-- Pick smaller child
				if right <= heap.count then
					if heap.i_th (right) < heap.i_th (child) then
						child := right
					end
				end
				if heap.i_th (child) < heap.i_th (i) then
					temp := heap.i_th (child)
					heap.put_i_th (heap.i_th (i), child)
					heap.put_i_th (temp, i)
					i := child
				else
					i := heap.count + 1  -- Exit
				end
			end
		end

feature -- Demo

	demo
			-- Standard Rosetta Code demo
		local
			pq: PRIORITY_QUEUE_EXAMPLE [INTEGER]
		do
			create pq.make (10)
			print ("Priority Queue Demo (Min-Heap):%N%N")

			print ("Inserting: 5, 3, 7, 1, 4, 6, 2%N")
			pq.insert (5)
			pq.insert (3)
			pq.insert (7)
			pq.insert (1)
			pq.insert (4)
			pq.insert (6)
			pq.insert (2)

			print ("Minimum: " + pq.minimum.out + "%N")
			print ("Count: " + pq.count.out + "%N%N")

			print ("Removing all elements (in priority order):%N")
			from until pq.is_empty loop
				print ("  Remove: " + pq.remove_minimum.out + "%N")
			end
		end

end
