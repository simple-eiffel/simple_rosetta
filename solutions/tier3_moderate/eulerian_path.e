note
	description: "[
		Rosetta Code: Eulerian path
		https://rosettacode.org/wiki/Eulerian_path

		Find a path that visits every edge exactly once.
		Uses Hierholzer's algorithm.
	]"

class
	EULERIAN_PATH

create
	make

feature {NONE} -- Initialization

	make (vertex_count: INTEGER)
			-- Create graph with vertex_count vertices
		require
			positive: vertex_count > 0
		do
			num_vertices := vertex_count
			create adjacency.make_filled (Void, 0, vertex_count - 1)
			across 0 |..| (vertex_count - 1) as i loop
				adjacency [i] := create {ARRAYED_LIST [INTEGER]}.make (5)
			end
		end

feature -- Graph Construction

	add_edge (v1, v2: INTEGER)
			-- Add undirected edge
		require
			valid_v1: v1 >= 0 and v1 < num_vertices
			valid_v2: v2 >= 0 and v2 < num_vertices
		do
			if attached adjacency [v1] as adj then
				adj.extend (v2)
			end
			if attached adjacency [v2] as adj then
				adj.extend (v1)
			end
			edge_count := edge_count + 1
		end

feature -- Query

	has_eulerian_path: BOOLEAN
			-- Does graph have an Eulerian path?
		local
			odd_count, v: INTEGER
		do
			odd_count := 0
			from v := 0 until v >= num_vertices loop
				if attached adjacency [v] as adj then
					if adj.count \\ 2 = 1 then
						odd_count := odd_count + 1
					end
				end
				v := v + 1
			end
			-- Eulerian path exists if 0 or 2 vertices have odd degree
			Result := odd_count = 0 or odd_count = 2
		end

	has_eulerian_circuit: BOOLEAN
			-- Does graph have an Eulerian circuit?
		local
			v: INTEGER
		do
			Result := True
			from v := 0 until v >= num_vertices or not Result loop
				if attached adjacency [v] as adj then
					if adj.count \\ 2 = 1 then
						Result := False
					end
				end
				v := v + 1
			end
		end

feature -- Algorithm

	find_eulerian_path: ARRAY [INTEGER]
			-- Find Eulerian path using Hierholzer's algorithm
		local
			adj_copy: ARRAY [ARRAYED_LIST [INTEGER]]
			stack: ARRAYED_LIST [INTEGER]
			path: ARRAYED_LIST [INTEGER]
			start_vertex, v, neighbor, idx: INTEGER
		do
			if not has_eulerian_path then
				create Result.make_empty
			else
				-- Copy adjacency lists
				create adj_copy.make_filled (create {ARRAYED_LIST [INTEGER]}.make (0), 0, num_vertices - 1)
				from v := 0 until v >= num_vertices loop
					if attached adjacency [v] as adj then
						adj_copy [v] := adj.twin
					else
						adj_copy [v] := create {ARRAYED_LIST [INTEGER]}.make (0)
					end
					v := v + 1
				end

				-- Find start vertex (odd degree if exists, else any with edges)
				start_vertex := -1
				from v := 0 until v >= num_vertices loop
					if attached adj_copy [v] as adj then
						if adj.count > 0 then
							if start_vertex < 0 then
								start_vertex := v
							end
							if adj.count \\ 2 = 1 then
								start_vertex := v
							end
						end
					end
					v := v + 1
				end

				if start_vertex < 0 then
					create Result.make_empty
				else
					create stack.make (edge_count + 1)
					create path.make (edge_count + 1)
					stack.extend (start_vertex)

					from until stack.is_empty loop
						v := stack.last
						if attached adj_copy [v] as adj and then not adj.is_empty then
							neighbor := adj.last
							adj.finish
							adj.remove
							-- Remove reverse edge
							if attached adj_copy [neighbor] as neighbor_adj then
								idx := neighbor_adj.index_of (v, 1)
								if idx > 0 then
									neighbor_adj.go_i_th (idx)
									neighbor_adj.remove
								end
							end
							stack.extend (neighbor)
						else
							path.put_front (v)
							stack.finish
							stack.remove
						end
					end

					Result := path.to_array
				end
			end
		end

feature -- Access

	num_vertices: INTEGER
	edge_count: INTEGER

feature {NONE} -- Implementation

	adjacency: ARRAY [detachable ARRAYED_LIST [INTEGER]]

feature -- Demo

	demo
			-- Standard Rosetta Code demo
		local
			graph: EULERIAN_PATH
			path: ARRAY [INTEGER]
		do
			print ("Eulerian Path Demo:%N%N")

			-- Königsberg bridges (no Eulerian path)
			create graph.make (4)
			graph.add_edge (0, 1)
			graph.add_edge (0, 1)
			graph.add_edge (0, 2)
			graph.add_edge (0, 2)
			graph.add_edge (0, 3)
			graph.add_edge (1, 2)
			graph.add_edge (2, 3)

			print ("Königsberg Bridges Graph:%N")
			print ("  Has Eulerian path: " + graph.has_eulerian_path.out + "%N")
			print ("  Has Eulerian circuit: " + graph.has_eulerian_circuit.out + "%N%N")

			-- Simple graph with Eulerian path
			create graph.make (5)
			graph.add_edge (0, 1)
			graph.add_edge (1, 2)
			graph.add_edge (2, 3)
			graph.add_edge (3, 4)
			graph.add_edge (4, 0)
			graph.add_edge (0, 2)
			graph.add_edge (2, 4)

			print ("Pentagon with diagonals:%N")
			print ("  Has Eulerian path: " + graph.has_eulerian_path.out + "%N")

			path := graph.find_eulerian_path
			if not path.is_empty then
				print ("  Eulerian path: ")
				across path as v loop
					print (v.out)
					if not (@ v.target_index = path.upper) then
						print (" -> ")
					end
				end
				print ("%N")
			end
		end

end
