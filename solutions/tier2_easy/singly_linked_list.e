note
	description: "[
		Rosetta Code: Singly-linked list/Element definition
		https://rosettacode.org/wiki/Singly-linked_list/Element_definition

		A singly-linked list where each node has reference only to next.
		Uses INTEGER for simplicity (generic version requires separate node class).
	]"

class
	SINGLY_LINKED_LIST

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

	first_node: detachable SLL_INTEGER_NODE
			-- First node in list

	count: INTEGER
			-- Number of elements

	item (i: INTEGER): INTEGER
			-- Element at index i (1-based)
		require
			valid_index: i >= 1 and i <= count
		local
			node: detachable SLL_INTEGER_NODE
			j: INTEGER
		do
			node := first_node
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

	extend (v: INTEGER)
			-- Add element at end
		local
			node: SLL_INTEGER_NODE
			curr: detachable SLL_INTEGER_NODE
		do
			create node.make (v)
			if attached first_node as f then
				curr := f
				from until not attached curr as c or else c.next = Void loop
					curr := c.next
				end
				if attached curr as c then
					c.set_next (node)
				end
			else
				first_node := node
			end
			count := count + 1
		ensure
			one_more: count = old count + 1
		end

	prepend (v: INTEGER)
			-- Add element at beginning
		local
			node: SLL_INTEGER_NODE
		do
			create node.make (v)
			node.set_next (first_node)
			first_node := node
			count := count + 1
		ensure
			one_more: count = old count + 1
			at_start: attached first_node as f and then f.value = v
		end

	insert_after (v: INTEGER; i: INTEGER)
			-- Insert v after position i
		require
			valid_index: i >= 1 and i <= count
		local
			node: SLL_INTEGER_NODE
			curr: detachable SLL_INTEGER_NODE
			j: INTEGER
		do
			curr := first_node
			from j := 1 until j >= i loop
				if attached curr as c then
					curr := c.next
				end
				j := j + 1
			end

			if attached curr as c then
				create node.make (v)
				node.set_next (c.next)
				c.set_next (node)
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
			if attached first_node as f then
				first_node := f.next
				count := count - 1
			end
		ensure
			one_less: count = old count - 1
		end

feature -- Conversion

	to_array: ARRAY [INTEGER]
			-- Convert to array
		local
			node: detachable SLL_INTEGER_NODE
			i: INTEGER
		do
			create Result.make_empty
			node := first_node
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
			list: SINGLY_LINKED_LIST
		do
			create list.make
			print ("Singly-Linked List Demo:%N%N")

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
		end

	print_list (list: SINGLY_LINKED_LIST)
			-- Print list contents
		do
			across list.to_array as elem loop
				print (elem.out + " ")
			end
			print ("%N")
		end

end
