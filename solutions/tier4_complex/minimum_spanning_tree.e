note
	description: "[
		Rosetta Code: Minimum spanning tree
		https://rosettacode.org/wiki/Minimum_spanning_tree

		Find MST using Kruskal's and Prim's algorithms.
	]"

class
	MINIMUM_SPANNING_TREE

create
	make

feature {NONE} -- Initialization

	make (vertex_count: INTEGER)
			-- Create graph with vertex_count vertices
		require
			positive: vertex_count > 0
		do
			num_vertices := vertex_count
			create edges.make (20)
		end

feature -- Graph Construction

	add_edge (from_v, to_v: INTEGER; weight: REAL_64)
			-- Add undirected edge
		require
			valid_from: from_v >= 0 and from_v < num_vertices
			valid_to: to_v >= 0 and to_v < num_vertices
		do
			edges.extend ([from_v, to_v, weight])
		end

feature -- Algorithms

	kruskal: ARRAY [TUPLE [from_v, to_v: INTEGER; weight: REAL_64]]
			-- Find MST using Kruskal's algorithm
		local
			parent: ARRAY [INTEGER]
			sorted_edges: ARRAYED_LIST [TUPLE [from_v, to_v: INTEGER; weight: REAL_64]]
			result_list: ARRAYED_LIST [TUPLE [from_v, to_v: INTEGER; weight: REAL_64]]
			root_u, root_v, i: INTEGER
		do
			-- Initialize union-find
			create parent.make_filled (0, 0, num_vertices - 1)
			from i := 0 until i >= num_vertices loop
				parent [i] := i
				i := i + 1
			end

			-- Sort edges by weight
			sorted_edges := edges.twin
			sort_edges (sorted_edges)

			create result_list.make (num_vertices - 1)

			across sorted_edges as edge loop
				root_u := find_root (edge.from_v, parent)
				root_v := find_root (edge.to_v, parent)

				if root_u /= root_v then
					result_list.extend (edge)
					parent [root_u] := root_v
				end
			end

			Result := result_list.to_array
		end

	prim: ARRAY [TUPLE [from_v, to_v: INTEGER; weight: REAL_64]]
			-- Find MST using Prim's algorithm
		local
			in_mst: ARRAY [BOOLEAN]
			key: ARRAY [REAL_64]
			parent_vertex: ARRAY [INTEGER]
			result_list: ARRAYED_LIST [TUPLE [from_v, to_v: INTEGER; weight: REAL_64]]
			i, u, min_idx: INTEGER
			min_key: REAL_64
		do
			create in_mst.make_filled (False, 0, num_vertices - 1)
			create key.make_filled ({REAL_64}.max_value, 0, num_vertices - 1)
			create parent_vertex.make_filled (-1, 0, num_vertices - 1)

			key [0] := 0

			from i := 0 until i >= num_vertices - 1 loop
				-- Find minimum key vertex not in MST
				min_key := {REAL_64}.max_value
				min_idx := -1
				from u := 0 until u >= num_vertices loop
					if not in_mst [u] and key [u] < min_key then
						min_key := key [u]
						min_idx := u
					end
					u := u + 1
				end

				if min_idx >= 0 then
					in_mst [min_idx] := True

					-- Update keys of adjacent vertices
					across edges as edge loop
						if edge.from_v = min_idx and not in_mst [edge.to_v] and edge.weight < key [edge.to_v] then
							key [edge.to_v] := edge.weight
							parent_vertex [edge.to_v] := min_idx
						elseif edge.to_v = min_idx and not in_mst [edge.from_v] and edge.weight < key [edge.from_v] then
							key [edge.from_v] := edge.weight
							parent_vertex [edge.from_v] := min_idx
						end
					end
				end
				i := i + 1
			end

			create result_list.make (num_vertices - 1)
			from i := 1 until i >= num_vertices loop
				if parent_vertex [i] >= 0 then
					result_list.extend ([parent_vertex [i], i, key [i]])
				end
				i := i + 1
			end

			Result := result_list.to_array
		end

feature -- Access

	num_vertices: INTEGER

	total_weight (mst: ARRAY [TUPLE [from_v, to_v: INTEGER; weight: REAL_64]]): REAL_64
			-- Total weight of MST
		do
			across mst as edge loop
				Result := Result + edge.weight
			end
		end

feature {NONE} -- Implementation

	edges: ARRAYED_LIST [TUPLE [from_v, to_v: INTEGER; weight: REAL_64]]

	find_root (v: INTEGER; parent: ARRAY [INTEGER]): INTEGER
			-- Find root with path compression
		do
			if parent [v] = v then
				Result := v
			else
				Result := find_root (parent [v], parent)
				parent [v] := Result
			end
		end

	sort_edges (edge_list: ARRAYED_LIST [TUPLE [from_v, to_v: INTEGER; weight: REAL_64]])
			-- Sort edges by weight (simple bubble sort)
		local
			i, j: INTEGER
			temp: TUPLE [from_v, to_v: INTEGER; weight: REAL_64]
		do
			from i := 1 until i >= edge_list.count loop
				from j := 1 until j > edge_list.count - i loop
					if edge_list [j].weight > edge_list [j + 1].weight then
						temp := edge_list [j]
						edge_list [j] := edge_list [j + 1]
						edge_list [j + 1] := temp
					end
					j := j + 1
				end
				i := i + 1
			end
		end

feature -- Demo

	demo
			-- Standard Rosetta Code demo
		local
			graph: MINIMUM_SPANNING_TREE
			mst: ARRAY [TUPLE [from_v, to_v: INTEGER; weight: REAL_64]]
		do
			print ("Minimum Spanning Tree Demo:%N%N")

			create graph.make (5)
			graph.add_edge (0, 1, 2)
			graph.add_edge (0, 3, 6)
			graph.add_edge (1, 2, 3)
			graph.add_edge (1, 3, 8)
			graph.add_edge (1, 4, 5)
			graph.add_edge (2, 4, 7)
			graph.add_edge (3, 4, 9)

			print ("Kruskal's Algorithm:%N")
			mst := graph.kruskal
			across mst as edge loop
				print ("  " + edge.from_v.out + " -- " + edge.to_v.out + " : " + edge.weight.out + "%N")
			end
			print ("  Total weight: " + graph.total_weight (mst).out + "%N%N")

			print ("Prim's Algorithm:%N")
			mst := graph.prim
			across mst as edge loop
				print ("  " + edge.from_v.out + " -- " + edge.to_v.out + " : " + edge.weight.out + "%N")
			end
			print ("  Total weight: " + graph.total_weight (mst).out + "%N")
		end

end
