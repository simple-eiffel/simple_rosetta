note
	description: "[
		Rosetta Code: Dijkstra's algorithm
		https://rosettacode.org/wiki/Dijkstra%27s_algorithm

		Find shortest paths from source to all vertices in weighted graph.
		Uses priority queue for O((V+E) log V) complexity.
	]"

class
	DIJKSTRA_SHORTEST_PATH

create
	make

feature {NONE} -- Initialization

	make (vertex_count: INTEGER)
			-- Create graph with vertex_count vertices (0-indexed)
		require
			positive: vertex_count > 0
		do
			num_vertices := vertex_count
			create adjacency.make_filled (Void, 0, vertex_count - 1)
			across 0 |..| (vertex_count - 1) as i loop
				adjacency [i] := create {ARRAYED_LIST [TUPLE [vertex: INTEGER; weight: REAL_64]]}.make (5)
			end
		end

feature -- Graph Construction

	add_edge (from_v, to_v: INTEGER; weight: REAL_64)
			-- Add directed edge from from_v to to_v with weight
		require
			valid_from: from_v >= 0 and from_v < num_vertices
			valid_to: to_v >= 0 and to_v < num_vertices
			non_negative: weight >= 0
		do
			if attached adjacency [from_v] as adj then
				adj.extend ([to_v, weight])
			end
		end

	add_undirected_edge (v1, v2: INTEGER; weight: REAL_64)
			-- Add undirected edge between v1 and v2
		require
			valid_v1: v1 >= 0 and v1 < num_vertices
			valid_v2: v2 >= 0 and v2 < num_vertices
			non_negative: weight >= 0
		do
			add_edge (v1, v2, weight)
			add_edge (v2, v1, weight)
		end

feature -- Algorithm

	shortest_paths (source: INTEGER): TUPLE [distances: ARRAY [REAL_64]; predecessors: ARRAY [INTEGER]]
			-- Compute shortest paths from source to all vertices
		require
			valid_source: source >= 0 and source < num_vertices
		local
			dist: ARRAY [REAL_64]
			pred: ARRAY [INTEGER]
			visited: ARRAY [BOOLEAN]
			pq: ARRAYED_LIST [TUPLE [vertex: INTEGER; dist: REAL_64]]
			i, u, v: INTEGER
			alt: REAL_64
			min_idx: INTEGER
			min_dist: REAL_64
		do
			-- Initialize
			create dist.make_filled ({REAL_64}.max_value, 0, num_vertices - 1)
			create pred.make_filled (-1, 0, num_vertices - 1)
			create visited.make_filled (False, 0, num_vertices - 1)
			dist [source] := 0

			-- Simple priority queue implementation
			create pq.make (num_vertices)
			pq.extend ([source, 0.0])

			from until pq.is_empty loop
				-- Extract minimum
				min_idx := 1
				min_dist := pq [1].dist
				from i := 2 until i > pq.count loop
					if pq [i].dist < min_dist then
						min_dist := pq [i].dist
						min_idx := i
					end
					i := i + 1
				end
				u := pq [min_idx].vertex
				pq.go_i_th (min_idx)
				pq.remove

				if not visited [u] then
					visited [u] := True

					-- Relax edges
					if attached adjacency [u] as adj then
						across adj as edge loop
							v := edge.vertex
							alt := dist [u] + edge.weight
							if alt < dist [v] then
								dist [v] := alt
								pred [v] := u
								pq.extend ([v, alt])
							end
						end
					end
				end
			end

			Result := [dist, pred]
		end

	shortest_path_to (source, target: INTEGER): TUPLE [distance: REAL_64; path: ARRAY [INTEGER]]
			-- Shortest path from source to target
		require
			valid_source: source >= 0 and source < num_vertices
			valid_target: target >= 0 and target < num_vertices
		local
			result_tuple: TUPLE [distances: ARRAY [REAL_64]; predecessors: ARRAY [INTEGER]]
			path: ARRAYED_LIST [INTEGER]
			curr: INTEGER
		do
			result_tuple := shortest_paths (source)
			create path.make (10)

			if result_tuple.predecessors [target] /= -1 or source = target then
				curr := target
				from until curr = -1 loop
					path.put_front (curr)
					curr := result_tuple.predecessors [curr]
				end
			end

			Result := [result_tuple.distances [target], path.to_array]
		end

feature -- Access

	num_vertices: INTEGER
			-- Number of vertices

feature {NONE} -- Implementation

	adjacency: ARRAY [detachable ARRAYED_LIST [TUPLE [vertex: INTEGER; weight: REAL_64]]]
			-- Adjacency list representation

feature -- Demo

	demo
			-- Standard Rosetta Code demo
		local
			graph: DIJKSTRA_SHORTEST_PATH
			result_tuple: TUPLE [distance: REAL_64; path: ARRAY [INTEGER]]
		do
			print ("Dijkstra's Shortest Path Demo:%N%N")

			-- Create graph from Rosetta Code example
			create graph.make (6)
			graph.add_edge (0, 1, 7)
			graph.add_edge (0, 2, 9)
			graph.add_edge (0, 5, 14)
			graph.add_edge (1, 0, 7)
			graph.add_edge (1, 2, 10)
			graph.add_edge (1, 3, 15)
			graph.add_edge (2, 0, 9)
			graph.add_edge (2, 1, 10)
			graph.add_edge (2, 3, 11)
			graph.add_edge (2, 5, 2)
			graph.add_edge (3, 1, 15)
			graph.add_edge (3, 2, 11)
			graph.add_edge (3, 4, 6)
			graph.add_edge (4, 3, 6)
			graph.add_edge (4, 5, 9)
			graph.add_edge (5, 0, 14)
			graph.add_edge (5, 2, 2)
			graph.add_edge (5, 4, 9)

			print ("Graph with 6 vertices (A=0, B=1, C=2, D=3, E=4, F=5)%N%N")

			result_tuple := graph.shortest_path_to (0, 4)
			print ("Shortest path from A(0) to E(4):%N")
			print ("  Distance: " + result_tuple.distance.out + "%N")
			print ("  Path: ")
			across result_tuple.path as v loop
				print (v.out + " ")
			end
			print ("%N")
		end

end
