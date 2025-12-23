note
	description: "Node for doubly-linked list"

class
	DLL_NODE [G]

create
	make

feature {NONE} -- Initialization

	make (v: G)
		do
			value := v
		end

feature -- Access

	value: G
	next: detachable DLL_NODE [G]
	prev: detachable DLL_NODE [G]

feature -- Modification

	set_next (n: detachable DLL_NODE [G])
		do
			next := n
		end

	set_prev (p: detachable DLL_NODE [G])
		do
			prev := p
		end

end
