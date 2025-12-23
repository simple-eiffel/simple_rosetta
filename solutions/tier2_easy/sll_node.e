note
	description: "Node for singly-linked list"

class
	SLL_NODE [G]

create
	make

feature {NONE} -- Initialization

	make (v: G)
		do
			value := v
		end

feature -- Access

	value: G
	next: detachable SLL_NODE [G]

feature -- Modification

	set_next (n: detachable SLL_NODE [G])
		do
			next := n
		end

end
