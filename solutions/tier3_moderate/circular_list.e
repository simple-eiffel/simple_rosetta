note
	description: "[
		Rosetta Code: Circular list
		https://rosettacode.org/wiki/Circular_list

		A list where the last element points back to the first,
		forming a ring structure.
	]"

class
	CIRCULAR_LIST [G]

create
	make

feature {NONE} -- Initialization

	make
			-- Create empty circular list
		do
			count := 0
		ensure
			empty: is_empty
		end

feature -- Access

	head: detachable CIRC_NODE [G]
			-- Current head of circular list

	count: INTEGER
			-- Number of elements

	item (i: INTEGER): G
			-- Element at index i (1-based, wraps around)
		require
			not_empty: not is_empty
		local
			node: detachable CIRC_NODE [G]
			j, actual_index: INTEGER
		do
			actual_index := ((i - 1) \\ count) + 1
			node := head
			from j := 1 until j >= actual_index loop
				if attached node as n then
					node := n.next
				end
				j := j + 1
			end
			check attached node as n then
				Result := n.value
			end
		end

feature -- Status

	is_empty: BOOLEAN
			-- Is list empty?
		do
			Result := count = 0
		end

feature -- Element change

	extend (v: G)
			-- Add element at end (before head in circular order)
		local
			node, last_node: detachable CIRC_NODE [G]
		do
			create node.make (v)
			if attached head as h then
				-- Find last node
				last_node := h
				from until attached last_node as ln and then ln.next = head loop
					if attached last_node as ln2 then
						last_node := ln2.next
					end
				end
				if attached last_node as ln3 then
					ln3.set_next (node)
				end
				node.set_next (h)
			else
				head := node
				node.set_next (node)  -- Point to itself
			end
			count := count + 1
		ensure
			one_more: count = old count + 1
		end

	rotate
			-- Rotate list: make next element the head
		require
			not_empty: not is_empty
		do
			if attached head as h then
				head := h.next
			end
		end

	rotate_back
			-- Rotate backwards: make previous element the head
		require
			not_empty: not is_empty
		local
			node: detachable CIRC_NODE [G]
		do
			if attached head as h then
				node := h
				from until attached node as n and then n.next = h loop
					if attached node as n then
						node := n.next
					end
				end
				head := node
			end
		end

	remove_head
			-- Remove current head
		require
			not_empty: not is_empty
		local
			last_node: detachable CIRC_NODE [G]
		do
			if count = 1 then
				head := Void
			elseif attached head as h then
				-- Find last node
				last_node := h
				from until attached last_node as ln and then ln.next = h loop
					if attached last_node as ln2 then
						last_node := ln2.next
					end
				end
				head := h.next
				if attached last_node as ln3 then
					ln3.set_next (head)
				end
			end
			count := count - 1
		ensure
			one_less: count = old count - 1
		end

feature -- Iteration

	do_all (action: PROCEDURE [G])
			-- Apply action to all elements starting from head
		local
			node: detachable CIRC_NODE [G]
			i: INTEGER
		do
			if attached head then
				node := head
				from i := 1 until i > count loop
					if attached node as n then
						action.call ([n.value])
						node := n.next
					end
					i := i + 1
				end
			end
		end

feature -- Conversion

	to_array: ARRAY [G]
			-- Convert to array starting from head
		local
			node: detachable CIRC_NODE [G]
			i: INTEGER
		do
			create Result.make_empty
			if attached head then
				node := head
				from i := 1 until i > count loop
					if attached node as n then
						Result.force (n.value, i)
						node := n.next
					end
					i := i + 1
				end
			end
		end

feature -- Demo

	demo
			-- Standard Rosetta Code demo
		local
			list: CIRCULAR_LIST [INTEGER]
		do
			create list.make
			print ("Circular List Demo:%N%N")

			list.extend (1)
			list.extend (2)
			list.extend (3)
			list.extend (4)
			print ("After adding 1, 2, 3, 4: ")
			print_list (list)

			print ("Rotate forward: ")
			list.rotate
			print_list (list)

			print ("Rotate forward again: ")
			list.rotate
			print_list (list)

			print ("Rotate backward: ")
			list.rotate_back
			print_list (list)

			print ("%NAccessing elements (with wrap-around):%N")
			print ("item(1) = " + list.item (1).out + "%N")
			print ("item(5) = " + list.item (5).out + " (wraps to 1)%N")
			print ("item(6) = " + list.item (6).out + " (wraps to 2)%N")
		end

	print_list (list: CIRCULAR_LIST [INTEGER])
			-- Print list contents
		do
			across list.to_array as elem loop
				print (elem.out + " ")
			end
			print ("%N")
		end

end
