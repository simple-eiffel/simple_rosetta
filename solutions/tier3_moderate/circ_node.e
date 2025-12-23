note
	description: "Node for circular list"

class
	CIRC_NODE [G]

create
	make

feature {NONE} -- Initialization

	make (v: G)
		do
			value := v
		end

feature -- Access

	value: G
	next: detachable CIRC_NODE [G]

feature -- Modification

	set_next (n: detachable CIRC_NODE [G])
		do
			next := n
		end

end
