note
	description: "[
		Rosetta Code: Tree traversal
		https://rosettacode.org/wiki/Tree_traversal

		Implement preorder, inorder, postorder, and level-order traversal.
	]"
	author: "Eiffel Solution"
	rosetta_task: "Tree_traversal"

class
	TREE_TRAVERSAL

create
	make

feature {NONE} -- Initialization

	make
			-- Demonstrate tree traversals.
		local
			root, n2, n3, n5: TREE_NODE
		do
			print ("Binary Tree Traversal%N")
			print ("=====================%N%N")

			-- Build sample tree:
			--        1
			--       / \
			--      2   3
			--     / \\   \
			--    4   5   6
			--       /
			--      7

			root := new_node (1)
			n2 := new_node (2)
			n3 := new_node (3)
			n5 := new_node (5)
			root.set_left (n2)
			root.set_right (n3)
			n2.set_left (new_node (4))
			n2.set_right (n5)
			n3.set_right (new_node (6))
			n5.set_left (new_node (7))

			print ("Tree structure:%N")
			print ("        1%N")
			print ("       / \%N")
			print ("      2   3%N")
			print ("     / \\   \%N")
			print ("    4   5   6%N")
			print ("       /%N")
			print ("      7%N%N")

			print ("Preorder (root, left, right):   ")
			preorder (root)
			print ("%N")

			print ("Inorder (left, root, right):    ")
			inorder (root)
			print ("%N")

			print ("Postorder (left, right, root):  ")
			postorder (root)
			print ("%N")

			print ("Level-order (breadth-first):    ")
			level_order (root)
			print ("%N")
		end

feature -- Tree Node

	new_node (value: INTEGER): TREE_NODE
			-- Create a new tree node with given value.
		do
			create Result.make (value)
		end

feature -- Traversals

	preorder (node: detachable TREE_NODE)
			-- Preorder traversal: root, left, right.
		do
			if attached node as n then
				print (n.value.out + " ")
				preorder (n.left)
				preorder (n.right)
			end
		end

	inorder (node: detachable TREE_NODE)
			-- Inorder traversal: left, root, right.
		do
			if attached node as n then
				inorder (n.left)
				print (n.value.out + " ")
				inorder (n.right)
			end
		end

	postorder (node: detachable TREE_NODE)
			-- Postorder traversal: left, right, root.
		do
			if attached node as n then
				postorder (n.left)
				postorder (n.right)
				print (n.value.out + " ")
			end
		end

	level_order (root: detachable TREE_NODE)
			-- Level-order (breadth-first) traversal.
		local
			queue: ARRAYED_LIST [TREE_NODE]
			curr: TREE_NODE
		do
			if attached root as r then
				create queue.make (10)
				queue.extend (r)

				from until queue.is_empty loop
					curr := queue.first
					queue.start
					queue.remove

					print (curr.value.out + " ")

					if attached curr.left as l then
						queue.extend (l)
					end
					if attached curr.right as r2 then
						queue.extend (r2)
					end
				end
			end
		end

end
