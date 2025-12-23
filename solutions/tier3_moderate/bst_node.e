note
	description: "Node for binary search tree"

class
	BST_NODE [G]

create
	make

feature {NONE} -- Initialization

	make (v: G)
		do
			value := v
		end

feature -- Access

	value: G
	left: detachable BST_NODE [G]
	right: detachable BST_NODE [G]

feature -- Modification

	set_left (n: detachable BST_NODE [G])
		do
			left := n
		end

	set_right (n: detachable BST_NODE [G])
		do
			right := n
		end

end
