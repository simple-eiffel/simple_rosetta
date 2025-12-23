note
	description: "[
		Rosetta Code: Doubly-linked list/Definition
		https://rosettacode.org/wiki/Doubly-linked_list/Definition

		A doubly-linked list where each node has references to both
		next and previous nodes.
	]"

class
	DOUBLY_LINKED_LIST [G]

create
	make

feature {NONE} -- Initialization

	make
			-- Create empty list
		do
			count := 0
		ensure
			empty: is_empty
		end

feature -- Access

	first: detachable DLL_NODE [G]
			-- First node in list

	last: detachable DLL_NODE [G]
			-- Last node in list

	count: INTEGER
			-- Number of elements

	item (i: INTEGER): G
			-- Element at index i (1-based)
		require
			valid_index: i >= 1 and i <= count
		local
			node: detachable DLL_NODE [G]
			j: INTEGER
		do
			node := first
			from j := 1 until j >= i loop
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
			-- Add element at end
		local
			node: DLL_NODE [G]
		do
			create node.make (v)
			if attached last as l then
				l.set_next (node)
				node.set_prev (l)
			else
				first := node
			end
			last := node
			count := count + 1
		ensure
			one_more: count = old count + 1
			at_end: attached last as l and then l.value = v
		end

	prepend (v: G)
			-- Add element at beginning
		local
			node: DLL_NODE [G]
		do
			create node.make (v)
			if attached first as f then
				f.set_prev (node)
				node.set_next (f)
			else
				last := node
			end
			first := node
			count := count + 1
		ensure
			one_more: count = old count + 1
			at_start: attached first as f and then f.value = v
		end

	insert_after (v: G; i: INTEGER)
			-- Insert v after position i
		require
			valid_index: i >= 1 and i <= count
		local
			node, current_node, next_node: detachable DLL_NODE [G]
			j: INTEGER
		do
			current_node := first
			from j := 1 until j >= i loop
				if attached current_node as cn then
					current_node := cn.next
				end
				j := j + 1
			end

			if attached current_node as cn then
				create node.make (v)
				next_node := cn.next
				cn.set_next (node)
				node.set_prev (cn)
				if attached next_node as nn then
					node.set_next (nn)
					nn.set_prev (node)
				else
					last := node
				end
				count := count + 1
			end
		ensure
			one_more: count = old count + 1
		end

	remove_first
			-- Remove first element
		require
			not_empty: not is_empty
		do
			if attached first as f then
				first := f.next
				if attached first as new_first then
					new_first.set_prev (Void)
				else
					last := Void
				end
				count := count - 1
			end
		ensure
			one_less: count = old count - 1
		end

	remove_last
			-- Remove last element
		require
			not_empty: not is_empty
		do
			if attached last as l then
				last := l.prev
				if attached last as new_last then
					new_last.set_next (Void)
				else
					first := Void
				end
				count := count - 1
			end
		ensure
			one_less: count = old count - 1
		end

feature -- Conversion

	to_array: ARRAY [G]
			-- Convert to array
		local
			node: detachable DLL_NODE [G]
			i: INTEGER
		do
			create Result.make_empty
			node := first
			from i := 1 until i > count loop
				if attached node as n then
					Result.force (n.value, i)
					node := n.next
				end
				i := i + 1
			end
		end

feature -- Demo

	demo
			-- Standard Rosetta Code demo
		local
			list: DOUBLY_LINKED_LIST [INTEGER]
		do
			create list.make
			print ("Doubly-Linked List Demo:%N%N")

			list.extend (1)
			list.extend (2)
			list.extend (3)
			print ("After extend 1, 2, 3: ")
			print_list (list)

			list.prepend (0)
			print ("After prepend 0: ")
			print_list (list)

			list.insert_after (15, 2)
			print ("After insert 15 after position 2: ")
			print_list (list)

			list.remove_first
			print ("After remove_first: ")
			print_list (list)

			list.remove_last
			print ("After remove_last: ")
			print_list (list)
		end

	print_list (list: DOUBLY_LINKED_LIST [INTEGER])
			-- Print list contents
		do
			across list.to_array as elem loop
				print (elem.out + " ")
			end
			print ("%N")
		end

end
