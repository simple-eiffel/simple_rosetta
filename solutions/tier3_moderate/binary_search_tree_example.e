note
	description: "[
		Rosetta Code: Binary search tree
		https://rosettacode.org/wiki/Binary_search_tree

		A tree structure where for each node, all left descendants
		are less and all right descendants are greater.
	]"

class
	BINARY_SEARCH_TREE_EXAMPLE [G -> COMPARABLE]

create
	make

feature {NONE} -- Initialization

	make
			-- Create empty tree
		do
			count := 0
		ensure
			empty: is_empty
		end

feature -- Access

	root: detachable BST_NODE [G]
			-- Root of tree

	count: INTEGER
			-- Number of elements

	minimum: G
			-- Minimum element in tree
		require
			not_empty: not is_empty
		local
			node: detachable BST_NODE [G]
		do
			node := root
			from until not attached node as n or else n.left = Void loop
				node := n.left
			end
			check attached node as n then
				Result := n.value
			end
		end

	maximum: G
			-- Maximum element in tree
		require
			not_empty: not is_empty
		local
			node: detachable BST_NODE [G]
		do
			node := root
			from until not attached node as n or else n.right = Void loop
				node := n.right
			end
			check attached node as n then
				Result := n.value
			end
		end

feature -- Status

	is_empty: BOOLEAN
			-- Is tree empty?
		do
			Result := count = 0
		end

	has (v: G): BOOLEAN
			-- Does tree contain v?
		local
			node: detachable BST_NODE [G]
		do
			node := root
			from until node = Void or Result loop
				if attached node as n then
					if v < n.value then
						node := n.left
					elseif v > n.value then
						node := n.right
					else
						Result := True
					end
				end
			end
		end

feature -- Element change

	insert (v: G)
			-- Insert element into tree
		local
			node, parent: detachable BST_NODE [G]
			new_node: BST_NODE [G]
			go_left: BOOLEAN
		do
			create new_node.make (v)
			if attached root as r then
				node := r
				from until node = Void loop
					parent := node
					if attached node as n then
						if v < n.value then
							node := n.left
							go_left := True
						else
							node := n.right
							go_left := False
						end
					end
				end
				if attached parent as p then
					if go_left then
						p.set_left (new_node)
					else
						p.set_right (new_node)
					end
				end
			else
				root := new_node
			end
			count := count + 1
		ensure
			one_more: count = old count + 1
			contains: has (v)
		end

feature -- Traversal

	inorder: ARRAY [G]
			-- Return elements in sorted order
		do
			create Result.make_empty
			inorder_recursive (root, Result)
		ensure
			correct_count: Result.count = count
		end

	preorder: ARRAY [G]
			-- Return elements in preorder (root, left, right)
		do
			create Result.make_empty
			preorder_recursive (root, Result)
		end

	postorder: ARRAY [G]
			-- Return elements in postorder (left, right, root)
		do
			create Result.make_empty
			postorder_recursive (root, Result)
		end

feature {NONE} -- Implementation

	inorder_recursive (node: detachable BST_NODE [G]; arr: ARRAY [G])
			-- Recursive inorder traversal
		do
			if attached node as n then
				inorder_recursive (n.left, arr)
				arr.force (n.value, arr.count + 1)
				inorder_recursive (n.right, arr)
			end
		end

	preorder_recursive (node: detachable BST_NODE [G]; arr: ARRAY [G])
			-- Recursive preorder traversal
		do
			if attached node as n then
				arr.force (n.value, arr.count + 1)
				preorder_recursive (n.left, arr)
				preorder_recursive (n.right, arr)
			end
		end

	postorder_recursive (node: detachable BST_NODE [G]; arr: ARRAY [G])
			-- Recursive postorder traversal
		do
			if attached node as n then
				postorder_recursive (n.left, arr)
				postorder_recursive (n.right, arr)
				arr.force (n.value, arr.count + 1)
			end
		end

feature -- Demo

	demo
			-- Standard Rosetta Code demo
		local
			tree: BINARY_SEARCH_TREE_EXAMPLE [INTEGER]
		do
			create tree.make
			print ("Binary Search Tree Demo:%N%N")

			print ("Inserting: 5, 3, 7, 1, 4, 6, 8, 2%N")
			tree.insert (5)
			tree.insert (3)
			tree.insert (7)
			tree.insert (1)
			tree.insert (4)
			tree.insert (6)
			tree.insert (8)
			tree.insert (2)

			print ("Count: " + tree.count.out + "%N")
			print ("Minimum: " + tree.minimum.out + "%N")
			print ("Maximum: " + tree.maximum.out + "%N%N")

			print ("Inorder (sorted): ")
			across tree.inorder as elem loop
				print (elem.out + " ")
			end
			print ("%N")

			print ("Preorder: ")
			across tree.preorder as elem loop
				print (elem.out + " ")
			end
			print ("%N")

			print ("Postorder: ")
			across tree.postorder as elem loop
				print (elem.out + " ")
			end
			print ("%N%N")

			print ("Has 4: " + tree.has (4).out + "%N")
			print ("Has 9: " + tree.has (9).out + "%N")
		end

end
