note
	description: "Node for integer singly-linked list"

class
	SLL_INTEGER_NODE

create
	make

feature {NONE} -- Initialization

	make (v: INTEGER)
		do
			value := v
		end

feature -- Access

	value: INTEGER
	next: detachable SLL_INTEGER_NODE

feature -- Modification

	set_next (n: detachable SLL_INTEGER_NODE)
		do
			next := n
		end

end
