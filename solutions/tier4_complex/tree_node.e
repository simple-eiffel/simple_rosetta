note
	description: "Binary tree node for tree traversal demonstrations."
	author: "Eiffel Solution"

class
	TREE_NODE

create
	make

feature {NONE} -- Initialization

	make (v: INTEGER)
			-- Create node with given value.
		do
			value := v
		ensure
			value_set: value = v
		end

feature -- Access

	value: INTEGER
			-- Node value.

	left: detachable TREE_NODE
			-- Left child.

	right: detachable TREE_NODE
			-- Right child.

feature -- Modification

	set_left (n: detachable TREE_NODE)
			-- Set left child.
		do
			left := n
		ensure
			left_set: left = n
		end

	set_right (n: detachable TREE_NODE)
			-- Set right child.
		do
			right := n
		ensure
			right_set: right = n
		end

end
